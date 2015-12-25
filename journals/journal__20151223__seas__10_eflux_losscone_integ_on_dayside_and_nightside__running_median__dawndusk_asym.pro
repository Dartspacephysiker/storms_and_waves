;2015/12/23 Newfangled running median, too!
PRO JOURNAL__20151223__SEAS__10_EFLUX_LOSSCONE_INTEG_ON_DAYSIDE_AND_NIGHTSIDE__RUNNING_MEDIAN__DAWNDUSK_ASYM

  ;;MLT params and stuff
  minM              = [0,7.5,-4.5]
  maxM              = [24,19.5,7.5]
  ptRegion          = ['All MLTs','Dayside','Nightside']
  psRegion          = ['all_MLTs','dayside','nightside']
                              
  do_these_plots    = [0,1,2]
  symColor          = ['black','red','blue']

  ;;histo stuff
  ;; histoBinSize      =  15 ;in hrs

  ;;Do a running median window
  running_median    = 10


  ;;strings 'n' things
  @fluxplot_defaults

  probOccPref       = 'journal_20151223--SEA_largestorms--10-EFLUX_LOSSCONE_INTEG--with_NOAA--running_median--dawndusk_asym'
  ptPref            = ''
  plotSuff          = '--all_MLT_day_night.png'

  maxInd            = 10
  yTitle            = title__alfDB_ind_10

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
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=120, $
        MAXIND=maxInd, $
        YRANGE_MAXIND=[2e1,8e4], $
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
