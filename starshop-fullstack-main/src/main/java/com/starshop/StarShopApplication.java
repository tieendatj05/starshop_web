package com.starshop;

import io.github.cdimascio.dotenv.Dotenv;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.env.Environment;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Optional;

@SpringBootApplication
public class StarShopApplication implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(StarShopApplication.class);

    private final Environment env;

    public StarShopApplication(Environment env) {
        this.env = env;
    }

    public static void main(String[] args) {
        SpringApplication.run(StarShopApplication.class, args);
    }

    @Override
    public void run(String... args) {
        try {
            String protocol = Optional.ofNullable(env.getProperty("server.ssl.key-store")).map(key -> "https").orElse("http");
            String host = InetAddress.getLocalHost().getHostAddress();
            String port = env.getProperty("local.server.port");
            String contextPath = Optional.ofNullable(env.getProperty("server.servlet.context-path")).orElse("");

            log.info("\n----------------------------------------------------------\n\t" +
                            "Application '{}' is running! Access URLs:\n\t" +
                            "Local: \t\t{}://localhost:{}{}\n\t" +
                            "External: \t{}://{}:{}{}\n----------------------------------------------------------",
                    env.getProperty("spring.application.name", "StarShop"),
                    protocol, port, contextPath, protocol, host, port, contextPath);
        } catch (UnknownHostException e) {
            log.warn("Could not determine host address, URL info will not be printed.", e);
        }
    }
}