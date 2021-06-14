package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.fragments.Register.Companion.validateRegistration

class RegisterViewModel : BaseObservable() {

    @get: Bindable
    var email = ""
        set(value) {
            field = value
            notifyChange()
        }

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
    var confirm = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get: Bindable
    var emailError = ""

    @get: Bindable
    var usernameError = ""

    @get: Bindable
    var passwordError = ""

    @get: Bindable
    var confirmError = ""

    val valid: Boolean
        get() = validateRegistration(this)

}
