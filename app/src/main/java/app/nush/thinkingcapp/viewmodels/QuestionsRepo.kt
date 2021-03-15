package app.nush.thinkingcapp.viewmodels

import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.util.State
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.tasks.await

class QuestionsRepo {
    private val questionsCollection = Firebase.firestore.collection("questions")

    fun getAllQuestions() = callbackFlow<State<List<Question>>> {
        offer(State.loading())
        val questions = questionsCollection.get().await().toObjects(Question::class.java)
        offer(State.success(questions))
        val sub=questionsCollection.addSnapshotListener { snapshot, exception ->
            if (snapshot == null) {
                return@addSnapshotListener
            }
            offer(State.success(snapshot.toObjects(Question::class.java)))
        }
        awaitClose { sub.remove() }
    }.catch {
        emit(State.failed(it.message.toString()))
    }.flowOn(Dispatchers.IO)
}
