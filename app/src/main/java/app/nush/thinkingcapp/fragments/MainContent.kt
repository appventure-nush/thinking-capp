package app.nush.thinkingcapp.fragments

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.fragment.app.Fragment
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.Preferences
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentMainContentBinding

/**
 * A simple [Fragment] subclass.
 * Use the [MainContent.newInstance] factory method to
 * create an instance of this fragment.
 */
class MainContent : Fragment(), AdapterView.OnItemSelectedListener {

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

        with (binding) {
            filter.setOnClickListener {
                val filterDialog = FilterDialog()
                filterDialog.show(childFragmentManager, "dialog")
            }
            fab.setOnClickListener {
                Navigation.navigate(R.id.newQuestion)
            }
            bar.setBackgroundColor(Color.parseColor(
                if (Preferences.isDarkMode()) "#000000"
                else "#FFFFFF"))
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
