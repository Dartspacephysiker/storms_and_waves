;2015/08/12
; We want indices corresponding to the following four quadrants:
;----------------------------------------------------------------
;|1 Brett identifies as LARGE    |2 Brett identifies as SMALL   |
;|  are in NOAA DB               |  are in NOAA DB              |
;|-------------------------------|------------------------------|
;|3 Brett identifies as LARGE    |4 Brett identifies as SMALL   |
;|  are NOT in NOAA DB           |  are NOT in NOAA DB          |
;----------------------------------------------------------------
;
; K?
;
; 2015/08/13
; NOTE: This journal has some issues. I ended up pursuing a totally different method, which you can
; find in JOURNAL__20150813__GET_FOUR_QUADRANT_INDS_BUT_DONT_USE_MATCH.

PRO JOURNAL__20150812__get_four_quadrant_inds_for_NOAA_and_Brett_DBS

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  ;restore and sort brett's DB by time
  PRINT,"Restoring " + DB_BRETT + "..."
  restore,DBDIR+DB_BRETT
  SORT_BRETTS_DB,stormStruct,jd_st

  PRINT,"Restoring " + DB_NOAA + "..."
  restore,DBDIR+DB_NOAA
  SORT_NOAA_SSC_DB,ssc1,jd_ssc1
  SORT_NOAA_SSC_DB,ssc2,jd_ssc2

  ;;**************************************************
  ;;Time things
  ;; timestamps (why?). All have fields year, month, day, hour, minute
  ts_ssc1 = TIMESTAMP(YEAR=ssc1.year, MONTH=ssc1.month, DAY=ssc1.day, HOUR=ssc1.hour, MINUTE=ssc1.minute)
  ts_ssc2 = TIMESTAMP(YEAR=ssc2.year, MONTH=ssc2.month, DAY=ssc2.day, HOUR=ssc2.hour, MINUTE=ssc2.minute)
  ts_st = TIMESTAMP(YEAR=stormStruct.year, MONTH=stormStruct.month, DAY=stormStruct.day, HOUR=stormStruct.hour, MINUTE=stormStruct.minute)
  
  ;; Julian day (rather have UTC)
  ;; jd_ssc1 = JULDAY(ssc1.month, ssc1.day, ssc1.year, ssc1.hour, ssc1.minute)
  ;; jd_ssc2 = JULDAY(ssc2.month, ssc2.day, ssc2.year, ssc2.hour, ssc2.minute)
  ;; jd_st = JULDAY(stormstruct.month, stormstruct.day, stormstruct.year, stormstruct.hour, stormstruct.minute)

  ;;Get all the times as UTC times, for crying out loud
  ;;Can't go before 1970, of course!
  utc_1=CONV_JULDAY_TO_UTC(jd_ssc1,i1_7)
  utc_2=CONV_JULDAY_TO_UTC(jd_ssc2,i2_7)
  utc_st=CONV_JULDAY_TO_UTC(jd_st,ist_7)

  jd_ssc1_7 = jd_ssc1(i1_7) 
  jd_ssc2_7 = jd_ssc2(i2_7) 
  jd_st_7 = jd_st(ist_7) 
  
  ts_ssc1_7 = ts_ssc1(i1_7) 
  ts_ssc2_7 = ts_ssc2(i2_7) 
  ts_st_7 = ts_st(ist_7) 
 
  ;;We're only worried about where we have FAST data
  ;;Based on 20150611 DB
  t1str='1996-10-06/16:26:02.417'
  t2str='2000-10-06/00:08:45.188'

  t1=str_to_time(t1str)
  t2=str_to_time(t2str)

  ssc1_ii_alom = [ MIN(WHERE(utc_1 GE t1,/NULL)), MAX(WHERE(utc_1 LE t2,/NULL)) ]
  ssc2_ii_alom = [ MIN(WHERE(utc_2 GE t1,/NULL)), MAX(WHERE(utc_2 LE t2,/NULL)) ]
  st_ii_alom = [ MIN(WHERE(utc_st GE t1,/NULL)), MAX(WHERE(utc_st LE t2,/NULL)) ]

  PRINT,"SSC1: " + STRCOMPRESS(ssc1_ii_alom[1]-ssc1_ii_alom[0]+1,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_1(ssc1_ii_alom))
  PRINT,""
  PRINT,"SSC2: " + STRCOMPRESS(ssc2_ii_alom[1]-ssc2_ii_alom[0]+1,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_2(ssc2_ii_alom))
  PRINT,""
  PRINT,"BRETT: " + STRCOMPRESS(st_ii_alom[1]-st_ii_alom[0]+1,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_st(st_ii_alom))
  PRINT,""

  PRINT,"BRETT: " + STRCOMPRESS(N_ELEMENTS(cgsetintersection(WHERE(stormStruct.is_largeStorm(ist_7)),[st_ii_alom[0]:st_ii_alom[1]]))) + " large storms in this range"
  PRINT,"BRETT: " + STRCOMPRESS(N_ELEMENTS(cgsetintersection(WHERE(~stormStruct.is_largeStorm(ist_7)),[st_ii_alom[0]:st_ii_alom[1]]))) + " small storms in this range"

  utc_1 = utc_1(ssc1_ii_alom[0]:ssc1_ii_alom[1])
  utc_2 = utc_2(ssc2_ii_alom[0]:ssc2_ii_alom[1])
  utc_st = utc_st(st_ii_alom[0]:st_ii_alom[1])

  ;; ts_ssc1 = ts_ssc1(ssc1_ii_alom[0]:ssc1_ii_alom[1])
  ;; ts_ssc2 = ts_ssc2(ssc2_ii_alom[0]:ssc2_ii_alom[1])
  ;; ts_st = ts_st(st_ii_alom[0]:st_ii_alom[1])

  ;; jd_ssc1 = jd_ssc1(ssc1_ii_alom[0]:ssc1_ii_alom[1])
  ;; jd_ssc2 = jd_ssc2(ssc2_ii_alom[0]:ssc2_ii_alom[1])
  ;; jd_st = jd_st(st_ii_alom[0]:st_ii_alom[1])

  ;;--------------------------------------------------
  ;;For quadrants 1 and 2:
  ;;Let's get where Brett and NOAA and Brett line up
  eps = 0.875 ;;make it a day to give Brett's stuff a chance

  ;;First just match the two NOAA DBs with Brett
  match, utc_1, utc_st, ii_1_to_st, ii_st_to_1, COUNT=count_1_to_st, SORT=sort_1_to_st, EPSILON=eps
  match, utc_2, utc_st, ii_2_to_st, ii_st_to_2, COUNT=count_2_to_st, SORT=sort_2_to_st, EPSILON=eps

  ;;delta between NOAA/Brett matches (in days)--junk all the fakers
  diff_st_minus_ssc1 = (jd_st(ii_st_to_1) - jd_ssc1(ii_1_to_st))*24.
  keep1_iii = where(diff_st_minus_ssc1 GT 0) ;others are bogus because Brett's identifies DST dips AFTER storm commencement
  ii_st_to_1 = ii_st_to_1(keep1_iii)
  ii_1_to_st = ii_1_to_st(keep1_iii)

  diff_st_minus_ssc2 = (jd_st(ii_st_to_2) - jd_ssc2(ii_2_to_st))*24.  
  keep2_iii = where(diff_st_minus_ssc2 GT 0) ;others are bogus because Brett's identifies DST dips AFTER storm commencement
  ii_st_to_2 = ii_st_to_2(keep2_iii)
  ii_2_to_st = ii_2_to_st(keep2_iii)
  
  ;; where are the dupes?
  ;; utc=utc_1 & this=ii_1_to_st & check_sorted,utc(this) & check_dupes,utc(this),rev_ind,dupe_i & print,time_to_str((utc(this))(rev_ind[dupe_i[0]:dupe_i[1]-1]))
  check_dupes,utc_1(ii_1_to_st),ri_1,dupes1,dataenum1
  check_dupes,utc_2(ii_2_to_st),ri_2,dupes2,dataenum2
  
  ;;UTC_1 dupes
  IF N_ELEMENTS(dupes1) GT 0 THEN BEGIN
     print,'i = ' + strcompress(0,/REMOVE_ALL)
     print,'NOAA SSC1 DUPES: ' + time_to_str((utc_1[ii_1_to_st])(ri_1[ ri_1[ dupes1[0]] : ri_1[dupes1[0] + 1 ] - 1 ] ))
     print,'Brett times: ' + time_to_str((utc_st[ii_st_to_1])(ri_1[ ri_1[ dupes1[0]] : ri_1[dupes1[0] + 1 ] - 1 ] ))
     print,''
  ENDIF
  ;;
  ;;UTC_2 dupes
  IF N_ELEMENTS(dupes1) GT 0 THEN BEGIN
     print,'i = ' + strcompress(0,/REMOVE_ALL)
     print,'NOAA SSC2 DUPES: ' + time_to_str((utc_2[ii_2_to_st])(ri_2[ ri_2[ dupes2[0]] : ri_2[dupes2[0] + 1 ] - 1 ] ))
     print,'Brett times: ' + time_to_str((utc_st[ii_st_to_2])(ri_2[ ri_2[ dupes2[0]] : ri_2[dupes2[0] + 1 ] - 1 ] ))
     print,''
  ENDIF

  ;;Make a struct that has members 
  n_ssc1=N_ELEMENTS(utc_1)
  n_ssc2=N_ELEMENTS(utc_2)
  n_st=N_ELEMENTS(utc_st)

  i1_final = i1_7(ii_1_to_st)
  i2_final = i2_7(ii_2_to_st)
  ist_1_final = ist_7(ii_st_to_1)
  ist_2_final = ist_7(ii_st_to_2)

  ;; keepStruct1 = {keepStruct,keep=MAKE_ARRAY(n_ssc1,VALUE=1), $
  ;; keep1 = 
  ;;Now loop through and see which of the "matching" ssc1 and ssc2 storms are closest to the given
  ;;brett storm
  ;; for the one that is less close, do keepstructi.keep[ind_for_less_close_guy]=0

  ;;ultimately, tstamps will be utc_ultimate=[utc_1(WHERE(keepstruct1.keep)),utc_2(WHERE(keepstruct2.keep))]
  ;;utc_ultimate=utc_ultimate(SORT(utc_ultimate))

END


