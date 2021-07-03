package app.nush.thinkingcapp.util.notifications

import app.nush.thinkingcapp.models.getUser
import app.nush.thinkingcapp.models.updateUser
import app.nush.thinkingcapp.util.notifications.models.NotificationRequest
import app.nush.thinkingcapp.util.notifications.models.toMap
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.functions.ktx.functions
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.FirebaseMessaging
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

object NotificationServer {

    private suspend fun getFCMToken() = suspendCoroutine<String> { cont ->
        FirebaseMessaging.getInstance().token.addOnSuccessListener {
            cont.resume(it)
        }.addOnFailureListener {
            cont.resumeWithException(it)
        }
    }

    suspend fun updateFCMToken() {
        val token = getFCMToken()
        val email = FirebaseAuth.getInstance().currentUser?.email!!
        val user = getUser(email) ?: return
        updateUser(user.copy(fcmTokens = user.fcmTokens + token))
    }

    fun sendNotification(notificationRequest: NotificationRequest) {
        Firebase.functions.getHttpsCallable("sendNotification")
            .call(notificationRequest.toMap())
            .addOnSuccessListener { 
                println("Request sent")
                println("Response ${it.data}")
            }
            .addOnFailureListener { 
                println(it)
            }
    }
}
