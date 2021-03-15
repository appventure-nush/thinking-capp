package app.nush.thinkingcapp.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nush.thinkingcapp.R


/**
 * A simple [Fragment] subclass.
 * Use the [NewQuestion.newInstance] factory method to
 * create an instance of this fragment.
 */
class NewQuestion : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        println("ok")
        return inflater.inflate(R.layout.fragment_new_question, container, false)
    }

    companion object {
        @JvmStatic
        fun newInstance() = NewQuestion()
    }
}
