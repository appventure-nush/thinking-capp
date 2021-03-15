package app.nush.thinkingcapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.observe
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.adapters.QuestionsAdapter
import app.nush.thinkingcapp.util.Navigation
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.R
import kotlinx.android.synthetic.main.fragment_main_content.view.*

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [MainContent.newInstance] factory method to
 * create an instance of this fragment.
 */
class MainContent : Fragment() {
    private val viewModel: QuestionsViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_main_content, container, false)
        view.recycler_view.layoutManager =
            LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        viewModel.questions.observe(this) {
            if (it is State.Success) {
                val adapter = QuestionsAdapter(it.data)
                view.recycler_view.adapter = adapter
            } else {
                println("Failed loading data")
            }
        }
        view.recycler_view.addItemDecoration(
            DividerItemDecoration(
                this.context,
                DividerItemDecoration.VERTICAL
            )
        )
        view.fab.setOnClickListener {
            Navigation.navigate(R.id.newQuestion)
        }
        return view
    }

    companion object {
        @JvmStatic
        fun newInstance() = MainContent()
    }
}
