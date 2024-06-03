package kr.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Criteria;
import kr.board.entity.News;
import kr.board.entity.PageMaker;
import kr.board.mapper.NewsMapper;

@RequestMapping("/board")
@RestController
public class BoardController {
	
	 @Autowired
	    private NewsMapper newsMapper;

	    @GetMapping("/newsList")
	    public Map<String, Object> getNewsList(@RequestParam(defaultValue = "1")int page) {
	   
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
	    
	    
	    
	    @GetMapping("/newsContent")
	    public News getNews(@RequestParam("news_idx") int news_idx) {
	    	
	    	News news = newsMapper.getNews(news_idx);
	    	
	    	System.out.println(news);
	    	
	    	return news;
	    	
	    }
	    
	    
	    

}
