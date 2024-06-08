package kr.board.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor 
@AllArgsConstructor
@Data
public class News {
	
	private int news_idx;
	private String news_title;
	private String news_content;
	private String news_url;
	private String news_subtitle;
	private String pressed_at;
	private String img_url;

}
