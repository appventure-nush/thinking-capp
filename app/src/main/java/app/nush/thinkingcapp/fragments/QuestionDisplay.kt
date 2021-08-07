package app.nush.thinkingcapp.fragments

import android.app.AlertDialog
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.navigation.findNavController
import androidx.navigation.fragment.navArgs
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.adapters.AnswersAdapter
import app.nush.thinkingcapp.adapters.ImagesAdapter
import app.nush.thinkingcapp.adapters.TagsAdapter
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.models.findByEmail
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.AnswersViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import app.nush.thinkingcapp.viewmodels.UsersViewModel
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentQuestionDisplayBinding


/**
 * A simple [Fragment] subclass.
 * Use the [QuestionDisplay.newInstance] factory method to
 * create an instance of this fragment.
 */
class QuestionDisplay : Fragment() {
    private val viewModel: QuestionsViewModel by activityViewModels()
    private val answersViewModel: AnswersViewModel by viewModels()
    private val usersViewModel: UsersViewModel by activityViewModels()
    private val args: QuestionDisplayArgs by navArgs()
    var binding: FragmentQuestionDisplayBinding? = null
    private var originalColor = 0
    private val firebaseAuth by lazy {
        FirebaseAuth.getInstance()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        val binding =
            FragmentQuestionDisplayBinding.inflate(inflater, container, false)
        originalColor = binding.questionNumVotes.currentTextColor

        usersViewModel.users.observe(viewLifecycleOwner, Observer { users ->
            if (users !is State.Success) {
                println("Failed loading user data")
                Toast.makeText(
                    requireContext(), R.string.load_data_error, Toast.LENGTH_SHORT)
                    .show()
                return@Observer
            }
            val isAdmin = users.data.findByEmail(firebaseAuth.currentUser?.email!!).admin
            if (isAdmin)
                binding.fab.visibility = View.VISIBLE
            viewModel.questions.observe(viewLifecycleOwner, Observer {
                if (it is State.Success) {
                    val question =
                        it.data.firstOrNull { question -> question.id == args.questionId }
                            ?: run {
                                println("Question not found.")
                                Toast.makeText(
                                    requireContext(), R.string.load_question_error, Toast.LENGTH_SHORT)
                                    .show()
                                return@Observer
                            }
                    val questionAuthor = users.data.findByEmail(question.author)
                    renderQuestion(
                        question.copy(author = questionAuthor.username),
                        binding,
                        isAdmin || questionAuthor.email == firebaseAuth.currentUser?.email!!)
                } else {
                    println("Failed loading data.")
                    Toast.makeText(
                        requireContext(), R.string.load_data_error, Toast.LENGTH_SHORT)
                        .show()
                }
            })
        })

        answersViewModel.questionId = args.questionId
        usersViewModel.users.observe(viewLifecycleOwner) { users ->
            if (users !is State.Success) {
                println("Failed user loading data")
                Toast.makeText(
                    requireContext(), R.string.load_data_error, Toast.LENGTH_SHORT)
                    .show()
                return@observe
            }
            answersViewModel.answers.observe(viewLifecycleOwner) {
                // Check State.Success
                if (it !is State.Success) return@observe
                val data = it.data.map { answer ->
                    answer.copy(author = users.data.findByEmail(answer.author).username)
                }.sortedByDescending { answer ->
                    answer.answeredDate
                }.sortedBy { answer ->
                    -answer.votes
                }
                // Render answers here
                binding.ansListView.adapter =
                    AnswersAdapter(data, answersViewModel)
                binding.ansListView.layoutManager =
                    LinearLayoutManager(context,
                        RecyclerView.VERTICAL,
                        false)
            }
        }
        binding.fab.setOnClickListener {
            val action =
                QuestionDisplayDirections.actionQuestionDisplayToNewAnswer(args.questionId)
            binding.root.findNavController().navigate(action)
        }
        this.binding = binding
        return binding.root
    }


    private fun renderQuestion(
        question: Question,
        binding: FragmentQuestionDisplayBinding,
        showClarify: Boolean
    ) {
        binding.question = question
        binding.tagsListView.adapter = TagsAdapter(question.tags)
        binding.tagsListView.layoutManager =
            LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
        binding.imagesView.adapter = ImagesAdapter(question.files)
        binding.imagesView.layoutManager =
            LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
        val email = FirebaseAuth.getInstance().currentUser?.email!!
        binding.upvote.setOnClickListener {
            val upvoters = if (email in question.upvoters) {
                question.upvoters - email
            } else {
                question.upvoters + email
            }
            val downvoters = question.downvoters - email
            viewModel.editQuestion(
                question.copy(
                    upvoters = upvoters,
                    downvoters = downvoters
                )
            )
        }
        binding.downvote.setOnClickListener {
            val downvoters = if (email in question.downvoters) {
                question.downvoters - email
            } else {
                question.downvoters + email
            }
            val upvoters = question.upvoters - email
            viewModel.editQuestion(
                question.copy(
                    downvoters = downvoters,
                    upvoters = upvoters
                )
            )
        }
        if (email in question.upvoters) {
            binding.upvote.setColorFilter(Color.rgb(255, 69, 0))
            binding.questionNumVotes.setTextColor(Color.rgb(255, 69, 0))
            binding.downvote.clearColorFilter()
        } else {
            binding.upvote.clearColorFilter()
            if (email in question.downvoters) {
                binding.downvote.setColorFilter(Color.rgb(113, 147, 255))
                binding.questionNumVotes.setTextColor(Color.rgb(113, 147, 255))
            } else {
                binding.downvote.clearColorFilter()
                binding.questionNumVotes.setTextColor(originalColor)
            }
        }

        if (showClarify) {
            binding.clarify.setOnClickListener {
                if (question.requireClarification)
                    viewModel.editQuestionStatus(
                        question, false, true)
                else {
                    val alertDialog: AlertDialog? = activity?.let {
                        val builder = AlertDialog.Builder(it)
                        builder.apply {
                            setTitle(R.string.clarify_dialog)
                            setPositiveButton(R.string.ok) { _, _ ->
                                viewModel.editQuestionStatus(
                                    question,
                                    false,
                                    true)
                            }
                            setNegativeButton(R.string.cancel) { _, _ -> }
                        }
                        builder.create()
                    }
                    alertDialog?.show()
                }
            }
        } else {
            binding.clarify.visibility = View.INVISIBLE
        }
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
