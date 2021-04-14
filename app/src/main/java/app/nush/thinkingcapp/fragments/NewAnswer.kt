package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import app.nush.thinkingcapp.viewmodels.AnswersViewModel
import com.nush.thinkingcapp.databinding.FragmentNewAnswerBinding


class NewAnswer : Fragment() {
    private var binding: FragmentNewAnswerBinding? = null
    private val answersViewModel: AnswersViewModel by viewModels()
    private val args: NewAnswerArgs by navArgs()
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        answersViewModel.questionId = args.questionId
        val binding =
            FragmentNewAnswerBinding.inflate(inflater, container, false)
//        button.setOnClickListener {
//            answersViewModel.addAnswer(...)
//        }
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }
}
