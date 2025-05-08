plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.checkin.enterpriseapp"
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
        applicationId = "com.checkin.enterpriseapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    def keystorePropertiesFile = rootProject.file("gradle.properties")
    def keystoreProperties = new Properties()
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

    signingConfigs {
        release {
            storeFile file(keystoreProperties['MYAPP_RELEASE_STORE_FILE'])
            storePassword keystoreProperties['MYAPP_RELEASE_STORE_PASSWORD']
            keyAlias keystoreProperties['MYAPP_RELEASE_KEY_ALIAS']
            keyPassword keystoreProperties['MYAPP_RELEASE_KEY_PASSWORD']
        }
    }

    buildTypes {
        release {
            // Disable debugging for release builds
            debuggable false
            // Enable code shrinking, obfuscation, and optimization for release builds
            minifyEnabled true
            // Use ProGuard to shrink and obfuscate your code
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            // Use the release signing configuration
            signingConfig signingConfigs.release
        }
    }
}

flutter {
    source = "../.."
}
