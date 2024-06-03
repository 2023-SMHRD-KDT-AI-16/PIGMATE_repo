package kr.board.mapper;

import kr.board.entity.Criteria;
import kr.board.entity.News;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface NewsMapper {
    
    public List<News> getNewsList(Criteria cri);
    
    int countAllNews();

	public News getNews(int news_idx);
}