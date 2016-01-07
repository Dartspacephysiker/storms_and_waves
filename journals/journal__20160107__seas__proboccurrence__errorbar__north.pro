PRO JOURNAL__20160106__SEAS__PROBOCCURRENCE__ON_DAYSIDE_AND_NIGHTSIDE__WINDOW_SUM__DROP_ALL_MLT__BOTH_HEMIS

  @journal__20160106__plot_defaults.pro

  window_sum        = 10

  probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--window_sum'
  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'SEA of 40 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        /NOMAXPLOTS, $
        PLOTTITLE=pT, $
        NOGEOMAGPLOTS=(i GT 0), $
        WINDOW_GEOMAG=geomagWindow, $
        /XLABEL_MAXIND__SUPPRESS, $
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