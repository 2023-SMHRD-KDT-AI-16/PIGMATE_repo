package kr.board.controller;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import kr.board.entity.EnvCri;
import kr.board.entity.Farm;
import kr.board.entity.FarmEnv;
import kr.board.entity.Member;
import kr.board.mapper.Env_criteria_infoMapper;
import kr.board.mapper.FarmMapper;

@RestController
public class FarmController {

    @Autowired
    private FarmMapper farmMapper;

    @Autowired
    private Env_criteria_infoMapper env_criteria_infoMapper;

    // 환경 정보 페이지로 환경 정보 가져오기
    @PostMapping("/farm/env")
    public List<FarmEnv> FarmEnvList(HttpSession session, @RequestParam("period") String period, @RequestParam("type") String type) {
        List<FarmEnv> farm_env = new ArrayList<>();

        Member m = (Member) session.getAttribute("mvo");

        if (m != null) {
            String mem_id = m.getMem_id();
            System.out.println("환경 정보 조회할 회원 :" + mem_id);

            List<Farm> farms = farmMapper.getFarm(mem_id);

            for (Farm farm : farms) {
                int idx = farm.getFarm_idx();

                if ("latest-weekly".equals(period)) {
                    List<FarmEnv> latestWeeklyEnv = farmMapper.getLatestWeeklyEnv(idx);
                    List<FarmEnv> weeklyAverages = new ArrayList<>();
                    
                    int cnt = 0;
                    double totalTemperature = 0;
                    double totalHumidity = 0;
                    double totalCo2 = 0;
                    double totalAmmonia = 0;
                    double totalPm = 0;

                    for (int i = 0; i < latestWeeklyEnv.size(); i++) {
                    	
                    	// 데이터 가져오기
                        FarmEnv env = latestWeeklyEnv.get(i);
                        cnt++;
                        
                        // 합계에 값 더해주기
                        totalTemperature += env.getTemperature();
                        totalHumidity += env.getHumidity();
                        totalCo2 += env.getCo2();
                        totalAmmonia += env.getAmmonia();
                        totalPm += env.getPm();

                        if (cnt == 7) {
                        	// 7일 단위로 평균을 계산하여 리스트에 추가
                            FarmEnv averageEnv = new FarmEnv();
                            
                            // 7로 나눠서 구한 평균값
                            averageEnv.setTemperature((float) (totalTemperature / 7));
                            averageEnv.setHumidity((float) (totalHumidity / 7));
                            averageEnv.setCo2((int) (totalCo2 / 7));
                            averageEnv.setAmmonia((int) (totalAmmonia / 7));
                            averageEnv.setPm((float) (totalPm / 7));
                            weeklyAverages.add(averageEnv);
                            System.out.println(averageEnv);

                            // 초기화해주기
                            cnt = 0;
                            totalTemperature = 0;
                            totalHumidity = 0;
                            totalCo2 = 0;
                            totalAmmonia = 0;
                            totalPm = 0;
                        }
                    }

                    // 마지막 주 남은 날들
                    if (cnt > 0) {
                        FarmEnv averageEnv = new FarmEnv();
                        averageEnv.setTemperature((float) (totalTemperature / cnt));
                        averageEnv.setHumidity((float) (totalHumidity / cnt));
                        averageEnv.setCo2((int) (totalCo2 / cnt)); // double을 int로 변환
                        averageEnv.setAmmonia((int) (totalAmmonia / cnt));
                        averageEnv.setPm((float) (totalPm / cnt));
                        weeklyAverages.add(averageEnv);
                    }

                    System.out.println("주별 평균 데이터: " + weeklyAverages);
                    farm_env.addAll(weeklyAverages);
                } else if ("daily".equals(period)) {
                    List<FarmEnv> dailyEnv = farmMapper.getEnv(idx);
                    System.out.println("일별 데이터: " + dailyEnv);
                    farm_env.addAll(dailyEnv);
                }
            }
        }
        return farm_env;
    }

    // 농장 전체보기
    @GetMapping("/all")
    public List<Farm> getFarm(HttpSession session) {
        Member m = (Member) session.getAttribute("mvo");
        String mem_id = m.getMem_id();
        List<Farm> list = farmMapper.getFarm(mem_id);
        return list;
    }

    // 농장정보 추가하기
    @PostMapping("/insertFarm.do")
    public String updateFarm(Farm farm, HttpSession session) {
        Member mvo = (Member) session.getAttribute("mvo");

        if (mvo == null) {
            System.out.println("mvo 없음");
            return "redirect:/login.do";
        }

        String mem_id = mvo.getMem_id();
        farm.setMem_id(mem_id);
        farmMapper.insertFarm(farm);
        return "redirect:/myPage.do";
    }

