package app.nush.thinkingcapp.models

import app.nush.thinkingcapp.util.uuid
import com.google.firebase.Timestamp

data class Answer(
    override val id: String = uuid(),
    val questionId: String = uuid(),
    val body: String = "",
    val author: String = "",
    val answers: List<String> = emptyList(),
    val upvoters: List<String> = emptyList(),
    val downvoters: List<String> = emptyList(),
    val acceptedAnswer: Boolean = false,
    val answeredDate: Timestamp = Timestamp.now(),
): Storable{
    val votes = upvoters.size - downvoters.size
}
