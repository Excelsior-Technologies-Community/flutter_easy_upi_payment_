package com.sufiyan.flutter_easy_upi_payment

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterEasyUpiPaymentPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: Result? = null

    companion object {
        private const val CHANNEL_NAME = "flutter_easy_upi_payment"
        private const val UPI_REQUEST_CODE = 7842
    }

    override fun onAttachedToEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(
            binding.binaryMessenger,
            CHANNEL_NAME
        )

        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "launchUpiPayment" -> {
                launchUpiPayment(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun launchUpiPayment(
        call: MethodCall,
        result: Result
    ) {
        val currentActivity = activity

        if (currentActivity == null) {
            result.error(
                "NO_ACTIVITY",
                "Unable to access Android activity.",
                null
            )
            return
        }

        val upiUri = call.argument<String>("upiUri")
        val packageName = call.argument<String>("packageName")

        if (upiUri.isNullOrBlank()) {
            result.error(
                "INVALID_URI",
                "UPI URI cannot be empty.",
                null
            )
            return
        }

        if (pendingResult != null) {
            result.error(
                "PAYMENT_IN_PROGRESS",
                "Another UPI payment is already in progress.",
                null
            )
            return
        }

        try {
            val uri = Uri.parse(upiUri)

            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = uri

                if (!packageName.isNullOrBlank()) {
                    setPackage(packageName)
                }
            }

            pendingResult = result

            currentActivity.startActivityForResult(
                intent,
                UPI_REQUEST_CODE
            )
        } catch (exception: ActivityNotFoundException) {
            pendingResult = null

            result.error(
                "UPI_APP_NOT_FOUND",
                if (packageName.isNullOrBlank()) {
                    "No compatible UPI application is installed."
                } else {
                    "The selected UPI application is not installed."
                },
                null
            )
        } catch (exception: Exception) {
            pendingResult = null

            result.error(
                "UPI_LAUNCH_FAILED",
                exception.message ?: "Unable to launch UPI payment.",
                null
            )
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity

        binding.addActivityResultListener { requestCode, resultCode, data ->
            if (requestCode != UPI_REQUEST_CODE) {
                return@addActivityResultListener false
            }

            handlePaymentResult(
                resultCode,
                data
            )

            true
        }
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun handlePaymentResult(
        resultCode: Int,
        data: Intent?
    ) {
        val result = pendingResult ?: return

        pendingResult = null

        val response = data?.getStringExtra("response")

        if (!response.isNullOrBlank()) {
            result.success(response)
            return
        }

        if (resultCode == Activity.RESULT_CANCELED) {
            result.success("Status=Cancelled")
            return
        }

        result.success("Status=Unknown")
    }

    override fun onDetachedFromEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel.setMethodCallHandler(null)
        pendingResult = null
    }
}