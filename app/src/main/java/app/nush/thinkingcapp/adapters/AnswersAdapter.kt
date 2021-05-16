package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.fragments.MainContentDirections
import app.nush.thinkingcapp.models.Answer
import com.nush.thinkingcapp.databinding.AnswerItemBinding

class AnswersAdapter (val answers: List<Answer>):
    RecyclerView.Adapter<AnswersAdapter.ViewHolder>(){

    inner class ViewHolder(private val binding: AnswerItemBinding) :
        RecyclerView.ViewHolder(binding.root){
            fun bind(item: Answer){
                binding.answer = item
                binding.executePendingBindings()
            }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = AnswerItemBinding.inflate(inflater, parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(answers[position])
    }

    override fun getItemCount(): Int {
        return answers.size
    }

}