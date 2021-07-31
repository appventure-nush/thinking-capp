package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.MainActivity
import app.nush.thinkingcapp.models.getUser
import app.nush.thinkingcapp.models.updateUser
import app.nush.thinkingcapp.util.Preferences
import app.nush.thinkingcapp.util.notifications.NotificationServer
import app.nush.thinkingcapp.util.notifications.models.NewQuestionNotification
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.databinding.FragmentSettingsBinding
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/**
 * A simple [Fragment] subclass.
 * Use the [Settings.newInstance] factory method to
 * create an instance of this fragment.
 */
class Settings : Fragment() {
    private var darkMode = Preferences.isDarkMode()
    private var notificationsEnabled = Preferences.notificationsEnabled()
    private var binding: FragmentSettingsBinding? = null
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        // Inflate the layout for this fragment
        val binding =
            FragmentSettingsBinding.inflate(inflater, container, false)
        binding.darkModeSwitch.setOnCheckedChangeListener { _, isChecked ->
            if (darkMode != isChecked) (activity as MainActivity).toggleDarkMode(
                isChecked
            )
            darkMode = isChecked
        }
        binding.notifications.setOnCheckedChangeListener { _, isChecked ->
            if (notificationsEnabled != isChecked) {
                Preferences.setNotificationsEnabled(isChecked)
                binding.testNotification.isEnabled = isChecked
                GlobalScope.launch {
                    if (isChecked) {
                        NotificationServer.updateFCMToken()
                    } else {
                        removeFCMToken()
                    }
                }
            }
            notificationsEnabled = isChecked
        }
        binding.testNotification.setOnClickListener {
            GlobalScope.launch {
                NotificationServer.sendNotification(NewQuestionNotification(
                    "test@aahjhshjj.com",
                    "Testing",
                    "Test question",
                    "1337"
                ))
            }
        }
        this.binding = binding
        return binding.root
    }


    private suspend fun removeFCMToken() {
        val email = FirebaseAuth.getInstance().currentUser?.email!!
        val user = getUser(email) ?: return
        updateUser(user.copy(fcmTokens = emptyList()))
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        binding?.darkModeSwitch?.isChecked = darkMode
        binding?.notifications?.isChecked = notificationsEnabled
        binding?.testNotification?.isEnabled = notificationsEnabled
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
