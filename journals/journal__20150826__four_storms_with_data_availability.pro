; Now we're cooking in a grease fire
;2015/08/26
;In order to produce the plots corresponding to various sample rates, you've got to modify both alfven_db_cleaner.pro and
;STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID.pro and set the sample_t restriction accordingly
;To accept anything 8 Hz or more, make the sample_t restriction LE 0.15
;To accept anything 32 Hz or more, make the sample_t restriction LE 0.036

PRO JOURNAL__20150826__FOUR_STORMS_WITH_DATA_AVAILABILITY

  date='20150826'

  ;scatter plots, N and S Hemi
  ;; savePlotName='Fig_1--four_storms_from_1998--data_avail_overlaid--GE32Hz--'+date+'.png'
  ;; savePlotName='Fig_1--four_storms_from_1998--data_avail_overlaid--GE8Hz--'+date+'.png'
  savePlotName='Fig_1--four_storms_from_1998--data_avail_overlaid--GE128Hz--'+date+'.png'

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

  maxInd=6 ;ion_flux_up
  yRange_maxInd=[-300,300]

  rmDupes = 1

  STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                     /USE_DARTDB_START_ENDDATE,TBEFORESTORM=15.,TAFTERSTORM=60., $
                                     MAXIND=maxInd, REMOVE_DUPES=rmDupes, $
                                     YRANGE_MAXIND=yRange_maxInd, $
                                     SAVEPLOTNAME=savePlotName, $
                                     SCPLOT_COLORLIST=['red','blue','green','purple'], $
                                     /USE_SYMH,/SHOW_DATA_AVAILABILITY,/USE_DATA_MINMAX

END