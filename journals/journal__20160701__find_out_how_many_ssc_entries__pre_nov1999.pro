PRO JOURNAL__20160701__FIND_OUT_HOW_MANY_SSC_ENTRIES__PRE_NOV1999

  dataDir    = '/SPENCEdata/Research/database'
  ;; dbFile  = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  indFile    = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'
  SSCFile    = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'
  stormFile  = 'large_and_small_storms--1985-2011--Anderson.sav'

  ;; ;All those storms
  RESTORE,dataDir+'/storm_data/' + indFile

  RESTORE,dataDir+'/storm_data/' + SSCFile
  RESTORE,dataDir+'/storm_data/' + stormFile

  PRINT,ssc1.tstamp[870]
  ;; 1996-11-11T15:27:00Z

  PRINT,ssc1.tstamp[965]
  ;; 1999-11-05T20:10:00Z

END