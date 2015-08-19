;2015/08/15
;Yes, just a redo of what we're currently calling figure 4 for the paper we hope to submit on
;stormtime Alfven activity and ion outflow

PRO JOURNAL__20150815__REDO_w_BrettNOAA__Fig4_SEA_of_upflowing_ions__Alfven_storm_GRL

  ;; ;the ins
  nEvBinsize=300.D
  ;; ;

  ;; ;the outs
  date='20150818'

  outMaxFile='Fig_4--ion_flux_up--no_restriction_on_chare_or_alt--5-HOUR_AVG--proper_storm_commencement_smaller.png'

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

  ;ION_FLUX_UP
  superpose_storms_nevents,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc,/OVERPLOT_HIST,/NEVENTHISTS,REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE, $
                           TBEFORESTORM=60.0D,TAFTERSTORM=60.0D, $
                           NEVBINSIZE=nEvBinsize, $
                           MAXIND=maxInd, $
                           AVG_TYPE_MAXIND=1, $
                           SAVEMAXPLOTNAME=outMaxFile, $
                           /LOG_DBQUANTITY, /NEG_AND_POS_SEPAR, $
                           YRANGE_MAXIND=[1e5,1e10], $
                           YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)"


END