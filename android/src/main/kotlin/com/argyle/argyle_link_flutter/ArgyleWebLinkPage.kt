package com.argyle.argyle_link_flutter

import org.json.JSONArray
import org.json.JSONObject

internal class ArgyleWebLinkPage(config: Map<String, Any?>, callbacks: Set<String>) {

    val baseUrl = "https://plugin.argyle.io/"

    val html: String

    init {
        val params = initParams(config) + callbackDefinitions(callbacks)
        html = TEMPLATE.replace("// ARGYLE_INIT_PARAMS", params.joinToString("\n"))
    }

    private fun initParams(config: Map<String, Any?>): List<String> {
        val apiHost = config["apiHost"] as? String
        val envParam = if (apiHost != null)
            "apiHost" to JSONObject.quote(apiHost)
        else
            "sandbox" to (config["sandbox"] as? Boolean ?: false).toString()

        val nativeSdkContext = JSONObject()
            .put("sdk", "Android")
            .put("wrapperSdk", "Flutter")

        return listOfNotNull(
            envParam,
            (config["userToken"] as? String)?.let { "userToken" to JSONObject.quote(it) },
            (config["connectUrl"] as? String)?.let { "connectUrl" to JSONObject.quote(it) },
            (config["flowId"] as? String)?.let { "flowId" to JSONObject.quote(it) },
            (config["items"] as? List<*>)?.let { items ->
                "items" to JSONArray(items.filterIsInstance<String>()).toString()
            },
            (config["ddsConfig"] as? String)?.let { "ddsConfig" to JSONObject.quote(it) },
            (config["accountId"] as? String)?.let { "accountId" to JSONObject.quote(it) },
            (config["language"] as? String)?.let { "language" to JSONObject.quote(it) },
            "nativeSdkContext" to nativeSdkContext.toString()
        ).map { (key, value) -> "$key: $value," }
    }

    private fun callbackDefinitions(callbacks: Set<String>): List<String> {
        val withData = CALLBACKS_WITH_DATA.filter { it in callbacks }.map {
            "$it: (ev) => { window.$BRIDGE_NAME.onCallbackHandle('$it', JSON.stringify(ev)) },"
        }
        val withoutData = CALLBACKS_WITHOUT_DATA.filter { it in callbacks }.map {
            "$it: () => { window.$BRIDGE_NAME.onCallbackHandle('$it', JSON.stringify({})) },"
        }
        val tokenExpired = if ("onTokenExpired" in callbacks)
            listOf(
                """
                onTokenExpired: (refreshToken) => {
                    $TOKEN_UPDATE_FUNC = refreshToken;
                    window.$BRIDGE_NAME.onCallbackHandle('onTokenExpired', JSON.stringify({}))
                },
                """.trimIndent()
            )
        else
            emptyList()
        return withData + withoutData + tokenExpired
    }

    companion object {
        const val BRIDGE_NAME = "ArgyleAndroidNativeSdkBridge"
        private const val TOKEN_UPDATE_FUNC = "window.argyleInterfaceOnTokenUpdate"

        private val CALLBACKS_WITH_DATA = listOf(
            "onAccountCreated",
            "onAccountConnected",
            "onAccountRemoved",
            "onAccountError",
            "onDDSSuccess",
            "onDDSError",
            "onUIEvent",
            "onError",
            "onCantFindItemClicked",
            "onFormSubmitted",
            "onDocumentsSubmitted"
        )

        private val CALLBACKS_WITHOUT_DATA = listOf(
            "onClose"
        )

        private val TEMPLATE = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            </head>
            <body>
            <script src="argyle.web.v5.js"></script>
            <script type="text/javascript">
              window.argyle = Argyle.create({
                // ARGYLE_INIT_PARAMS
              })
              window.argyle.open()
            </script>
            </body>
            </html>
        """.trimIndent()

        fun tokenUpdateScript(token: String) = "$TOKEN_UPDATE_FUNC(${JSONObject.quote(token)});"
    }
}
