package com.appviajes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients(basePackages = "com.appviajes.client")
public class App {

  public static void main(String[] args) {
    SpringApplication.run(App.class, args);
  }
}
