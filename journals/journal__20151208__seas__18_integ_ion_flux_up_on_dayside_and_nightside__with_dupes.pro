PRO JOURNAL__20151208__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND_NIGHTSIDE__WITH_DUPES

  ;;MLT params and stuff
  minM              = [0,6,-6]
  maxM              = [24,18,6]
  ptRegion          = ['All MLTs','Dayside','Nightside']
  psRegion          = ['all_MLTs','dayside','nightside']
                              
  do_these_plots    = [0,1,2]
  ;; do_these_plots    = [0]
  symColor          = ['black','red','blue']


  ;;histo stuff
  histoBinSize      =  10 ;in hrs

  ;;strings 'n' things
  probOccPref       = 'journal_20151208--SEA_largestorms--18-INTEG_ION_FLUX_UP--with_NOAA--with_dupes'
  ptPref            = ''
  plotSuff          = '--all_MLT_day_night.png'

  maxInd            = 18
  yTitle            = "Integrated upward ion flux (N $cm^{-3}$)"

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     ;; savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--",I0,"-hr_bins--",A0)', $
     ;;                            probOccPref, $
     ;;                            (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
     ;;                            maxM[i], $
     ;;                            histoBinsize, $
     ;;                            psRegion[i])
     ;; spn               = savePlotPref+plotSuff
     ;; pt                = STRING(FORMAT='(A0," (",A0,", ",I0,"–",I0," MLT, ", I0,"-hr bins, with dupes)")', $
     ;;                            ptPref, $
     ;;                            ptRegion[i], $
     ;;                            minM[i],maxM[i], $
     ;;                            histoBinsize)
     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(I0,"-hr bins, with duplicates")', $
                                histoBinsize)

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=1, $
        ;; /REMOVE_DUPES, $
        ;; HOURS_AFT_FOR_NO_DUPES=60, $
        MAXIND=maxInd, $
        YTITLE_MAXIND=yTitle, $
        AVG_TYPE_MAXIND=2, $
        /NOGEOMAGPLOTS, $
        NOMAXPLOTS=(i EQ 0), $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        ;; TITLE__AVG_PLOT=pT, $
        N__AVG_PLOTS=3, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        /MAKE_LEGEND__AVG_PLOT, $
        NAME__AVG_PLOT=ptRegion[i], $
        ;; /LOG_DBQUANTITY, $
        /ONLY_POS, $
        YRANGE_MAXIND=[1e8,1e13], $
        /YLOGSCALE_MAXIND, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HISTOBINSIZE=histoBinSize, $
        SAVEMAXPLOT=(i EQ 2), $
        SAVEMPNAME=spn
     
  ENDFOR



END