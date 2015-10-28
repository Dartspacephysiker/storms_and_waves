PRO JOURNAL__20151028__FIG3__SEA_PROBOCCURRENCE__ALFSTORM2

  minM              = -4
  maxM              =  4
  histoBinSize      = 2.5

  probOccurrencePref = 'alfstorm2--Fig_3--SEA_probOccurrence--'
  savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                             probOccurrencePref, $
                             (minM LT 0) ? minM + 24 : minM, $
                             maxM)
  plotSuff          = '.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                      /USE_DARTDB_START_ENDDATE,STORMTYPE=1,/REMOVE_DUPES,/NOGEOMAGPLOTS, $
                                      MINMLT=minM, $
                                      MAXMLT=maxM, $
                                      /PROBOCCURENCE_SEA, $
                                      /LOG_PROBOCCURRENCE, $
                                      SAVEPLOTNAME=probOccurrencePref+'--log'+plotSuff,HISTORANGE=[1e-3,3e-1]

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                      /USE_DARTDB_START_ENDDATE,STORMTYPE=1,/REMOVE_DUPES,/NOGEOMAGPLOTS, $
                                      MINMLT=minM, $
                                      MAXMLT=maxM, $
                                      /PROBOCCURENCE_SEA, $
                                      SAVEPLOTNAME=probOccurrencePref+plotSuff,HISTORANGE=[0,0.5]
END