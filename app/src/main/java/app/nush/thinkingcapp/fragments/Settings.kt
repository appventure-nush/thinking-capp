package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.MainActivity
import app.nush.thinkingcapp.util.Preferences
import com.nush.thinkingcapp.databinding.FragmentSettingsBinding

/**
 * A simple [Fragment] subclass.
 * Use the [Settings.newInstance] factory method to
 * create an instance of this fragment.
 */
class Settings : Fragment() {
    private var darkMode = Preferences.isDarkMode()
    private var binding: FragmentSettingsBinding? = null
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout for this fragment
        val binding = FragmentSettingsBinding.inflate(inflater, container, false)
        binding.darkModeSwitch.setOnCheckedChangeListener { _, isChecked ->
            if (darkMode != isChecked) (activity as MainActivity).toggleDarkMode(
                isChecked
            )
            darkMode = isChecked
        }
        this.binding = binding
        return binding.root
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        binding?.darkModeSwitch?.isChecked = darkMode
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        @JvmStatic
        fun newInstance() = Settings()
    }
}
