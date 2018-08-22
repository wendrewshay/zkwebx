package com.wendrewshay.zkwebx;

import com.wendrewshay.zkwebx.config.H2Starter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@SpringBootApplication
@ServletComponentScan
public class ZkwebxApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        H2Starter.startH2Server();
        return builder.sources(ZkwebxApplication.class);
    }

    public static void main(String[] args) {
        H2Starter.startH2Server();
        SpringApplication.run(ZkwebxApplication.class, args);
    }
}
