package app.nush.thinkingcapp.models

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.SetOptions
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

data class User(
    val admin: Boolean = false,
    val email: String = "",
    val username: String = email,
    val fcmTokens: List<String> = emptyList(),
) : Storable {
    override val id: String
        get() = email
}

fun List<User>.findByEmail(email: String): User {
    return this.find { it.email == email } ?: User(false, email, email)
}

suspend fun getUser(email: String) = suspendCoroutine<User?> { cont ->
    Firebase.firestore.collection("emails")
        .document(email)
        .get()
        .addOnSuccessListener {
            cont.resume(it.toObject(User::class.java))
        }
        .addOnFailureListener {
            cont.resumeWithException(it)
        }
}

suspend fun getCurrentUser() = suspendCoroutine<User?> { cont ->
    val email = FirebaseAuth.getInstance().currentUser?.email!!
    Firebase.firestore.collection("emails")
        .document(email)
        .get()
        .addOnSuccessListener {
            cont.resume(it.toObject(User::class.java))
        }
        .addOnFailureListener {
            cont.resumeWithException(it)
        }
}


suspend fun updateUser(user: User) = suspendCoroutine<Unit> { cont ->
    Firebase.firestore.collection("emails")
        .document(user.id)
        .set(user, SetOptions.merge())
        .addOnSuccessListener {
            cont.resume(Unit)
        }
        .addOnFailureListener {
            cont.resumeWithException(it)
        }
}
