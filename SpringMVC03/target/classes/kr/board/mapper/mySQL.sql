

select * from member_info;
select * from farm_info;
select * from farm_env_info;
select * from env_criteria_info;

insert into env_criteria_info (farm_idx, temperature, humidity, co2, ammonia,
		pm)
		values ('19', '20', '20', '20', '20', '20')

update member_info set mem_name = '테스트', mem_phone = '010-0000-0000', 
mem_email = 'test2@naver.com' where mem_id = 'test2'

select * from farm_info where mem_id = 'admin';

select * from news_info order by pressed_at limit #{pageStart}, #{perPageNum};

DELETE FROM farm_info WHERE farm_livestock_cnt = 50;

update farm_info set farm_name = 'admin' where farm_livestock_cnt = 50;


UPDATE farm_info
SET farm_name = 'admin12', farm_loc = '전남 어딘가11', farm_livestock_cnt = 101
WHERE farm_name = 'admin123';

 UPDATE env_criteria_info
SET temperature = 50, humidity = 50, co2 = 50, ammonia = 50, pm = 50
WHERE farm_idx = 19;

select * from env_criteria_info where farm_idx = 19;

delete from env_criteria_info where criteria_idx = 2;