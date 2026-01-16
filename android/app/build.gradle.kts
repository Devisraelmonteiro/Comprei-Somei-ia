plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin do Flutter SEMPRE depois
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.compreisomei.comprei_some_ia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // ✅ Obrigatório para flutter_local_notifications
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // ✅ ISSO resolve o erro do build release
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "br.com.compreisomei.comprei_some_ia"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Temporário (ok pra agora)
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    // ✅ Dependência exigida pelo desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
