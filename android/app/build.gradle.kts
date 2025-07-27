// import java.util.Properties
// import java.io.FileInputStream

plugins {
    id("com.android.application")
    // Firebase Configuration removed for public repository
    // To enable Firebase, uncomment:
    // id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Keystore properties removed for public repository
// val keystoreProperties = Properties()
// val keystorePropertiesFile = rootProject.file("key.properties")
// if (keystorePropertiesFile.exists()) {
//     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
// }

android {
   // namespace = "com.example.DIRDIR"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
       // applicationId = "com.example.DIRDIR"
        minSdk = 23 // minSdkVersion 23 olarak güncellendi
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing configs removed for public repository
    // To enable release signing, uncomment and configure:
    // signingConfigs {
    //     create("release") {
    //         keyAlias = keystoreProperties["keyAlias"] as String
    //         keyPassword = keystoreProperties["keyPassword"] as String
    //         storeFile = keystoreProperties["storeFile"]?.let { file(it) }
    //         storePassword = keystoreProperties["storePassword"] as String
    //     }
    // }
    
    buildTypes {
        release {
            // Release signing removed for public repository
            // signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
