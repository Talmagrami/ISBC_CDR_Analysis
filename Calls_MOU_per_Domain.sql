--
-- This SQL query calculates the total number of calls and Minutes of Use (MOU) per domain for a specific date range.
-- The query aggregates data from the DISH_MNO_DL.INTERCONNECT_5G.RAW_INTERCONNECT_CDR_PARSE_HIST table, focusing on INVITE and BYE messages.
-- The results are grouped by month and domain, providing insights into call activity and usage patterns.
-- Based on the CDRs contents, INVITE records are used to identify the Domain while BYE CDRs are used to determine the duration of calls.
-- INVITE and BYE messages can be joined on the SESSION_ID to match calls.
-- The query is designed to be run in a SQL environment that supports the Snowflake functions and syntax.
--

WITH 
INVITES AS (
    SELECT
        TO_CHAR(TIMESTAMPADD('hour', 0, TO_TIMESTAMP(
            EVENT_TIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS"+0000"')), 'YYYY-MM') AS CALL_MONTH,  -- Format the timestamp to 'YYYY-MM' for monthly aggregation
        SERVICE_INFORMATION_USER_SESSION_ID AS SESSION_ID,  -- Unique session ID for the call
        REGEXP_SUBSTR(SERVICE_INFORMATION_REQUESTED_PARTY_ADDRESS, '@([^;]+)', 1, 1, 'e') AS CALLED_DOMAIN  -- Extract the domain from the called party address
    
    FROM DISH_MNO_DL.INTERCONNECT_5G.RAW_INTERCONNECT_CDR_PARSE_HIST -- Use the historical CDR parse table
    
    -- Filter for INVITE messages with specific conditions
    WHERE 
        SERVICE_INFORMATION_EVENT_TYPE_METHOD = 'INVITE'
        AND ACCOUNTING_RECORD_NUMBER = '0'  -- Only consider the first record; initiate INVITE, in the call sequence
        AND NOKIA_SPECIFIC_EXTENSION_OUTGOING_VN_TG_NAME LIKE 'Partner%'  -- Filter for specific trunk group names starting with 'Partner'
        
        -- Ensure the event timestamp is within the specified date range. :daterange can be replaced with a specific date range
        AND TIMESTAMPADD('hour', 0, TO_TIMESTAMP(EVENT_TIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS"+0000"')) >= TO_TIMESTAMP('2025-06-01 00:00:00')  -- Start date
        AND TIMESTAMPADD('hour', 0, TO_TIMESTAMP(EVENT_TIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS"+0000"')) < TO_TIMESTAMP('2025-07-01 00:00:00')  -- End date
),

BYES AS (
    SELECT
        SERVICE_INFORMATION_USER_SESSION_ID AS SESSION_ID,
        NOKIA_SPECIFIC_EXTENSION_CALL_DURATION AS CALL_DURATION_SEC -- Duration of the call in seconds
    FROM DISH_MNO_DL.INTERCONNECT_5G.RAW_INTERCONNECT_CDR_PARSE_HIST
    WHERE 
        SERVICE_INFORMATION_EVENT_TYPE_METHOD = 'BYE'   -- Consider BYE messages (scuccessful call termination)
        AND NOKIA_SPECIFIC_EXTENSION_OUTGOING_VN_TG_NAME LIKE 'Partner%'
        AND TIMESTAMPADD('hour', 0, TO_TIMESTAMP(EVENT_TIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS"+0000"')) >= TO_TIMESTAMP('2025-06-01 00:00:00')
        AND TIMESTAMPADD('hour', 0, TO_TIMESTAMP(EVENT_TIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS"+0000"')) < TO_TIMESTAMP('2025-07-01 00:00:00')
)

SELECT
    i.CALL_MONTH,   -- Month of the call from the INVITE message. 'i' is the alias for the INVITES table
    i.CALLED_DOMAIN, -- Domain of the called party extracted from the INVITE message
    COUNT(*) AS TOTAL_CALLS,    -- Total number of calls for the month and domain
    ROUND(SUM(b.CALL_DURATION_SEC) / 60, 0) AS MOU  -- Total Minutes of Use (MOU) rounded to the nearest minute. 'b' is the alias for the BYES table

FROM BYES b

JOIN INVITES i ON b.SESSION_ID = i.SESSION_ID   -- Join BYES with INVITES on the session ID to match calls

WHERE 
    b.CALL_DURATION_SEC IS NOT NULL  -- Ensure that the call duration is not null

GROUP BY i.CALL_MONTH, i.CALLED_DOMAIN  -- Group by month and domain to aggregate the data

ORDER BY i.CALL_MONTH, MOU DESC;    --- Order the results by month and MOU in descending order