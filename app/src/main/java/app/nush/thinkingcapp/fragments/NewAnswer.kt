package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.navigation.findNavController
import androidx.navigation.fragment.navArgs
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.util.notifications.NotificationServer
import app.nush.thinkingcapp.util.notifications.models.NewAnswerNotification
import app.nush.thinkingcapp.viewmodels.AnswersViewModel
import app.nush.thinkingcapp.viewmodels.NewAnswerViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.databinding.FragmentNewAnswerBinding
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class NewAnswer : Fragment() {
    private var binding: FragmentNewAnswerBinding? = null
    private val answersViewModel: AnswersViewModel by viewModels()
    private val questionsViewModel: QuestionsViewModel by viewModels()
    private val args: NewAnswerArgs by navArgs()
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        answersViewModel.questionId = args.questionId
        val binding =
            FragmentNewAnswerBinding.inflate(inflater, container, false)
        val newAnswerViewModel = NewAnswerViewModel()
        binding.answer = newAnswerViewModel
        questionsViewModel.questions.observe(viewLifecycleOwner, Observer {
            if (it is State.Success) {
                val question =
                    it.data.firstOrNull { question -> question.id == args.questionId }
                        ?: run {
                            println("Question not found.")
                            return@Observer
                        }
                binding.question = question
            }
        })
        binding.addAnswerFab.setOnClickListener {
            val answer = newAnswerViewModel.toAnswer().copy()
            answersViewModel.addAnswer(answer)
            GlobalScope.launch {
                val notification = NewAnswerNotification.fromQuestionAndAnswer(
                    binding.question!!,
                    answer)
                NotificationServer.sendNotification(notification)
            }

            val action =
                NewAnswerDirections.actionNewAnswerToQuestionDisplay(args.questionId)
            binding.root.findNavController().navigate(action)
        }
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

}
