package io.github.zhesun88.testing;

import org.gradle.api.Project;
import org.gradle.testfixtures.ProjectBuilder;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;

class TestingPluginTest {

    @Test
    void pluginRegistersGreetingTask() {
        Project project = ProjectBuilder.builder().build();
        project.getPlugins().apply("io.github.zhesun88.testing");

        assertNotNull(project.getTasks().findByName("greeting"),
                "The plugin should register a 'greeting' task");
    }
}
