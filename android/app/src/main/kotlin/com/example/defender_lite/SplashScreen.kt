import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Generate the binding code
        val bindingCode = generateBindingCode()

        // Save the binding code in SharedPreferences
        saveBindingCode(this, bindingCode)

        // Log the generated binding code for debugging purposes
        Log.d("DefenderLite", "Generated Binding Code: $bindingCode")
    }

    private fun generateBindingCode(): String {
        return (100000..999999).random().toString() // 6-digit random code
    }

    // Save the generated binding code into SharedPreferences
    private fun saveBindingCode(context: Context, code: String) {
        val sharedPreferences = context.getSharedPreferences("AppBinding", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("binding_code", code).apply() // Save asynchronously
    }
}
