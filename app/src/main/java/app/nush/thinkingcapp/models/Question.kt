package app.nush.thinkingcapp.models

import app.nush.thinkingcapp.util.uuid
import com.google.firebase.Timestamp

data class Question(
    override val id: String = uuid(),
    val title: String = "",
    val body: String = "",
    val author: String = "",
    val tags: List<String> = emptyList(),
    val answers: List<String> = emptyList(),
    val upvoters: List<String> = emptyList(),
    val downvoters: List<String> = emptyList(),
    val hasAcceptedAnswer: Boolean = false,
    val modifiedDate: Timestamp = Timestamp.now(),
    val modified: Boolean = false,
    val files: List<String> = emptyList()
) : Storable {
    val votes = upvoters.size - downvoters.size
}
