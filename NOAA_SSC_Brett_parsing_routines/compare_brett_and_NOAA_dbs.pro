;2015/08/13
;It's time to compare how many of the storms identified by Brett Anderson's dst_stormfinder_v2.pro
;are also identified by the NOAA databases of sudden storm commencements. (See read_sudden_commencement_dbs.pro for more
;information on the latter).

PRO COMPARE_BRETT_AND_NOAA_DBS

  DBDIR = '/home/spencerh/Research/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  ;restore and sort brett's DB by time
  PRINT,"Restoring " + DB_BRETT + "..."
  restore,DBDIR+DB_BRETT
  SORT_BRETTS_DB,stormStruct

  PRINT,"Restoring " + DB_NOAA + "..."
  restore,DBDIR+DB_NOAA

  ;;********************************************
  ;; Now find out how many storms each year

  uniq_ssc2=uniq(ssc2.year)
  PRINT,FORMAT='("YEAR",T8,"N NOAA_1",T20,"N NOAA_2",T32,"N BRETT",T44,"N BRETT (LG)",T56,"N BRETT (SM)")'
  FOR i=0,N_ELEMENTS(uniq_ssc2)-1 DO BEGIN

     yr = ssc2.year(uniq_ssc2(i))

     nNOAA1 = N_ELEMENTS(WHERE(ssc1.year EQ yr,/NULL))
     nNOAA2 = N_ELEMENTS(WHERE(ssc2.year EQ yr,/NULL))
     nBrett_sm = N_ELEMENTS(WHERE((stormStruct.year EQ yr) AND $
                               ~stormStruct.is_largestorm,/NULL))
     nBrett_lg = N_ELEMENTS(WHERE((stormStruct.year EQ yr) AND $
                               stormStruct.is_largestorm,/NULL))
     nBrett = N_ELEMENTS(WHERE(stormStruct.year EQ yr,/NULL))

     PRINT,FORMAT='(I4,T8,I4,T20,I4,T32,I4,T44,I4,T56,I4)', $
           yr,nNOAA1,nNOAA2,nBrett,nBrett_lg,nBrett_sm

  ENDFOR

  ;;*********************************************************************
  ;;Now find out how many are the same (within a margin of, say, 12 hours)
  
  ;; timestamps (why?). All have fields year, month, day, hour, minute
  ts_ssc1 = TIMESTAMP(YEAR=ssc1.year, MONTH=ssc1.month, DAY=ssc1.day, HOUR=ssc1.hour, MINUTE=ssc1.minute)
  ts_ssc2 = TIMESTAMP(YEAR=ssc2.year, MONTH=ssc2.month, DAY=ssc2.day, HOUR=ssc2.hour, MINUTE=ssc2.minute)
  ts_st = TIMESTAMP(YEAR=stormStruct.year, MONTH=stormStruct.month, DAY=stormStruct.day, HOUR=stormStruct.hour, MINUTE=stormStruct.minute)
  
  ;; Julian day (rather have UTC)
  jd_ssc1 = JULDAY(ssc1.month, ssc1.day, ssc1.year, ssc1.hour, ssc1.minute)
  jd_ssc2 = JULDAY(ssc2.month, ssc2.day, ssc2.year, ssc2.hour, ssc2.minute)
  jd_st = JULDAY(stormstruct.month, stormstruct.day, stormstruct.year, stormstruct.hour, stormstruct.minute)

  ;;figure out ideal epsilon so that match doesn't give crappy doubles
  ;; eps_12 = 0.083 ;No more than 2 hours between matches in NOAA DBs
  ;; eps_brett = 1.0 ; more leeway with Brett's, since his identifies the min in DST

  ;; better, but not quite...
  ;; eps_1 = MIN(ABS(jd_ssc1-shift(jd_ssc1,1)))
  ;; eps_2 = MIN(ABS(jd_ssc2-shift(jd_ssc2,1)))
  ;; eps_brett = MIN(ABS(jd_st-shift(jd_st,1)))
  ;; eps = MIN([eps_1,eps_2,eps_brett])

  ;;think this is what's necessary
  eps = 0.8 ;;make it a day to give Brett's stuff a chance
  
  ;; Now get rid of all elements spaced more closely than the min of the epsilons
  i1_good = WHERE( ABS(jd_ssc1-shift(jd_ssc1,1)) GT eps, COMPLEMENT=i1_bad )
  i2_good = WHERE( ABS(jd_ssc2-shift(jd_ssc2,1)) GT eps, COMPLEMENT=i2_bad )
  ist_good = WHERE( ABS(jd_st-shift(jd_st,1)) GT eps, COMPLEMENT=ist_bad )

  jd_ssc1 = jd_ssc1(i1_good)
  jd_ssc2 = jd_ssc2(i2_good)
  jd_st = jd_st(ist_good)

  ;; MATCH: do ssc1 and ssc2 first
  match, jd_ssc1, jd_ssc2, i_1_to_2, i_2_to_1, COUNT=count_1_to_2, SORT=sort_1_to_2, EPSILON=eps
  match, jd_ssc1, jd_st, i_1_to_st, i_st_to_1, COUNT=count_1_to_st, SORT=sort_1_to_st, EPSILON=eps
  match, jd_ssc2, jd_st, i_2_to_st, i_st_to_2, COUNT=count_2_to_st, SORT=sort_2_to_st, EPSILON=eps

  ;;delta between NOAA/Brett matches (in days)--junk all the fakers
  diff_st_minus_ssc1 = (jd_st(i_st_to_1) - jd_ssc1(i_1_to_st))*24.
  keep1_ii = where(diff_st_minus_ssc1 GT 0) ;others are bogus because Brett's identifies DST dips AFTER storm commencement
  i_st_to_1 = i_st_to_1(keep1_ii)
  i_1_to_st = i_1_to_st(keep1_ii)

  diff_st_minus_ssc2 = (jd_st(i_st_to_2) - jd_ssc2(i_2_to_st))*24.  
  keep2_ii = where(diff_st_minus_ssc2 GT 0) ;others are bogus because Brett's identifies DST dips AFTER storm commencement
  i_st_to_2 = i_st_to_2(keep2_ii)
  i_2_to_st = i_2_to_st(keep2_ii)

  ;;duplicates in the NOAA matches?
  ui12 = uniq(i_1_to_2(sort(i_1_to_2)))
  ui1st = uniq(i_1_to_st(sort(i_1_to_st)))
  uist1 = uniq(i_st_to_1(sort(i_st_to_1)))
  ui21 = uniq(i_2_to_1(sort(i_2_to_1)))
  ui2st = uniq(i_2_to_st(sort(i_2_to_st)))
  uist2 = uniq(i_st_to_2(sort(i_st_to_2)))
  print,'Elements in i_1_to_2 (UNIQUE): ' + STRCOMPRESS(n_elements(i_1_to_2)) + '(' + STRCOMPRESS(n_elements(ui12)) + ')'
  print,'Elements in i_1_to_st (UNIQUE): ' + STRCOMPRESS(n_elements(i_1_to_st)) + '(' + STRCOMPRESS(n_elements(ui1st)) + ')'
  print,'Elements in i_st_to_1 (UNIQUE): ' + STRCOMPRESS(n_elements(i_st_to_1)) + '(' + STRCOMPRESS(n_elements(uist1)) + ')'
  print,'Elements in i_2_to_1 (UNIQUE): ' + STRCOMPRESS(n_elements(i_2_to_1)) + '(' + STRCOMPRESS(n_elements(ui21)) + ')'
  print,'Elements in i_2_to_st (UNIQUE): ' + STRCOMPRESS(n_elements(i_2_to_st)) + '(' + STRCOMPRESS(n_elements(ui2st)) + ')'
  print,'Elements in i_st_to_2 (UNIQUE): ' + STRCOMPRESS(n_elements(i_st_to_2)) + '(' + STRCOMPRESS(n_elements(uist2)) + ')'
  
  ;;match all three, and take special measures to get actual indices
  match, jd_ssc1(i_1_to_st), jd_ssc2(i_2_to_st), ii_1_all_three, ii_2_all_three, COUNT=count_all_three, SORT=sort_all_three, EPSILON=eps
  i_1_all_three = i_1_to_st(ii_1_all_three)
  i_2_all_three = i_2_to_st(ii_2_all_three)

  ui1all3 = UNIQ(i_1_all_three(SORT(i_1_all_three)))
  ui2all3 = UNIQ(i_2_all_three(SORT(i_2_all_three)))
  print,'Elements in i_1_all_three (UNIQUE): ' + STRCOMPRESS(n_elements(i_1_all_three)) + '(' + STRCOMPRESS(n_elements(ui1all3)) + ')'
  print,'Elements in i_2_all_three (UNIQUE): ' + STRCOMPRESS(n_elements(i_2_all_three)) + '(' + STRCOMPRESS(n_elements(ui1all3)) + ')'


  ;;Last, only keep uniques
  ;; i_1_to_2 = i_1_to_2(ui12)
  ;; i_1_to_st = i_1_to_st(ui1st)
  ;; i_2_to_1 = i_2_to_1(ui21)
  ;; i_2_to_st = i_2_to_st(ui2st)
  ;; i_st_to_1 = i_st_to_1(uist1)
  ;; i_st_to_2 = i_st_to_2(uist2)

  count_1_to_2 = N_ELEMENTS(i_1_to_2)
  count_1_to_st = N_ELEMENTS(i_1_to_st)
  count_2_to_st = N_ELEMENTS(i_2_to_st)

  ;;Where i_1_to_st and i_2_to_st are less than a few minutes apart, junk 'em
  match, jd_ssc1(i_1_to_2), jd_ssc2(i_2_to_1), i_1_to_2_final, i_2_to_1_final, COUNT=count_1_to_2_final, SORT=sort_1_to_2_final, EPSILON=eps

  diff_ssc1_minus_ssc2 = ABS(jd_ssc1(i_1_to_2_final) - jd_ssc2(i_2_to_1_final))*24.
  



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Report some stats on matches between DBs
  ssc1_i_where_brett_starts = (where(ssc1.year EQ stormstruct.year(0)))[0]
  ssc1_poss = STRCOMPRESS(N_ELEMENTS(ssc1.year[ssc1_i_where_brett_starts:-1]))
  ssc1_i_firstmatch = (WHERE(i_1_to_st GE ssc1_i_where_brett_starts))[0]

  ssc2_i_where_brett_starts = (where(ssc2.year EQ stormstruct.year(0)))[0]
  ssc2_poss = STRCOMPRESS(N_ELEMENTS(ssc2.year[ssc2_i_where_brett_starts:-1]))
  ssc2_i_firstmatch = (WHERE(i_2_to_st GE ssc2_i_where_brett_starts))[0]

  ;;n of matched storms that are large in Brett's DB
  i_lg_st_to_1 = WHERE(stormStruct.is_largestorm(i_st_to_1))
  i_lg_st_to_2 = WHERE(stormStruct.is_largestorm(i_st_to_2))
  n_lg_st_to_1 = N_ELEMENTS(i_lg_st_to_1)
  n_lg_st_to_2 = N_ELEMENTS(i_lg_st_to_2)

  ;;Output some of this info
  PRINT,'Matches between NOAA1 and NOAA2: ' + STRCOMPRESS(count_1_to_2)
  PRINT,''
  PRINT,'Matches between NOAA1 and Brett: ' + STRCOMPRESS(count_1_to_st) + ' (' + STRCOMPRESS(ssc1_poss) + ' >1985 in NOAA1)'
  PRINT,'"" "" NOAA1 and Brett(large): ' + STRCOMPRESS(n_lg_st_to_1)
  PRINT,''
  ;; PRINT,''' '' NOAA1(>1985) and Brett: ' + STRCOMPRESS(count_1_to_st[i_1_to_st[0]:-1]) + '(' + ssc1_poss + ' possible)'
  PRINT,'Matches between NOAA2 and Brett: ' + STRCOMPRESS(count_2_to_st) + ' (' + STRCOMPRESS(ssc2_poss) + ' >1985 in NOAA2)'
  PRINT,'"" "" NOAA2 and Brett(large): ' + STRCOMPRESS(n_lg_st_to_2)
  PRINT,''
  PRINT,'Matches between all three: ' + STRCOMPRESS(count_all_three)
  ;; PRINT,''' '' NOAA2(>1985) and Brett: ' + STRCOMPRESS(count_2_to_st[i_2_to_st[0]:-1]) + '(' + ssc2_poss + ' possible)'

  ;; PRINT,FORMAT='("YEAR",T6,"MONTH",T12,"NOAA1",T37,"NOAA2",T62,"BRETT")'
  
  ;; i1=0
  ;; i2=0
  ;; is=0
  ;; jd1_cur=jd_ssc1(0)
  ;; jd2_cur=jd_ssc2(0)
  ;; jds_cur=jd_st(0)

  ;; FOR i1=0,N_ELEMENTS(jd_ssc1) DO BEGIN

  ;;    jd1_c=jd_ssc1(i1)
  ;;    jd2_c=jd_ssc2(i2)
  ;;    jds_c=jd_st(is)
     
  ;;    IF ABS(jd1_c - jd2_c
  ;;    PRINT,FORMAT=
  ;; ENDFOR

END
