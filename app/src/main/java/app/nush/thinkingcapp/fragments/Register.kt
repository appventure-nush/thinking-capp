package app.nush.thinkingcapp.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.MainActivity
import app.nush.thinkingcapp.viewmodels.RegisterViewModel
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentRegisterBinding

class Register : Fragment(R.layout.fragment_register) {

    // TODO some way to clear error messages
    // TODO move firebase code to some other class?? if needed
    // TODO update email requirements to better fit firebase requirement
    // TODO strings.xml
    // TODO logout function in MainActivity

    val REGEX = "\\w+@\\w+\\.\\w+"
    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
    private var binding: FragmentRegisterBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        val binding = FragmentRegisterBinding.inflate(inflater, container, false)
        val registerViewModel = RegisterViewModel()
        binding.register = registerViewModel

        binding.registerButtonRegister.setOnClickListener {
            if (checkLength(registerViewModel)) checkRegister(registerViewModel)
        }

        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    private fun checkLength(model: RegisterViewModel): Boolean {
        var valid = true
        if (!model.email.trim().matches(REGEX.toRegex())) {
            model.emailError = "Invaid email format"
            valid = false
        }
        if (model.username.trim().length < 5) {
            model.usernameError = "Must be at least 5 characters long"
            valid = false
        }
        if (model.password.trim().length < 8) {
            model.passwordError = "Must be at least 8 characters long"
            valid = false
        }
        if (model.password.trim() != model.confirm.trim()) {
            model.confirmError = "Passwords do not match"
            valid = false
        }
        return valid
    }

    private fun checkRegister(model: RegisterViewModel) {
        try {
            Firebase.firestore.collection("emails")
                .document(model.email.trim()).get().addOnSuccessListener { documentSnapshot ->
                    if (documentSnapshot.exists())
                        model.emailError = "Email taken"
                    else {
                        Firebase.firestore.collection("usernames")
                            .document(model.username.trim()).get()
                            .addOnSuccessListener { documentSnapshot2 ->
                                if (documentSnapshot2.exists())
                                    model.usernameError = "Username taken"
                                else
                                    register(model)
                            }
                    }

                }
        } catch (e: Exception) {
            Toast.makeText(context, "Registration failed", Toast.LENGTH_SHORT).show()
        }
    }

    private fun register(model: RegisterViewModel) {
        val usernameMap = hashMapOf("username" to model.username.trim())
        val emailMap = hashMapOf("email" to model.email.trim())

        try {
            firebaseAuth.createUserWithEmailAndPassword(model.email.trim(), model.password.trim())
                .addOnCompleteListener(
                    context as Activity,
                    OnCompleteListener { task: Task<AuthResult> ->
                        if (task.isSuccessful) {
                            Firebase.firestore.collection("emails")
                                .document(model.email.trim()).set(usernameMap)
                            Firebase.firestore.collection("usernames")
                                .document(model.username.trim()).set(emailMap)

                            startActivity(Intent(context, MainActivity::class.java))
                            requireActivity().finish()
                            Toast.makeText(context, "Registration successful", Toast.LENGTH_SHORT)
                                .show()
                        } else
                            Toast.makeText(context, "Registration failed", Toast.LENGTH_SHORT)
                                .show()
                    })
        } catch (e: Exception) {
            Toast.makeText(context, "Registration failed", Toast.LENGTH_SHORT).show()
        }
    }

}
