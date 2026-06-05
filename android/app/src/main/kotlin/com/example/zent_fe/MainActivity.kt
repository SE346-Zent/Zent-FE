package com.example.zent_fe

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL = "zent_fe/file_manager"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openFolder") {
                    val path = call.argument<String>("path")
                    if (path == null) {
                        result.error("INVALID_ARGUMENT", "path is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        openFolderInFileManager(path)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("OPEN_FOLDER_FAILED", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun openFolderInFileManager(path: String) {
        // Build the content URI for the folder to highlight it in the Files app.
        // This works for /storage/emulated/0/Download and similar public paths.
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Android 8+ – open via DocumentsUI
            val downloadsUri = Uri.parse(
                "content://com.android.externalstorage.documents/document/primary%3ADownload"
            )
            Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(downloadsUri, "vnd.android.document/directory")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        } else {
            // Older Android – open via file URI
            Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(Uri.fromFile(File(path)), "resource/folder")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        }
        startActivity(intent)
    }
}
