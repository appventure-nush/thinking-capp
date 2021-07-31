package app.nush.thinkingcapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.NavController
import androidx.navigation.fragment.findNavController
import app.nush.thinkingcapp.fragments.MainContentDirections
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.Preferences
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    lateinit var navController: NavController

    override fun onCreate(savedInstanceState: Bundle?) {
        Preferences.init(this)
        setTheme(
            if (Preferences.isDarkMode()) R.style.AppTheme
            else R.style.AppTheme_Light
        )
        super.onCreate(savedInstanceState)
        val binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        with(binding) {
            setSupportActionBar(toolbar)
            val toggle = ActionBarDrawerToggle(this@MainActivity,
                drawerLayout,
                toolbar,
                0,
                0)
            actionBar?.setDisplayHomeAsUpEnabled(true)
            drawerLayout.addDrawerListener(toggle)
            toggle.isDrawerIndicatorEnabled = true
            toggle.syncState()
            navController =
                supportFragmentManager.findFragmentById(R.id.nav_host_fragment)!!
                    .findNavController()

            Navigation.init(
                mapOf(
                    R.id.nav_settings to R.id.settings,
                    R.id.nav_main to R.id.mainContent
                ), navController, navView, drawerLayout
            )
        }
        if (intent != null) {
            handleIntents(intent)
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        intent ?: return
        handleIntents(intent)
    }

    private fun handleIntents(intent: Intent) {
        val questionID = intent.getStringExtra("questionID") ?: kotlin.run {
            println("Null question ID")
            return
        }
        // Magic
        if(questionID == "1337"){
            return
        }
        val action = MainContentDirections.actionMainContentToQuestionDisplay(questionID)
        navController.navigate(action)
    }

    fun toggleDarkMode(dark: Boolean) {
        println("Dark theme? $dark")
        Preferences.setDarkMode(dark)
        finish()
        startActivity(intent)
    }
}
