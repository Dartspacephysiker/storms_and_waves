;2015/08/15
;Yes, just a redo of what we're currently calling figure 4 for the paper we hope to submit on
;stormtime Alfven activity and ion outflow

PRO JOURNAL__20150815__REDO_w_BrettNOAA__Fig4_SEA_of_upflowing_ions__Alfven_storm_GRL

  ;the outs
  date='20150815'

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'
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
  maxStr='--ion_flux_up'

  sufStr = '--24hourdiff'

  rmDupes = 1
  IF rmDupes THEN sufStr = '--rmDupes' + sufStr

  qStr='storms_quadrant'

  dstStr='--dst-centered'
  sscStr='--ssc-centered'

  ;;SSC-centered here
  superpose_storms_nevents,STORMTYPE=1,STORMINDS=q1_st,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q1_utc, $
                           /USE_DARTDB_START_ENDDATE,TBEFORESTORM=tBeforeAfterStorm,TAFTERSTORM=tBeforeAfterStorm, $
                           MAXIND=maxInd, $
                           NEVBINSIZE=nEvBinsize, NEVRANGE=nEvRange, $
                           SAVEFILE=tempOutFile, $
                           RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist

  ;ION_FLUX_UP
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=16,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=600,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[1e5,1e10], $
                                            YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)", $
                                            /USE_SYMH



END