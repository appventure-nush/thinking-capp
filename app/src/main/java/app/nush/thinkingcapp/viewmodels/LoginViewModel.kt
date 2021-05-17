package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable

class LoginViewModel : BaseObservable() {

    @get: Bindable
    var username = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get: Bindable
    var password = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get: Bindable
    var usernameError = ""
        set(value) {
            field = value
            notifyChange()
        }

    val valid: Boolean
        get() = username.isNotBlank() && password.isNotBlank()

}