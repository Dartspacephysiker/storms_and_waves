PRO JOURNAL__20151027__CHECKINGOUTPROBOCCURENCESTORMSTUFF

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                      /PROBOCCURENCE_SEA,/USE_DARTDB_START_ENDDATE,STORMTYPE=1,/REMOVE_DUPES,/NOGEOMAGPLOTS,/LOG_PROBOCCURRENCE

END