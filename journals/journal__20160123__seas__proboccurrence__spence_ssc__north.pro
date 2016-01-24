PRO JOURNAL__20160123__SEAS__PROBOCCURRENCE__SPENCE_SSC__NORTH

  @journal__20160123__plot_defaults.pro

  window_sum        = 10

  ;; probOccPref       = pref + 'PROBOCCURRENCE--with_SPENCE_SSC--window_sum'
  ;; probOccPref       = pref + 'PROBOCCURRENCE--with_Q3_no_NOAA--window_sum'
  probOccPref       = pref + 'PROBOCCURRENCE--with_Q1andQ2_NOAA--window_sum'
  ptPref            = ''
  ;; pT                = 'SEA of Spence storms'
  ;; pT                = 'SEA of Q3 storms'
  pT                = 'SEA of Q1 and Q2 storms'

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                window_sum)
     spn               = savePlotPref+plotSuff

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=stormType, $
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
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_BIN_L_OFFSET=running_bin_l_offset, $
        RUNNING_BIN_R_OFFSET=running_bin_r_offset, $
        /PRINT_MAXIND_SEA_STATS, $
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