select * from member_info;
select * from farm_info;
select * from farm_env_info where mem_id = 'admin';
select * from env_criteria_info;
select * from alert_info;
select * from detection_info;
delete from alert_info;

INSERT INTO detection_info (livestock_cnt, sit_cnt, result, created_at, farm_idx)
VALUES ('26', '12', '0', '2024-06-08 09:00:00', '32');

INSERT INTO pig_info (livestock_cnt, warn_cnt, farm_idx, created_at)
VALUES ('26','0','32','2024-06-08 18:32:20');

select * from pig_info;

delete from detection_info where detect_idx = '21';

INSERT INTO alert_info
		(mem_id, alarm_msg, alarmed_at, farm_idx)
		VALUES ('admin',
		'test', '2024-06-11-00:00:00', '32')

ALTER TABLE alert_info MODIFY COLUMN alarm_idx INT AUTO_INCREMENT;

select * from pen_info where farm_idx = 22;

insert into env_criteria_info (farm_idx, temperature, humidity, co2, ammonia,
		pm)
		values ('19', '20', '20', '20', '20', '20')

update member_info set mem_name = '테스트', mem_phone = '010-0000-0000', 
mem_email = 'test2@naver.com' where mem_id = 'test2'

select * from farm_info where mem_id = 'admin';

select * from news_info order by pressed_at limit #{pageStart}, #{perPageNum};

DELETE FROM farm_info WHERE farm_loc = '전남 담양군 무정면 광주대구고속도로 11';

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
    
    
SELECT created_date, AVG(lying_cnt) AS avg_lying_cnt, AVG(livestock_cnt) AS avg_livestock_cnt
FROM (
    SELECT 
        DATE(created_at) AS created_date,
        lying_cnt,
        livestock_cnt
    FROM 
        detection_info
    WHERE 
        farm_idx = 19
    ORDER BY 
        created_at DESC
    LIMIT 100  -- 일단 100개로 한정, 필요에 따라 조정
) subquery
GROUP BY created_date
ORDER BY created_date ASC
LIMIT 10;


    SELECT created_date, AVG(warn_cnt) AS avg_warn_cnt, AVG(livestock_cnt) AS avg_livestock_cnt
    FROM (
        SELECT 
            DATE(created_at) AS created_date,
            warn_cnt,
            livestock_cnt
        FROM 
           pig_info
        WHERE 
            farm_idx = 32
        ORDER BY 
            created_at DESC
        LIMIT 100
    ) subquery
    GROUP BY created_date
    ORDER BY created_date ASC
    LIMIT 10;

      WITH recent_data AS (
        SELECT *
        FROM (
            SELECT *
            FROM pig_info
            WHERE farm_idx = 32
            ORDER BY created_at DESC
            LIMIT 15
        ) sub
        ORDER BY created_at
    ),
    hourly_intervals AS (
        SELECT 
            CASE 
                WHEN MINUTE(created_at) < 30 THEN DATE_FORMAT(created_at, '%Y-%m-%d %H:00:00')
                ELSE DATE_FORMAT(created_at, '%Y-%m-%d %H:30:00')
            END AS time_interval,
            warn_cnt, livestock_cnt
        FROM recent_data
    ),
    averaged_data AS (
        SELECT
            time_interval,
            AVG(warn_cnt) AS avg_warn_cnt,
            AVG(livestock_cnt) AS avg_livestock_cnt
        FROM hourly_intervals
        GROUP BY time_interval
    )
    SELECT 
        time_interval AS `interval`,
        avg_warn_cnt AS warnCnt,
        avg_livestock_cnt AS livestockCnt
    FROM averaged_data
    ORDER BY `interval`;