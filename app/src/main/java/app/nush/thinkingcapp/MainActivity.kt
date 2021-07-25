package app.nush.thinkingcapp

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.NavController
import androidx.navigation.fragment.findNavController
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.Preferences
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
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
            val toggle = ActionBarDrawerToggle(this@MainActivity, drawerLayout, toolbar, 0, 0)
            actionBar?.setDisplayHomeAsUpEnabled(true)
            drawerLayout.addDrawerListener(toggle)
            toggle.isDrawerIndicatorEnabled = true
            toggle.syncState()
            navController = supportFragmentManager.findFragmentById(R.id.nav_host_fragment)!!.findNavController()

            Navigation.init(
                mapOf(
                    R.id.nav_settings to R.id.settings,
                    R.id.nav_main to R.id.mainContent
                ), navController, navView, drawerLayout
            )

            navView.menu.findItem(R.id.nav_logout).setOnMenuItemClickListener { _ ->
                logout()
                true
            }
        }
    }

    private fun logout() {
        val intent = Intent(this, LoginActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
        firebaseAuth.signOut()
        Toast.makeText(this, getString(R.string.logout_success), Toast.LENGTH_SHORT).show()
        finish()
    }

    fun toggleDarkMode(dark: Boolean) {
        println("Dark theme? $dark")
        Preferences.setDarkMode(dark)
        finish()
        startActivity(intent)
    }
}
