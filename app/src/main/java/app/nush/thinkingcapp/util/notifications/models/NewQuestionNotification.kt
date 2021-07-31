package app.nush.thinkingcapp.util.notifications.models

import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.models.getCurrentUser

class NewQuestionNotification(
    override val authorEmail: String,
    override val authorUsername: String,
    override val questionTitle: String,
    override val questionID: String,
) : NotificationRequest {
    override val type: String
        get() = "new_question"

    companion object {
        suspend fun fromQuestion(question: Question) = NewQuestionNotification(
            questionTitle = question.title,
            questionID = question.id,
            authorEmail = question.author,
            authorUsername = getCurrentUser()?.username ?: question.author
        )
    }
}
