

select * from member_info;
select * from farm_info;
select * from farm_env_info;

update member_info set mem_name = '테스트', mem_phone = '010-0000-0000', 
mem_email = 'test2@naver.com' where mem_id = 'test2'

select * from farm_info where mem_id = 'admin';

select * from news_info order by pressed_at limit #{pageStart}, #{perPageNum};

DELETE FROM farm_info WHERE farm_livestock_cnt = 50;

update farm_info set farm_name = 'admin' where farm_livestock_cnt = 50;