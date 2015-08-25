;2015/08/24
;An extension of JOURNAL__20150815__REDO_w_BrettNOAA__Fig4_SEA_of_upflowing_ions__Alfven_storm_GRL.pro
;The difference is that now I'm going to overlay a background upflowing ion plot.

PRO JOURNAL__20150824__REDO_W_BRETTNOAA__FIG4_SEA_OF_UPFLOWING_IONS__BACKGROUND_OVERLAID__ALFVEN_STORM_GRL

  ;; ;the ins
 nEvBinsize=600.D
  ;; ;

  ;; ;the outs
  ;; date='20150824'
  date='20150825'

  outMaxFile='Fig_4--ion_flux_up--'+ STRING(FORMAT='(F0.1)',nEvBinsize/60) + $
             '-HOUR_AVG.png'

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

  rmDupes = 1

  ;get random ion_flux_up
  superpose_storms_nevents,RANDOMTIMES=40,/NOPLOTS,/NOMAXPLOTS,OUT_BKGRND_MAXIND=bkgrnd_maxInd,OUT_TBINS=tBins,/USE_DARTDB_START_ENDDATE, $
                           MAXIND=maxInd,NEVBINSIZE=nEvBinsize,TBEFORESTORM=60.0D,TAFTERSTORM=60.0D,AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY

  ;ION_FLUX_UP
  superpose_storms_nevents,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc,REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE, $
                           TBEFORESTORM=60.0D,TAFTERSTORM=60.0D, $
                           NEVBINSIZE=nEvBinsize, $
                           MAXIND=maxInd, $
                           AVG_TYPE_MAXIND=1, $
                           BKGRND_MAXIND=bkgrnd_maxInd, TBINS=tBins, $
                           SAVEMAXPLOTNAME=outMaxFile, $
                           /LOG_DBQUANTITY, $
                           YRANGE_MAXIND=[1e5,1e10], $
                           YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)"


END