package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.models.Answer
import com.google.firebase.auth.FirebaseAuth

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
    var markdown = false
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
        return Answer(
            body = body, author = firebaseAuth.currentUser!!.email!!, markdown = markdown
        )
    }
}
