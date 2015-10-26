;;2015/08/14
;;The question becomes, what do I do with all of these blasted indices that I've labored so diligently to obtain?
;;We need to have a way to simply feed a list of times to superpose_storms_and_[blah...].pro

PRO JOURNAL__20150814__PLOTS_AND_CHECKS_WITH_FOUR_QUAD_INDS

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

;; print,qi[0].qi_info
;; Structure for Brett's storm database
;; Q1: Brett identifies as LARGE storm, and sudden commencement appears in NOAA SSC DB
;; Q2: Brett identifies as SMALL storm, and sudden commencement appears in NOAA SSC DB
;; Q3: Brett identifies as LARGE storm, and sudden commencement DOES NOT appear in NOAA SSC DB
;; Q4: Brett identifies as SMALL storm, and sudden commencement DOES NOT appear in NOAA SSC DB
;; See comments at top of generating file for description of the four quadrants these indices represent.;; See comments at top of generating file for description of the four quadrants these indices represent.

;; print,qi[1].qi_info
;; Structure for NOAA database of storm sudden commencements
;; Q1: Brett identifies as LARGE storm, and sudden commencement appears in NOAA SSC DB
;; Q2: Brett identifies as SMALL storm, and sudden commencement appears in NOAA SSC DB
;; Q5: Identified in NOAA db, but not identified in Brett DB
;; See comments at top of generating file for description of the four quadrants these indices represent.

  ;; print,qi[0].list_i[0]

  q1_st=qi[0].list_i[0]
  q2_st=qi[0].list_i[1]
  q3_st=qi[0].list_i[2]
  q4_st=qi[0].list_i[3]

  q1_1=qi[1].list_i[0]
  q2_1=qi[1].list_i[1]
  q5_1=qi[1].list_i[2]
  
  ;; ;Want to see that they're the same?
  PRINT,'Q1: Large storms + NOAA (' + STRCOMPRESS(N_ELEMENTS(q1_st),/REMOVE_ALL) + ' total)'
  PRINT,"Time in Brett's DB       Time in NOAA DB          Difference (days)"
  FOR i=0,N_ELEMENTS(q1_st)-1 DO print,FORMAT='(A0,TR5,A0,TR5,F0.2)',stormstruct.tstamp[q1_st[i]],ssc1.tstamp[q1_1[i]],(stormstruct.julday[q1_st[i]]-ssc1.julday[q1_1[i]])
  
  PRINT,'Q2: Large storms + NOAA (' + STRCOMPRESS(N_ELEMENTS(q2_st),/REMOVE_ALL) + ' total)'
  PRINT,"Time in Brett's DB       Time in NOAA DB          Difference (days)"
  FOR i=0,N_ELEMENTS(q2_st)-1 DO print,FORMAT='(A0,TR5,A0,TR5,F0.2)',stormstruct.tstamp[q2_st[i]],ssc1.tstamp[q2_1[i]],(stormstruct.julday[q2_st[i]]-ssc1.julday[q2_1[i]])

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])
  q2_utc=conv_julday_to_utc(ssc1.julday[q2_1])
  q5_utc=conv_julday_to_utc(ssc1.julday[q5_1])

  ;;now plot 'em!!
  maxInd=16 ;ion_flux_up
  maxStr='--ion_flux_up'

  ;; maxInd=6  ;mag_current

  ;; maxInd=7  ;esa_current

  ;; maxInd=12  ;max_chare_losscone


  sufStr = '--24hourdiff'

  rmDupes = 1
  IF rmDupes THEN sufStr = '--rmDupes' + sufStr

  qStr='storms_quadrant'

  dstStr='--dst-centered'
  sscStr='--ssc-centered'
  

  ;;All dst-centered here
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=1,STORMINDS=q1_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'1' + dstStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 1: 'Large storms' in NOAA SSC DB (Centered on Dst min)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'1' + dstStr + maxStr + sufStr + '.png'

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=0,STORMINDS=q2_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'2' + dstStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 2: 'Small storms' in NOAA SSC DB (Centered on NOAA SSC)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'2' + dstStr + maxStr + sufStr + '.png'

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=1,STORMINDS=q3_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'3' + dstStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 3: 'Large' storms NOT in NOAA SSC DB (Centered on Dst min)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'3' + dstStr + maxStr + sufStr + '.png'

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=0,STORMINDS=q4_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'4' + dstStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 4: 'Small' storms NOT in NOAA SSC DB (Centered on Dst min)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'4' + dstStr + maxStr + sufStr + '.png'

  ;;Now SSC-centered
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=1,STORMINDS=q1_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q1_utc, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'1' + sscStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 1: 'Large storms' in NOAA SSC DB (Centered on NOAA SSC)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'1' + sscStr + maxStr + sufStr + '.png'

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=0,STORMINDS=q2_st,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS, REMOVE_DUPES=rmDupes,SSC_TIMES_UTC=q2_utc, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'2' + sscStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 2: 'Small storms' in NOAA SSC DB (Centered on NOAA SSC)", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'2' + sscStr + maxStr + sufStr + '.png'

  ;;Now 'quadrant 5'
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,q5_utc,MAXIND=maxInd,/OVERPLOT_HIST,/NEVENTHISTS,REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE,SAVEPLOTNAME=qStr+'5' + sscStr + sufStr + '.png', $
                           PLOTTITLE="Quadrant 5: Storms ONLY in NOAA SSC DB ", $
                           AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY,YRANGE_MAXIND=[1e5,1e10],SAVEMAXPLOTNAME=qStr+'5' + sscStr + maxStr + sufStr + '.png'

END