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
