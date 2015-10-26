;2015/08/21 My life, my life...
;The four storms we originally had now have no Alfven events in them (or at least that's the case with a few of them--see
;JOURNAL__20150820__find_out_if_all_four_storms_are_in_our_NOAABrett_DB.pro--so now I've got to find four other storms. My brain hurts.

;See storm_info/How_many_events_are_in_each_storm.txt for some curiosities on the number of events per storm


PRO JOURNAL__20150821__four_storms_NOT_from_Yao__Alfven_storm_GRL

  ;;************************************************************
  ;;to be outputted

  

  ;scatter plots, N and S Hemi
  savePlotName='Fig_1--four_storms_from_1998--20150822.png'
  scOutPref='Fig_1--scatterplots--four_storms_in_1998--20150822'
  

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
  
  ;;none of these have storms in them!!
  ;; q1_st=q1_st[[34,35,36,39]]
  ;; q1_1=q1_1[[34,35,36,39]]
  ;; 2000-02-11T23:52:00Z 2000-05-23T17:02:00Z 2000-06-08T09:10:00Z
  ;; 2000-08-11T18:46:00Z

  ;; q1_st=q1_st[[13,14,16,17]]
  ;; q1_1=q1_1[[13,14,16,17]]

  ;;four random storms from 1998

  ;; min=12.
  ;; max=23.
  ;; diff=max-min
  ;; this=ROUND(randomu(seed,/UNIFORM)*diff+min)
  ;; FOR i=0,2 DO this=[this,ROUND(randomu(seed,/UNIFORM)*diff+min)]
  ;; check_dupes,this,out_dupe_i=out_dupe_i
  
  ;; WHILE N_ELEMENTS(out_dupe_i) GT 0 DO BEGIN
  ;;    FOR i=out_dupe_i[0],N_ELEMENTS(out_dupe_i)-1 DO this[out_dupe_i[i]]=ROUND(randomu(seed,/UNIFORM)*diff+min)
  ;;    check_dupes,this,out_dupe_i=out_dupe_i
  ;; ENDWHILE

  ;; this=this(sort(this))

  ;; this=generate_rands_between_two_values(4,12.,23.,/NO_DUPLICATES,/SORT_PLEASE)
  ;; print,this

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

  ;;SSC-centered here
  STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                     /USE_DARTDB_START_ENDDATE,TBEFORESTORM=15.,TAFTERSTORM=60., $
                                     MAXIND=maxInd, REMOVE_DUPES=rmDupes, $
                                     RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist,YRANGE_MAXIND=yRange_maxInd, $
                                     SAVEPLOTNAME=savePlotName, $
                                     /DO_SCATTERPLOTS,epochPlot_colorNames=['red','blue','green','purple'], $
                                     SCATTEROUTPREFIX=scOutPref, $
                                     /USE_SYMH




END