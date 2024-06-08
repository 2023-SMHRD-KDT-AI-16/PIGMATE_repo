package kr.board.mapper;

import kr.board.entity.EnvCri;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.logging.Logger;

@Component
public class EnvCheck {

    @Autowired
    private EmailService emailService;

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private FarmMapper farmMapper;

    @Autowired
    private Env_criteria_infoMapper envCriMapper;

    private static final Logger logger = Logger.getLogger(EnvCheck.class.getName());

    @Scheduled(fixedRate = 3600000) // 1시간마다 실행
    public void checkEnvironments() {
        logger.info("Checking environments...");
        
        // 모든 회원의 농장 정보 가져오기
        List<Member> members = memberMapper.getAllMembers();

        for (Member member : members) {
            List<Farm> farms = farmMapper.getFarm(member.getMem_id());
            for (Farm farm : farms) {
            	// 최신 환경 정보 가져오기
                FarmEnv currentEnv = farmMapper.getLatestEnvironment(farm.getFarm_idx());
                // 환경 기준 정보 가져오기
                EnvCri criteria = envCriMapper.getEnvCriByFarmIdx(farm.getFarm_idx());

                if (currentEnv != null && criteria != null) {
                	// 기준에서 벗어나면 알림 전송
                    if (isOutOfRange(currentEnv, criteria)) {
                        sendAlert(member, farm, currentEnv);
                    }
                }
            }
        }
    }

    // 환경 수치가 기준에서 벗어났는지 확인하는 메서드
    private boolean isOutOfRange(FarmEnv env, EnvCri criteria) {
        float tempDiff = Math.abs(env.getTemperature() - criteria.getTemperature()) / criteria.getTemperature();
        float humidityDiff = Math.abs(env.getHumidity() - criteria.getHumidity()) / criteria.getHumidity();
        int co2Diff = Math.abs(env.getCo2() - criteria.getCo2()) / criteria.getCo2();
        int ammoniaDiff = Math.abs(env.getAmmonia() - criteria.getAmmonia()) / criteria.getAmmonia();
        float pmDiff = Math.abs(env.getPm() - criteria.getPm()) / criteria.getPm();

        // +- 5% 이상 벗어났는지 확인 
        return tempDiff > 0.05 || humidityDiff > 0.05 || co2Diff > 0.05 || ammoniaDiff > 0.05 || pmDiff > 0.05;
    }

    // 이메일 전송하는 메서드
    private void sendAlert(Member member, Farm farm, FarmEnv env) {
        emailService.sendAlertMessage(member.getMem_email(), farm.getFarm_name(), env.getTemperature(), env.getHumidity(), env.getCo2(), env.getAmmonia(), env.getPm());
        logger.info("Sent email alert to " + member.getMem_email());
    }
}
