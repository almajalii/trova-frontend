buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.3.20")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// file_picker's own build.gradle guards `apply plugin: 'org.jetbrains.kotlin.android'`
// behind an AGP-version check that assumes it's building standalone. In this
// composite build the effective AGP version is the one from the root
// settings.gradle.kts (9.0.1), so that guard resolves true and file_picker skips
// applying Kotlin entirely — its .kt sources (e.g. FilePickerPlugin.kt) then never
// get compiled, breaking GeneratedPluginRegistrant at the :app compile step.
// Force-apply it here once AGP's own library plugin has been applied to that
// subproject, which restores normal Kotlin compilation for it.
subprojects {
    plugins.withId("com.android.library") {
        if (project.name == "file_picker") {
            pluginManager.apply("org.jetbrains.kotlin.android")
            extensions.configure(org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension::class.java) {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
