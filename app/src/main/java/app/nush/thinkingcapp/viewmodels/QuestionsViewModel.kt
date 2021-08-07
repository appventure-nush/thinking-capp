package app.nush.thinkingcapp.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.util.State
import com.google.firebase.Timestamp
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect

class QuestionsViewModel : ViewModel() {
    private val repo = Repo<Question>(Firebase.firestore.collection("questions"))
    val questions = liveData<State<List<Question>>>(Dispatchers.IO) {
        emit(State.loading())
        try {
            repo.getAllItems<Question>().collect {
                emit(it)
            }
        } catch (e: Exception) {
            println("Failed: " + e.message.toString())
            emit(State.failed(e.message.toString()))
        }
    }

    fun addQuestion(question: Question) = repo.addItem(question)

    fun editQuestion(question: Question, updateTime: Boolean = false) {
        val newQuestion = if (updateTime)
            question.copy(modifiedDate = Timestamp.now(), modified = true)
        else question
        repo.editItem(newQuestion)
    }

    fun editQuestionStatus(
        question: Question,
        changeHasAcceptedAnswer: Boolean = false,
        changeRequireClarification: Boolean = false,
    ) {
        if (!changeHasAcceptedAnswer && !changeRequireClarification)
            return

        val acceptedAnswer = if (changeHasAcceptedAnswer)
            !question.hasAcceptedAnswer
        else question.hasAcceptedAnswer
        val clarify = if (changeRequireClarification)
            !question.requireClarification
        else question.requireClarification

        val newQuestion = question.copy(
            hasAcceptedAnswer = acceptedAnswer,
            requireClarification = clarify
        )
        repo.editItem(newQuestion)
    }
}
