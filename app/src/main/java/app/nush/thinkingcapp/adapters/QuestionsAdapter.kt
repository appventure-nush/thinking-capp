package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.navigation.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.fragments.MainContentDirections
import app.nush.thinkingcapp.models.Question
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.QuestionItemBinding

class QuestionsAdapter(val questions: List<Question>) :
    RecyclerView.Adapter<QuestionsAdapter.ViewHolder>() {


    inner class ViewHolder(private val binding: QuestionItemBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(item: Question) {
            binding.question = item
            binding.root.setOnClickListener {
                val action = MainContentDirections.actionMainContentToQuestionDisplay(item.id)
                binding.root.findNavController().navigate(action)
            }
            if (item.files.isNotEmpty())
                binding.title.setCompoundDrawablesRelativeWithIntrinsicBounds(
                0, 0, R.drawable.ic_baseline_image_24, 0
                )
            binding.tagsRecyclerView.adapter = TagsAdapter(item.tags)
            binding.tagsRecyclerView.layoutManager =
                LinearLayoutManager(binding.root.context, RecyclerView.HORIZONTAL, false)
            binding.executePendingBindings()
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = QuestionItemBinding.inflate(inflater, parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(questions[position])
    }

    override fun getItemCount(): Int {
        return questions.size
    }


}
