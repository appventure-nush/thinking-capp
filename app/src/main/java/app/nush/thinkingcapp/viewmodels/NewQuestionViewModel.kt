package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.models.Question
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.CompletableDeferred

class NewQuestionViewModel : BaseObservable() {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }

    @get:Bindable
    var title = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get:Bindable
    var body = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get:Bindable
    val valid: Boolean
        get() = title.isNotBlank() && body.isNotBlank()

    fun toQuestion(): Question {
        if (!valid) {
            throw IllegalStateException("Invalid question.")
        }
        var username=firebaseAuth.currentUser.email
        Firebase.firestore.collection("emails")
            .document(firebaseAuth.currentUser.email.trim())
            .get().addOnSuccessListener {
                documentSnapshot ->
                if (documentSnapshot.exists()){
                    username=documentSnapshot.getString("username") as String
                }
        }

        return Question(title = title, body = body, author = username)

    }
}
