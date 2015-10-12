;2015/08/25
;Time to add a rug plot, per Professor LaBelle's request
;Ripped off JOURNAL__20150821__four_storms_NOT_from_Yao__Alfven_storm_GRL

PRO JOURNAL__20150825__GET_STARTSTOP_FOR_FOUR_STORMS__ALFVENS_STORMS_GRL, $
   GEOMAGWINDOW=geomagWindow,GEOMAGPLOTS=geomagPlots, $
   MAXPLOTS=maxPlots, $
   OUT_DSS=dss

   ;;NOTE: save call at bottom, commented out

  date = '20150825'

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
  
  this=[13,14,17,20]

  q1_st=q1_st[this]
  q1_1=q1_1[this]

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;;now plot 'em!!
  maxInd=16 ;ion_flux_up
  maxStr='--ion_flux_up'

  maxInd=6 ;ion_flux_up
  yRange_maxInd=[-300,300]
  maxStr='--ion_flux_up'

  rmDupes = 1

  stackplots_storms_nevents_overlaid,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                     /USE_DARTDB_START_ENDDATE,TBEFORESTORM=15.,TAFTERSTORM=60., $
                                     MAXIND=maxInd, REMOVE_DUPES=rmDupes, $
                                     /USE_DATA_MINMAX, $
                                     /USE_SYMH, $
                                     RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist, $
                                     YRANGE_MAXIND=yRange_maxInd, $
                                     SAVEPLOTNAME=savePlotName, $
                                     SCPLOT_COLORLIST=['red','blue','green','purple'], $
                                     OUT_GEOMAGWINDOW=geomagWindow,OUT_GEOMAGPLOTS=geomagPlots, $
                                     OUT_MAXPLOTS=maxPlots,OUT_DATSTARTSTOP=dss


  ;; save,dss,FILENAME='datStartStop_for_four_1998_storms--'+date+'.sav'

END