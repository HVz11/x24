package com.sendsmart;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SendSmartApplication {
    public static void main(String[] args) {
        SpringApplication.run(SendSmartApplication.class, args);
    }
}