# Proguard rules for Firebase and Google Play Services in Release mode

# Keep Google Play Services classes from being obfuscated
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Firebase classes from being obfuscated
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Flutter Secure Storage proguard rules (if needed)
-keep class class.to.keep.** { *; }
-dontwarn javax.security.auth.callback.PasswordCallback
