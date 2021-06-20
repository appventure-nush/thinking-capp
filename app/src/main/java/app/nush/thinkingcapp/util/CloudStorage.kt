package app.nush.thinkingcapp.util


import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage
import kotlinx.coroutines.suspendCancellableCoroutine
import java.io.InputStream
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

object CloudStorage {
    private val storage = Firebase.storage
    private val root = storage.reference
    suspend fun addObject(stream: InputStream, extension: String) = suspendCancellableCoroutine<String> { cont ->
        val fileName = "${uuid()}.$extension"
        val fileRef = root.child(fileName)
        val task = fileRef.putStream(stream)
        cont.invokeOnCancellation {
            task.cancel()
        }
        task.continueWithTask { task ->
            if (!task.isSuccessful) {
                task.exception?.let {
                    throw it
                }
            }
            fileRef.downloadUrl
        }.addOnSuccessListener {
            cont.resume(it.toString())
        }.addOnFailureListener {
            cont.resumeWithException(it)
        }
    }
}
