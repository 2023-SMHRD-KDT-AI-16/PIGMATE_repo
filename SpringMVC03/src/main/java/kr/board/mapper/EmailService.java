package kr.board.mapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

import kr.board.entity.Alert;
import kr.board.mapper.AlertInfoMapper;
import kr.board.mapper.MemberMapper;
import kr.board.entity.Member;

@Service
public class EmailService {

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private AlertInfoMapper alertMapper;

	@Autowired
	private MemberMapper memberMapper;

	// 간단한 이메일을 보내는 메서드
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

	// 환경 알림 이메일을 보내는 메서드
	@Transactional
	public void sendAlertMessage(String memId, String farmName, float temperature, float humidity, int co2, int ammonia,
			float pm) {
		// member 정보 가져오기
		Member member = memberMapper.getMember(memId);
		if (member == null) {
			System.err.println("No member found with mem_id: " + memId);
			return;
		}

		String to = member.getMem_email();

		String subject = "농장 환경 경고"; // 이메일 제목
		String text = String.format(
				"안녕하세요, 관리자님.\n\n귀하의 농장 '%s'의 환경이 지정된 범위를 벗어났습니다.\n\n현재 환경 수치:\n온도: %.2f도\n습도: %.2f%%\n이산화탄소: %dppm\n암모니아: %dppm\n미세먼지: %.2fμg/m³\n\n조속한 조치가 필요합니다.\n\n감사합니다.\n귀하의 농장 관리팀 드림",
				farmName, temperature, humidity, co2, ammonia, pm);

		// 이메일 전송
		sendSimpleMessage(to, subject, text);

		// 간단한 알림 메시지
		String alertMsg = String.format("농장 이름: %s, 내용: 온도 %.2f도, 습도 %.2f%%, CO2 %dppm, 암모니아 %dppm, 미세먼지 %.2fμg/m³",
				farmName, temperature, humidity, co2, ammonia, pm);

		// alert_info 테이블에 데이터 저장
		Alert alert = new Alert();
		alert.setMemId(memId); // memId 필드에 설정
		alert.setAlarmMsg(alertMsg); // 간단한 알림 메시지
		alert.setAlarmedAt(new Date()); // 현재 날짜 및 시간
		alertMapper.insertAlert(alert); // 데이터베이스에 삽입
		System.out.println("Alert saved to database for mem_id: " + memId);
	}
}
