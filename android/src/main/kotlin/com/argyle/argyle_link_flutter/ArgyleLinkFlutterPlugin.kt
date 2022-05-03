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
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "argyle_link_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "startSdk" -> {
        configureArgyleSdk()
        result.success("Something")
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private val LINK_KEY = "017cf0de-aac1-e1c4-b86c-7d9dffbfc8ed"
  private val API_HOST = "https://api-sandbox.argyle.com/v1"

  private fun configureArgyleSdk(token: String? = null) {
    val argyle = Argyle.instance

    Log.d(TAG, "openSdk with token : $token")

    val config = ArgyleConfig.Builder()

      .loginWith(LINK_KEY, API_HOST, token)
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
        }

        override fun onAccountConnected(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountConnected: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
        }

        override fun onAccountUpdated(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountUpdated: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
        }

        override fun onAccountRemoved(accountId: String, userId: String, linkItemId:String) {
          Log.d(TAG, "onAccountRemoved: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
        }

        override fun onAccountError(accountId: String, userId: String, linkItemId: String
        ) {
          Log.d(TAG, "onAccountError: accountId: $accountId workerId: $userId linkItemId: $linkItemId")
        }

        override fun onError(error: ArgyleErrorType) {
          Log.d(TAG, "onError: error: $error")
        }

        override fun onUserCreated(userToken: String, userId: String) {

        }

        override fun onClose() {
          Log.d(TAG, "onClose")
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

  private val TAG = "MainActivity"

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
