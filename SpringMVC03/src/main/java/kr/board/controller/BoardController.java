package kr.board.controller;

import java.util.List;

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
	    public Model getNewsList(Model model, Criteria cri) {
	    	
	        List<News> newsList = newsMapper.getNewsList();
	        
	        PageMaker pgm = new PageMaker();
	        pgm.setCri(cri);
	        pgm.setTotalCount(17);
	        
	        model.addAttribute("newsList", newsList);
	        model.addAttribute("pageMake", pgm);
	        
	        return model;
	    }
	    
	    
	    
	    @GetMapping("/newsContent")
	    public News getNews(@RequestParam("news_idx") int news_idx) {
	    	
	    	News news = newsMapper.getNews(news_idx);
	    	
	    	System.out.println(news);
	    	
	    	return news;
	    	
	    }
	    
	    
	    

}
