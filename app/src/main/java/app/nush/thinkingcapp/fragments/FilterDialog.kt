package app.nush.thinkingcapp.fragments

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import android.view.LayoutInflater
import androidx.fragment.app.DialogFragment
import androidx.recyclerview.widget.LinearLayoutManager
import app.nush.thinkingcapp.adapters.FilterAdapter
import app.nush.thinkingcapp.util.Preferences
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.DialogFilterBinding

class FilterDialog : DialogFragment() {

    var binding: DialogFilterBinding? = null

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val binding = DialogFilterBinding.inflate(LayoutInflater.from(context))

        val tagFilters = Preferences.getTagFilters()
        val tagFilterMap = resources.getStringArray(R.array.filter_tags)
            .associateWith { it in tagFilters }
        val adapter = FilterAdapter(tagFilterMap)

        binding.answered.isChecked = Preferences.getShowAnswered()
        binding.recycler.layoutManager = LinearLayoutManager(requireContext())
        binding.recycler.adapter = adapter

        return AlertDialog.Builder(requireActivity())
                .setView(binding.root)
                .setPositiveButton("OK") { _, _ ->
                    MainContent.showAnswered = binding.answered.isChecked
                    MainContent.tagFilters = adapter.checkedFilters
                    Preferences.setShowAnswered(binding.answered.isChecked)
                    Preferences.setTagFilters(adapter.checkedFilters)
                    (parentFragment as MainContent).sendResult()
                }
                .setNegativeButton("Cancel") { dialog, _ -> dialog.cancel() }
                .create()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

}
