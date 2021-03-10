package app.nush.thinkingcapp

import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.util.Preferences
import kotlinx.android.synthetic.main.fragment_settings.*

object SettingsController : FragmentController {
    private lateinit var context: Fragment
    var darkMode = true
        private set

    override fun init(context: Fragment) {
        SettingsController.context = context
        with(context) {
            darkMode = Preferences.isDarkMode()
            darkModeSwitch.setOnCheckedChangeListener { _, isChecked ->
                val prevValue = darkMode
                darkMode = isChecked
                if (prevValue != darkMode) (activity as MainActivity).toggleDarkMode(darkMode)
            }
        }
    }

    override fun restoreState() {
        with(context) {
            darkModeSwitch.isChecked = darkMode
        }
    }
}
