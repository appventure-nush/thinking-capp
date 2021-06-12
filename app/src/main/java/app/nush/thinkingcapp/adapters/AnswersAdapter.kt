package app.nush.thinkingcapp.adapters

import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.models.Answer
import app.nush.thinkingcapp.viewmodels.AnswersViewModel
import com.google.firebase.auth.FirebaseAuth
import com.nush.thinkingcapp.databinding.AnswerItemBinding
import io.noties.markwon.Markwon

class AnswersAdapter(
    val answers: List<Answer>,
    val answersViewModel: AnswersViewModel,
) :
    RecyclerView.Adapter<AnswersAdapter.ViewHolder>() {

    inner class ViewHolder(private val binding: AnswerItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(answer: Answer) {
            val originalColor = binding.ansNumVotes.currentTextColor
            val markwon = Markwon.create(binding.root.context)
            binding.answer = answer
            binding.executePendingBindings()
            markwon.setMarkdown(binding.textViewBody, answer.body)
            val name = FirebaseAuth.getInstance().currentUser?.email!!
            binding.upvote.setOnClickListener {
                val upvoters = if (name in answer.upvoters) {
                    answer.upvoters - name
                } else {
                    answer.upvoters + name
                }
                val downvoters = answer.downvoters - name
                answersViewModel.editAnswer(
                    answer.copy(
                        upvoters = upvoters,
                        downvoters = downvoters
                    )
                )
            }
            binding.downvote.setOnClickListener {
                val downvoters = if (name in answer.downvoters) {
                    answer.downvoters - name
                } else {
                    answer.downvoters + name
                }
                val upvoters = answer.upvoters - name
                answersViewModel.editAnswer(
                    answer.copy(
                        downvoters = downvoters,
                        upvoters = upvoters
                    )
                )
            }
            if (name in answer.upvoters) {
                binding.upvote.setColorFilter(Color.rgb(255, 69, 0))
                binding.ansNumVotes.setTextColor(Color.rgb(255, 69, 0))
                binding.downvote.clearColorFilter()
            } else {
                binding.upvote.clearColorFilter()
                if (name in answer.downvoters) {
                    binding.downvote.setColorFilter(Color.rgb(113, 147, 255))
                    binding.ansNumVotes.setTextColor(Color.rgb(113,
                        147,
                        255))
                } else {
                    binding.downvote.clearColorFilter()
                    binding.ansNumVotes.setTextColor(originalColor)
                }
            }
        }
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int,
    ): ViewHolder {
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
