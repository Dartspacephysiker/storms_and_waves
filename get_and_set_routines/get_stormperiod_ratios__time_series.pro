;2016/08/24
FUNCTION GET_STORMPERIOD_RATIOS__TIME_SERIES,Dst, $
   INCLUDE_STATISTICS=include_statistics, $
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
   VERBOSE=verbose

  COMPILE_OPT idl2

  deltaMin       = 0.00069444444444444447D ;;The length of 1 min in units of days

  include_stats  = N_ELEMENTS(include_statistics) GT 0 ? include_statistics :  1

  IF N_ELEMENTS(Dst) EQ 0 THEN BEGIN
     LOAD_DST_AE_DBS,Dst,ae,LUN=lun, $
                     DST_AE_DIR=Dst_AE_dir, $
                     DST_AE_FILE=Dst_AE_file, $
                     FULL_DST_DB=full_Dst_DB
  ENDIF

  IF KEYWORD_SET(t1_UTC) AND KEYWORD_SET(t2_UTC) THEN BEGIN
     ;; earliest_UTC        = t1_UTC
     ;; latest_UTC          = t2_UTC
     earliest_julDay        = UTC_TO_JULDAY(t1_UTC)
     latest_julDay          = UTC_TO_JULDAY(t2_UTC)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(t1_julDay) AND KEYWORD_SET(t2_julDay) THEN BEGIN
        earliest_julDay     = t1_julDay
        latest_julDay       = t2_julDay
     ENDIF ELSE BEGIN
        PRINT,'No input time provided! Assuming I should just do them all ...'
        calc_all_times      = 1
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(calc_all_times) THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(full_Dst_DB): BEGIN
           earliest_julDay  = Dst.julDay[0]
           latest_julDay    = Dst.julDay[-1]
        END
        ELSE: BEGIN
           ;; earliest_UTC  = Dst.time[0]
           ;; latest_UTC    = Dst.time[-1]
           earliest_julDay  = UTC_TO_JULDAY(Dst.time[0])
           latest_julDay    = UTC_TO_JULDAY(Dst.time[-1])
        END
     ENDCASE
  ENDIF

  ;;Now handle times
  timeArr    = TIMEGEN_EASIER(earliest_julDay,latest_julDay, $
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
  nDays      = (SHIFT(timeArr,-1)-timeArr)[0:-2]
  nSPArr     = MAKE_ARRAY(nIntervals,/INTEGER)
  nNSArr     = MAKE_ARRAY(nIntervals,/INTEGER)
  nMPArr     = MAKE_ARRAY(nIntervals,/INTEGER)
  nRPArr     = MAKE_ARRAY(nIntervals,/INTEGER)
  nTotArr    = MAKE_ARRAY(nIntervals,/INTEGER)
  nMissedArr = MAKE_ARRAY(nIntervals,/INTEGER,VALUE=0)
  finalJul   = MAKE_ARRAY(2,nIntervals,/DOUBLE)

  nsRatArr   = MAKE_ARRAY(nIntervals,/FLOAT)
  spRatArr   = MAKE_ARRAY(nIntervals,/FLOAT)
  mpRatArr   = MAKE_ARRAY(nIntervals,/FLOAT)
  rpRatArr   = MAKE_ARRAY(nIntervals,/FLOAT)

  ;;Now get time series
  FOR iTime=0,nIntervals-1 DO BEGIN
     tmpJul  = [timeArr[iTime],timeArr[iTime+1]-deltaMin]
     finalJul[*,iTime] = tmpJul

     IF KEYWORD_SET(verbose) THEN BEGIN
        CALDAT,tmpJul[0],month1,day1,year1,hour1,min1
        CALDAT,tmpJul[1],month2,day2,year2,hour2,min2

        PRINT,'iTime: ' + STRCOMPRESS(iTime,/REMOVE_ALL)
        PRINT,FORMAT='("[START, STOP] : [",A0,", ",A0,"]")', $
              TIMESTAMP(MONTH=month1,DAY=day1,YEAR=year1,HOUR=hour1,MIN=min1), $
              TIMESTAMP(MONTH=month2,DAY=day2,YEAR=year2,HOUR=hour2,MIN=min2)
     ENDIF
     GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
        DSTCUTOFF=DstCutoff, $
        ;; EARLIEST_UTC=earliest_UTC, $
        ;; LATEST_UTC=latest_UTC, $
        /USE_JULDAY_NOT_UTC, $
        EARLIEST_JULDAY=tmpJul[0], $
        LATEST_JULDAY=tmpJul[1], $
        STORM_DST_I=s_dst_i, $
        NONSTORM_DST_I=ns_dst_i, $
        MAINPHASE_DST_I=mp_dst_i, $
        RECOVERYPHASE_DST_I=rp_dst_i, $
        N_STORM=n_s, $
        N_NONSTORM=n_ns, $
        N_MAINPHASE=n_mp, $
        N_RECOVERYPHASE=n_rp, $
        QUIET=~KEYWORD_SET(verbose), $
        LUN=lun

     nSPArr[iTime]     = n_s
     nNSArr[iTime]     = n_ns
     nMPArr[iTime]     = n_mp
     nRPArr[iTime]     = n_rp
     nTotArr[iTime]    = n_ns+n_mp+n_rp
     ;; nMissedArr[iTime] = 

  ENDFOR

  nz_i       = WHERE(nTotArr GT 0,n_nz)
  IF n_nz EQ 0 THEN BEGIN
     PRINT,"You're hosed! Everything is zero!"
     STOP
  ENDIF

  ;;Calculate ratios of each storm phase
  nsRatArr[nz_i] = FLOAT(nNSArr[nz_i])/nTotArr[nz_i]
  spRatArr[nz_i] = FLOAT(nSPArr[nz_i])/nTotArr[nz_i]
  mpRatArr[nz_i] = FLOAT(nMPArr[nz_i])/nTotArr[nz_i]
  rpRatArr[nz_i] = FLOAT(nRPArr[nz_i])/nTotArr[nz_i]

  ;;Make the final struct
  stormRatStruct = {times      :finalJul, $
                    nIntervals : nIntervals, $    
                    nDays      : nDays, $
                    n_SP       : nSPArr, $    
                    n_NS       : nNSArr, $ 
                    n_MP       : nMPArr, $ 
                    n_RP       : nRPArr, $ 
                    n_tot      : nTotArr, $ 
                    nsRatio    : nsRatArr, $
                    spRatio    : spRatArr, $
                    mpRatio    : mpRatArr, $
                    rpRatio    : rpRatArr, $
                    nMissedArr : nMissedArr $ ;, $
                    ;; stats      : {BPD     : {data    : StormRatBPD, $
                    ;;                          extras  : StormRatBPDList, $
                    ;;                          bad     : StormRatBadBPD}, $
                    ;;               moment  : StormRatMom, $
                    ;;               name    : KEYWORD_SET(stormRatNames) ? $
                    ;;               stormRatNames : ['Quiescent','Main','Recovery']} $
                   }

  IF KEYWORD_SET(include_stats) THEN BEGIN
     stats       = GET_STORMRATIO_STATISTICS_FROM_STORMRATIOSTRUCT(stormRatStruct, $
                                                                   /ADD_TO_STRUCT)
  ENDIF

  RETURN,stormRatStruct

END