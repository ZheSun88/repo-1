# repo-1 — Gradle plugin release test

A minimal Gradle plugin used to validate the **Gradle Plugin Portal** release
pipeline. It registers a single `greeting` task and is wired up for publishing
the same way [Vaadin Flow's gradle plugin](https://github.com/vaadin/flow/blob/main/flow-plugins/flow-gradle-plugin/build.gradle#L12)
is: `java-gradle-plugin` + `maven-publish` + `com.gradle.plugin-publish` `0.11.0`.

## Toolchain

Mirrors Flow's setup:

| Tool           | Version |
| -------------- | ------- |
| Gradle         | 8.14    |
| JDK            | 21      |
| plugin-publish | 0.11.0  |

> **Why `sourcesJar`/`javadocJar` are declared manually:** plugin-publish `0.11.0`
> falls back to `Jar.setClassifier()` — an API removed in Gradle 8 — when it has to
> create those tasks itself. Declaring them up front (with the modern
> `archiveClassifier`) makes the plugin reuse them, which is exactly how Flow runs
> `0.11.0` on Gradle 8.14. Without this, the build fails at configuration time.

## Build & test

```bash
./gradlew build
```

## Verify locally

Publish to your local Maven repo and inspect the artifacts (including the plugin
marker that lets `plugins { id '...' }` resolve):

```bash
./gradlew publishToMavenLocal
```

## Release to the Gradle Plugin Portal

1. Get an API key/secret from https://plugins.gradle.org/ (My API Keys).
2. Add them as repository secrets `GRADLE_PUBLISH_KEY` and `GRADLE_PUBLISH_SECRET`.
3. Publish a GitHub Release (or run the **Release to Gradle Plugin Portal**
   workflow manually) — see [`.github/workflows/release.yml`](.github/workflows/release.yml).

To publish from your machine instead:

```bash
./gradlew publishPlugins \
  -Dgradle.publish.key=KEY \
  -Dgradle.publish.secret=SECRET
```

## Plugin coordinates

- Plugin id: `io.github.zhesun88.testing`
- Implementation: `io.github.zhesun88.testing.TestingPlugin`
- Group / version: set in [`gradle.properties`](gradle.properties)
