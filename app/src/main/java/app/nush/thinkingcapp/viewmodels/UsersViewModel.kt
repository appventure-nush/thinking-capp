package app.nush.thinkingcapp.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import app.nush.thinkingcapp.models.User
import app.nush.thinkingcapp.util.State
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect

class UsersViewModel : ViewModel() {
    private val repo = Repo<User>(Firebase.firestore.collection("emails"))
    val users = liveData<State<List<User>>>(Dispatchers.IO) {
        emit(State.loading())
        try {
            repo.getAllItems<User>().collect {
                if (it is State.Success) {
                    emit(State.Success(it.data))
                } else emit(it)
            }
        } catch (e: Exception) {
            println("Failed: " + e.message.toString())
            emit(State.failed(e.message.toString()))
        }
    }
}
