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

    private val channelName = "argyle_link_flutter"

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private var context: Context? = null

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
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
            "close" -> {
                close()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun close() {
        Argyle.instance.close()
    }

    private fun <T> Map<String, Any>.getValueOrNull(key: String): T? {
        return this[key] as T
    }

    private fun startSdk(linkConfiguration: Map<String, Any>) {

        checkNotNull(context) {
            Log.e(TAG, "Activity not attached");
            throw IllegalStateException("Activity not attached");
        }

        val linkKey = linkConfiguration[LINK_KEY] as String
        val apiHost = linkConfiguration[API_HOST] as String
        val userToken = linkConfiguration[USER_TOKEN] as String?

        val config = ArgyleConfig.Builder()
            .loginWith(linkKey, apiHost, userToken)

        linkConfiguration.getValueOrNull<String>(PD_CONFIG)?.let {
            config.payDistributionConfig(it)
        }

        linkConfiguration.getValueOrNull<List<String>>(LINK_ITEM_IDS)?.let {
            config.linkItems(it.toTypedArray())
        }

        linkConfiguration.getValueOrNull<Boolean>(PD_ITEMS_ONLY)?.let {
            config.payDistributionItemsOnly(it)
        }

        linkConfiguration.getValueOrNull<Boolean>(PD_UPDATE_FLOW)?.let {
            config.payDistributionUpdateFlow(it)
        }

        linkConfiguration.getValueOrNull<Boolean>(PD_AUTO_TRIGGER)?.let {
            config.payDistributionAutoTrigger(it)
        }

        linkConfiguration.getValueOrNull<String>(SDK_CUSTOMISATION_ID)?.let {
            config.customizationId(it)
        }

        linkConfiguration.getValueOrNull<String>(COMPANY_NAME)?.let {
            config.companyName(it)
        }

        linkConfiguration.getValueOrNull<String>(EXIT_BUTTON_TITLE)?.let {
            config.exitButtonTitle(it)
        }

        linkConfiguration.getValueOrNull<String>(BACK_TO_SEARCH_BUTTON_TITLE)?.let {
            config.backToSearchButtonTitle(it)
        }

        linkConfiguration.getValueOrNull<String>(PD_REVIEW_SCREEN_TITLE)?.let {
            config.payDistributionReviewScreenTitle(it)
        }

        linkConfiguration.getValueOrNull<String>(PD_REVIEW_SCREEN_SUBTITLE)?.let {
            config.payDistributionReviewScreenSubtitle(it)
        }

        linkConfiguration.getValueOrNull<Boolean>(SHOW_BACK_TO_SEARCH_BUTTON)?.let {
            config.showBackToSearchButton(it)
        }

        linkConfiguration.getValueOrNull<Boolean>(SHOW_CATEGORIES)?.let {
            config.showCategories(it)
        }

        linkConfiguration.getValueOrNull<List<String>>(EXCLUDE_CATEGORIES)?.let {
            config.excludeCategories(it.toTypedArray())
        }

        linkConfiguration.getValueOrNull<String>(CANT_FIND_LINK_ITEM_TITLE)?.let {
            config.cantFindLinkItemTitle(it)
        }

        linkConfiguration.getValueOrNull<Boolean>(SHOW_CANT_FIND_LINK_ITEM_AT_TOP)?.let {
            config.showCantFindLinkItemAtTop(it)
        }

        config.setCallbackListener(object : Argyle.ArgyleResultListener {
            override fun onTokenExpired(handler: (String) -> Unit) {
                val token = "token"
                handler(token)
            }

            override fun onAccountCreated(accountId: String, userId: String, linkItemId: String) {
                Log.d(TAG, "onAccountCreated: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod("onAccountCreated", mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId))
            }

            override fun onAccountConnected(accountId: String, userId: String, linkItemId: String) {
                Log.d(TAG, "onAccountConnected: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onAccountConnected",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onAccountUpdated(accountId: String, userId: String, linkItemId: String) {
                Log.d(TAG, "onAccountUpdated: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onAccountUpdated",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onAccountRemoved(accountId: String, userId: String, linkItemId: String) {
                Log.d(TAG, "onAccountRemoved: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onAccountRemoved",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onAccountError(
                accountId: String, userId: String, linkItemId: String
            ) {
                Log.d(TAG, "onAccountError: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onAccountError",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onError(error: ArgyleErrorType) {
                Log.d(TAG, "onError: error: $error")
                channel.invokeMethod("onError", mapOf("error" to error))
            }

            override fun onUserCreated(userToken: String, userId: String) {
                channel.invokeMethod(
                    "onUserCreated",
                    mapOf("userToken" to userToken, "userId" to userId)
                )
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
                Log.d(TAG, "onPayDistributionError: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onPayDistributionError",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onPayDistributionSuccess(
                accountId: String,
                userId: String,
                linkItemId: String
            ) {
                Log.d(TAG, "onPayDistributionSuccess: accountId: $accountId userId: $userId linkItemId: $linkItemId")
                channel.invokeMethod(
                    "onPayDistributionSuccess",
                    mapOf("accountId" to accountId, "userId" to userId, "linkItemId" to linkItemId)
                )
            }

            override fun onUIEvent(name: String, properties: Map<String, Any>) {
                Log.d(TAG, "onUIEvent: $name, properties: $properties")
                channel.invokeMethod("onUIEvent", mapOf("name" to name, "properties" to properties))
            }
        })

        Log.d(TAG, "openSdk with user token : $userToken")
        val argyle = Argyle.instance
        argyle.init(config.build())
        argyle.startSDK(activity)
    }

    companion object {
        private const val TAG = "ArgyleLinkFlutterPlugin"

        /// Link Configuration Keys
        private const val LINK_KEY = "linkKey"
        private const val API_HOST = "apiHost"
        private const val USER_TOKEN = "userToken"
        private const val LINK_ITEM_IDS = "linkItemIds"
        private const val PD_CONFIG = "pdConfig"
        private const val PD_ITEMS_ONLY = "pdItemsOnly"
        private const val PD_UPDATE_FLOW = "pdUpdateFlow"
        private const val PD_AUTO_TRIGGER = "pdAutoFlow"
        private const val SDK_CUSTOMISATION_ID = "customisationId"
        private const val COMPANY_NAME = "companyName"
        private const val EXIT_BUTTON_TITLE = "exitButtonTitle"
        private const val EXCLUDE_CATEGORIES = "excludeCategories"
        private const val SHOW_CATEGORIES = "showCategories"
        private const val SHOW_BACK_TO_SEARCH_BUTTON = "showBackToSearchButton"
        private const val PD_REVIEW_SCREEN_SUBTITLE = "pdReviewScreenSubtitle"
        private const val PD_REVIEW_SCREEN_TITLE = "pdReviewScreenTitle"
        private const val BACK_TO_SEARCH_BUTTON_TITLE = "backToSearchButtonTitle"
        private const val CANT_FIND_LINK_ITEM_TITLE = "cantFindLinkItemTitle"
        private const val SHOW_CANT_FIND_LINK_ITEM_AT_TOP = "showCantFindLinkItemAtTop"
    }

}
