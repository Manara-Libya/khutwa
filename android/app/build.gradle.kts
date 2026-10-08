import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
}

// Secrets never live in the repo: the API key and the URL gist come from backend/.env (git-ignored),
// or from android/local.properties (values, or khutwa.envFile=<path to .env>) for builds elsewhere.
fun secret(name: String): String {
    val local = Properties().apply { rootProject.file("local.properties").takeIf { it.exists() }?.inputStream()?.use(::load) }
    local.getProperty(name)?.let { return it }
    // khutwa.envFile in local.properties points at the .env when building from another checkout.
    val env = local.getProperty("khutwa.envFile")?.let(::file) ?: rootProject.file("../backend/.env")
    if (env.exists()) env.readLines().firstOrNull { it.startsWith("$name=") }?.let { return it.substringAfter("=").trim() }
    return ""
}

val gistId = secret("KHUTWA_URL_GIST")
val gistOwner = providers.gradleProperty("khutwa.gistOwner").getOrElse("")

android {
    namespace = "ly.manara.khutwa"
    compileSdk = 37

    defaultConfig {
        applicationId = "ly.manara.khutwa"
        minSdk = 26
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        buildConfigField("String", "API_KEY", "\"${secret("KHUTWA_API_KEY")}\"")
        buildConfigField("String", "API_URL", "\"${secret("KHUTWA_API_URL")}\"")
        buildConfigField("String", "URL_GIST_RAW",
            "\"" + (if (gistId.isNotEmpty() && gistOwner.isNotEmpty())
                "https://gist.githubusercontent.com/$gistOwner/$gistId/raw/khutwa-url.json" else "") + "\"")
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
            signingConfig = signingConfigs.getByName("debug")  // demo builds only
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
    testOptions { unitTests.isReturnDefaultValues = true }
}


dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2026.09.00")
    implementation(composeBom)
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui-tooling-preview")
    debugImplementation("androidx.compose.ui:ui-tooling")
    implementation("androidx.activity:activity-compose:1.13.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.11.0")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.11.0")
    implementation("androidx.core:core-ktx:1.19.1")
    implementation("androidx.core:core-splashscreen:1.2.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.11.0")
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.json:json:20250517")  // real org.json on the JVM (Android's is a stub in unit tests)
}
