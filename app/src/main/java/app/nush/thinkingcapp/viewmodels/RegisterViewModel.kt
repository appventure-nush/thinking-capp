package app.nush.thinkingcapp.viewmodels

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import app.nush.thinkingcapp.fragments.Register.Companion.validateRegistration

class RegisterViewModel : BaseObservable() {

    @get: Bindable
    var email = ""
        set(value) {
            field = value
            checkingRegistration = false
            notifyChange()
        }

    @get: Bindable
    var username = ""
        set(value) {
            field = value
            checkingRegistration = false
            notifyChange()
        }

    @get: Bindable
    var password = ""
        set(value) {
            field = value
            checkingRegistration = false
            notifyChange()
        }

    @get: Bindable
    var confirm = ""
        set(value) {
            field = value
            checkingRegistration = false
            notifyChange()
        }

    @get: Bindable
    var emailError = ""
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

    @get: Bindable
    var passwordError = ""
        set(value) {
            field = value
            notifyChange()
        }

    @get: Bindable
    var confirmError = ""
        set(value) {
            field = value
            notifyChange()
        }


    val valid: Boolean
        get() = validateRegistration(this)

    var checkingRegistration = false

}
