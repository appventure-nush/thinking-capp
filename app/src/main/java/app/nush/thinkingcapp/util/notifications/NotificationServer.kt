package app.nush.thinkingcapp.util.notifications

import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

object NotificationServer {

    fun init() {
        FirebaseMessaging.getInstance().token
            .addOnCompleteListener { task ->
                if (!task.isSuccessful) {
                    println("Failed")
                    return@addOnCompleteListener
                }

                // Get new Instance ID token
                val token = task.result ?: return@addOnCompleteListener
                GlobalScope.launch {
                    addToken(token)
                }
            }

    }

    suspend fun addToken(token: String) {
        println("Token $token")
//        val request = AddTokenRequest(token, getMsToken())
//        queue.postJson(
//            "https://pyrostore.nushhwboard.ml/notifications/addToken",
//            request,
//            AddTokenRequest.serializer()
//        )
    }

//    suspend fun sendNotification(sendNotificationRequest: SendNotificationRequest) {
//        if (!userExists()) return
//        queue.postJson(
//            "https://pyrostore.nushhwboard.ml/notifications/sendNotification",
//            sendNotificationRequest.copy(auth = getMsToken()),
//            SendNotificationRequest.serializer()
//        )
//    }
}
