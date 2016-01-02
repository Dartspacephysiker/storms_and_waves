PRO JOURNAL__20160101__SEAS__49_PFLUXEST_ON_DAYSIDE_AND_NIGHTSIDE__SMOOTHED_RUNNING_AVG__DROP_ALL_MLT

  ;;MLT params and stuff
  minM              = [6.0,-6.0]
  maxM              = [18.0,6.0]
  hemi              = 'NORTH'
  ptRegion          = ['Dayside','Nightside']
  psRegion          = ['dayside','nightside']
  hours_aft         = 120
                              
  do_these_plots    = [0,1]
  symColor          = ['red','blue']

  ;;Do a running logAvg window
  running_logAvg    = 10
  smooth_nPoints    = 3

  ;;strings 'n' things
  ;; fancy_plotNames   = 1
  @fluxplot_defaults

  probOccPref       = 'journal_20160101--SEA_largestorms--49-PFLUXEST--with_NOAA--smoothed_running_logAvg'
  ptPref            = ''
  plotSuff          = '--day_night.png'

  maxInd            = 49
  yTitle            = title__alfDB_ind_49

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                running_logAvg)
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(I0,"-hr bins, ")', $
                                running_logAvg)

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        HISTOBINSIZE=histoBinSize, $
        RUNNING_AVERAGE=running_logAvg, $
        RUNNING_SMOOTH_NPOINTS=smooth_nPoints, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MAXIND=maxInd, $
        ;; /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=[1e-1,1e2], $
        YTITLE_MAXIND=yTitle, $
        /YLOGSCALE_MAXIND, $
        AVG_TYPE_MAXIND=2, $
        ;; NOMAXPLOTS=(i EQ 0), $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        ;; TITLE__AVG_PLOT=pT, $
        N__AVG_PLOTS=2, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        ;; /MAKE_LEGEND__AVG_PLOT, $
        NAME__AVG_PLOT=ptRegion[i], $
        /ONLY_POS, $
        /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        SAVEMAXPLOT=(i EQ 1), $
        SAVEMPNAME=spn
     
  ENDFOR



END
