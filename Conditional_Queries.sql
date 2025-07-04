SELECT *,

FROM DISH_MNO_DL.INTERCONNECT_5G.RAW_INTERCONNECT_CDR_PARSE,

WHERE 

    -- ACCOUNTING_RECORD_NUMBER,                         -- Sequence number of the INVITE and BYE messages in the call and start with 0
    -- EVENT_TIMESTAMP,                                  -- Timestamp of the event in UTC format, e.g. '2023-10-01T12:00:00+0000' 
    -- NOKIA_SPECIFIC_EXTENSION_CALL_DURATION,           -- Duration of the call in seconds
    -- NOKIA_SPECIFIC_EXTENSION_CALL_RELEASE_INDICATION, -- if = '2' Caller Release, = '3' Callee Release
    -- NOKIA_SPECIFIC_EXTENSION_INCOMING_VN_TG_NAME,     -- Incoming Trunk Group Name
    -- NOKIA_SPECIFIC_EXTENSION_OUTGOING_VN_TG_NAME,     -- Outgoing Trunk Group Name
    -- NOKIA_CORE_QOS_STATISTICS_RTP_STATISTICS,         -- Local RTP statistics for the call, including packet loss, jitter, and delay
    -- NOKIA_CORE_QOS_STATISTICS_RTCP_STATISTICS,        -- Local RTCP statistics for the call, including packet loss, jitter, and delay
    -- NOKIA_CORE_QOS_STATISTICS_NETWORK_STATISTICS,     -- Local network statistics 
    -- NOKIA_CORE_QOS_STATISTICS_CONNECTION_IP,          -- IP address of Local remote RTP (CFX)
    -- NOKIA_CORE_QOS_STATISTICS_CODEC_REMOTE,           -- Accepted SDB from CFX to ISBC (JSON format)
    -- NOKIA_CORE_QOS_STATISTICS_CODEC_LOCAL,            -- Offered SDB from ISBC to CFX (JSON format)
    -- NOKIA_CORE_QOS_STATISTICS_BANDWIDTH,              -- b=AS:30 means the maximum bandwidth allowed for this media stream is 30 kilobits per second (kbps)
    -- NOKIA_PEER_QOS_STATISTICS_RTP_STATISTICS,         -- PEER RTP statistics for the call, including packet loss, jitter, and delay
    -- NOKIA_PEER_QOS_STATISTICS_RTCP_STATISTICS,        -- PEER RTCP statistics for the call, including packet loss, jitter, and delay
    -- NOKIA_PEER_QOS_STATISTICS_NETWORK_STATISTICS,     -- PEER network statistics
    -- NOKIA_PEER_QOS_STATISTICS_CONNECTION_IP,          -- IP address of Peer remote RTP
    -- NOKIA_PEER_QOS_STATISTICS_CODEC_REMOTE,           -- Remote SDB Offer (JSON format)
    -- NOKIA_PEER_QOS_STATISTICS_CODEC_LOCAL,            -- Local SDB Accept (JSON format)
    -- NOKIA_PEER_QOS_STATISTICS_BANDWIDTH,              -- Peer maximum bandwidth allowed for this media stream
    -- ACCOUNTING_RECORD_TYPE,                           -- '1' (failed calls)'2' = INVITE, '3' = RE-INVITE, '4' = BYE (successful call)
    -- SERVICE_INFORMATION_ACCESS_NETWORK_INFORMATION,   -- '%utran-cell-id%' means call originated from cell, '%wlan-node-id%' means call originated from wifi
    -- SERVICE_INFORMATION_CALLED_PARTY_ADDRESS,         -- Called Party Address; including the phone number and the domain name of the called party
    -- SERVICE_INFORMATION_CALLING_PARTY_IDENTITY,       
    -- SERVICE_INFORMATION_CALLING_PARTY_ADDRESS,        -- Calling Party Address; including the phone number and the domain name of the calling party
    -- SERVICE_INFORMATION_CALLED_ASSERTED_IDENTITY,     -- voicemail may included
    -- SERVICE_INFORMATION_CAUSE_CODE,
    -- SERVICE_INFORMATION_EVENT_TYPE_METHOD,            -- 'INVITE' or 'BYE'
    -- SERVICE_INFORMATION_ROLE_OF_NODE                  -- '0' = Outgoing, '1' = Incoming Traffic
    -- SERVICE_INFORMATION_FROM_ADDRESS_AVP,
    -- SERVICE_INFORMATION_SIP_REQUEST_TIME_STAMP,
    -- SERVICE_INFORMATION_SIP_RESPONSE_TIME_STAMP,
    -- SERVICE_INFORMATION_EARLY_MEDIA_DESCRIPTION,
    -- SERVICE_INFORMATION_SDP_SESSION_DESCRIPTION,
    -- SERVICE_INFORMATION_REASON_HEADER,
    -- SERVICE_INFORMATION_USER_SESSION_ID,
    -- SERVICE_INFORMATION_SDP_MEDIA_COMPONENT,
    
    TIMESTAMPADD('hour', 0, TO_TIMESTAMP(EVENT_TIMESTAMP, 'YYYY-MM-DD\"T\"HH24:MI:SS\"+0000\"')) = :daterange
