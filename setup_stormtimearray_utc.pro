;2015/10/20
PRO SETUP_STORMTIMEARRAY_UTC,stormTimeArray_utc,TBEFORESTORM=tBeforeStorm,TAFTERSTORM=tAfterStorm, $
                             nStorms=nStorms,STORMINDS=stormInds,STORMFILE=stormFile, $
                             MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $   ;DBs
                             STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $          ;extra info
                             CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds, $ ; outs
                             RANDOMTIMES=randomTimes, $
                             SAVEFILE=saveFile,SAVESTR=saveString

  IF N_ELEMENTS(stormTimeArray_utc) NE 0 THEN BEGIN

     nStorms = N_ELEMENTS(stormTimeArray_utc)
     centerTime = stormTimeArray_utc
     tStamps = TIME_TO_STR(stormTimeArray_utc)
     stormString = 'user-provided'

  ENDIF ELSE BEGIN              ;Looks like we're relying on Brett

     IF randomTimes GT 1 THEN BEGIN
        nStorms=randomTimes
        GET_STORMTIME_UTC,nStorms=nStorms,STORMINDS=stormInds,STORMFILE=stormFile, $
                          MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $      ;DBs
                          STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $             ;extra info
                          CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds, $    ; outs
                          RANDOMTIMES=randomTimes
     ENDIF ELSE BEGIN
        nStorms=N_ELEMENTS(stormStruct.time)
        
        GET_STORMTIME_UTC,nStorms=nStorms,STORMINDS=stormInds,STORMFILE=stormFile, $
                          MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $      ;DBs
                          STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $             ;extra info
                          CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds    ; outs
        
        IF saveFile THEN saveStr+=',startDate,stopDate,stormType,stormStruct_inds'
     ENDELSE
  ENDELSE

  datStartStop = MAKE_ARRAY(nStorms,2,/DOUBLE)
  datStartStop[*,0] = centerTime - tBeforeStorm*3600.   ;[*,0] are the times before which we don't want data for each storm
  datStartStop[*,1] = centerTime + tAfterStorm*3600.    ;[*,1] are the times after which we don't want data for each storm

END