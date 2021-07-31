package app.nush.thinkingcapp.adapters

import android.net.Uri
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.nush.thinkingcapp.databinding.ImageThumbnailBinding
import com.stfalcon.imageviewer.StfalconImageViewer

class URIImagesAdapter(
    val imageURIs: List<Uri>,
) :
    RecyclerView.Adapter<URIImagesAdapter.ViewHolder>() {

    inner class ViewHolder(private val binding: ImageThumbnailBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(imageURI: Uri, position: Int) {
            Glide
                .with(binding.root.context)
                .load(imageURI)
                .centerCrop()
                .apply(RequestOptions().override(300, 300))
                .into(binding.imageView)
            binding.imageView.setOnClickListener {
                StfalconImageViewer.Builder(binding.root.context,
                    imageURIs,
                    ::loadImage)
                    .withStartPosition(position)
                    .withTransitionFrom(binding.imageView)
                    .show()
            }
            binding.executePendingBindings()
        }

        private fun loadImage(imageView: ImageView, uri: Uri) {
            Glide
                .with(binding.root.context)
                .load(uri)
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
        holder.bind(imageURIs[position], position)
    }

    override fun getItemCount(): Int {
        return imageURIs.size
    }

}
