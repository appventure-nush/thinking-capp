package app.nush.thinkingcapp.fragments

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.observe
import androidx.navigation.fragment.navArgs
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.adapters.TagsAdapter
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.databinding.FragmentQuestionDisplayBinding
import kotlinx.android.synthetic.main.fragment_question_display.view.*


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
        val binding = FragmentQuestionDisplayBinding.inflate(inflater, container, false)
        val originalColor = binding.root.questionNumVotes.currentTextColor
        viewModel.questions.observe(this) {
            if (it is State.Success) {
                val question =
                    it.data.firstOrNull { question -> question.id == args.questionId } ?: run {
                        println("Question not found.")
                        return@observe
                    }
                binding.question = question
                binding.root.tagsListView.adapter = TagsAdapter(question.tags)
                binding.root.tagsListView.layoutManager =
                    LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                // TODO: Change when authentication implemented
                val name = "Adrian Ong"
                binding.root.upvote.setOnClickListener {
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
                binding.root.downvote.setOnClickListener {
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
                    binding.root.upvote.setColorFilter(Color.rgb(255, 69, 0))
                    binding.root.questionNumVotes.setTextColor(Color.rgb(255, 69, 0))
                    binding.root.downvote.clearColorFilter()
                } else {
                    binding.root.upvote.clearColorFilter()
                    if (name in question.downvoters) {
                        binding.root.downvote.setColorFilter(Color.rgb(113, 147, 255))
                        binding.root.questionNumVotes.setTextColor(Color.rgb(113, 147, 255))
                    } else {
                        binding.root.downvote.clearColorFilter()
                        binding.root.questionNumVotes.setTextColor(originalColor)
                    }
                }
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
