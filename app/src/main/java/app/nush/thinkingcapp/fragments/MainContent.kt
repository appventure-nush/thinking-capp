package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.adapters.QuestionsAdapter
import app.nush.thinkingcapp.models.findByEmail
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import app.nush.thinkingcapp.viewmodels.UsersViewModel
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentMainContentBinding

/**
 * A simple [Fragment] subclass.
 * Use the [MainContent.newInstance] factory method to
 * create an instance of this fragment.
 */
class MainContent : Fragment() {
    private val viewModel: QuestionsViewModel by activityViewModels()
    private val usersViewModel: UsersViewModel by activityViewModels()
    var binding: FragmentMainContentBinding? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        // Inflate the layout for this fragment
        val binding =
            FragmentMainContentBinding.inflate(inflater, container, false)
        binding.recyclerView.layoutManager =
            LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        usersViewModel.users.observe(viewLifecycleOwner) { users ->
            if (users !is State.Success) {
                println("Failed loading user data in main")
                println(users)
                return@observe
            }
            viewModel.questions.observe(viewLifecycleOwner, {
                if (it is State.Success) {
                    val adapter = QuestionsAdapter(
                        it.data.map { question ->
                            question.copy(author = users.data.findByEmail(
                                question.author).username)
                        }
                    )
                    binding.recyclerView.adapter = adapter
                } else {
                    println("Failed loading data")
                }
            })
        }

        binding.recyclerView.addItemDecoration(
            DividerItemDecoration(
                this.context,
                DividerItemDecoration.VERTICAL
            )
        )
        binding.fab.setOnClickListener {
            Navigation.navigate(R.id.newQuestion)
        }
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        @JvmStatic
        fun newInstance() = MainContent()
    }
}
