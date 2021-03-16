package app.nush.thinkingcapp.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import app.nush.thinkingcapp.models.MetaData
import app.nush.thinkingcapp.util.State
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.tasks.await

class MetaDataViewModel : ViewModel() {
    private val document = Firebase.firestore.collection("metadata").document("tags")
    private val flow = callbackFlow<State<MetaData>> {
        offer(State.loading<MetaData>())
        val obj = document.get().await()
        val data = obj.toObject(MetaData::class.java) ?: return@callbackFlow run {
            offer(State.failed("Object is null."))
        }
        offer(State.success(data))
        val sub = document.addSnapshotListener { value, error ->
            if (value == null) {
                return@addSnapshotListener
            }
            val data1 = value.toObject(MetaData::class.java) ?: return@addSnapshotListener
            offer(State.success(data1))
        }
        awaitClose { sub.remove() }
    }.catch {
        emit(State.failed(it.message.toString()))
    }.flowOn(Dispatchers.IO)


    val metadata = liveData(Dispatchers.IO) {
        emit(State.loading<MetaData>())
        try {
            flow.collect {
                emit(it)
            }
        } catch (e: Exception) {
            println("Failed: " + e.message.toString())
            emit(State.failed(e.message.toString()))
        }
    }
}
