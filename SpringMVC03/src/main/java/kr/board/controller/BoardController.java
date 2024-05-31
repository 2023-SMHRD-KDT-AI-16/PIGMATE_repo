package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.News;
import kr.board.mapper.NewsMapper;

@RequestMapping("/board")
@RestController
public class BoardController {
	
	 @Autowired
	    private NewsMapper newsMapper;

	    @GetMapping("/newsList")
	    public List<News> getNewsList(Model model) {
	    	
	        List<News> newsList = newsMapper.getNewsList();
	        
	        return newsList;
	    }

}
