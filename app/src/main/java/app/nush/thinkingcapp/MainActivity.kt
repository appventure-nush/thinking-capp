package app.nush.thinkingcapp

import android.os.Bundle
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.NavController
import androidx.navigation.fragment.findNavController
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.Preferences
import com.nush.thinkingcapp.R
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    lateinit var navController: NavController

    override fun onCreate(savedInstanceState: Bundle?) {
        Preferences.init(this)
        setTheme(
            if (Preferences.isDarkMode()) R.style.AppTheme
            else R.style.AppTheme_Light
        )
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setSupportActionBar(toolbar)
        val toggle = ActionBarDrawerToggle(this, drawer_layout, toolbar, 0, 0)
        actionBar?.setDisplayHomeAsUpEnabled(true)
        drawer_layout.addDrawerListener(toggle)
        toggle.isDrawerIndicatorEnabled = true
        toggle.syncState()
        navController = nav_host_fragment.findNavController()

        Navigation.init(
            mapOf(
                R.id.nav_settings to R.id.settings,
                R.id.nav_main to R.id.mainContent
            ), navController, nav_view, drawer_layout
        )
    }

    fun toggleDarkMode(dark: Boolean) {
        println("Dark theme? $dark")
        Preferences.setDarkMode(dark)
        finish()
        startActivity(intent)
    }
}
