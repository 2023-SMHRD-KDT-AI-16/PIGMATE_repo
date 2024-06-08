

select * from member_info;
select * from farm_info;
select * from farm_env_info where farm_idx = 19;
select * from env_criteria_info;

insert into env_criteria_info (farm_idx, temperature, humidity, co2, ammonia,
		pm)
		values ('19', '20', '20', '20', '20', '20')

update member_info set mem_name = '테스트', mem_phone = '010-0000-0000', 
mem_email = 'test2@naver.com' where mem_id = 'test2'

select * from farm_info where mem_id = 'admin';

select * from news_info order by pressed_at limit #{pageStart}, #{perPageNum};

DELETE FROM farm_info WHERE farm_livestock_cnt = 303;


update farm_info set farm_name = 'admin' where farm_livestock_cnt = 50;


UPDATE farm_info
SET farm_name = 'admin12', farm_loc = '전남 어딘가11', farm_livestock_cnt = 101
WHERE farm_name = 'admin123';

 UPDATE env_criteria_info
SET temperature = 50, humidity = 50, co2 = 50, ammonia = 50, pm = 50
WHERE farm_idx = 19;

select * from env_criteria_info where farm_idx = 19;

delete from env_criteria_info where criteria_idx = 2;

select * from farm_env_info where farm_idx=19 desc;

SELECT * FROM farm_env_info WHERE farm_idx = 19 ORDER BY created_at DESC;
		
SELECT
    DATE_FORMAT(created_at, '%Y-%u') as week,
    AVG(temperature) as temperature,
    AVG(humidity) as humidity,
    AVG(co2) as co2,
    AVG(ammonia) as ammonia,
    AVG(pm) as pm,
    19 as farm_idx
FROM
    farm_env_info
WHERE
    farm_idx = 19
GROUP BY
    week
    
    SELECT
        DATE(created_at) as created_at,
        AVG(temperature) as temperature,
        AVG(humidity) as humidity,
        AVG(co2) as co2,
        AVG(ammonia) as ammonia,
        AVG(pm) as pm,
        19 as farm_idx
    FROM
        farm_env_info
    WHERE
        farm_idx = 19
        AND created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)
    GROUP BY DATE(created_at)
    ORDER BY created_at
    
SELECT
    DATE(created_at) as created_at,
    AVG(temperature) as temperature,
    AVG(humidity) as humidity,
    AVG(co2) as co2,
    AVG(ammonia) as ammonia,
    AVG(pm) as pm,
    19 as farm_idx
FROM
    farm_env_info
WHERE
    farm_idx = 19
    AND DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
GROUP BY DATE(created_at)
ORDER BY created_at;

SELECT
    created_at,
    temperature,
    humidity,
    co2,
    ammonia,
    pm,
    19 as farm_idx
FROM
    farm_env_info
WHERE
    farm_idx = 19
    AND DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
ORDER BY created_at

SELECT
    created_at,
    temperature,
    humidity,
    co2,
    ammonia,
    pm,
    19 as farm_idx
FROM
    farm_env_info
WHERE
    farm_idx = 19
    AND DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
ORDER BY created_at;

 SELECT
        created_at,
        temperature,
        humidity,
        co2,
        ammonia,
        pm,
        19 as farm_idx
    FROM
        farm_env_info
    WHERE
        farm_idx = 19
        AND created_at >= (
            SELECT DATE_SUB(MAX(created_at), INTERVAL 1 WEEK)
            FROM farm_env_info
            WHERE farm_idx = 19
        )
    ORDER BY created_at;
    
    
  SELECT
        created_at,
        temperature,
        humidity,
        co2,
        ammonia,
        pm,
        19 as farm_idx
    FROM
        farm_env_info
    WHERE
        farm_idx = 19 and created_at >= CURDATE() - INTERVAL 28 DAY;
    
SELECT
    created_at,
    temperature,
    humidity,
    co2,
    ammonia,
    pm,
    19 as farm_idx
FROM
    farm_env_info
WHERE
    farm_idx = 19
    AND created_at >= (
        SELECT DATE_SUB(MAX(created_at), INTERVAL 28 DAY)
        FROM farm_env_info
        WHERE farm_idx = 19
    )
ORDER BY
    created_at;
    
    
SELECT m.*, f.*
		FROM member_info m
		LEFT JOIN farm_info f ON m.mem_id = f.mem_id
		WHERE m.mem_id = 'admin' AND m.mem_pw = MD5('1234');
		
SELECT * FROM farm_env_info_day where farm_idx = 19;

SELECT * FROM farm_env_info_day;


