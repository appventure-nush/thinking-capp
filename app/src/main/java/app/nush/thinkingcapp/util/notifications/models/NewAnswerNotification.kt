package app.nush.thinkingcapp.util.notifications.models

import app.nush.thinkingcapp.models.Answer
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.models.getCurrentUser

class NewAnswerNotification(
    override val authorEmail: String,
    override val authorUsername: String,
    override val questionTitle: String,
) : NotificationRequest {
    override val type: String
        get() = "new_answer"

    companion object {
        suspend fun fromQuestionAndAnswer(question: Question, answer: Answer) =
            NewAnswerNotification(
                questionTitle = question.title,
                authorEmail = answer.author,
                authorUsername = getCurrentUser()?.username ?: answer.author
            )
    }
}
