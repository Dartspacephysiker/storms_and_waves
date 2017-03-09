;;08/26/16
FUNCTION GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT,stormStruct, $
   RESTRICT_I=restrict_i, $
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
   ADD_FREQ_STATS=add_freq_stats, $
   VERBOSE=verbose

  COMPILE_OPT IDL2,STRICTARRSUBS

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

  ;;These guys contain the extras, like outliers, if they exist
  DstMinBPDList  = LIST()
  DstDropBPDList = LIST()
  DstFreqBPDList = LIST()

  DstMinBadBPD   = !NULL
  DstDropBadBPD  = !NULL

  DstMinMom  = !NULL
  DstDropMom = !NULL

  ;;First get the totals
  tmpStats   = GET_DST_STATISTICS_FROM_STORMSTRUCT_V2(stormStruct,storm_i)

  ;;String for the totals
  CALDAT,earliest_julDay,!NULL,!NULL,earlyYear
  CALDAT,latest_julDay,!NULL,!NULL,lateYear
  totString  = STRING(FORMAT='(I0,"–",I0)',earlyYear,lateYear)

  totalMin   =  {BPD     : tmpStats[0].BPD, $
                 moment  : TRANSPOSE(tmpStats[0].mom), $
                 name    : totString}
  totalDrop  =  {BPD     : tmpStats[1].BPD, $
                 moment  : TRANSPOSE(tmpStats[1].mom), $
                 name    : totString}
  

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
        ;; CONTINUE
        tmp_i       = !NULL
     ENDIF ELSE BEGIN
        tmp_i       = storm_i[tmp_ii]
        nArr[iTime] = nTmp
        nTotStorms += nTmp
        IF KEYWORD_SET(verbose) THEN PRINT,STRCOMPRESS(N_ELEMENTS(tmp_i),/REMOVE_ALL) + ' storms available for this period'
     ENDELSE

     tmpStats       = GET_DST_STATISTICS_FROM_STORMSTRUCT_V2(stormStruct,tmp_i)

     DstMinBPD      = [[DstMinBPD] ,[TRANSPOSE(tmpStats[0].BPD.data)]]
     DstDropBPD     = [[DstDropBPD],[TRANSPOSE(tmpStats[1].BPD.data)]]

     DstMinBPDList.Add ,tmpStats[0].BPD.extras
     DstDropBPDList.Add,tmpStats[1].BPD.extras

     DstMinBadBPD   = [DstMinBadBPD ,tmpStats[0].BPD.bad]
     DstDropBadBPD  = [DstDropBadBPD,tmpStats[1].BPD.bad]

     DstMinMom      = [[DstMinMom] ,[tmpStats[0].mom]]
     DstDropMom     = [[DstDropMom],[tmpStats[1].mom]]

     julTimes[*,iTime] = tmpJul

  ENDFOR

  DstStats = { $
             times     : julTimes, $
             n         : nArr, $

             min       : {BPD     : {data    : DstMinBPD, $
                                     extras  : DstMinBPDList, $
                                     bad     : DstMinBadBPD}, $
                          moment  : DstMinMom, $
                          name    : KEYWORD_SET(stormMinName) ? $
                          stormMinName  : nStormStr + ' ' + stormType + ' Storms'}, $

             drop      : {BPD     : {data    : DstDropBPD, $
                                     extras  : DstDropBPDList, $
                                     bad     : DstDropBadBPD}, $
                          moment  : DstDropMom, $
                          name    : KEYWORD_SET(stormDropName) ? $
                          stormDropName : nStormStr + ' ' + stormType + ' Storms'}, $

             totalMin  : totalMin, $
             totalDrop : totalDrop $
             }

  IF KEYWORD_SET(add_freq_stats) THEN BEGIN
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;DstFreq statistics

     IF N_ELEMENTS(DstStats.N) GE 5 THEN BEGIN
        include_BPD      = 1 
     ENDIF ELSE BEGIN
        include_BPD      = 0
     ENDELSE

     IF N_ELEMENTS(DstStats.N) EQ 0 THEN BEGIN
        include_Mom      = 0
     ENDIF ELSE BEGIN
        include_mom      = 1
     ENDELSE

     DstFreqDat          = DstStats.N/(DstStats.times[1,*]-DstStats.times[0,*])*365.25

     IF include_BPD THEN BEGIN
        DstFreqBPD       = CREATEBOXPLOTDATA(DstFreqDat, $
                                             CI_VALUES=ci_freqVals, $
                                             MEAN_VALUES=BPDFreqMean, $
                                             OUTLIER_VALUES=BPDFreqOutliers, $
                                             SUSPECTED_OUTLIER_VALUES=BPDFreqSusOutliers)
     ENDIF ELSE BEGIN
        DstFreqBPD       = MAKE_ARRAY(1,5,VALUE=0)
        DstFreqBPD[0,2]  = N_ELEMENTS(storm_i) GT 0 ? MEDIAN(DstFreqDat) : 0
        ;; BPDFreqMean   = 0
        ci_freqVals      = MAKE_ARRAY(2,VALUE=0)
        BPDFreqMean      = 0
        BPDFreqOutliers  = 0
     ENDELSE

     IF include_mom THEN BEGIN
        DstFreqMom       = MOMENT(DstFreqDat)
     ENDIF ELSE BEGIN
        DstFreqMom       = MAKE_ARRAY(4,VALUE=0)
     ENDELSE

     tmpExtra            =  {ci_values   : ci_FreqVals, $
                             mean_values : BPDFreqMean}

     CASE 1 OF
        (N_ELEMENTS(BPDFreqOutliers) GT 0) AND $
           (N_ELEMENTS(BPDFreqSusOutliers) GT 0): BEGIN
           tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                         "OUTLIER_VALUES",BPDFreqOutliers, $
                                         "SUSPECTED_OUTLIER_VALUES",BPDFreqSusOutliers)
           
        END
        (N_ELEMENTS(BPDFreqOutliers) GT 0): BEGIN
           tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                         "OUTLIER_VALUES",BPDFreqOutliers)

        END
        (N_ELEMENTS(BPDFreqSusOutliers) GT 0): BEGIN
           tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                         "SUSPECTED_OUTLIER_VALUES",BPDFreqSusOutliers)
        END
        ELSE: 
     ENDCASE

     DstFreqBPD          = {data    : DstFreqBPD, $
                            extras  : tmpExtra, $
                            bad     : 0}

     DstStats            = { $
                           times     : DstStats.times, $
                           n         : DstStats.n, $

                           min       : DstStats.min, $

                           drop      : DstStats.drop, $

                           freq      : {BPD     : DstFreqBPD, $
                                        moment  : DstFreqMom, $
                                        name    : KEYWORD_SET(stormFreqName) ? $
                                        stormFreqName : stormType + ' Storm Frequency', $
                                        units   : 'Years^-1'}, $

                           totalMin  : DstStats.totalMin, $
                           totalDrop : DstStats.totalDrop $
                           }

  ENDIF

  RETURN,DstStats
END
