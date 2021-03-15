package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.observe
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.viewmodels.NewQuestionViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentNewQuestionBinding
import kotlinx.android.synthetic.main.fragment_new_question.view.*


/**
 * A simple [Fragment] subclass.
 * Use the [NewQuestion.newInstance] factory method to
 * create an instance of this fragment.
 */
class NewQuestion : Fragment() {

    private val questionsViewModel: QuestionsViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = FragmentNewQuestionBinding.inflate(inflater, container, false)
        val newQuestionViewModel = NewQuestionViewModel()
        binding.question = newQuestionViewModel

        binding.root.addQuestionFab.setOnClickListener {
            val question = newQuestionViewModel.toQuestion()
            val flow = questionsViewModel.addQuestion(question)
            flow.observe(this) {
                Navigation.navigate(R.id.mainContent)
                flow.removeObservers(this)
            }
        }
        return binding.root
    }

    companion object {
        @JvmStatic
        fun newInstance() = NewQuestion()
    }
}
