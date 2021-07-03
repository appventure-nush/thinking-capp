package app.nush.thinkingcapp.util.notifications

import androidx.core.app.NotificationCompat
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
        val notification =
            Notifications.getBuilder(applicationContext).apply {
                setContentTitle(remoteMessage.notification!!.title)
                setContentText(remoteMessage.notification!!.body)
                // TODO: Set icon
                setSmallIcon(R.drawable.avatar)
                setVibrate(longArrayOf(0, 250))
                priority = NotificationCompat.PRIORITY_HIGH
            }.build()
        notify(applicationContext, notification)
    }
}
