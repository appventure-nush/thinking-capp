package app.nush.thinkingcapp.util

import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.NavController
import com.google.android.material.navigation.NavigationView

object Navigation {
    private lateinit var navMap: Map<Int, Int>

    fun init(
        navMap: Map<Int, Int>,
        navController: NavController,
        nav_view: NavigationView,
        drawerLayout: DrawerLayout
    ) {
        Navigation.navMap = navMap
        nav_view.setNavigationItemSelectedListener {
            val destination = navMap[it.itemId] ?: return@setNavigationItemSelectedListener false
            navController.navigate(destination)
            drawerLayout.closeDrawer(GravityCompat.START)
            true
        }
    }
}
