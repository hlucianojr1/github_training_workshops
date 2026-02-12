package com.insight.ai_demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HelloController {

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to AI Demo Application!");
        response.put("status", "running");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/hello")
    public Map<String, String> hello(@RequestParam(defaultValue = "World") String name) {
        Map<String, String> response = new HashMap<>();
        response.put("greeting", "Hello, " + name + "!");
        response.put("timestamp", LocalDateTime.now().toString());
        return response;
    }

    @GetMapping("/hello/{name}")
    public Map<String, String> helloPath(@PathVariable String name) {
        Map<String, String> response = new HashMap<>();
        response.put("greeting", "Hello, " + name + "!");
        response.put("message", "This is a path variable example");
        return response;
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("application", "ai-demo");
        response.put("version", "0.0.1-SNAPSHOT");
        response.put("java_version", System.getProperty("java.version"));
        return response;
    }
}