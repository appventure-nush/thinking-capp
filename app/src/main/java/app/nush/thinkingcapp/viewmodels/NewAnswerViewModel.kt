package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.models.Answer
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class NewAnswerViewModel : BaseObservable() {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }

    @get:Bindable
    var body = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get:Bindable
    val valid: Boolean
        get() = body.isNotBlank()

    fun toAnswer(): Answer {
        if (!valid) {
            throw IllegalStateException("Invalid answer.")
        }
        // TODO: Actually handle auth here
        var username=firebaseAuth.currentUser.email
        Firebase.firestore.collection("emails")
            .document(firebaseAuth.currentUser.email.trim())
            .get().addOnSuccessListener {
                    documentSnapshot ->
                if (documentSnapshot.exists()){
                    username=documentSnapshot.getString("username") as String
                }
            }

        return Answer(body = body, author = username)
    }
}
