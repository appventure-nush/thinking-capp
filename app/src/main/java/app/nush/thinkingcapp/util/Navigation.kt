package app.nush.thinkingcapp.util

import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.NavController
import com.google.android.material.navigation.NavigationView

object Navigation {
    private lateinit var navMap: Map<Int, Int>
    private lateinit var navController: NavController

    fun init(
        navMap: Map<Int, Int>,
        navController: NavController,
        nav_view: NavigationView,
        drawerLayout: DrawerLayout
    ) {
        Navigation.navMap = navMap
        Navigation.navController = navController
        nav_view.setNavigationItemSelectedListener {
            val destination = navMap[it.itemId] ?: return@setNavigationItemSelectedListener false
            // This functionality allows the user to return to whatever
            // they were previously doing before navigating to the fragment.
            // Change this to "clear back stack until the bottom-most fragment if not satisfied
            navController.popBackStack(destination, true)
            navController.navigate(destination)
            drawerLayout.closeDrawer(GravityCompat.START)
            true
        }
    }

    fun navigate(id: Int) {
        navController.navigate(id)
    }
}
