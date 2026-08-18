allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// home_widget 0.9.2 skips applying the Kotlin Gradle Plugin when AGP >= 9, assuming the
// project uses AGP's built-in Kotlin. We keep android.builtInKotlin=false (the app and all
// other plugins still apply KGP), so home_widget's Kotlin sources would never compile,
// producing "cannot find symbol HomeWidgetPlugin" at javac time. Apply KGP to it ourselves,
// right after its android library plugin is applied so ordering is correct.
subprojects {
    if (name == "home_widget") {
        pluginManager.withPlugin("com.android.library") {
            pluginManager.apply("org.jetbrains.kotlin.android")
        }
        // home_widget's own `jvmTarget = "1.8"` is also gated behind the AGP < 9 check, so
        // Kotlin defaults to a target that doesn't match its Java tasks (compiled at 1.8).
        // Align Kotlin to 1.8 to avoid "Inconsistent JVM Target Compatibility".
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
            }
        }
    }
}

// Some plugins declare a compileSdk lower than what their transitive dependencies require.
// gradle.afterProject fires after each project finishes its own configuration, so it
// runs after the module has set its compileSdk and we can safely override it.
gradle.afterProject {
    extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.apply {
        val minRequired = when (project.name) {
            // glance-appwidget:1.3.0-alpha01 and remote-creation-android:1.0.0-alpha11
            // both require compileSdk 37+, but home_widget declares only 36.
            "home_widget" -> 37
            // sound_effect 0.1.3 declares compileSdk 35 but flutter_plugin_android_lifecycle requires 36+.
            else -> 36
        }
        if ((compileSdk ?: 0) < minRequired) compileSdk = minRequired
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
