PRO JOURNAL__20160101__SEAS__PROBOCCURRENCE__ON_DAYSIDE_AND_NIGHTSIDE__WINDOW_SUM__DROP_ALL_MLT__REVERSE_DUPE

  ;;MLT params and stuff
  minM              = [6.0,-6.0]
  maxM              = [18.0,6.0]
  hemi              = 'NORTH'
  ptRegion          = ['Dayside','Nightside']
  psRegion          = ['dayside','nightside']
  hours_bef         = 120
                              
  do_these_plots    = [0,1]
  symColor          = ['red','blue']

  ;;Do a running median window
  window_sum        = 10
  smooth_nPoints    = 3

  ;;strings 'n' things
  @fluxplot_defaults

  probOccPref       = 'journal_20160101--SEA_largestorms--PROBOCCURRENCE--with_NOAA--window_sum'
  ptPref            = ''
  plotSuff          = '--day_night--'+STRCOMPRESS(hours_bef,/REMOVE_ALL)+'-hr_no_dupes_REVERSE.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'SEA of 40 storms'

     ;; pt                = STRING(FORMAT='(I0,"-hr bins, asym dawn/dusk line")', $
     ;;                            histoBinsize)
     ;; plotSuff          = '.png'
     ;; spn               = probOccPref + plotSuff
     
     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=1, $
        /REMOVE_DUPES__REVERSE, $
        HOURS_BEF_FOR_NO_DUPES=hours_bef, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        /NOMAXPLOTS, $
        PLOTTITLE=pT, $
        NOGEOMAGPLOTS=(i GT 0), $
        WINDOW_GEOMAG=geomagWindow, $
        ;; /XLABEL_MAXIND__SUPPRESS, $
        HISTORANGE=[0,0.5], $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /PROBOCCURENCE_SEA, $
        WINDOW_SUM=window_sum, $
        SAVEPLOT=(i EQ 1), $
        OUT_HISTO_PLOT=out_histo_plot, $
        /ACCUMULATE__HISTO_PLOTS, $
        N__HISTO_PLOTS=2, $
        SYMCOLOR__HISTO_PLOT=symColor[i], $
        /MAKE_LEGEND__HISTO_PLOT, $
        NAME__HISTO_PLOT=ptRegion[i], $
        SAVEPNAME=spn
  ENDFOR

END