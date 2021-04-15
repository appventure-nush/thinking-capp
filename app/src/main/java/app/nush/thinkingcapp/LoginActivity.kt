package app.nush.thinkingcapp

import android.os.Bundle
import android.view.View
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import app.nush.thinkingcapp.util.Preferences
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.nush.thinkingcapp.R

class LoginActivity : AppCompatActivity() {

    var register: Boolean = false

    lateinit var textInputUsername: TextInputLayout
    lateinit var textInputPassword: TextInputLayout
    lateinit var textInputConfirm: TextInputLayout
    lateinit var editTextUsername: TextInputEditText
    lateinit var editTextPassword: TextInputEditText
    lateinit var editTextConfirm: TextInputEditText

    lateinit var buttonLogin: Button
    lateinit var buttonRegister: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        Preferences.init(this)
        setTheme(
            if (Preferences.isDarkMode()) R.style.AppTheme
            else R.style.AppTheme_Light
        )
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        initialize()
        toggleRegisterMode()
    }

    private fun initialize() {
        textInputUsername = findViewById(R.id.text_input_username)
        textInputPassword = findViewById(R.id.text_input_password)
        textInputConfirm = findViewById(R.id.text_input_confirm)
        editTextUsername = findViewById(R.id.edit_text_username)
        editTextPassword = findViewById(R.id.edit_text_password)
        editTextConfirm = findViewById(R.id.edit_text_confirm)
        buttonLogin = findViewById(R.id.button_login)
        buttonRegister = findViewById(R.id.button_register)

        editTextUsername.setOnFocusChangeListener { view, hasFocus -> if (hasFocus) textInputUsername.error = "" }
        editTextPassword.setOnFocusChangeListener { view, hasFocus -> if (hasFocus) textInputPassword.error = "" }
        editTextConfirm.setOnFocusChangeListener { view, hasFocus -> if (hasFocus) textInputConfirm.error = "" }
    }

    fun onClick(view: View) {
        when (view.id) {
            R.id.button_login -> if (register) register() else login()
            R.id.button_register -> {
                register = !register
                toggleRegisterMode()
            }
        }
    }

    private fun toggleRegisterMode() {
        if (register) {
            textInputConfirm.visibility = View.VISIBLE
            buttonLogin.text = getString(R.string.login_register)
            buttonRegister.text = getString(R.string.login_to_login)
        } else {
            textInputConfirm.visibility = View.INVISIBLE
            buttonLogin.text = getString(R.string.login_login)
            buttonRegister.text = getString(R.string.login_to_register)
        }
    }

    private fun login() {
        textInputConfirm.error = "Invalid username or password"
    }

    private fun register() {

    }

}