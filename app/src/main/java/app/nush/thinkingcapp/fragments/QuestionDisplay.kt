package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.observe
import androidx.navigation.fragment.navArgs
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.databinding.FragmentNewQuestionBinding
import com.nush.thinkingcapp.databinding.FragmentQuestionDisplayBinding


/**
 * A simple [Fragment] subclass.
 * Use the [QuestionDisplay.newInstance] factory method to
 * create an instance of this fragment.
 */
class QuestionDisplay : Fragment() {
    val viewModel: QuestionsViewModel by activityViewModels()
    val args: QuestionDisplayArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = FragmentQuestionDisplayBinding.inflate(inflater, container, false)
        viewModel.questions.observe(this) {
            if (it is State.Success) {
                val question =
                    it.data.firstOrNull { question -> question.id == args.questionId } ?: run {
                        println("Question not found.")
                        return@observe
                    }
                binding.question = question
            } else {
                println("Failed loading data.")
            }
        }
        return binding.root
    }

    companion object {
        @JvmStatic
        fun newInstance() = QuestionDisplay()
    }
}
