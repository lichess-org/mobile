package org.lichess.mobileV2

import android.app.Activity
import android.content.Intent
import android.os.Bundle

// Trampoline activity that receives the OAuth redirect URI (org.lichess.mobile://login-callback)
// and forwards it to the existing MainActivity via onNewIntent, then finishes immediately.
//
// This keeps MainActivity as singleTop (correct back-navigation behavior) while ensuring the
// OAuth callback is always delivered to the running instance rather than a new one.
class OAuthCallbackActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        intent.data?.let { uri ->
            startActivity(
                Intent(this, MainActivity::class.java).apply {
                    action = Intent.ACTION_VIEW
                    data = uri
                    addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP,
                    )
                },
            )
        }
        finish()
    }
}
