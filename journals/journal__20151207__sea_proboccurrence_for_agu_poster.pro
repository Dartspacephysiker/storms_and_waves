PRO JOURNAL__20151207__SEA_PROBOCCURRENCE_FOR_AGU_POSTER

  ;; minM              = -4
  ;; maxM              =  4
  ;; minM              = 6
  ;; maxM              = 18
  minM              = [-6,6,0]
  maxM              = [6,18,24]
  strings           = ['--nightside','--dayside','--all_MLTs']
  niceStrings       = ['Nightside','Dayside','All MLTs']

  histoBinSize      = 5.0

  probOccurrencePref = '2015AGUposter--SEA_probOccurrence--'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR i = 0,2 DO BEGIN
     savePlotPref       = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                                 probOccurrencePref, $
                                 (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
                                 maxM[i])

     plotSuff          = strings[i] + '.png'
     
     
     SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st, $
                                         SSC_TIMES_UTC=q1_utc, $
                                         /USE_DARTDB_START_ENDDATE, $
                                         STORMTYPE=1, $
                                         /REMOVE_DUPES, $
                                         ;; /NOGEOMAGPLOTS, $
                                         MINMLT=minM[i], $
                                         MAXMLT=maxM[i], $
                                         PLOTTITLE='SEA of 39 storms—'+niceStrings[i], $
                                         HISTORANGE=[0,0.2], $
                                         HISTOBINSIZE=histoBinsize, $
                                         /OVERPLOT_HIST, $
                                         /PROBOCCURENCE_SEA, $
                                         /SAVEPLOT, $
                                         SAVEPNAME=savePlotPref+plotSuff

  ENDFOR
  ;; SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
  ;;                                     /USE_DARTDB_START_ENDDATE, $
  ;;                                     STORMTYPE=1, $
  ;;                                     /REMOVE_DUPES, $
  ;;                                     ;; /NOGEOMAGPLOTS, $
  ;;                                     MINMLT=minM, $
  ;;                                     MAXMLT=maxM, $
  ;;                                     /PROBOCCURENCE_SEA, $
  ;;                                     /LOG_PROBOCCURRENCE, $
  ;;                                     HISTORANGE=[1e-3,3e-1], $
  ;;                                     HISTOBINSIZE=histoBinsize, $
  ;;                                     /OVERPLOT_HIST, $
  ;;                                     /SAVEPLOT, $
  ;;                                     SAVEPNAME=savePlotPref+'--log'+plotSuff

END