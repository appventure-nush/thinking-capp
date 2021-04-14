package app.nush.thinkingcapp.viewmodels

import app.nush.thinkingcapp.models.Storable
import app.nush.thinkingcapp.util.State
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.SetOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.tasks.await

class Repo<T : Storable>(val collection: CollectionReference) {

    inline fun <reified T : Storable> getAllItems() =
        callbackFlow<State<List<T>>> {
            offer(State.loading())
            val items = collection.get().await().toObjects(T::class.java)
            offer(State.success(items))
            val sub = collection.addSnapshotListener { snapshot, exception ->
                if (snapshot == null) {
                    return@addSnapshotListener
                }
                offer(State.success(snapshot.toObjects(T::class.java)))
            }
            awaitClose { sub.remove() }
        }.catch {
            emit(State.failed(it.message.toString()))
        }.flowOn(Dispatchers.IO)

    fun addItem(item: T) {
        collection
            .document(item.id)
            .set(item)
    }

    fun editItem(item: T) {
        collection
            .document(item.id)
            .set(item, SetOptions.merge())
    }
}
