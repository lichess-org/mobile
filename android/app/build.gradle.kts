import groovy.json.JsonSlurper
import java.util.Properties
import java.io.FileInputStream
import java.io.File
import java.net.URI
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

abstract class CopyChessgroundPieceAssetsTask : DefaultTask() {
  @get:InputFile
  abstract val packageConfigFile: RegularFileProperty

  @get:OutputDirectory
  abstract val outputDirectory: DirectoryProperty

  @TaskAction
  fun copy() {
    val configFile = packageConfigFile.get().asFile
    check(configFile.exists()) {
      "Missing $configFile — run `flutter pub get` from the project root first."
    }

    val config = JsonSlurper().parse(configFile) as Map<*, *>

    @Suppress("UNCHECKED_CAST")
    val packages = config["packages"] as List<Map<*, *>>
    val chessground = packages.first { it["name"] == "chessground" }
    val packageDir = File(URI(chessground["rootUri"] as String))


    val outDir = outputDirectory.get().asFile
    outDir.deleteRecursively()
    outDir.mkdirs()
    val drawableDir = File(outDir, "drawable-nodpi")

    copyPieceAssets(packageDir, drawableDir)
    copyBoardThemes(packageDir, drawableDir, File(outDir, "raw"))
  }

  private fun copyPieceAssets(packageDir: File, drawableDir: File) {
    drawableDir.mkdirs()
    val pieceRoot = File(packageDir, "assets/piece_sets")
    check(pieceRoot.exists()) { "Could not find piece sets at $pieceRoot" }

    val pieceCodes = listOf("bB", "bK", "bN", "bP", "bQ", "bR", "wB", "wK", "wN", "wP", "wQ", "wR")

    val setDirs = pieceRoot.listFiles { f -> f.isDirectory } ?: emptyArray()
    for (setDir in setDirs){
      val androidSetName = setDir.name.replace("-", "").lowercase()

      if (setDir.name == "disguised"){
        val wSrc = File(setDir, "w.webp")
        val bSrc = File(setDir, "b.webp")
        if(wSrc.exists() && bSrc.exists()){
          for (code in pieceCodes){
            val src = if(code.startsWith("w")) wSrc else bSrc
            src.copyTo(File(drawableDir, "piece_${androidSetName}_${code.lowercase()}.webp"))
          }
        }
        continue
      }

      if (!File(setDir, "bB.webp").exists()) continue
      for (code in pieceCodes){
        val src = File(setDir, "$code.webp")
        if(src.exists()){
          src.copyTo(File(drawableDir, "piece_${androidSetName}_${code.lowercase()}.webp"))
        }
      }
    }
  }
  private fun copyBoardThemes(packageDir: File,drawableDir: File, rawDir: File) {
    val schemeFile = File(packageDir, "lib/src/board_color_scheme.dart")
    check(schemeFile.exists()) { "Could not find board_color_scheme.dart at $schemeFile" }
    val source = schemeFile.readText()

    val blockStart = Regex("""static const (\w+) = ChessboardColorScheme\(""")
    val matches = blockStart.findAll(source).toList()
    check(matches.isNotEmpty()) { "Parsed zero themes from $schemeFile — its format may have changed" }

    val lightRegex = Regex("""lightSquare:\s*Color\((0x[0-9a-fA-F]{8})\)""")
    val darkRegex = Regex("""darkSquare:\s*Color\((0x[0-9a-fA-F]{8})\)""")
    val lastMoveRegex =
      Regex("""lastMove:\s*HighlightDetails\(\s*solidColor:\s*Color\((0x[0-9a-fA-F]{8})\)""")
    val imageBackgroundRegex = Regex("""background:\s*ImageChessboardBackground""")
    val assetImageRegex = Regex("""AssetImage\('\${'$'}_boardsPath/([\w.\-]+)'""")
    val boardsDir = File(packageDir, "assets/boards")

    fun toAndroidHex(dartHex: String) = "#${dartHex.removePrefix("0x")}"

    val entries = mutableListOf<String>()
    for (i in matches.indices) {
      val name = matches[i].groupValues[1]
      val start = matches[i].range.last
      val end = if (i + 1 < matches.size) matches[i + 1].range.first else source.length
      val block = source.substring(start, end)

      val light = lightRegex.find(block)?.groupValues?.get(1) ?: continue
      val dark = darkRegex.find(block)?.groupValues?.get(1) ?: continue
      val lastMove = lastMoveRegex.find(block)?.groupValues?.get(1) ?: "0x809cc700"

      var boardResourceName: String? = null
      if (imageBackgroundRegex.containsMatchIn(block)) {
        val assetFile = assetImageRegex.find(block)?.groupValues?.get(1)
        val src = assetFile?.let { File(boardsDir, it) }
        if (src != null && src.exists()) {
          val resName = "board_${name.lowercase()}"
          src.copyTo(File(drawableDir, "$resName.${src.extension}"))
          boardResourceName = resName
        }
      }

      val boardField = boardResourceName?.let { "\"$it\"" } ?: "null"
      entries += "  \"$name\": {\"light\": \"${toAndroidHex(light)}\", " +
        "\"dark\": \"${toAndroidHex(dark)}\", \"lastMove\": \"${toAndroidHex(lastMove)}\", " +
        "\"board\": $boardField}"
    }
      check(entries.isNotEmpty()) { "Extracted zero valid theme entries from $schemeFile" }
      rawDir.mkdirs()
      File(rawDir, "board_themes.json").writeText("{\n${entries.joinToString(",\n")}\n}\n")
    }
}
  val copyChessgroundPieceAssets = tasks.register<CopyChessgroundPieceAssetsTask>("copyChessgroundPieceAssets") {
  packageConfigFile.set(file("../../.dart_tool/package_config.json"))
  outputDirectory.set(layout.buildDirectory.dir("generated/chessgroundAssets/res"))
}

androidComponents {
  onVariants { variant ->
    variant.sources.res?.addGeneratedSourceDirectory(
      copyChessgroundPieceAssets,
      CopyChessgroundPieceAssetsTask::outputDirectory
    )
  }
}

android {
    namespace = "org.lichess.mobileV2"
    // compileSdk = flutter.compileSdkVersion
    // home_widget pulls in glance-appwidget and remote-creation-android, both of which
    // declare in their AAR metadata that all dependents (including the app) must compile
    // against SDK 37+. This cannot be suppressed — it is enforced by AGP at build time.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Flag required by flutter_local_notifications package
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        // Flag required by flutter_local_notifications package
        multiDexEnabled = true
        applicationId = "org.lichess.mobileV2"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
            ndk {
                debugSymbolLevel = "FULL"
            }
        }
        debug {
            applicationIdSuffix = ".debug"
        }
    }

    dependenciesInfo {
        includeInApk = false
        includeInBundle = true
    }

}


kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_11
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Dependency required by flutter_local_notifications package
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-splashscreen:1.0.1")
}
