package app.nush.thinkingcapp.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.MainActivity
import app.nush.thinkingcapp.viewmodels.LoginViewModel
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentLoginBinding

class Login : Fragment(R.layout.fragment_login) {

    val REGEX = "\\w+@\\w+\\.\\w+"
    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
    private var binding: FragmentLoginBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View? {

        val binding = FragmentLoginBinding.inflate(inflater, container, false)
        val loginViewModel = LoginViewModel()
        binding.login = loginViewModel

        binding.loginButtonLogin.setOnClickListener {
            checkLogin(loginViewModel)
        }

        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    private fun checkLogin(model: LoginViewModel) {
        val username = model.username.trim()
        if (username.matches(REGEX.toRegex())) login(username, model)
        else try {
            Firebase.firestore.collection("emails")
                .whereEqualTo("username", username).get()
                .addOnSuccessListener { querySnapshot ->
                    if (querySnapshot.documents.isEmpty()) {
                        model.usernameError =
                            getString(R.string.login_invalid)
                        return@addOnSuccessListener
                    }
                    val documentSnapshot = querySnapshot.documents.first()
                    if (!documentSnapshot.exists()) {
                        model.usernameError =
                            getString(R.string.login_invalid)
                    } else {
                        val email = documentSnapshot.getString("email")
                        if (email == null) {
                            model.usernameError =
                                getString(R.string.login_invalid)
                        } else
                            login(email, model)
                    }
                }
        } catch (e: Exception) {
            Toast.makeText(context,
                getString(R.string.login_error),
                Toast.LENGTH_SHORT).show()
        }
    }

    private fun login(email: String, model: LoginViewModel) {
        try {
            firebaseAuth.signInWithEmailAndPassword(email,
                model.password.trim())
                .addOnCompleteListener(
                    context as Activity,
                    OnCompleteListener { task: Task<AuthResult> ->
                        if (task.isSuccessful) {
                            startActivity(Intent(context,
                                MainActivity::class.java))
                            requireActivity().finish()
                            Toast.makeText(context,
                                getString(R.string.login_success),
                                Toast.LENGTH_SHORT).show()
                        } else
                            model.usernameError =
                                getString(R.string.login_invalid)
                    })
        } catch (e: Exception) {
            Toast.makeText(context,
                getString(R.string.login_error),
                Toast.LENGTH_SHORT).show()
        }
    }

}
