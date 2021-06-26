package app.nush.thinkingcapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.nush.thinkingcapp.databinding.ImageThumbnailBinding
import com.stfalcon.imageviewer.StfalconImageViewer

class ImagesAdapter(
    val imageURLs: List<String>,
) :
    RecyclerView.Adapter<ImagesAdapter.ViewHolder>() {

    inner class ViewHolder(private val binding: ImageThumbnailBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(imageURL: String, position: Int) {
            Glide
                .with(binding.root.context)
                .load(imageURL)
                .centerCrop()
                .apply(RequestOptions().override(300, 300))
                .into(binding.imageView)
            binding.imageView.setOnClickListener {
                StfalconImageViewer.Builder(binding.root.context,
                    imageURLs,
                    ::loadImage)
                    .withStartPosition(position)
                    .withTransitionFrom(binding.imageView)
                    .show()
            }
            binding.executePendingBindings()
        }

        private fun loadImage(imageView: ImageView, url: String) {
            Glide
                .with(binding.root.context)
                .load(url)
                .centerCrop()
                .fitCenter()
                .into(imageView)
        }
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int,
    ): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = ImageThumbnailBinding.inflate(inflater, parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(imageURLs[position], position)
    }

    override fun getItemCount(): Int {
        return imageURLs.size
    }

}
