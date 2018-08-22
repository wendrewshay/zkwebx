package com.wendrewshay.zkwebx.config;

import org.h2.tools.Server;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;

/**
 * H2数据库启动
 * @author by Joney on 2018/8/22 11:55
 */
public class H2Starter {

    private static final Logger logger = LoggerFactory.getLogger(H2Starter.class);

    public static void startH2Server() {
        try {
            Server h2Server = Server.createTcpServer().start();
            if (h2Server.isRunning(true)) {
                logger.info("H2 server was started and is running.");
            } else {
                throw new RuntimeException("Could not start H2 server.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to start H2 server: ", e);
        }
    }
}
