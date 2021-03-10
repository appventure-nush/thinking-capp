package app.nush.thinkingcapp

import androidx.fragment.app.Fragment

interface FragmentController {
    fun init(context: Fragment)
    fun restoreState()
}
