package app.nush.thinkingcapp

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.BindingAdapter
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.fragments.Login
import app.nush.thinkingcapp.fragments.Register
import app.nush.thinkingcapp.util.Preferences
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.R

class LoginActivity : AppCompatActivity() {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
    var login: Boolean = true
    lateinit var modeButton: Button
    lateinit var fragmentLogin: Login
    lateinit var fragmentRegister: Register

    override fun onCreate(savedInstanceState: Bundle?) {
        Preferences.init(this)
        setTheme(
            if (Preferences.isDarkMode()) R.style.AppTheme
            else R.style.AppTheme_Light
        )
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        if (firebaseAuth.currentUser != null) {
            val activityIntent = Intent(this, MainActivity::class.java)
            if (intent != null) {
                val questionID =
                    intent.getStringExtra("questionID")
                if (questionID != null)
                    activityIntent.putExtra("questionID", questionID)
            }
            startActivity(activityIntent)
            finish()
        }

        fragmentLogin = Login()
        fragmentRegister = Register()

        modeButton = findViewById(R.id.login_button_mode)
        toggleLoginMode()
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        intent ?: return
        if (firebaseAuth.currentUser != null) {
            val activityIntent = Intent(this, MainActivity::class.java)
            val questionID =
                intent.getStringExtra("questionID")
            if (questionID != null)
                activityIntent.putExtra("questionID", questionID)
            startActivity(activityIntent)
            finish()
        }
    }

    fun changeLoginMode(view: View) {
        login = !login
        toggleLoginMode()
    }

    private fun toggleLoginMode() {
        if (login) {
            changeFragment(fragmentLogin)
            modeButton.text = getText(R.string.login_to_register)
        } else {
            changeFragment(fragmentRegister)
            modeButton.text = getText(R.string.login_to_login)
        }
    }

    private fun changeFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction().apply {
            replace(R.id.login_fragment, fragment)
            commit()
        }
    }

}

@BindingAdapter("app:errorText")
fun setErrorMessage(view: TextInputLayout, errorMessage: String?) {
    view.error = errorMessage
}
