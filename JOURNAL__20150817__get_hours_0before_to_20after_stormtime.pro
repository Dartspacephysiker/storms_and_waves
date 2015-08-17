;2015/08/17 Man, there's always something else.
;I forgot to get updated inds for stormtime when making stormtime histos for Figure 4. Gotta do it here.

PRO JOURNAL__20150817__GET_HOURS_0BEFORE_TO_20AFTER_STORMTIME

  ;;some important vars
  rmDupes = 1
  timeBeforeStorm = 0.0D
  timeAfterStorm = 20.0D
  nEvBinSize=300.0D
  nEvRange=[0,15000]

  ;;the file_outs
  outDir='/SPENCEdata/Research/Cusp/'
  OUTINDSFILE = 'storms_Alfvens/saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150817.dat'

  ;;the file_ins
  dbFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  
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
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;;now plot 'em!!
  maxInd=16 ;ion_flux_up
  ;; maxStr='--ion_flux_up'

  ;;SSC-centered here
  superpose_storms_nevents,STORMTYPE=1,STORMINDS=q1_st,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q1_utc, $
                           /USE_DARTDB_START_ENDDATE,TBEFORESTORM=timeBeforeStorm,TAFTERSTORM=timeAfterStorm, $
                           MAXIND=maxInd, $
                           NEVBINSIZE=nEvBinsize, NEVRANGE=nEvRange, $
                           SAVEFILE=outDir+outIndsFile, $
                           RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist,/NOMAXPLOTS


  PRINT,'Saved ' + outDir+outIndsFile + '...'

END