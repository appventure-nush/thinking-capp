package app.nush.thinkingcapp.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import app.nush.thinkingcapp.models.Answer
import app.nush.thinkingcapp.util.State
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect

class AnswersViewModel : ViewModel() {
    lateinit var questionId: String
    private val repo = Repo<Answer>(Firebase.firestore.collection("answers"))
    val answers = liveData<State<List<Answer>>>(Dispatchers.IO) {
        emit(State.loading())
        try {
            repo.getAllItems<Answer>().collect {
                if (it is State.Success) {
                    val relevantAnswers =
                        it.data.filter { answer -> !::questionId.isInitialized || answer.questionId == questionId }
                    emit(State.Success(relevantAnswers))
                } else emit(it)
            }
        } catch (e: Exception) {
            println("Failed: " + e.message.toString())
            emit(State.failed(e.message.toString()))
        }
    }

    fun addAnswer(answer: Answer) =
        repo.addItem(answer.copy(questionId = questionId))

    fun editAnswer(answer: Answer) {
        repo.editItem(answer.copy(questionId = questionId))
    }
}
