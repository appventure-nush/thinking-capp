package app.nush.thinkingcapp.util

import android.text.format.DateUtils
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
    else this.substring(0, length - overflowIndicator.length) + overflowIndicator


fun String.parseDate(
    patterns: List<String> = listOf(
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ssX"
    )
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


fun Date.toStringValue(): String = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this)
fun Date.isToday() = DateUtils.isToday(this.time)
fun Date.isYesterday() = DateUtils.isToday(this.time + DateUtils.DAY_IN_MILLIS)
fun String.toDate() = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(this) as Date
fun String.formatDate(): String = SimpleDateFormat("dd MMM yyyy").format(toDate())
infix fun Int.suffix(suffix: String) = if (this == 1) "1 $suffix" else "$this $suffix" + "s"

fun uuid() = UUID.randomUUID().toString()
