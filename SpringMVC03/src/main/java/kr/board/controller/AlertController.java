package kr.board.controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Alert;
import kr.board.mapper.AlertInfoMapper;

@RestController
public class AlertController {

    @Autowired
    private AlertInfoMapper alertMapper;

    @GetMapping("/getAlerts")
    public List<Alert> getAlerts(@RequestParam("farmId") int farmId) {
        return alertMapper.findAlertsByFarmId(farmId);
    }

    @PostMapping("/insertAlert")
    public void insertAlert(@RequestParam("memId") String memId,
                            @RequestParam("alarmMsg") String alarmMsg,
                            @RequestParam("alarmedAt") Date alarmedAt,
                            @RequestParam("farm_idx") int farm_idx) {
        Alert alert = new Alert();
        alert.setMemId(memId);
        alert.setAlarmMsg(alarmMsg);
        alert.setAlarmedAt(alarmedAt);
        alert.setFarm_idx(farm_idx);
        alertMapper.insertAlert(alert);
    }

}