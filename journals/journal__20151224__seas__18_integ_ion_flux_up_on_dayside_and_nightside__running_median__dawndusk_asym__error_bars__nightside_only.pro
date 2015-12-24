;2015/12/24 Now with error bars! Newfangled running median, too!
PRO JOURNAL__20151224__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND_NIGHTSIDE__RUNNING_MEDIAN__DAWNDUSK_ASYM__ERROR_BARS__NIGHTSIDE_ONLY

  ;;MLT params and stuff
  minM              = [0,7.5,-4.5]
  maxM              = [24,19.5,7.5]
  ptRegion          = ['All MLTs','Dayside','Nightside']
  psRegion          = ['all_MLTs','dayside','nightside']
                              
  do_these_plots    = [2]
  symColor          = ['black','red','blue']

  ;;histo stuff
  ;; histoBinSize      =  15 ;in hrs

  ;;Do a running median window 10 hours wide
  running_median    = 10
  running_binspace  = 2
  eb_nBoot          = 1000

  ;;strings 'n' things
  probOccPref       = 'journal_20151224--SEA_largestorms--18-INTEG_ION_FLUX_UP--with_NOAA--running_median--dawndusk_asym--error_bars_'+STRCOMPRESS(eb_nBoot,/REMOVE_ALL)
  ptPref            = ''
  ;; plotSuff          = '--all_MLT_day_night.png'
  plotSuff          = '--night.png'

  maxInd            = 18
  yTitle            = "Integrated upward ion flux (N $cm^{-3}$)"

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                running_median)
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(I0,"-hr bins, asym dawn/dusk line")', $
                                running_median)

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        HISTOBINSIZE=histoBinSize, $
        RUNNING_MEDIAN=running_median, $
        RUNNING_BIN_SPACING=running_binspace, $
        /MAKE_ERROR_BARS__AVG_PLOT, $
        ERROR_BAR_NBOOT=eb_nBoot, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=120, $
        MAXIND=maxInd, $
        YRANGE_MAXIND=[1e8,1e13], $
        YTITLE_MAXIND=yTitle, $
        /YLOGSCALE_MAXIND, $
        AVG_TYPE_MAXIND=2, $
        NOMAXPLOTS=(i EQ 0), $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        TITLE__AVG_PLOT=pT, $
        N__AVG_PLOTS=3, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        /MAKE_LEGEND__AVG_PLOT, $
        NAME__AVG_PLOT=ptRegion[i], $
        /ONLY_POS, $
        /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        SAVEMAXPLOT=(i EQ 2), $
        SAVEMPNAME=spn
     
  ENDFOR



END