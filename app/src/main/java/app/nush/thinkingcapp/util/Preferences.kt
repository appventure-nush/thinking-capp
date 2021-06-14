package app.nush.thinkingcapp.util

import android.app.Activity
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences

object Preferences {
    lateinit var context: Activity
    lateinit var preferences: SharedPreferences
    fun init(context: Activity) {
        Preferences.context = context
        preferences = context.getPreferences(MODE_PRIVATE)
    }

    fun isDarkMode() = preferences.getBoolean("darkMode?", false)
    fun setDarkMode(darkMode: Boolean) = preferences.edit().putBoolean("darkMode?", darkMode).commit()

    fun getSortMode() = preferences.getInt("sortMode?", 0)
    fun setSortMode(sortMode: Int) = preferences.edit().putInt("sortMode?", sortMode).commit()
}
