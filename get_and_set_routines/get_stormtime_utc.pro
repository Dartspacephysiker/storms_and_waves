;2015/08/21 
;Stop trying to maintain the various versions of this thing called by SUPERPOSE_STORMS_ALFVENDBQUANTITIES and STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID

PRO GET_STORMTIME_UTC,nEpochs=nEpochs,EPOCHINDS=epochInds,STORMFILE=stormFile, $
                      MAXIMUS=maximus,STORMSTRUCTURE=stormStructure,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $      ;DBs
                      STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $          ;extra info
                      CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds, $ ; outs
                      RANDOMTIMES=randomTimes
  
  IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
     startDate=str_to_time(maximus.time(0))
     stopDate=str_to_time(maximus.time(-1))
     PRINT,'Using start and stop time from Dartmouth/Chaston database.'
     PRINT,'Start time: ' + maximus.time(0)
     PRINT,'Stop time: ' + maximus.time(-1)
  ENDIF
  
  IF KEYWORD_SET(STARTDATE) THEN BEGIN
     IF N_ELEMENTS(STOPDATE) EQ 0 THEN BEGIN
        PRINT,"No stop year specified! Plotting data up to a full year after startDate."
        stopDate=startDate+86400.*31.*12.
     ENDIF
     
  ENDIF ELSE BEGIN
     PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
     RETURN
  ENDELSE
  
  IF KEYWORD_SET(randomTimes) THEN BEGIN
     stormStruct_inds = -1
     stormType = 2
     stormString = 'random'
     centerTime = RANDOMU(seed,nEpochs,/DOUBLE)*(stopDate-startDate)+startDate
     centerTime = centerTime(SORT(centerTime))
     julDay = conv_utc_to_julday(centerTime,tStamps)
  ENDIF ELSE BEGIN
     stormStruct_inds=WHERE(stormStructure.time GE startDate AND stormStructure.time LE stopDate,/NULL)
     
     IF KEYWORD_SET(epochInds) THEN BEGIN
        PRINT,'Using provided epoch indices (' + STRCOMPRESS(N_ELEMENTS(epochInds),/REMOVE_ALL) + ' epochs)...'
        PRINT,"Database: " + stormFile
        
        stormStruct_inds = cgsetintersection(stormStruct_inds,epochInds)
     ENDIF
     
     ;; Check storm type
     IF stormType EQ 1 THEN BEGIN ;Only large storms
        stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStructure.is_largeStorm EQ 1,/NULL))
        stormString='large'
     ENDIF ELSE BEGIN
        IF stormType EQ 0 THEN BEGIN
           stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStructure.is_largeStorm EQ 0,/NULL))
           stormString='small'
        ENDIF ELSE BEGIN
           IF stormType EQ 2 THEN BEGIN
              stormString='all'
           ENDIF
        ENDELSE
     ENDELSE
     
     nEpochs=N_ELEMENTS(stormStruct_inds)     
     PRINT,"Storm type: " + stormString 
     PRINT,STRCOMPRESS(N_ELEMENTS(stormStruct_inds),/REMOVE_ALL)+" storms (out of " + STRCOMPRESS(nEpochs,/REMOVE_ALL) + " in the DB) selected"
     
     IF nEpochs EQ 0 THEN BEGIN
        PRINT,"No storms found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     IF KEYWORD_SET(ssc_times_utc) THEN BEGIN 
        centerTime = ssc_times_utc
        tStamps = time_to_str(ssc_times_utc)
     ENDIF ELSE BEGIN
        centerTime = stormStructure.time(stormStruct_inds)
        tStamps = stormStructure.tstamp(stormStruct_inds)
     ENDELSE
     
  ENDELSE

END