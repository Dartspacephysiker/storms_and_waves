PRO JOURNAL__20151031__PROBOCCURRENCE__NO_NOAA__ALFSTORM2

  minM              = 0
  maxM              = 24
  histoBinSize      = 5.0

  probOccurrencePref = 'alfstorm2--Fig_3--SEA_probOccurrence--no_NOAA--'
  savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                             probOccurrencePref, $
                             (minM LT 0) ? minM + 24 : minM, $
                             maxM)
  plotSuff          = '.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
     /USE_DARTDB_START_ENDDATE, $
     STORMTYPE=1, $
     /REMOVE_DUPES, $
     /OVERPLOT_HIST, $
     MINMLT=minM, $
     MAXMLT=maxM, $
     /PROBOCCURENCE_SEA, $
     /LOG_PROBOCCURRENCE, $
     SAVEPLOTNAME=savePlotPref+'--log'+plotSuff,HISTORANGE=[1e-3,3e-1]
  
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
     /USE_DARTDB_START_ENDDATE, $
     STORMTYPE=1, $
     /REMOVE_DUPES, $
     /OVERPLOT_HIST, $
     MINMLT=minM, $
     MAXMLT=maxM, $
     /PROBOCCURENCE_SEA, $
     SAVEPLOTNAME=savePlotPref+plotSuff,HISTORANGE=[0,0.4]
  

END