    // 농장 정보 업데이트
    @RequestMapping(value = "/editFarm.do", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> editFarm(@RequestParam("old_farm_name") String oldFarmName,
                                           @RequestParam("new_farm_name") String newFarmName, 
                                           @RequestParam("farm_loc") String farmLoc,
                                           @RequestParam("farm_livestock_cnt") int farmLivestockCnt) {
        try {
            farmMapper.updateFarmByOldName(oldFarmName, newFarmName, farmLoc, farmLivestockCnt);
            return new ResponseEntity<>("농장 수정이 완료되었습니다.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("농장 수정 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 농장 삭제하기
    @RequestMapping("/deleteFarm.do")
    @ResponseBody
    public ResponseEntity<String> deleteFarm(@RequestParam("farm_name") String farmName) {
        try {
            System.out.println("삭제할 농장 이름: " + farmName);
            // 자식 레코드 먼저 삭제
            System.out.println("Pen info 삭제 시작");
            farmMapper.deletePenInfoByFarmName(farmName);
            System.out.println("Pen info 삭제 완료");

            System.out.println("Env criteria info 삭제 시작");
            farmMapper.deleteEnvCriteriaByFarmName(farmName);
            System.out.println("Env criteria info 삭제 완료");

            // 부모 레코드 삭제
            System.out.println("Farm info 삭제 시작");
            farmMapper.deleteFarmByName(farmName);
            System.out.println("Farm info 삭제 완료");

            return new ResponseEntity<>("농장 삭제가 완료되었습니다.", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("에러 발생: " + e.getMessage());
            return new ResponseEntity<>("농장 삭제 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 마이 페이지로 환경 기준 정보 가져오기
    @GetMapping("/getEnvCriteria.do")
    public ResponseEntity<EnvCri> getEnvCriteria(@RequestParam("farm_idx") int farmIdx) {
        try {
            EnvCri envCri = env_criteria_infoMapper.getEnvCriByFarmIdx(farmIdx);
            if (envCri != null) {
                System.out.println("환경 기준 데이터: " + envCri); // 서버 콘솔에 출력
                return new ResponseEntity<>(envCri, HttpStatus.OK);
            } else {
                System.out.println("환경 기준 데이터 없음: 빈 객체 반환"); // 서버 콘솔에 출력
                return new ResponseEntity<>(new EnvCri(), HttpStatus.OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 메인 페이지로 환경 기준 정보 가져오기
    @GetMapping("/env/criteria")
    public ResponseEntity<EnvCri> getEnvCriteria(HttpSession session) {
        Member m = (Member) session.getAttribute("mvo");

        if (m != null) {
            String mem_id = m.getMem_id();
            List<Farm> farmList = farmMapper.getFarm(mem_id);
            if (!farmList.isEmpty()) {
                int farmIdx = farmList.get(0).getFarm_idx(); // 첫 번째 농장의 기준만 사용
                EnvCri envCri = env_criteria_infoMapper.getEnvCriByFarmIdx(farmIdx);
                return new ResponseEntity<>(envCri, HttpStatus.OK);
            }
        }
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    // 농장별 환경 기준 추가/수정하기
    @PostMapping("/insertEnvCri.do")
    public ResponseEntity<String> insertEnvCri(EnvCri envCri, HttpSession session) {
        try {
            // 환경 기준 데이터가 이미 존재하는지 확인
            EnvCri existingEnvCri = env_criteria_infoMapper.getEnvCriByFarmIdx(envCri.getFarm_idx());
            if (existingEnvCri != null) {
                // 존재하면 업데이트
                env_criteria_infoMapper.updateEnvCri(envCri);
                return new ResponseEntity<>("환경 기준이 수정되었습니다.", HttpStatus.OK);
            } else {
                // 존재하지 않으면 추가
                env_criteria_infoMapper.insertEnvCri(envCri);
                return new ResponseEntity<>("환경 기준이 저장되었습니다.", HttpStatus.OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("환경 기준 저장 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 메인 페이지로 환경 정보 가져오기
    @PostMapping("/index/env")
    public List<FarmEnv> IndexEnvList(HttpSession session) {
        List<FarmEnv> farm_env = new ArrayList<>();

        Member m = (Member) session.getAttribute("mvo");

        if (m != null) {
            // 로그인했을 때 session에서 mem_id 가져와서 회원이 가지고 있는 농장 인덱스만 가져오기
            String mem_id = m.getMem_id();

            System.out.println("환경 정보 조회할 회원 :" + m.getMem_id());

            List<Farm> farm = farmMapper.getFarm(mem_id);

            for (int i = 0; i < farm.size(); i++) {
                int idx = farm.get(i).getFarm_idx();
                farm_env.addAll(farmMapper.getEnv(idx));
            }
        }
        return farm_env;
    }
}