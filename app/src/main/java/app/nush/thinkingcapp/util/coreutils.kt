package app.nush.thinkingcapp.util

import android.app.Activity
import android.content.Context
import android.net.Uri
import android.text.format.DateUtils
import android.view.inputmethod.InputMethodManager
import android.webkit.MimeTypeMap
import com.google.firebase.Timestamp
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import org.ocpsoft.prettytime.PrettyTime
import java.io.File
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

fun <T> MutableList<T>.removeAll() = this.removeAll(this)
fun <T> MutableList<T>.setAll(list: List<T>) {
    removeAll()
    plusAssign(list)
}


fun String.truncate(length: Int, overflowIndicator: String = "...") =
    if (this.length <= length) this
    else this.substring(0,
        length - overflowIndicator.length) + overflowIndicator


fun String.parseDate(
    patterns: List<String> = listOf(
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ssX"
    ),
): Date? {
    for (pattern in patterns) {
        try {
            return SimpleDateFormat(pattern).parse(this)
        } catch (e: ParseException) {
        }
    }
    println("Fail: $this")
    return null
}


fun String.toDp(numDp: Int) =
    if (contains("."))
        substringBefore(".") + "." +
            substringAfter(".").substring(0 until numDp)
    else "$this.0"


fun Date.toStringValue(): String =
    SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this)

fun Date.isToday() = DateUtils.isToday(this.time)
fun Date.isYesterday() = DateUtils.isToday(this.time + DateUtils.DAY_IN_MILLIS)
fun String.toDate() =
    SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(this) as Date

fun String.formatDate(): String =
    SimpleDateFormat("dd MMM yyyy").format(toDate())

infix fun Int.suffix(suffix: String) =
    if (this == 1) "1 $suffix" else "$this $suffix" + "s"

fun uuid() = UUID.randomUUID().toString()

fun prettyElapsedTime(time: Timestamp): String {
    val date = time.toDate()
    return PrettyTime().format(date)
}

suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> =
    coroutineScope {
        map { async { f(it) } }.awaitAll()
    }


fun getFileExtension(uri: Uri, context: Context): String {
    return if (uri.scheme == "content") {
        val cR = context.contentResolver
        val mime = MimeTypeMap.getSingleton()
        mime.getExtensionFromMimeType(cR.getType(uri))!!
    }else{
        MimeTypeMap.getFileExtensionFromUrl(Uri.fromFile(File(uri.path)).toString())
    }
}

fun hideKeyboard(activity: Activity) {
    val inputMethodManager =
        activity.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager

    val currentFocusedView = activity.currentFocus
    currentFocusedView?.let {
        inputMethodManager.hideSoftInputFromWindow(
            currentFocusedView.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)
    }
}
