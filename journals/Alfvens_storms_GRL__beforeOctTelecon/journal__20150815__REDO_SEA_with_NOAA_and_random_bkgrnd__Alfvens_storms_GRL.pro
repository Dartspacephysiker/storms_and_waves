;2015/08/15
;Holy mackerel, it's Saturday and I simply cannot work fast enough. I have a draft of this paper due to Chris Chaston by end of
;day, and I've been piddling with code for nearly seven hours. Whatever—it's gots to be done.

;So if you want to make the plot that I'm calling 'final,' just run this thing, move the legend in the final SEA window to an
;appropriate place, then click the disk to save. The saving is not automated.

PRO JOURNAL__20150815__redo_SEA_with_NOAA_and_random_bkgrnd__Alfven_storm_GRL

  ;the ins
  nRandTimes = 2000
  nIterations = 1 
  nStorms = 40. ; I know because I've seen the outcome...
  nEvRange=[0,12000]
  nEvBinsize=300.D
  ;; BefAft_t=60.0D

  ;the outs
  ;; date='20150815'
  date='20150822'
  ;; outFile = 'Fig_2--Dst_plus_nEventHistos--proper_storm_commencement--PROPER_ALFVEN_DB_SCREENING--20150821.png'
  outFile = 'Fig_2--SYMH_plus_nEventHistos--PROPER_ALFVEN_DB_SCREENING--'+date+'.png'
  scPlotPref = 'Fig_2--scatterplots--PROPER_ALFVEN_DB_SCREENING--'+date

  tempOutFile = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--'+date+'.dat'

  DBDIR = '/home/spencerh/Research/database/sw_omnidata/'
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
  maxStr='--ion_flux_up'

  sufStr = '--24hourdiff'

  rmDupes = 1
  IF rmDupes THEN sufStr = '--rmDupes' + sufStr

  ;;SSC-centered here
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=1,STORMINDS=q1_st,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q1_utc, $
                           /USE_DARTDB_START_ENDDATE,TBEFORESTORM=60.,TAFTERSTORM=60., $
                           MAXIND=maxInd, $
                           NEVBINSIZE=nEvBinsize, NEVRANGE=nEvRange, $
                           SAVEFILE=tempOutFile, $
                           RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist,/NOMAXPLOTS

  ;Now get a bunch of random time stuff
  superpose_randomtimes_and_alfven_db_quantities,nevbinsize=nEvBinsize,NRANDTIME=nRandTimes,stormfile=tempOutFile,/overlay_neventhists,/neventhists,returned_nev_tbins_and_hist=randtime_returned_tbins_and_nevhist,/SKIPPLOTS

  rt_tbins_and_nevhist_list=LIST(randtime_returned_tbins_and_nevhist)
  IF nIterations GT 1 THEN BEGIN
     FOR i=0,nIterations-1 DO BEGIN
        superpose_randomtimes_and_alfven_db_quantities,nevbinsize=nEvBinsize,stormfile=tempOutFile,/overlay_neventhists,/neventhists, $
           returned_nev_tbins_and_hist=randtime_returned_tbins_and_nevhist
        rt_tbins_and_nevhist_list.add,randtime_returned_tbins_and_nevhist
     ENDFOR
  ENDIF

  ;now avg them
  sumHist=(rt_tbins_and_nevhist_list[0])[*,1]
  IF nIterations GT 1 THEN BEGIN
     FOR i=1,nIterations DO sumHist+=(rt_tbins_and_nevhist_list[i])[*,1]
  ENDIF
     
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=1,STORMINDS=q1_st,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q1_utc, $
                           /USE_DARTDB_START_ENDDATE,TBEFORESTORM=60.,TAFTERSTORM=60., $
                           MAXIND=maxInd, $
                           NEVBINSIZE=nEvBinsize, NEVRANGE=nEvRange, $
                           BKGRND_HIST=sumHist/40.,/NOMAXPLOTS,/DO_SCATTERPLOTS,/USE_SYMH,$
                           SAVEPLOTNAME=outFile,SCATTEROUTPREFIX=scPlotPref

END