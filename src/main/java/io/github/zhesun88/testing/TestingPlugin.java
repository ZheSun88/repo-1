package io.github.zhesun88.testing;

import org.gradle.api.Plugin;
import org.gradle.api.Project;

/**
 * A minimal Gradle plugin used to test the Gradle Plugin Portal release pipeline.
 *
 * <p>It registers a single {@code greeting} task that prints a message, which is
 * enough to verify that the plugin is applied, packaged and published correctly.
 */
public class TestingPlugin implements Plugin<Project> {

    @Override
    public void apply(Project project) {
        project.getTasks().register("greeting", task -> {
            task.setGroup("verification");
            task.setDescription("Prints a greeting to verify the plugin is applied.");
            task.doLast(t -> project.getLogger()
                    .lifecycle("Hello from io.github.zhesun88.testing on {}", project.getName()));
        });
    }
}
