package kr.board.mapper;

import kr.board.entity.DetectionInfo;
import kr.board.entity.Member;
import kr.board.mapper.DetectionInfoMapper;
import kr.board.mapper.MemberMapper;
import kr.board.mapper.AlertInfoMapper;
import kr.board.entity.Alert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class PigEmailService {

    @Autowired
    private DetectionInfoMapper detectionInfoMapper;

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private AlertInfoMapper alertMapper;

    @Autowired
    private JavaMailSender mailSender;

    @Transactional
    public void checkAndSendAlert(int farmIdx, String memId, String farmName) {
        List<DetectionInfo> abnormalDetections = detectionInfoMapper.getAbnormalDetectionCount(farmIdx);

        if (abnormalDetection(abnormalDetections, 5)) {
            sendAlertEmail(memId, farmIdx, farmName);
        }
    }

    private boolean abnormalDetection(List<DetectionInfo> detections, int threshold) {
        int count = 0;
        for (DetectionInfo detection : detections) {
            if (detection.getResult() == 1) {
                count++;
                if (count >= threshold) {
                    return true;
                }
            } else {
                count = 0;
            }
        }
        return false;
    }

    private void sendAlertEmail(String memId, int farmIdx, String farmName) {
        Member member = memberMapper.getMember(memId);
        if (member == null) {
            return;
        }

        String to = member.getMem_email();
        String subject = "농장 돼지 이상 행동 경고";
        String text = String.format("안녕하세요, 관리자님.\n\n귀하의 농장 '%s'에서 이상 행동을 보이는 돼지가 연속으로 5번 이상 발견되었습니다.\n조속한 확인이 필요합니다.\n\n감사합니다.\n귀하의 농장 관리팀 드림", farmName);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);

        try {
            mailSender.send(message);
            System.out.println("Pig Email sent successfully to " + to);

            // 알림 저장
            String alertMsg = String.format("농장 이름: %s, 내용: 연속으로 5번 이상 돼지의 이상 행동이 발견되었습니다.", farmName);
            Alert alert = new Alert();
            alert.setMemId(memId);
            alert.setAlarmMsg(alertMsg);
            alert.setAlarmedAt(new Date());
            alert.setFarm_idx(farmIdx);
            System.out.println("Inserting Pig alert with farmId: " + alert.getFarm_idx());
            alertMapper.insertAlert(alert);
        } catch (Exception e) {
            System.err.println("Error sending email to " + to + ": " + e.getMessage());
        }
    }
}