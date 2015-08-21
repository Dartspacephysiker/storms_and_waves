;2015/08/20
;Not all four storms from Yao et al. [2000] are in the combined NOAA/Brett DB.
;Brett DB shows all four!
;NOAA DB only shows storms 2. and 4.

;These storms took place, according to Yao et al. [2000],
;1. '11-15 Feb, 2000'
;2. '06-09 Apr, 2000'
;3. '24-26 May, 2000'
;4. '17-20 Sep, 2000'

;;Min DST times of those in Brett DB
;1. 2000-02-12T11:00:00Z
;2. 2000-04-07T00:00:00Z
;3. 2000-05-24T08:00:00Z
;4. 2000-09-17T23:00:00Z

;;SSCs of those existing in SSC DB
;1. 2000-02-11T23:52:00Z
;2. 
;3. 2000-05-23T17:02:00Z
;4. 
PRO JOURNAL__20150820__find_out_if_all_four_storms_are_in_our_NOAABrett_DB

  dataDir='/SPENCEdata/Research/Cusp/database'
  ;; dbFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  indFile = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'
  SSCFile = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'
  stormFile = 'large_and_small_storms--1985-2011--Anderson.sav'

  ;; ;All those storms
  restore,dataDir+'/sw_omnidata/' + indFile

  restore,dataDir+'/sw_omnidata/' + SSCFile
  restore,dataDir+'/sw_omnidata/' + stormFile

  ;; 'st' is for 'stormStruct', Brett's DB of storms
  ;; '1' is for 
  q1_st=qi[0].list_i[0]
  q2_st=qi[0].list_i[1]
  q3_st=qi[0].list_i[2]
  q4_st=qi[0].list_i[3]

  q1_1=qi[1].list_i[0]
  q2_1=qi[1].list_i[1]
  q5_1=qi[1].list_i[2]

  ;;SSC times
  print,ssc1.tstamp

  ;;Dst min times
  print,stormStruct.tstamp

  ;;SSC times for the two in Brett/NOAA db
  print,ssc1.tstamp(q1_1)

  ;;DST min times for the two in Brett/NOAA db
  print,stormstruct.tstamp(q1_st)

END