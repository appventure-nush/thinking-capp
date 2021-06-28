package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.nush.thinkingcapp.databinding.FilterItemBinding

class FilterAdapter(private val filters: Map<String, Boolean>) :
    RecyclerView.Adapter<FilterAdapter.ViewHolder>() {

    private val filterTexts: List<String> = filters.keys.toList()
    private val filterChecked: List<Boolean> = filters.values.toList()
    val checkedFilters = filters.filter { it.value }.keys.toMutableList()

    inner class ViewHolder(private val binding: FilterItemBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(text: String, checked: Boolean) {
            binding.filter.text = text
            binding.filter.isChecked = checked
            binding.filter.setOnCheckedChangeListener { _, isChecked ->
                if (isChecked) {
                    checkedFilters.add(text)
                } else {
                    checkedFilters.remove(text)
                }
            }
            binding.executePendingBindings()
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = FilterItemBinding.inflate(inflater, parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(filterTexts[position], filterChecked[position])
    }

    override fun getItemCount(): Int {
        return filters.size
    }


}
