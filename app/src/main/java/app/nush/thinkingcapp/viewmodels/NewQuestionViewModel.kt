package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.models.Question
import com.google.firebase.auth.FirebaseAuth

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

        return Question(title = title, body = body, author = firebaseAuth.currentUser?.email!!)
    }
}
