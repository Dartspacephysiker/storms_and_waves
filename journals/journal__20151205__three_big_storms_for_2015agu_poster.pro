;2015/12/05
;Here are the three biggest storms I can see for quadrant 1, where we have an SSC time and Brett has marked the storm as large
;; 13 1998-04-23/18:25:00  0.89                   6963
;; 15 1998-05-03/17:43:00  1.06                   9292
;; 26 1999-02-18/02:46:00  0.34                   6262
PRO JOURNAL__20151205__THREE_BIG_STORMS_FOR_2015AGU_POSTER

  date='20151205'

  ;scatter plots, N and S Hemi
  savePlotName='Fig_1--three_storms--data_avail_overlaid--'+date+'.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDIR=dbDir,DB_NOAA=DB_NOAA,DB_BRETT=DB_Brett,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  ;; this=[13,15,26]
  this=[4,6,11]

  q1_st=q1_st[this]
  q1_1=q1_1[this]

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;;now plot 'em!!

  maxInd=6 ;MAG_CURRENT
  yRange_maxInd=[-200,200]

  rmDupes = 0

  STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID, $
     STORMTYPE=1, $
     EPOCHINDS=q1_st, $
     SSC_TIMES_UTC=q1_utc, $
     /USE_DARTDB_START_ENDDATE, $
     TBEFOREEPOCH=15., $
     TAFTEREPOCH=60., $
     MAXIND=maxInd, $
     /OVERPLOT_ALFVENDBQUANTITY, $
     REMOVE_DUPES=rmDupes, $
     YRANGE_MAXIND=yRange_maxInd, $
     SAVEPLOTNAME=savePlotName, $
     EPOCHPLOT_COLORNAMES=['red','blue','green'], $
     ;; /USE_SYMH, $
     /SHOW_DATA_AVAILABILITY


END
