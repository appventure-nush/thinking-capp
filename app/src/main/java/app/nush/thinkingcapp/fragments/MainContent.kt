package app.nush.thinkingcapp.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.LoginActivity
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.Preferences
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentMainContentBinding

/**
 * A simple [Fragment] subclass.
 * Use the [MainContent.newInstance] factory method to
 * create an instance of this fragment.
 */
class MainContent : Fragment(), AdapterView.OnItemSelectedListener {

    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }
    var binding: FragmentMainContentBinding? = null

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?,
    ): View {
        // Inflate the layout for this fragment
        val binding =
            FragmentMainContentBinding.inflate(inflater, container, false)

        showAnswered = Preferences.getShowAnswered()
        tagFilters = Preferences.getTagFilters()
        binding.spinner.setSelection(Preferences.getSortMode())

        ArrayAdapter.createFromResource(
                requireContext(),
                R.array.sort_modes,
                android.R.layout.simple_spinner_item
        ).also { adapter ->
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            binding.spinner.adapter = adapter
        }
        binding.spinner.onItemSelectedListener = this

        binding.filter.setOnClickListener {
            val filterDialog = FilterDialog()
            filterDialog.show(childFragmentManager, "dialog")
        }
        binding.logout.setOnClickListener {
            val intent = Intent(requireContext(), LoginActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
            firebaseAuth.signOut()
            activity?.finish()
        }
        binding.fab.setOnClickListener {
            Navigation.navigate(R.id.newQuestion)
        }

        this.binding = binding
        return binding.root
    }

    fun sendResult() { refreshQuestions() }

    private fun refreshQuestions() {
        childFragmentManager.beginTransaction().apply {
            replace(R.id.questions_frame, MainQuestions())
            commit()
        }
    }

    override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        mode = when (position) {
            0 -> SortMode.TOP
            1 -> SortMode.NEW
            else -> mode
        }
        Preferences.setSortMode(position)
        refreshQuestions()
    }
    override fun onNothingSelected(parent: AdapterView<*>?) {}

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        enum class SortMode {
            TOP, NEW
        }
        @JvmStatic
        var mode = SortMode.TOP
        @JvmStatic
        var showAnswered = true
        @JvmStatic
        var tagFilters = emptyList<String>()
        @JvmStatic
        fun newInstance() = MainContent()
    }
}
