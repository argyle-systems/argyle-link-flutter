package com.argyle.argyle_link_flutter

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject

class ArgyleLinkFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private val channelName = "argyle_link_flutter"

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "start" -> start(call)
            "provideNewToken" -> provideNewToken(call)
            "close" -> close()
            else -> {
                result.notImplemented()
                return
            }
        }
        result.success(null)
    }

    private fun start(call: MethodCall) {
        val activity = activity ?: throw IllegalStateException("Activity must be attached")
        val params = call.argument<Map<String, Any?>>("config")
            ?: throw IllegalArgumentException("config parameter must be set")
        val callbacks = params
            .filter { (key, value) -> key.startsWith("on") && value == true }
            .keys
            .map { if (it == "onUiEvent") "onUIEvent" else it }
            .toSet()
        val session = ArgyleWebLinkSession(
            page = ArgyleWebLinkPage(params, callbacks),
            onCallback = { name, data -> sendCallback(name, data) }
        )
        if (!ArgyleWebLinkSession.begin(session)) {
            return
        }
        try {
            activity.startActivity(Intent(activity, ArgyleWebLinkActivity::class.java))
        } catch (e: Throwable) {
            ArgyleWebLinkSession.cancel(session)
        }
    }

    private fun sendCallback(name: String, data: JSONObject) {
        when (name) {
            "onAccountCreated", "onAccountConnected", "onAccountRemoved", "onAccountError",
            "onDDSSuccess", "onDDSError" -> channel.invokeMethod(
                name,
                mapOf("accountData" to data.pick("accountId", "userId", "itemId"))
            )
            "onFormSubmitted", "onDocumentsSubmitted" -> channel.invokeMethod(
                name,
                mapOf("formData" to data.pick("accountId", "userId"))
            )
            "onError" -> channel.invokeMethod(
                name,
                mapOf(
                    "linkError" to mapOf(
                        "errorType" to (data.optStringOrNull("errorType") ?: "generic"),
                        "errorMessage" to (data.optStringOrNull("errorMessage") ?: ""),
                        "errorDetails" to data.optStringOrNull("errorDetails")
                    )
                )
            )
            "onUIEvent" -> channel.invokeMethod(
                "onUiEvent",
                mapOf("uiEvent" to data.pick("name", "properties"))
            )
            "onCantFindItemClicked" -> channel.invokeMethod(
                name,
                mapOf("term" to data.optStringOrNull("search"))
            )
            "onClose", "onTokenExpired" -> channel.invokeMethod(name, null)
        }
    }

    private fun provideNewToken(call: MethodCall) {
        val token = call.argument<String>("newToken") ?:
            throw IllegalArgumentException("newToken argument must be set")
        ArgyleWebLinkSession.current?.activity?.evaluateJavascript(
            ArgyleWebLinkPage.tokenUpdateScript(token)
        )
    }

    private fun close() {
        ArgyleWebLinkSession.current?.activity?.closeLink()
    }
}

private fun JSONObject.optStringOrNull(key: String): String? =
    if (has(key) && !isNull(key)) optString(key) else null

private fun JSONObject.pick(vararg keys: String): Map<String, Any?> =
    keys.associateWith { if (has(it)) toPlainValue(get(it)) else null }

private fun toPlainValue(value: Any?): Any? = when (value) {
    JSONObject.NULL -> null
    is JSONObject -> value.keys().asSequence().associateWith { toPlainValue(value.get(it)) }
    is JSONArray -> (0 until value.length()).map { toPlainValue(value.get(it)) }
    else -> value
}
