PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS

  ;;Get smoothed Dst and AE DBs
  load_dst_ae_dbs,dst,ae

  IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
     startDate=str_to_time(maximus.time(0))
     stopDate=str_to_time(maximus.time(-1))
     PRINT,'Using start and stop time from Dartmouth/Chaston database.'
     PRINT,'Start time: ' + maximus.time(0)
     PRINT,'Stop time: ' + maximus.time(-1)
  ENDIF
  
  ;;Smooth Dst data
  SMOOTH

END