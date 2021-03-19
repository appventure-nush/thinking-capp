package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.Observer
import app.nush.thinkingcapp.models.MetaData
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.MetaDataViewModel
import app.nush.thinkingcapp.viewmodels.NewQuestionViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentNewQuestionBinding


/**
 * A simple [Fragment] subclass.
 * Use the [NewQuestion.newInstance] factory method to
 * create an instance of this fragment.
 */
class NewQuestion : Fragment() {

    private val questionsViewModel: QuestionsViewModel by activityViewModels()
    private val metaDataViewModel: MetaDataViewModel by activityViewModels()
    private var binding: FragmentNewQuestionBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout for this fragment
        val binding = FragmentNewQuestionBinding.inflate(inflater, container, false)
        val newQuestionViewModel = NewQuestionViewModel()
        binding.question = newQuestionViewModel

        binding.addQuestionFab.setOnClickListener {
            val question = newQuestionViewModel.toQuestion().copy(
                tags = binding.nachoTextView.chipValues
            )
            questionsViewModel.addQuestion(question)
            Navigation.navigate(R.id.mainContent)
        }
        metaDataViewModel.metadata.observe(viewLifecycleOwner, Observer {
            val data = (it as? State.Success)?.data ?: return@Observer
            binding.nachoTextView.setAdapter(
                ArrayAdapter(
                    this.requireContext(),
                    R.layout.support_simple_spinner_dropdown_item,
                    data.tags
                )
            )
        })
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        @JvmStatic
        fun newInstance() = NewQuestion()
    }
}
