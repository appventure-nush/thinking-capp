package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.models.Question
import app.nush.thinkingcapp.util.State
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.nush.thinkingcapp.databinding.QuestionItemBinding

class QuestionsAdapter (val questions: List<Question>): RecyclerView.Adapter<QuestionsAdapter.ViewHolder>() {


    inner class ViewHolder(private val binding: QuestionItemBinding): RecyclerView.ViewHolder(binding.root){

        fun bind(item: Question){
            println("Binding: $item")
            binding.question = item
            binding.executePendingBindings()
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = QuestionItemBinding.inflate(inflater)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(questions[position])
    }

    override fun getItemCount(): Int {
        return questions.size
    }


}
