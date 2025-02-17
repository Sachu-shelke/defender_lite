//package com.example.defender_lite
//
//import android.graphics.Bitmap
//import android.os.Bundle
//import android.widget.ImageView
//import androidx.appcompat.app.AppCompatActivity
//import com.journeyapps.barcodescanner.BarcodeEncoder
//import com.google.zxing.BarcodeFormat
//import com.google.zxing.MultiFormatWriter
//import com.google.zxing.WriterException
//import com.google.zxing.common.BitMatrix
//
//class QRGeneratorActivity : AppCompatActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_qr_generator)
//
//        val qrImageView: ImageView = findViewById(R.id.qrImageView)
//        val textToEncode = "Hello, Defender Lite!"
//
//        try {
//            val bitMatrix: BitMatrix = MultiFormatWriter().encode(
//                textToEncode, BarcodeFormat.QR_CODE, 500, 500
//            )
//            val barcodeEncoder = BarcodeEncoder()
//            val bitmap: Bitmap = barcodeEncoder.createBitmap(bitMatrix)
//            qrImageView.setImageBitmap(bitmap)
//        } catch (e: WriterException) {
//            e.printStackTrace()
//        }
//    }
//}
