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
import app.nush.thinkingcapp.viewmodels.RegisterViewModel
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentRegisterBinding

class Register : Fragment(R.layout.fragment_register) {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
    private var binding: FragmentRegisterBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View? {

        val binding =
            FragmentRegisterBinding.inflate(inflater, container, false)
        val registerViewModel = RegisterViewModel()
        binding.register = registerViewModel

        binding.registerButtonRegister.setOnClickListener {
            if (validateRegistration(registerViewModel)) checkRegister(
                registerViewModel)
        }

        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    private fun checkRegister(model: RegisterViewModel) {
        try {
            Firebase.firestore.collection("emails")
                .document(model.email.trim()).get()
                .addOnSuccessListener { documentSnapshot ->
                    if (documentSnapshot.exists())
                        model.emailError = getString(R.string.register_error_email)
                    else {
                        Firebase.firestore.collection("usernames")
                            .document(model.username.trim()).get()
                            .addOnSuccessListener { documentSnapshot2 ->
                                if (documentSnapshot2.exists())
                                    model.usernameError = getString(R.string.register_error_username)
                                else
                                    register(model)
                            }
                    }

                }
        } catch (e: Exception) {
            Toast.makeText(context, getString(R.string.register_error), Toast.LENGTH_SHORT)
                .show()
        }
    }

    private fun register(model: RegisterViewModel) {
        val userMap = hashMapOf("username" to model.username.trim(),
            "email" to model.email.trim(),
            "admin" to false)

        try {
            firebaseAuth.createUserWithEmailAndPassword(model.email.trim(),
                model.password.trim())
                .addOnCompleteListener(
                    context as Activity
                ) { task: Task<AuthResult> ->
                    if (task.isSuccessful) {
                        Firebase.firestore.collection("emails")
                            .document(model.email.trim()).set(userMap)

                        startActivity(Intent(context,
                            MainActivity::class.java))
                        requireActivity().finish()
                        Toast.makeText(context,
                            getString(R.string.register_success),
                            Toast.LENGTH_SHORT)
                            .show()
                    } else
                        Toast.makeText(context,
                            getString(R.string.register_error),
                            Toast.LENGTH_SHORT)
                            .show()
                }
        } catch (e: Exception) {
            Toast.makeText(context, getString(R.string.register_error), Toast.LENGTH_SHORT)
                .show()
        }
    }

    companion object {
        private const val REGEX = "\\w+@\\w+\\.\\w+"

        fun validateRegistration(model: RegisterViewModel): Boolean {
            model.emailError = ""
            model.usernameError = ""
            model.passwordError = ""
            model.confirmError = ""
            // Initially there are no errors
            if (model.email.isBlank() && model.username.isBlank() && model.password.isBlank()) {
                return true
            }
            if (!model.email.trim().matches(REGEX.toRegex())) {
                model.emailError = "Invalid email format"
                return false
            }
            if (model.username.trim().length < 5) {
                model.usernameError = "Must be at least 5 characters long"
                return false

            }
            if (model.password.trim().length < 8) {
                model.passwordError = "Must be at least 8 characters long"
                return false
            }
            if (model.password.trim() != model.confirm.trim()) {
                model.confirmError = "Passwords do not match"
                return false
            }
            if (model.email.isBlank()) {
                model.emailError = "Email cannot be blank"
                return false
            }
            if (model.username.isBlank()) {
                model.usernameError = "Username cannot be blank"
                return false
            }
            if (model.password.isBlank()) {
                model.passwordError = "Password cannot be blank"
                return false
            }
            return true
        }
    }

}
