pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    // ✅ 모든 Kotlin 플러그인을 2.0.20으로 강제
    resolutionStrategy {
        eachPlugin {
            if (requested.id.id.startsWith("org.jetbrains.kotlin")) {
                useVersion("2.0.20")
            }
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // ✅ AGP를 8.5.2로 낮춰 안정화 (Gradle 8.7과 궁합)
    id("com.android.application") version "8.5.2" apply false
    // ✅ Kotlin도 2.0.20로 통일
    id("org.jetbrains.kotlin.android") version "2.0.20" apply false
}

include(":app")
