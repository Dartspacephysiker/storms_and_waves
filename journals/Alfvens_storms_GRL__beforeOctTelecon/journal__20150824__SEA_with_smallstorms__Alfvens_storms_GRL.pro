
PRO JOURNAL__20150824__SEA_with_smallstorms__Alfvens_storms_GRL

  ;the ins
  ;; nRandTimes = 40
  nIterations = 1 
  nStorms = 40. ; I know because I've seen the outcome...
  nEvRange=[0,12000]
  nEvBinsize=300.D

  ;the outs
  date='20150824'
  outFile = 'Fig_2--SYMH_plus_nEventHistos--small_storms--'+date+'.png'
  scPlotPref = 'Fig_2--scatterplots--small_storms--'+date

  tempOutFile = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/superposed_small_storm_output_w_n_Alfven_events--'+date+'.dat'

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  INDS_FILE = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'

  PRINT,"Restoring " + DB_BRETT + "..."
  RESTORE,DBDIR+DB_BRETT

  PRINT,"Restoring " + DB_NOAA + "..."
  RESTORE,DBDIR+DB_NOAA

  RESTORE,DBDIR+INDS_FILE

  ;;these qi structs get restored with the inds file
  q2_st=qi[0].list_i[1]
  q2_1=qi[1].list_i[1]
  
  q2_utc=conv_julday_to_utc(ssc1.julday[q2_1])

END