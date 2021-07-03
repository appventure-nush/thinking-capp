package app.nush.thinkingcapp.util.notifications.models

sealed interface NotificationRequest{
    val type: String
    val authorEmail: String
    val authorUsername: String
    val questionTitle: String
}

fun NotificationRequest.toMap() = mapOf(
    "type" to type,
    "authorEmail" to authorEmail,
    "authorUsername" to authorUsername,
    "questionTitle" to questionTitle
)
