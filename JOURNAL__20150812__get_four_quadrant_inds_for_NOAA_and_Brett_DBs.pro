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

PRO JOURNAL__20150812__get_four_quadrant_inds_for_NOAA_and_Brett_DBS

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  ;restore and sort brett's DB by time
  PRINT,"Restoring " + DB_BRETT + "..."
  restore,DBDIR+DB_BRETT
  SORT_BRETTS_DB,stormStruct

  PRINT,"Restoring " + DB_NOAA + "..."
  restore,DBDIR+DB_NOAA

  ;;**************************************************
  ;;Time things
  ;; timestamps (why?). All have fields year, month, day, hour, minute
  ts_ssc1 = TIMESTAMP(YEAR=ssc1.year, MONTH=ssc1.month, DAY=ssc1.day, HOUR=ssc1.hour, MINUTE=ssc1.minute)
  ts_ssc2 = TIMESTAMP(YEAR=ssc2.year, MONTH=ssc2.month, DAY=ssc2.day, HOUR=ssc2.hour, MINUTE=ssc2.minute)
  ts_st = TIMESTAMP(YEAR=stormStruct.year, MONTH=stormStruct.month, DAY=stormStruct.day, HOUR=stormStruct.hour, MINUTE=stormStruct.minute)
  
  ;; Julian day (rather have UTC)
  jd_ssc1 = JULDAY(ssc1.month, ssc1.day, ssc1.year, ssc1.hour, ssc1.minute)
  jd_ssc2 = JULDAY(ssc2.month, ssc2.day, ssc2.year, ssc2.hour, ssc2.minute)
  jd_st = JULDAY(stormstruct.month, stormstruct.day, stormstruct.year, stormstruct.hour, stormstruct.minute)

  ;;Get all the times as UTC times, for crying out loud
  ;;Can't go before 1970, of course!
  utc_1=CONV_JULDAY_TO_UTC(jd_ssc1,i1_7)
  utc_2=CONV_JULDAY_TO_UTC(jd_ssc2,i2_7)
  utc_st=CONV_JULDAY_TO_UTC(jd_st,ist_7)

  jd_ssc1 = jd_ssc1(i1_7) 
  jd_ssc2 = jd_ssc2(i2_7) 
  jd_st = jd_st(ist_7) 
  
  ts_ssc1 = ts_ssc1(i1_7) 
  ts_ssc2 = ts_ssc2(i2_7) 
  ts_st = ts_st(ist_7) 
  ;;We're only worried about where we have FAST data
  ;;Based on 20150611 DB
  t1str='1996-10-06/16:26:02.417'
  t2str='2000-10-06/00:08:45.188'

  t1=str_to_time(t1str)
  t2=str_to_time(t2str)

  ssc1_i_alom = [ MIN(WHERE(utc_1 GE t1,/NULL)), MAX(WHERE(utc_1 LE t2,/NULL)) ]
  ssc2_i_alom = [ MIN(WHERE(utc_2 GE t1,/NULL)), MAX(WHERE(utc_2 LE t2,/NULL)) ]
  st_i_alom = [ MIN(WHERE(utc_st GE t1,/NULL)), MAX(WHERE(utc_st LE t2,/NULL)) ]

  PRINT,time_to_str(utc_1(ssc1_i_alom))
  PRINT,time_to_str(utc_2(ssc2_i_alom))
  PRINT,time_to_str(utc_st(st_i_alom))

  ;;--------------------------------------------------
  ;;For quadrants 1 and 2:
  ;;Let's get where Brett and NOAA and Brett line up
  eps = 0.875 ;;make it a day to give Brett's stuff a chance

  ;;First just match the two NOAA DBs with Brett
  match, jd_ssc1, jd_st, i_1_to_st, i_st_to_1, COUNT=count_1_to_st, SORT=sort_1_to_st, EPSILON=eps
  match, jd_ssc2, jd_st, i_2_to_st, i_st_to_2, COUNT=count_2_to_st, SORT=sort_2_to_st, EPSILON=eps

  ;; do I need to do this?
  ;; Now get rid of all elements spaced more closely than the min of the epsilons
  i1_good = WHERE( ABS(jd_ssc1-shift(jd_ssc1,1)) GT eps, COMPLEMENT=i1_bad )
  i2_good = WHERE( ABS(jd_ssc2-shift(jd_ssc2,1)) GT eps, COMPLEMENT=i2_bad )
  ist_good = WHERE( ABS(jd_st-shift(jd_st,1)) GT eps, COMPLEMENT=ist_bad )


  ;;Make a struct that has members 
  n_ssc1=N_ELEMENTS(utc_1)
  n_ssc2=N_ELEMENTS(utc_2)
  n_st=N_ELEMENTS(utc_st)

  keepStruct1 = {keepStruct,keep=MAKE_ARRAY(n_ssc1,VALUE=1), $
                 ...

  ;;Now loop through and see which of the "matching" ssc1 and ssc2 storms are closest to the given
  ;;brett storm
  ;; for the one that is less close, do keepstructi.keep[ind_for_less_close_guy]=0

  ;;ultimately, tstamps will be utc_ultimate=[utc_1(WHERE(keepstruct1.keep)),utc_2(WHERE(keepstruct2.keep))]
  ;;utc_ultimate=utc_ultimate(SORT(utc_ultimate))

END


