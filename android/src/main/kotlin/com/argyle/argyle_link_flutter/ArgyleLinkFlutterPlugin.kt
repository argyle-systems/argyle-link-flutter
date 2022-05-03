package com.argyle.argyle_link_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.argyle.Argyle
import com.argyle.ArgyleConfig
import com.argyle.ArgyleErrorType

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** ArgyleLinkFlutterPlugin */
class ArgyleLinkFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private val TAG = "ArgyleLinkFlutterPlugin"
  private val channelName = "argyle_link_flutter"

  private lateinit var channel: MethodChannel
  private var context: Context? = null
  private lateinit var activity: Activity

  /// Link Configuration Keys
  private val LINK_KEY = "linkKey"
  private val API_HOST = "apiHost"
  private val USER_TOKEN = "userToken"
  private val PD_CONFIG = "pdConfig"
  private val PD_ITEMS_ONLY = "pdItemsOnly"
  private val PD_UPDATE_FLOW = "pdUpdateFlow"

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.channel.setMethodCallHandler(null)
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "startSdk" -> {
        startSdk(call.arguments as Map<String, Any>)
        result.success("")
      }
      "stopSdk" -> {
        close()
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun close() {
    TODO("Not yet implemented")
  }

  private fun startSdk(linkConfiguration: Map<String, Any>) {

    if (context == null) {
      Log.w(TAG, "Activity not attached");
      throw IllegalStateException("Activity not attached");
    }

    val linkKey = linkConfiguration[LINK_KEY] as String
    val apiHost = linkConfiguration[API_HOST] as String
    val userToken = linkConfiguration[USER_TOKEN] as String?

    val argyle = Argyle.instance

    Log.d(TAG, "openSdk with user token : $userToken")

    val config = ArgyleConfig.Builder()

      .loginWith(linkKey, apiHost, userToken)
//            .linkItems(arrayOf("uber"))
//            .payDistributionConfig(YOUR_PD_CONFIG)
//            .payDistributionItemsOnly(true)
//            .payDistributionUpdateFlow(true)
      .setCallbackListener(object : Argyle.ArgyleResultListener {

        override fun onTokenExpired(handler: (String) -> Unit) {
          val token = "token"
          handler(token)
        }

        override fun onAccountCreated(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountCreated: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
          channel.invokeMethod("onAccountCreated", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
        }

        override fun onAccountConnected(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountConnected: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
          channel.invokeMethod("onAccountConnected", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
        }

        override fun onAccountUpdated(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountUpdated: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
          channel.invokeMethod("onAccountUpdated", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
        }

        override fun onAccountRemoved(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountRemoved: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
          channel.invokeMethod("onAccountRemoved", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
        }

        override fun onAccountError(accountId: String, userId: String, linkItemId: String
        ) {
          Log.d(TAG, "onAccountError: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
          channel.invokeMethod("onAccountError", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
        }

        override fun onError(error: ArgyleErrorType) {
          Log.d(TAG, "onError: error: $error")
          channel.invokeMethod("onError", mapOf("error" to error))
        }

        override fun onUserCreated(userToken: String, userId: String) {
          channel.invokeMethod("onUserCreated", mapOf("userToken" to userToken, "userId" to userId))
        }

        override fun onClose() {
          Log.d(TAG, "onClose")
          channel.invokeMethod("onClose", null)
        }

        override fun onPayDistributionError(
          accountId: String,
          userId: String,
          linkItemId: String
        ) {
          Log.d(
            TAG,
            "onPayDistributionError: accountId: $accountId userId: $userId linkItemId: $linkItemId"
          )
        }

        override fun onPayDistributionSuccess(
          accountId: String,
          userId: String,
          linkItemId: String
        ) {
          Log.d(
            TAG,
            "onPayDistributionSuccess: accountId: $accountId userId: $userId linkItemId: $linkItemId"
          )
        }

        override fun onUIEvent(name: String, properties: Map<String, Any>) {
          Log.d(TAG, "onUIEvent: $name, properties: $properties")
        }

      })
      .build()

    argyle.init(config)
    argyle.startSDK(activity)
  }
}
