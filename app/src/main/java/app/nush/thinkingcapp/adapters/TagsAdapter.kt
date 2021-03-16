package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.navigation.findNavController
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.fragments.MainContentDirections
import app.nush.thinkingcapp.models.Question
import com.nush.thinkingcapp.databinding.QuestionItemBinding
import com.nush.thinkingcapp.databinding.TagChipBinding

class TagsAdapter(private val tags: List<String>) :
    RecyclerView.Adapter<TagsAdapter.ViewHolder>() {


    inner class ViewHolder(private val binding: TagChipBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(item: String) {
            binding.tag = item
            binding.executePendingBindings()
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = TagChipBinding.inflate(inflater, parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(tags[position])
    }

    override fun getItemCount(): Int {
        return tags.size
    }


}
