package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.models.Answer

class NewAnswerViewModel : BaseObservable() {
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
        return Answer(body = body, author = "Adrian Ong")
    }
}
