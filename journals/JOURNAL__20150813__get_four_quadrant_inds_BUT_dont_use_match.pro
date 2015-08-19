;2015/08/13
;This is the completion of what I was attempting in JOURNAL__20150812__get_four_quadrant_inds...
;
; We want indices corresponding to the following four quadrants:
;----------------------------------------------------------------
;|1 Brett identifies as LARGE    |2 Brett identifies as SMALL   |
;|  are in NOAA DB               |  are in NOAA DB              |
;|-------------------------------|------------------------------|
;|3 Brett identifies as LARGE    |4 Brett identifies as SMALL   |
;|  are NOT in NOAA DB           |  are NOT in NOAA DB          |
;----------------------------------------------------------------
  ;;
;; NOTE, 'st' is an abbreviation for stormStruct, or Brett Anderson's DST storm database

PRO JOURNAL__20150813__GET_FOUR_QUADRANT_INDS_BUT_DONT_USE_MATCH

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  INDS_OUTFILE = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'
  INDS_OUTFILE = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'

  ;; some helper vars
  maxDiff = 24./24.; Brett's stuff can lead sudden commencement by 16 hours, let's say
  s2day = 1./86400.

  PRINT,"Restoring " + DB_BRETT + "..."
  restore,DBDIR+DB_BRETT

  PRINT,"Restoring " + DB_NOAA + "..."
  restore,DBDIR+DB_NOAA

  ;;**************************************************
  ;;Time things
  ;; timestamps (why?). All have fields year, month, day, hour, minute
  ;; ts_ssc1 = TIMESTAMP(YEAR=ssc1.year, MONTH=ssc1.month, DAY=ssc1.day, HOUR=ssc1.hour, MINUTE=ssc1.minute)
  ;; ts_ssc2 = TIMESTAMP(YEAR=ssc2.year, MONTH=ssc2.month, DAY=ssc2.day, HOUR=ssc2.hour, MINUTE=ssc2.minute)
  ;; ts_st = TIMESTAMP(YEAR=stormStruct.year, MONTH=stormStruct.month, DAY=stormStruct.day, HOUR=stormStruct.hour, MINUTE=stormStruct.minute)
  
  ;; Julian day (rather have UTC)
  jd_ssc1 = JULDAY(ssc1.month, ssc1.day, ssc1.year, ssc1.hour, ssc1.minute)
  jd_ssc2 = JULDAY(ssc2.month, ssc2.day, ssc2.year, ssc2.hour, ssc2.minute)
  jd_st = JULDAY(stormstruct.month, stormstruct.day, stormstruct.year, stormstruct.hour, stormstruct.minute)

  ;;Get all the times as UTC times, for crying out loud
  ;;Can't go before 1970, of course!
  utc_1=CONV_JULDAY_TO_UTC(jd_ssc1,i1_7)
  utc_2=CONV_JULDAY_TO_UTC(jd_ssc2,i2_7)
  utc_st=CONV_JULDAY_TO_UTC(jd_st,ist_7)

  ;;We're only worried about where we have FAST data
  ;;Based on 20150611 DB
  t1str='1996-10-06/16:26:02.417'
  t2str='2000-10-06/00:08:45.188'

  t1=str_to_time(t1str)
  t2=str_to_time(t2str)

  ;; alom = 'al'pha and 'om'ega
  ssc1_ii_alom = [ MIN(WHERE(utc_1 GE t1,/NULL)), MAX(WHERE(utc_1 LE t2,/NULL)) ]
  ssc2_ii_alom = [ MIN(WHERE(utc_2 GE t1,/NULL)), MAX(WHERE(utc_2 LE t2,/NULL)) ]
  st_ii_alom = [ MIN(WHERE(utc_st GE t1,/NULL)), MAX(WHERE(utc_st LE t2,/NULL)) ]

  nStorms1=ssc1_ii_alom[1]-ssc1_ii_alom[0]+1
  nStorms2=ssc2_ii_alom[1]-ssc2_ii_alom[0]+1
  nStormsST=st_ii_alom[1]-st_ii_alom[0]+1

  PRINT,"SSC1: " + STRCOMPRESS(nStorms1,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_1(ssc1_ii_alom))
  PRINT,""
  PRINT,"SSC2: " + STRCOMPRESS(nStorms2,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_2(ssc2_ii_alom))
  PRINT,""
  PRINT,"BRETT: " + STRCOMPRESS(nStormsST,/REMOVE_ALL) + " storms in this range"
  PRINT,time_to_str(utc_st(st_ii_alom))
  PRINT,""

  alom1 = [ssc1_ii_alom[0]:ssc1_ii_alom[1]]
  alom2 = [ssc2_ii_alom[0]:ssc2_ii_alom[1]]
  alomst = [st_ii_alom[0]:st_ii_alom[1]]

  utc_1 = utc_1(alom1)
  utc_2 = utc_2(alom2)
  utc_st = utc_st(alomst)

  ;;*****************************************************************************************
  ;; All right, here is where we sort Brett's storm indices out into the four quadrants given
  ;; in the comments at the top of the program

  ;;--------------------------------------------------
  ;;For quadrants 1 and 2:
  ;; Storms in NOAA DBs and Brett DB
  ;;--------------------------------------------------
  ;;For quadrants 3 and 4:
  ;; Storms in Brett's DB but not in NOAA DBs

  ;;These provide indices of storms in Brett's DB that most closely align with the corresponding SSC DB
  loc1=VALUE_CLOSEST(utc_1,utc_st,diffs1,/ONLY_GE)
  loc2=VALUE_CLOSEST(utc_2,utc_st,diffs2,/ONLY_GE)

  quad12_ii_st = WHERE(ABS(diffs1*s2day) LT maxDiff,COMPLEMENT=quad34_ii_st) ;quad34 are storms not located in NOAA DBs

  ;; Get all Brett inds...
  quad12_i_st = ist_7(alomst(quad12_ii_st))
  quad34_i_st = ist_7(alomst(quad34_ii_st))

  quad1_i_st = cgsetintersection(WHERE(stormstruct.is_largestorm),quad12_i_st)
  quad2_i_st = cgsetintersection(WHERE(~stormstruct.is_largestorm),quad12_i_st)

  quad3_i_st = cgsetintersection(WHERE(stormstruct.is_largestorm),quad34_i_st)
  quad4_i_st = cgsetintersection(WHERE(~stormstruct.is_largestorm),quad34_i_st)

  ;;Good! Now do NOAA!
  ;;Gotta junk NaNs, since that's what VALUE_CLOSEST assigns to diff values if it can't get index in vector GT val
  ;; st1 = WHERE(FINITE(diffs1))
  ;; st2 = WHERE(FINITE(diffs2))

  ;; loc1 = loc1(st1)
  ;; diffs1 = diffs1(st1)
  ;; loc2 = loc2(st2)
  ;; diffs2 = diffs2(st2)

  quad12_ii_1 = loc1(quad12_ii_st)
  ;; quad34_ii_st = loc1(quad34_j_st) ;These are bogus by definition: we can't index into storms in the NOAA db that are too far
  ;;from Brett's storms to qualify. Quadrants 3 and 4 are all storms that are NOT found in the NOAA db!

  ;; In NOAA DB, get two quadrants (1 and 2) where NOAA aligns with Brett...
  quad1_ii_st = cgsetintersection(WHERE(stormstruct.is_largestorm(ist_7(alomst))),quad12_ii_st)
  quad2_ii_st = cgsetintersection(WHERE(~stormstruct.is_largestorm(ist_7(alomst))),quad12_ii_st)

  quad1_ii_1 = loc1(quad1_ii_st)
  quad2_ii_1 = loc1(quad2_ii_st)
  
  ;; Get all NOAA inds...
  quad1_i_1 = i1_7(alom1(quad1_ii_1))
  quad2_i_1 = i1_7(alom1(quad2_ii_1))

  ;;And here's how you know whether or not is was succesfull...
  ;;All values should be positive, since Brett identifies minimum DST and sudden commencement must occur before the minimum DST value.
  ;; print,jd_st(quad1_i_st)-jd_ssc1(quad1_i_1)

  ;;Really should check for dupes here
  check_dupes,quad12_ii_st ;First Brett dupes, Q 1-2
  check_dupes,quad12_ii_1  ;Now NOAA dupes, Q 1-2
  check_dupes,quad34_ii_st ;Now only Brett dupes, Q 3-4

  ;; Are these identical?
  IF ARRAY_EQUAL(utc_1(loc1),utc_2(loc2)) THEN BEGIN
     do_loc_st = 1
     PRINT,"NOAA DBs give the same answer to Brett. No difference..."
  ENDIF ELSE BEGIN
     do_loc_st = 0
     PRINT,"NOAA DBs don't give the same answer to Brett's storm DB! Better investigate..."
  ENDELSE
     
  IF do_loc_st THEN BEGIN

     ;;These provide indexes of the appropriate SSC DB that most closely align with Brett's DB
     loc_st1 = VALUE_CLOSEST(utc_st,utc_1,diffs_st1,/ONLY_LE)
     loc_st2 = VALUE_CLOSEST(utc_st,utc_2,diffs_st2,/ONLY_LE)

     ;; Get quad5 inds...
     quad5_ii_1 = WHERE(ABS(diffs_st1*s2day) GT maxDiff) ;q5 are storms not located in Brett's DB
     quad5_ii_2 = WHERE(ABS(diffs_st2*s2day) GT maxDiff)

     ;;Convert back to inds for original ssc struct
     quad5_i_1 = i1_7(alom1(quad5_ii_1))
     quad5_i_2 = i2_7(alom2(quad5_ii_2))

     IF array_equal(loc_st1,loc_st2) THEN do_loc_st = 1 ELSE do_loc_st = 0

  ENDIF
  
  ;;Now get the struct ready
  qi_st_l = LIST(quad1_i_st)
  qi_st_l.add,quad2_i_st
  qi_st_l.add,quad3_i_st
  qi_st_l.add,quad4_i_st

  IF do_loc_st THEN BEGIN 

     qi_NOAA_l = LIST(quad1_i_1)
     qi_NOAA_l.add,quad2_i_1
     qi_NOAA_l.add,quad5_i_1
     qi_NOAA = {qi_SSC, $
                NAME:'qi_NOAA', $
                GENERATING_FILE:'journal__20150813__get_four_quadrant_inds_but_dont_use_match.pro', $
                GIT_DB:'storms_and_waves', $
                USE_WITH_DB:DB_NOAA, $
                list_i:qi_NOAA_l, $
                qi_info:"Structure for NOAA database of storm sudden commencements" + string(10B) + $
                'Q1: Brett identifies as LARGE storm, and sudden commencement appears in NOAA SSC DB' + string(10B) + $
                'Q2: Brett identifies as SMALL storm, and sudden commencement appears in NOAA SSC DB' + string(10B) + $
                'Q5: Identified in NOAA db, but not identified in Brett DB' + string(10B) + $
                'See comments at top of generating file for description of the four quadrants these indices represent.'}

  ENDIF
  qi_st = {qi_SSC, $
           NAME:'qi_st', $
           GENERATING_FILE:'journal__20150813__get_four_quadrant_inds_but_dont_use_match.pro', $
           GIT_DB:'storms_and_waves', $
           USE_WITH_DB:DB_BRETT, $
           list_i:qi_st_l, $
           qi_info:"Structure for Brett's storm database"+ string(10B) + $
           'Q1: Brett identifies as LARGE storm, and sudden commencement appears in NOAA SSC DB' + string(10B) + $
           'Q2: Brett identifies as SMALL storm, and sudden commencement appears in NOAA SSC DB' + string(10B) + $
           'Q3: Brett identifies as LARGE storm, and sudden commencement DOES NOT appear in NOAA SSC DB' + string(10B) + $
           'Q4: Brett identifies as SMALL storm, and sudden commencement DOES NOT appear in NOAA SSC DB' + string(10B) + $
           'See comments at top of generating file for description of the four quadrants these indices represent.'}
              
  qi = [qi_st,qi_NOAA]


  saveStr='save' 
  ;; saveStr +=',qi_st'
  ;; IF do_loc_st THEN saveStr += ',qi_NOAA'
  saveStr +=',qi'
  saveStr += ',filename=' + '"'+INDS_OUTFILE+'"'
  print,'Saving to file ' + INDS_OUTFILE + '...'
  biz = EXECUTE(saveStr)

END


