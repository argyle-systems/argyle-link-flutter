package com.argyle.argyle_link_flutter

import android.content.Context
import com.argyle.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ArgyleLinkFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private val channelName = "argyle_link_flutter"

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var newTokenCallback: ((String) -> Unit)? = null

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val returnedResult = when (call.method) {
            "startSdk" -> start(call)
            "provideNewToken" -> provideNewToken(call)
            "close" -> close()
            else -> null
        }
        if (returnedResult != null) {
            result.success(returnedResult)
        }
    }

    private fun start(call: MethodCall) {
        val params = call.argument<Map<String, Any>>("config")
            ?: throw IllegalArgumentException("config parameter must be set")
        ArgyleLink.start(context!!, parseLinkConfig(params))
    }

    @Suppress("UNCHECKED_CAST")
    private fun parseLinkConfig(params: Map<String, Any>) = LinkConfig(
        linkKey = params["linkKey"] as String,
        userToken = params["userToken"] as String,
        sandbox = params["sandbox"] as Boolean
    ).apply {
        items = params["items"] as List<String>?
        flowId = params["flowId"] as String?
        ddsConfig = params["ddsConfig"] as String?

        if (params["onCantFindItemClicked"] as Boolean) {
            onCantFindItemClicked = {
                channel.invokeMethod("onCantFindItemClicked", mapOf("term" to it))
            }
        }
        if (params["onAccountCreated"] as Boolean) {
            onAccountCreated = { channel.invokeMethod("onAccountCreated", it.toMap()) }
        }
        if (params["onAccountConnected"] as Boolean) {
            onAccountConnected = { channel.invokeMethod("onAccountConnected", it.toMap()) }
        }
        if (params["onAccountRemoved"] as Boolean) {
            onAccountRemoved = { channel.invokeMethod("onAccountRemoved", it.toMap()) }
        }
        if (params["onAccountError"] as Boolean) {
            onAccountError = { channel.invokeMethod("onAccountError", it.toMap()) }
        }
        if (params["onDDSSuccess"] as Boolean) {
            onDDSSuccess = { channel.invokeMethod("onDDSSuccess", it.toMap()) }
        }
        if (params["onDDSError"] as Boolean) {
            onDDSError = { channel.invokeMethod("onDDSError", it.toMap()) }
        }
        if (params["onFormSubmitted"] as Boolean) {
            onFormSubmitted = { channel.invokeMethod("onFormSubmitted", it.toMap()) }
        }
        if (params["onDocumentsSubmitted"] as Boolean) {
            onDocumentsSubmitted = { channel.invokeMethod("onDocumentsSubmitted", it.toMap()) }
        }
        if (params["onError"] as Boolean) {
            onError = { channel.invokeMethod("onError", it.toMap()) }
        }
        if (params["onClose"] as Boolean) {
            onClose = { channel.invokeMethod("onClose", null) }
        }
        if (params["onTokenExpired"] as Boolean) {
            onTokenExpired = {
                newTokenCallback = it
                channel.invokeMethod("onTokenExpired", null)
            }
        }
        if (params["onUiEvent"] as Boolean) {
            onUIEvent = { channel.invokeMethod("onUiEvent", it.toMap()) }
        }
    }

    private fun AccountData.toMap() = mapOf(
        "accountData" to mapOf(
            "accountId" to accountId, "userId" to userId, "itemId" to itemId
        )
    )

    private fun FormData.toMap() = mapOf(
        "formData" to mapOf(
            "accountId" to accountId, "userId" to userId
        )
    )

    private fun LinkError.toMap() = mapOf(
        "linkError" to mapOf(
            "errorType" to errorType.name,
            "errorMessage" to errorMessage,
            "errorDetails" to errorDetails
        )
    )

    private fun UIEvent.toMap() = mapOf(
        "uiEvent" to mapOf(
            "name" to name, "properties" to properties
        )
    )

    private fun provideNewToken(call: MethodCall) {
        val token = call.argument<String>("newToken") ?:
            throw IllegalArgumentException("newToken argument must be set")
        newTokenCallback?.invoke(token)
    }

    private fun close() {
        ArgyleLink.close()
    }
}
