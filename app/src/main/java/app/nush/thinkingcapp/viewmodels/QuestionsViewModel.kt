package app.nush.thinkingcapp.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.util.State
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect

class QuestionsViewModel : ViewModel() {
    private val repo = QuestionsRepo()
    val questions = liveData(Dispatchers.IO) {
        emit(State.loading<List<Question>>())
        try {
            repo.getAllQuestions().collect {
                emit(it)
            }
        } catch (e: Exception) {
            println("Failed: " + e.message.toString())
            emit(State.failed(e.message.toString()))
        }
    }

    fun addQuestion(question: Question) =repo.addQuestion(question)

    fun editQuestion(question: Question) =repo.editQuestion(question)
}
