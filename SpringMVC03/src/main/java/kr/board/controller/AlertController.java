package kr.board.controller;

import java.util.List;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Alert;
import kr.board.mapper.AlertInfoMapper;

@RestController
public class AlertController {

    @Autowired
    private AlertInfoMapper alertMapper;

    // private static final Logger logger = Logger.getLogger(AlertController.class.getName());

    @GetMapping("/getAlerts")
    public List<Alert> getAlerts() {
        List<Alert> alerts = alertMapper.findAll();
        // logger.info("Fetched alerts: " + alerts);
        System.out.println("Fetched alerts: " + alerts);
        return alerts;
    }
}
