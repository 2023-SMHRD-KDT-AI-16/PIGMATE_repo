package kr.board.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.board.entity.Alert;
import kr.board.entity.Criteria;
import kr.board.entity.DetectionInfo;
import kr.board.entity.FarmEnv;
import kr.board.entity.News;
import kr.board.entity.PageMaker;
import kr.board.entity.PigInfo;
import kr.board.mapper.AlertInfoMapper;
import kr.board.mapper.DetectionInfoMapper;
import kr.board.mapper.FarmMapper;
import kr.board.mapper.NewsMapper;
import kr.board.mapper.PigInfoMapper;

@RestController
public class BoardController {
    
    private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

    @Autowired
    private NewsMapper newsMapper;
    
    @Autowired
	private FarmMapper farmMapper;
    
    @Autowired
	private PigInfoMapper pigInfoMapper;
    
    @Autowired
	private DetectionInfoMapper detectionInfoMapper;
    
    @Autowired
    private AlertInfoMapper alertMapper;

    @GetMapping("/board/newsList")
    public Map<String, Object> getNewsList(@RequestParam(defaultValue = "1") int page) {
        Criteria cri = new Criteria();
        cri.setPage(page);
        cri.setPageNum(10); // 한 페이지에 10개의 뉴스 표시

        List<News> newsList = newsMapper.getNewsList(cri);
        int totalNewsCount = newsMapper.countAllNews();

        PageMaker pgm = new PageMaker();
        pgm.setCri(cri);
        pgm.setTotalCount(totalNewsCount);

        Map<String, Object> result = new HashMap<>();
        result.put("newsList", newsList);
        result.put("pageMaker", pgm);

        return result;
    }

    @GetMapping("/board/newsContent")
    public News getNews(@RequestParam("news_idx") int news_idx) {
        News news = null;
        try {
            news = newsMapper.getNews(news_idx);
            if (news != null) {
                // HTML 특수 문자 디코딩
                String decodedContent = URLDecoder.decode(news.getNews_content(), StandardCharsets.UTF_8.toString());
                news.setNews_content(decodedContent);
            } else {
                logger.error("News with id {} not found", news_idx);
            }
        } catch (UnsupportedEncodingException e) {
            logger.error("UnsupportedEncodingException: ", e);
        } catch (Exception e) {
            logger.error("Exception: ", e);
        }
        return news;
    }
    
 // 리포트 - 날짜별 하루 단위 환경 정보
 	@GetMapping("/farm/env/date")
 	public List<FarmEnv> getDailyEnvByDate(@RequestParam("farm_id") int farm_idx, @RequestParam("date") String date) {
 		System.out.println("날짜별 데이터 farm_id: " + farm_idx + " and date: " + date);
 	    
 		// 같은 달 데이터 없으면 month데이터에 월 평균 데이터 넣기
 		if (farmMapper.countMonthlyData(farm_idx, date) == 0) {
 			//int month_insert = farmMapper.insertMonthTable(farm_idx);
 		    //System.out.println("month_insert : " + month_insert);
 	    }
 		// 같은 날짜 데이터 없으면 일 평균 데이터 넣기
 	    if (farmMapper.countDailyData(farm_idx) == 0) {
 		    //int day_insert = farmMapper.insertDayTable(farm_idx);
 		    //System.out.println("day_insert : " + day_insert);
 	    }
 	    // 같은 시간 데이터 없으면 시간별 평균 데이터 넣기
 	    if (farmMapper.countHourlyData(farm_idx) == 0) {
 		    int hour_insert = farmMapper.insertHourTable(farm_idx);
 		    System.out.println("hour_insert : " + hour_insert);
 		    int time_delete = farmMapper.deleteTimeTable(farm_idx);
 		    System.out.println("time_delete : " + time_delete);
 	    }
 	    
 	    List<FarmEnv> result = farmMapper.getDailyEnvByDate(farm_idx, date);
 	    System.out.println("하루 환경 정보: " + result);
 	    return result;
 	}
 	
 // 날짜 선택 시 시간별 이상 돼지 객체 탐지 평균
 	 @GetMapping("/farm/AbnormalInfo/date")
 	    public List<PigInfo> getDailyAbnormalInfoByDate(@RequestParam("farm_id") int farm_idx,
 	                                                    @RequestParam("date") String date) {
 	        System.out.println("Fetching abnormal detection info for farm_id: " + farm_idx + ", date: " + date);
 	        List<PigInfo> abnormalInfoList = new ArrayList<>();
 	        try {
 	            abnormalInfoList = pigInfoMapper.getDailyAbonormalInfoByDate(farm_idx, date);
 	            System.out.println("Fetched abnormal detection info: " + abnormalInfoList);
 	        } catch (Exception e) {
 	            System.err.println("Error fetching abnormal detection info: " + e.getMessage());
 	            e.printStackTrace();
 	        }
 	        return abnormalInfoList;
 	    }
 	 
 	// 날짜 선택 시 시간별 돼지객체 탐지 평균
 	@GetMapping("/farm/DetectionInfo/date")
 	public List<DetectionInfo> getDailyDetectionInfoByDate(@RequestParam("farm_id") int farm_idx,
 			@RequestParam("date") String date) {
 		List<DetectionInfo> detectionInfoList = detectionInfoMapper.getDailyDetectionInfoByDate(farm_idx, date);
 		System.out.println("날짜별 탐지 정보: " + detectionInfoList);
 		return detectionInfoList;
 	}
 	
 	// 날짜 선택시 시간 알림 수 가져옴
 	@GetMapping("/farm/alertDate")
 	public List<Alert> getAlertData(@RequestParam("farm_id") int farm_idx, @RequestParam("date") String date){
 		List<Alert> alertList = alertMapper.getAlertData(farm_idx, date);
 		System.out.println("날짜별 알림 정보: " + alertList);
 		return alertList;
 	}
}