package app.nush.thinkingcapp.util.notifications

import android.app.PendingIntent
import android.content.Intent
import androidx.core.app.NotificationCompat
import app.nush.thinkingcapp.LoginActivity
import app.nush.thinkingcapp.util.notifications.Notifications.notify
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.nush.thinkingcapp.R
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        GlobalScope.launch {
            NotificationServer.updateFCMToken()
        }
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val body = remoteMessage.data["body"] ?: return
        val title = remoteMessage.data["title"] ?: return
        val questionID = remoteMessage.data["questionID"] ?: return
        val intent = PendingIntent.getActivity(applicationContext, 0, Intent(
            applicationContext,
            LoginActivity::class.java
        ).apply {
            putExtra("questionID", questionID)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }, PendingIntent.FLAG_ONE_SHOT)
        val notification =
            Notifications.getBuilder(applicationContext).apply {
                setContentTitle(title)
                setContentText(body)
                // TODO: Set icon
                setSmallIcon(R.drawable.avatar)
                setVibrate(longArrayOf(0, 250))
                setContentIntent(intent)
                setAutoCancel(true)
                priority = NotificationCompat.PRIORITY_HIGH
            }.build()
        notify(applicationContext, notification)
    }
}
