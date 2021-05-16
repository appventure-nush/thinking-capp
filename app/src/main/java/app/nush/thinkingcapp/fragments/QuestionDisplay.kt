package app.nush.thinkingcapp.fragments

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.navigation.fragment.navArgs
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.adapters.AnswersAdapter
import app.nush.thinkingcapp.adapters.TagsAdapter
import app.nush.thinkingcapp.models.Answer
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.AnswersViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.databinding.FragmentQuestionDisplayBinding


/**
 * A simple [Fragment] subclass.
 * Use the [QuestionDisplay.newInstance] factory method to
 * create an instance of this fragment.
 */
class QuestionDisplay : Fragment() {
    private val viewModel: QuestionsViewModel by activityViewModels()
    private val answersViewModel: AnswersViewModel by viewModels()
    private val args: QuestionDisplayArgs by navArgs()
    var binding: FragmentQuestionDisplayBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val binding = FragmentQuestionDisplayBinding.inflate(inflater, container, false)
        val originalColor = binding.questionNumVotes.currentTextColor
        viewModel.questions.observe(viewLifecycleOwner, Observer {
            if (it is State.Success) {
                val question =
                    it.data.firstOrNull { question -> question.id == args.questionId } ?: run {
                        println("Question not found.")
                        return@Observer
                    }
                binding.question = question
                binding.tagsListView.adapter = TagsAdapter(question.tags)
                binding.tagsListView.layoutManager =
                    LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                // TODO: Change when authentication implemented
                val name = "Adrian Ong"
                binding.upvote.setOnClickListener {
                    val upvoters = if (name in question.upvoters) {
                        question.upvoters - name
                    } else {
                        question.upvoters + name
                    }
                    val downvoters = question.downvoters - name
                    viewModel.editQuestion(
                        question.copy(
                            upvoters = upvoters,
                            downvoters = downvoters
                        )
                    )
                }
                binding.downvote.setOnClickListener {
                    val downvoters = if (name in question.downvoters) {
                        question.downvoters - name
                    } else {
                        question.downvoters + name
                    }
                    val upvoters = question.upvoters - name
                    viewModel.editQuestion(
                        question.copy(
                            downvoters = downvoters,
                            upvoters = upvoters
                        )
                    )
                }
                if (name in question.upvoters) {
                    binding.upvote.setColorFilter(Color.rgb(255, 69, 0))
                    binding.questionNumVotes.setTextColor(Color.rgb(255, 69, 0))
                    binding.downvote.clearColorFilter()
                } else {
                    binding.upvote.clearColorFilter()
                    if (name in question.downvoters) {
                        binding.downvote.setColorFilter(Color.rgb(113, 147, 255))
                        binding.questionNumVotes.setTextColor(Color.rgb(113, 147, 255))
                    } else {
                        binding.downvote.clearColorFilter()
                        binding.questionNumVotes.setTextColor(originalColor)
                    }
                }
            } else {
                println("Failed loading data.")
            }
        })
        answersViewModel.questionId = args.questionId
        answersViewModel.answers.observe(viewLifecycleOwner){
            // Check State.Success
            if (it !is State.Success) return@observe
            val data = it.data
            // Render answers here
            binding.ansListView.adapter = AnswersAdapter(data)
            binding.ansListView.layoutManager =
                LinearLayoutManager(context,RecyclerView.VERTICAL,false)
            println(data)
        }
//        Navigate to new answer fragment
//         button.setOnClickListener {
//             val action = QuestionDisplayDirections.actionQuestionDisplayToNewAnswer(args.questionId)
//             binding.root.findNavController().navigate(action)
//         }
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        @JvmStatic
        fun newInstance() = QuestionDisplay()
    }
}
