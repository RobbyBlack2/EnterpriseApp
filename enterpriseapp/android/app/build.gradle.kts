import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.checkin.enterprise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.checkin.enterprise"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keystorePropertiesFile = rootProject.file("gradle.properties")
    val keystoreProperties = Properties()
    keystoreProperties.load(keystorePropertiesFile.inputStream())

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties.getProperty("MYAPP_RELEASE_STORE_FILE"))
            storePassword = keystoreProperties.getProperty("MYAPP_RELEASE_STORE_PASSWORD")
            keyAlias = keystoreProperties.getProperty("MYAPP_RELEASE_KEY_ALIAS")
            keyPassword = keystoreProperties.getProperty("MYAPP_RELEASE_KEY_PASSWORD")
        }
    }

    buildTypes {
        getByName("release") {
            // Disable debugging for release builds
            isDebuggable = false
            // Enable code shrinking, obfuscation, and optimization for release builds
            isMinifyEnabled = true
            // Use ProGuard to shrink and obfuscate your code
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Use the release signing configuration
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}