;;08/26/16
FUNCTION GET_DST_STATISTICS__TIMESERIES__FROM_STORMSTRUCT,stormStruct, $
   ;; DstMinBPD,DstMinMom,DstMinCIList, $
   ;; DstDropBPD,DstDropMom,DstDropCIList, $
   ;; julTimes, $
   LARGE_STORMS=large_storms, $
   SMALL_STORMS=small_storms, $
   NMONTHS_PER_CALC=monthInterval, $
   NDAYS_PER_CALC=dayInterval, $
   NYEARS_PER_CALC=yearInterval, $
   NHOURS_PER_CALC=hourInterval, $
   FULL_DST_DB=full_Dst_DB, $
   T1_UTC=t1_UTC, $
   T2_UTC=t2_UTC, $
   T1_JULDAY=t1_julDay, $
   T2_JULDAY=t2_julDay, $
   CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
   ;; OUT_TOTAL_DSTMINSTATS=totalDstMinStats, $
   ;; OUT_TOTALDSTDROPSTATS=totalDstDropStats, $
   ;; OUT_TOTALDSTMIN_BPD=totalDstMin_BPD, $ 
   ;; OUT_TOTALDSTDROP_BPD=totalDstDrop_BPD, $
   ;; OUT_TOTALDSTMIN_MOM=totalDstMinMom, $  
   ;; OUT_TOTALDSTDROP_MOM=totalDstDropMom, $ 
   ;; OUT_TOTALDSTMIN_CI=totalDstMinCI, $   
   ;; OUT_TOTALDSTDROP_CI=totalDstDropCI, $  
   VERBOSE=verbose

  COMPILE_OPT IDL2

  deltaMin = 0.00069444444444444447D ;;The length of 1 min in units of days

  large_i        = WHERE(stormStruct.is_largeStorm,nLarge, $
                         COMPLEMENT=small_i,NCOMPLEMENT=nSmall)

  IF KEYWORD_SET(restrict_i) THEN BEGIN
     PRINT,'Restricting Dst stats with user-provided inds ...'
     large_i     = CGSETINTERSECTION(large_i,restrict_i,COUNT=nLarge)
     small_i     = CGSETINTERSECTION(small_i,restrict_i,COUNT=nSmall)
  ENDIF

  CASE 1 OF
     KEYWORD_SET(large_storms): BEGIN
        IF nLarge EQ 0 THEN BEGIN
           PRINT,'No largestorm data! Returning ...'
           RETURN,-1
        ENDIF ELSE BEGIN
           PRINT,'Using ' + STRCOMPRESS(nLarge,/REMOVE_ALL) + ' large storms ...'
        ENDELSE

        storm_i  = large_i
        nStorm   = nLarge
        stormType = 'Large'
     END
     KEYWORD_SET(small_storms): BEGIN
        IF nSmall EQ 0 THEN BEGIN
           PRINT,'No smallstorm data! Returning ...'
           RETURN,-1
        ENDIF ELSE BEGIN
           PRINT,'Using ' + STRCOMPRESS(nSmall,/REMOVE_ALL) + ' small storms ...'
        ENDELSE

        storm_i  = small_i
        nStorm   = nSmall
        stormType = 'Small'
     END
     ELSE: BEGIN
        nStorm   = N_ELEMENTS(stormStruct.is_largeStorm)
        storm_i  = INDGEN(nStorm)
        stormType = 'BOTH'
     END
  ENDCASE
  nStormStr      = STRCOMPRESS(nStorm,/REMOVE_ALL)

  IF KEYWORD_SET(t1_UTC) AND KEYWORD_SET(t2_UTC) THEN BEGIN
     earliest_julDay     = UTC_TO_JULDAY(t1_UTC)
     latest_julDay       = UTC_TO_JULDAY(t2_UTC)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(t1_julDay) AND KEYWORD_SET(t2_julDay) THEN BEGIN
        earliest_julDay  = t1_julDay
        latest_julDay    = t2_julDay
     ENDIF ELSE BEGIN
        PRINT,'No input time provided! Assuming I should just do them all ...'
        calc_all_times   = 1
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(calc_all_times) THEN BEGIN
     earliest_julDay  = stormStruct.julDay[0]
     latest_julDay    = stormStruct.julDay[-1]
  ENDIF

  timeArr = TIMEGEN_EASIER(earliest_julDay,latest_julDay, $
                           NMONTHS_PER_CALC=monthInterval, $
                           NDAYS_PER_CALC=dayInterval, $
                           NYEARS_PER_CALC=yearInterval, $
                           NHOURS_PER_CALC=hourInterval, $
                           OUT_MAXSEP=maxSep)

  
  ;;Make sure we're not missing out on the last possibility for a data point
  IF (latest_julDay-timeArr[-1]) GT maxSep THEN BEGIN
     timeArr = [timeArr,latest_julDay]
  ENDIF

  ;;Set up arrays
  nTimes     = N_ELEMENTS(timeArr)
  nIntervals = nTimes-1
  nArr       = MAKE_ARRAY(nIntervals,/INTEGER)

  nDays      = (SHIFT(timeArr,-1)-timeArr)[0:-2]

  julTimes   = MAKE_ARRAY(2,nIntervals,/DOUBLE)

  DstMinBPD  = !NULL
  DstDropBPD = !NULL

  DstMinMom  = !NULL
  DstDropMom = !NULL

  ;; DstMinCI   = !NULL
  ;; DstDropCI  = !NULL

  DstMinCIList   = LIST()
  DstDropCIList  = LIST()

  ;;First get the totals
  tmpStats   = GET_DST_STATISTICS_FROM_STORMSTRUCT(stormStruct,storm_i, $
                                                   BPD__DSTMIN_OUTLIERS=BPDMinOutliers, $
                                                   BPD__DSTDROP_OUTLIERS=BPDDropOutliers, $
                                                   BPD__DSTMIN_SUSPECTED_OUTLIERS=BPDMinSusOutliers, $
                                                   BPD__DSTDROP_SUSPECTED_OUTLIERS=BPDDropSusOutliers)

  ;;String for the totals
  CALDAT,earliest_julDay,!NULL,!NULL,earlyYear
  CALDAT,latest_julDay,!NULL,!NULL,lateYear
  totString  = STRING(FORMAT='(I0,"–",I0)',earlyYear,lateYear)

  totalMin   =  {BPD     : tmpStats[0].BPD, $
                 moment  : TRANSPOSE(tmpStats[0].mom), $
                 BPD_CI  : tmpStats[0].ci_BPD, $
                 name    : totString}
  totalDrop  =  {BPD     : tmpStats[1].BPD, $
                 moment  : TRANSPOSE(tmpStats[1].mom), $
                 BPD_CI  : tmpStats[1].ci_BPD, $
                 name    : totString}
  
  ;; totalDstMin_BPD  = 
  ;; totalDstDrop_BPD = tmpStats[1].BPD

  ;; totalDstMinMom   = 
  ;; totalDstDropMom  = TRANSPOSE(tmpStats[1].mom)

  ;; totalDstMinCI    = 
  ;; totalDstDropCI   = tmpStats[1].ci_BPD


  ;;Now get time series
  nTotStorms = 0
  FOR iTime=0,nIntervals-1 DO BEGIN
     tmpJul  = [timeArr[iTime],timeArr[iTime+1]-deltaMin]

     IF KEYWORD_SET(verbose) THEN BEGIN
        CALDAT,tmpJul[0],month1,day1,year1,hour1,min1
        CALDAT,tmpJul[1],month2,day2,year2,hour2,min2

        PRINT,'iTime: ' + STRCOMPRESS(iTime,/REMOVE_ALL)
        PRINT,FORMAT='("[START, STOP] : [",A0,", ",A0,"]")', $
              TIMESTAMP(MONTH=month1,DAY=day1,YEAR=year1,HOUR=hour1,MIN=min1), $
              TIMESTAMP(MONTH=month2,DAY=day2,YEAR=year2,HOUR=hour2,MIN=min2)
     ENDIF

     tmp_ii  = WHERE((stormStruct.julDay[storm_i] GE tmpJul[0]) AND $
                     (stormStruct.julDay[storm_i] LE tmpJul[1]),nTmp)
     
     IF nTmp EQ 0 THEN BEGIN
        IF KEYWORD_SET(verbose) THEN PRINT,'No data for this period, most unfortunately...'
        CONTINUE
     ENDIF ELSE BEGIN
        tmp_i       = storm_i[tmp_ii]
        nArr[iTime] = nTmp
        nTotStorms += nTmp
        IF KEYWORD_SET(verbose) THEN PRINT,STRCOMPRESS(N_ELEMENTS(tmp_i),/REMOVE_ALL) + ' storms available for this period'
     ENDELSE

     tmpStats = GET_DST_STATISTICS_FROM_STORMSTRUCT(stormStruct,tmp_i, $
                                                    ;; BPD__DSTMIN_MEAN=BPDMinMean, $
                                                    ;; BPD__DSTDROP_MEAN=BPDDropMean, $
                                                    BPD__DSTMIN_OUTLIERS=BPDMinOutliers, $
                                                    BPD__DSTDROP_OUTLIERS=BPDDropOutliers, $
                                                    BPD__DSTMIN_SUSPECTED_OUTLIERS=BPDMinSusOutliers, $
                                                    BPD__DSTDROP_SUSPECTED_OUTLIERS=BPDDropSusOutliers)

     DstMinBPD  = [[DstMinBPD] ,[TRANSPOSE(tmpStats[0].BPD)]]
     DstDropBPD = [[DstDropBPD],[TRANSPOSE(tmpStats[1].BPD)]]

     DstMinMom  = [[DstMinMom] ,[tmpStats[0].mom]]
     DstDropMom = [[DstDropMom],[tmpStats[1].mom]]

     ;; DstMinCI   = [DstMinCI ,tmpStats[0].ci_BPD]
     ;; DstDropCI  = [DstDropCI,tmpStats[1].ci_BPD]

     DstMinCIList.Add,tmpStats[0].ci_BPD
     DstDropCIList.Add,tmpStats[1].ci_BPD

     julTimes[*,iTime] = tmpJul

  ENDFOR

  DstStats = { $
             times     : julTimes, $
             n         : nArr, $
             min       : {BPD     : DstMinBPD, $
                          moment  : DstMinMom, $
                          CI_list : DstMinCIList, $
                          name    : KEYWORD_SET(stormMinName) ? $
                                    stormMinName  : nStormStr + ' ' + stormType + ' Storms'}, $
             drop      : {BPD     : DstDropBPD, $
                          moment  : DstDropMom, $
                          CI_list : DstDropCIList, $
                          name    : KEYWORD_SET(stormDropName) ? $
                                    stormDropName : nStormStr + ' ' + stormType + ' Storms'}, $
             totalMin  : totalMin, $
             totalDrop : totalDrop $
               }

  RETURN,DstStats
END
