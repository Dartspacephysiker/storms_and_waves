PRO JOURNAL__20151208__SEA_PROBOCCURRENCE_FOR_AGU_POSTER__REMOVED_DUPES

  minM              = [0,6,-6]
  maxM              = [24,18,6]
  ;; strings           = ['--all_MLTs','--dayside','--nightside']
  niceStrings       = ['All MLTs','Dayside','Nightside']

  histoBinSize      = 10.0

  symColor          = ['black','red','blue']

  probOccurrencePref = '2015AGUposter--SEA_probOccurrence--no_dupes--all_MLT_day_night'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR i = 0,2 DO BEGIN
     ;; savePlotPref       = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
     ;;                             probOccurrencePref, $
     ;;                             (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
     ;;                             maxM[i])
     ;; plotSuff          = strings[i] + '.png'

     pT                = 'SEA of 40 storms'
     plotSuff          = '.png'
     spn               = probOccurrencePref + plotSuff
     
     SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st, $
                                         SSC_TIMES_UTC=q1_utc, $
                                         /USE_DARTDB_START_ENDDATE, $
                                         STORMTYPE=1, $
                                         /REMOVE_DUPES, $
                                         HOURS_AFT_FOR_NO_DUPES=60, $
                                         MINMLT=minM[i], $
                                         MAXMLT=maxM[i], $
                                         /NOMAXPLOTS, $
                                         PLOTTITLE=pT, $
                                         NOGEOMAGPLOTS=(i GT 0), $
                                         WINDOW_GEOMAG=geomagWindow, $
                                         HISTORANGE=[0,0.2], $
                                         HISTOBINSIZE=histoBinsize, $
                                         /OVERPLOT_HIST, $
                                         /PROBOCCURENCE_SEA, $
                                         SAVEPLOT=(i EQ 2), $
                                         OUT_HISTO_PLOT=out_histo_plot, $
                                         /ACCUMULATE__HISTO_PLOTS, $
                                         N__HISTO_PLOTS=3, $
                                         SYMCOLOR__HISTO_PLOT=symColor[i], $
                                         /MAKE_LEGEND__HISTO_PLOT, $
                                         NAME__HISTO_PLOT=niceStrings[i], $
                                         SAVEPNAME=spn
  ENDFOR

END