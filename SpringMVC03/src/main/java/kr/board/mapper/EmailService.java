package kr.board.mapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    // 이메일 보내는 메서드
    public void sendSimpleMessage(String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to); // 수신자 이메일 주소 설정
        message.setSubject(subject); // 이메일 제목 설정
        message.setText(text); // 이메일 본문 설정
        try {
            mailSender.send(message); // 이메일 전송
            System.out.println("Email sent successfully to " + to);
        } catch (Exception e) {
            System.err.println("Error sending email to " + to + ": " + e.getMessage());
        }
    }
    
    // 환경 알림 이메일 보내는 메서드
    public void sendAlertMessage(String to, String farmName, float temperature, float humidity, int co2, int ammonia, float pm) {
        // 이메일 제목 
    	String subject = "농장 환경 경고";
    	// 이메일 본문
        String text = String.format("안녕하세요, 관리자님.\n\n귀하의 농장 '%s'의 환경이 지정된 범위를 벗어났습니다.\n\n현재 환경 수치:\n온도: %.2f도\n습도: %.2f%%\n이산화탄소: %dppm\n암모니아: %dppm\n미세먼지: %.2fμg/m³\n\n 조치가 필요합니다.\n\n감사합니다.\n피그메이트 드림",
                farmName, temperature, humidity, co2, ammonia, pm);
        // 이메일 전송
        sendSimpleMessage(to, subject, text);
    }
}
