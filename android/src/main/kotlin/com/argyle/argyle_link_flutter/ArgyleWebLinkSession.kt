package com.argyle.argyle_link_flutter

import org.json.JSONObject

internal class ArgyleWebLinkSession(
    val page: ArgyleWebLinkPage,
    val onCallback: (String, JSONObject) -> Unit
) {
    var activity: ArgyleWebLinkActivity? = null

    companion object {
        var current: ArgyleWebLinkSession? = null
            private set

        fun begin(session: ArgyleWebLinkSession): Boolean {
            if (current != null) {
                return false
            }
            current = session
            return true
        }

        fun end(activity: ArgyleWebLinkActivity) {
            if (current?.activity === activity) {
                current = null
            }
        }

        fun cancel(session: ArgyleWebLinkSession) {
            if (current === session) {
                current = null
            }
        }
    }
}
