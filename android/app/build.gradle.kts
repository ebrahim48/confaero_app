import java.util.Properties

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(keystorePropertiesFile.inputStream())
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "confaero.com.app"
    compileSdk = 36
    // NDK r28+ links native code with 16 KB-aligned ELF segments by default,
    // required for Android 15 devices with 16 KB memory pages.
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "confaero.com.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // mobile_scanner 5.2.3 bundles ML Kit barcode-scanning 17.2.0, whose native
    // libs (libbarhopper_v3.so, libimage_processing_util_jni.so) are only 4 KB-
    // aligned and fail Google Play's 16 KB page-size check. Force the 16 KB-
    // aligned release; the higher version wins Gradle's conflict resolution.
    implementation("com.google.mlkit:barcode-scanning:17.3.0")

    // mobile_scanner 5.2.3 pins androidx.camera 1.3.3, whose
    // libimage_processing_util_jni.so is 4 KB-aligned. camera 1.5.0 ships the
    // 16 KB-aligned lib; the higher version wins conflict resolution.
    implementation("androidx.camera:camera-core:1.5.0")
    implementation("androidx.camera:camera-camera2:1.5.0")
    implementation("androidx.camera:camera-lifecycle:1.5.0")
}
