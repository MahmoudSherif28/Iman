package com.example.iman

import android.content.ContentUris
import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : AudioServiceActivity() {
    private val channelName = "iman/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "needsLegacyStoragePermission" -> {
                    result.success(Build.VERSION.SDK_INT < Build.VERSION_CODES.Q)
                }

                "findInDownloads" -> {
                    val relativePath = call.argument<String>("relativePath") ?: ""
                    val fileName = call.argument<String>("fileName") ?: ""
                    if (fileName.isBlank()) {
                        result.success(null)
                        return@setMethodCallHandler
                    }

                    try {
                        val found = findInDownloads(relativePath = relativePath, fileName = fileName)
                        result.success(found)
                    } catch (e: Exception) {
                        result.error("FIND_FAILED", e.message, null)
                    }
                }

                "saveToDownloads" -> {
                    val sourcePath = call.argument<String>("sourcePath") ?: ""
                    val relativePath = call.argument<String>("relativePath") ?: ""
                    val fileName = call.argument<String>("fileName") ?: ""
                    val mimeType = call.argument<String>("mimeType") ?: "audio/mpeg"

                    if (sourcePath.isBlank() || fileName.isBlank()) {
                        result.error("INVALID_ARGS", "sourcePath and fileName are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val saved = saveToDownloads(
                            sourcePath = sourcePath,
                            relativePath = relativePath,
                            fileName = fileName,
                            mimeType = mimeType
                        )
                        result.success(saved)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun normalizeRelativePath(relativePath: String): String {
        val trimmed = relativePath.trim().trim('/')
        return if (trimmed.isEmpty()) "" else "$trimmed/"
    }

    private fun mediaStoreRelativePath(relativePath: String): String {
        val normalized = normalizeRelativePath(relativePath)
        return if (normalized.isEmpty()) {
            "${Environment.DIRECTORY_DOWNLOADS}/"
        } else {
            "${Environment.DIRECTORY_DOWNLOADS}/$normalized"
        }
    }

    private fun findInDownloads(relativePath: String, fileName: String): String? {
        val legacyPath = legacyDownloadPath(relativePath, fileName)
        if (legacyPath != null && File(legacyPath).exists()) return legacyPath

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null

        val resolver = applicationContext.contentResolver
        val projection = arrayOf(MediaStore.MediaColumns._ID)
        val selection = "${MediaStore.MediaColumns.RELATIVE_PATH}=? AND ${MediaStore.MediaColumns.DISPLAY_NAME}=?"
        val args = arrayOf(mediaStoreRelativePath(relativePath), fileName)

        resolver.query(
            MediaStore.Downloads.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            args,
            null
        )?.use { cursor ->
            if (cursor.moveToFirst()) {
                val idIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns._ID)
                val id = cursor.getLong(idIndex)
                return ContentUris.withAppendedId(MediaStore.Downloads.EXTERNAL_CONTENT_URI, id).toString()
            }
        }

        return null
    }

    private fun saveToDownloads(sourcePath: String, relativePath: String, fileName: String, mimeType: String): String {
        val existing = findInDownloads(relativePath = relativePath, fileName = fileName)
        if (!existing.isNullOrBlank()) return existing

        val sourceFile = File(sourcePath)
        if (!sourceFile.exists()) {
            throw IllegalStateException("Source file does not exist")
        }

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            saveToDownloadsMediaStore(sourceFile = sourceFile, relativePath = relativePath, fileName = fileName, mimeType = mimeType)
        } else {
            saveToDownloadsLegacy(sourceFile = sourceFile, relativePath = relativePath, fileName = fileName)
        }
    }

    private fun saveToDownloadsMediaStore(sourceFile: File, relativePath: String, fileName: String, mimeType: String): String {
        val resolver = applicationContext.contentResolver

        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, mediaStoreRelativePath(relativePath))
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }

        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
            ?: throw IllegalStateException("Failed to create Downloads entry")

        try {
            resolver.openOutputStream(uri)?.use { out ->
                FileInputStream(sourceFile).use { input ->
                    input.copyTo(out)
                }
            } ?: throw IllegalStateException("Failed to open output stream")

            val doneValues = ContentValues().apply {
                put(MediaStore.MediaColumns.IS_PENDING, 0)
            }
            resolver.update(uri, doneValues, null, null)
        } catch (e: Exception) {
            resolver.delete(uri, null, null)
            throw e
        }

        return uri.toString()
    }

    private fun legacyDownloadPath(relativePath: String, fileName: String): String? {
        val base = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val trimmed = relativePath.trim().trim('/')
        val dir = if (trimmed.isEmpty()) base else File(base, trimmed)
        return File(dir, fileName).absolutePath
    }

    private fun saveToDownloadsLegacy(sourceFile: File, relativePath: String, fileName: String): String {
        val baseDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val trimmed = relativePath.trim().trim('/')
        val targetDir = if (trimmed.isEmpty()) baseDir else File(baseDir, trimmed)
        if (!targetDir.exists()) targetDir.mkdirs()

        val targetFile = File(targetDir, fileName)
        if (targetFile.exists()) return targetFile.absolutePath

        FileInputStream(sourceFile).use { input ->
            FileOutputStream(targetFile).use { output ->
                input.copyTo(output)
            }
        }

        return targetFile.absolutePath
    }
}
