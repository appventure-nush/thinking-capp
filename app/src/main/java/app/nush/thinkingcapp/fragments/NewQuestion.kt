package app.nush.thinkingcapp.fragments

import android.app.Activity
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.Observer
import androidx.navigation.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.nush.thinkingcapp.MainActivity
import app.nush.thinkingcapp.adapters.URIImagesAdapter
import app.nush.thinkingcapp.util.*
import app.nush.thinkingcapp.viewmodels.MetaDataViewModel
import app.nush.thinkingcapp.viewmodels.NewQuestionViewModel
import app.nush.thinkingcapp.viewmodels.QuestionsViewModel
import com.github.dhaval2404.imagepicker.ImagePicker
import com.nush.thinkingcapp.R
import com.nush.thinkingcapp.databinding.FragmentNewQuestionBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


/**
 * A simple [Fragment] subclass.
 * Use the [NewQuestion.newInstance] factory method to
 * create an instance of this fragment.
 */
class NewQuestion : Fragment() {

    private val questionsViewModel: QuestionsViewModel by activityViewModels()
    private val metaDataViewModel: MetaDataViewModel by activityViewModels()
    private var binding: FragmentNewQuestionBinding? = null
    private val newQuestionViewModel = NewQuestionViewModel()
    private val imageResultHandler =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result: ActivityResult ->
            val resultCode = result.resultCode
            val data = result.data

            when (resultCode) {
                Activity.RESULT_OK -> {
                    val fileUri = data?.data!!
                    newQuestionViewModel.files += fileUri
                    binding?.imagesView?.adapter =
                        URIImagesAdapter(newQuestionViewModel.files)
                    binding?.imagesView?.layoutManager =
                        LinearLayoutManager(context,
                            RecyclerView.HORIZONTAL,
                            false)
                }
                ImagePicker.RESULT_ERROR -> {
                    Toast.makeText(this.requireContext(),
                        ImagePicker.getError(data),
                        Toast.LENGTH_SHORT).show()
                }
                else -> {
                    Toast.makeText(this.requireContext(),
                        "Task cancelled",
                        Toast.LENGTH_SHORT).show()
                }
            }
        }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        // Inflate the layout for this fragment
        val binding =
            FragmentNewQuestionBinding.inflate(inflater, container, false)
        binding.question = newQuestionViewModel

        binding.addQuestionFab.setOnClickListener {
            GlobalScope.launch(Dispatchers.IO) {
                val urls = newQuestionViewModel.files.pmap {
                    val stream =
                        requireContext().contentResolver.openInputStream(it)!!
                    CloudStorage.addObject(stream,
                        getFileExtension(it, requireContext()))
                }
                val question = newQuestionViewModel.toQuestion().copy(
                    tags = binding.nachoTextView.chipValues,
                    files = urls
                )
                questionsViewModel.addQuestion(question)
            }
            Toast.makeText(this.requireContext(),
                getString(R.string.question_added),
                Toast.LENGTH_SHORT).show()
            hideKeyboard(activity as MainActivity)
//            Navigation.navigate(R.id.mainContent)
            binding.root.findNavController().popBackStack()
        }
        metaDataViewModel.metadata.observe(viewLifecycleOwner, Observer {
            val data = (it as? State.Success)?.data ?: return@Observer
            binding.nachoTextView.setAdapter(
                ArrayAdapter(
                    this.requireContext(),
                    R.layout.support_simple_spinner_dropdown_item,
                    data.tags
                )
            )
        })
        binding.upload.setOnClickListener {
            ImagePicker.with(this).createIntent { intent ->
                imageResultHandler.launch(intent)
            }
        }
        this.binding = binding
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        binding = null
    }

    companion object {
        @JvmStatic
        fun newInstance() = NewQuestion()
    }
}
