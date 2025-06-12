# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Timezone (used internally by flutter_local_notifications)
-keep class org.threeten.bp.** { *; }
-dontwarn org.threeten.bp.**

# Optional: Prevent obfuscation of Flutter entry points
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn com.google.android.play.**
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**
