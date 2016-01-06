PRO JOURNAL__20160106__SEAS__49_PFLUXEST_ON_DAYSIDE_AND_NIGHTSIDE__SMOOTHED_RUNNING_AVG__DROP_ALL_MLT__BOTH_HEMIS

  @journal__20160106__plot_defaults.pro

  probOccPref       = pref + '--49-PFLUXEST'
  ptPref            = ''

  maxInd            = 49
  yTitle            = title__alfDB_ind_49

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
        /XLABEL_MAXIND__SUPPRESS, $
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
