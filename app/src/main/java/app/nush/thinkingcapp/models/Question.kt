package app.nush.thinkingcapp.models

import app.nush.thinkingcapp.util.uuid
import com.google.firebase.Timestamp

data class Question(
    val id: String = uuid(),
    val title: String = "",
    val body: String = "",
    val author: String = "",
    val tags: List<String> = emptyList(),
    val answers: List<String> = emptyList(),
    val upvotes: Int = 0,
    val downvotes: Int = 0,
    val hasAcceptedAnswer: Boolean = false,
    val modifiedDate: Timestamp = Timestamp.now()
)
