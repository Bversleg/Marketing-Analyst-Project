WITH      first_table AS( 
                        SELECT  TIMESTAMP_MICROS(event_timestamp) date_time,
                                event_timestamp,
                                user_pseudo_id,
                                ROW_NUMBER() OVER (PARTITION BY event_timestamp, user_pseudo_id ORDER BY event_timestamp) row_nr, --to remove duplicate timestamps
                                CASE WHEN event_name = "purchase" THEN 1 END purchase       
                        FROM `tc-da-1.turing_data_analytics.raw_events` 
                        --ORDER BY date_time, user_pseudo_id
                        ),

      sessions_table AS( 
                        SELECT  *,
                                CASE WHEN event_timestamp = MIN(event_timestamp)OVER (PARTITION BY user_pseudo_id) THEN 1 ELSE 0 END first_session_start, -- this to show very first session start
                                CASE WHEN event_timestamp - (LAG(event_timestamp) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp))>1800000000 THEN 1 ELSE 0 END second_session_start, 
                                --number is 30 min in microseconds and function shows when a next session would start
                                CASE WHEN event_timestamp = MAX(event_timestamp) OVER (PARTITION BY user_pseudo_id) THEN 1 ELSE 0 END last_session_end,
                                --shows then the last session (or first if there is only 1 session per user) would end
                
                        FROM first_table
                        WHERE row_nr = 1 --to filter out duplicate timestamps for same user if various events started at same time 
                        --ORDER BY date_time, user_pseudo_id  
                        ),

      timestamp_table AS(    
                        SELECT  date_time,
                                user_pseudo_id,
                                event_timestamp,
                                first_session_start,
                                second_session_start,
                                last_session_end,
                                CASE WHEN second_session_start = 1 THEN LAG(TIMESTAMP_MICROS(event_timestamp)) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp) END previous_session_end, 
                                --to get the timestamp from when previous session ends
                                CASE WHEN last_session_end = 1 THEN TIMESTAMP_MICROS(event_timestamp) END session_end_time,
                                --timestamp from when last(or first if user has only 1) session ends    
                                
                        FROM sessions_table
                        ORDER BY user_pseudo_id,event_timestamp
                        ),

 move_timestamp_table AS(
                        SELECT  date_time,
                                user_pseudo_id,
                                first_session_start,
                                second_session_start,
                                last_session_end,
                                LEAD(previous_session_end) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp) session_end_time,-- to move the session end timestamp next to the previous session
                                LEAD(session_end_time) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp) session_end_time2,-- to move the timestamp next to the previous session       
                        
                        FROM timestamp_table
                        WHERE second_session_start = 1 OR first_session_start = 1 OR last_session_end = 1 -- to remove rows without start or end information
                        ORDER BY user_pseudo_id,event_timestamp
                        ),

additional_info_table AS( --add info about medium and campaign used
                        SELECT  campaign,
                                medium,
                                user_pseudo_id,
                                TIMESTAMP_MICROS(event_timestamp) date_time,
                        FROM `turing_data_analytics.raw_events`
                        WHERE campaign IS NOT NULL --to remove duplicate rows                       
                        ),

       duration_table AS( --calculate the duration of a session
                        SELECT  date_time,
                                EXTRACT(DAYOFWEEK FROM date_time) weekday,
                                user_pseudo_id,
                                CASE WHEN session_end_time IS NULL AND session_end_time2 IS NOT NULL THEN DATETIME_DIFF(session_end_time2,date_time, SECOND) 
                                WHEN session_end_time IS  NOT NULL THEN DATETIME_DIFF(session_end_time, date_time, SECOND) ELSE 0
                                END duration,
        
                        FROM move_timestamp_table
                        WHERE second_session_start = 1 OR first_session_start = 1
                        ),

    conversion_table AS( --join this table on the durations table to find the sessions where a purchase happened
                        SELECT  user_pseudo_id,
                                date_time,
                                purchase,
                                
                        FROM sessions_table
                        )

SELECT *
FROM(
        SELECT  date_time, 
                user_pseudo_id,
                weekday,
                session_duration,
                campaign,
                CASE WHEN LEAD(purchase) OVER (PARTITION BY user_pseudo_id ORDER BY date_time) = 1 THEN 1 ELSE 0 END conversion,
                --Get the conversion flag next to the correct session by moving it one row up.
                medium

        FROM   (SELECT CASE WHEN conversion_table.purchase IS NULL THEN duration_table.date_time ELSE conversion_table.date_time END date_time, --join 3 tables
                        CASE WHEN conversion_table.purchase IS NULL THEN duration_table.user_pseudo_id ELSE conversion_table.user_pseudo_id END user_pseudo_id,
                        weekday,
                        TIME(TIMESTAMP_SECONDS(duration)) session_duration,
                        campaign,
                        conversion_table.purchase,
                        medium
                
                FROM duration_table
                LEFT JOIN additional_info_table
                ON additional_info_table.user_pseudo_id = duration_table.user_pseudo_id AND additional_info_table.date_time = duration_table.date_time
                FULL JOIN conversion_table
                ON conversion_table.user_pseudo_id = duration_table.user_pseudo_id AND conversion_table.date_time = duration_table.date_time
                )
        WHERE date_time IS NOT NULL )
WHERE session_duration IS NOT NULL --filter out the row where the purchase, purchase date and UID is showing
ORDER BY user_pseudo_id, date_time 
