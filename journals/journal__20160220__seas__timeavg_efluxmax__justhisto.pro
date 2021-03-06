;2016/02/20 Plots for Chris
PRO JOURNAL__20160220__SEAS__TIMEAVG_EFLUXMAX__JUSTHISTO

  @journal__20160220__plot_defaults.pro

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize      = 2.5

  do_despun             = 0

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff       = '--north_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff       = '--north_hemi.png'
  ENDELSE

  log_timeavgd_eFluxMax    = 1

  ;; hemi              = 'SOUTH'
  ;; IF do_despun THEN BEGIN
  ;;    plotSuff       = '--south_hemi--despun_db.png'
  ;; ENDIF ELSE BEGIN
  ;;    plotSuff       = '--south_hemi.png'
  ;; ENDELSE

  probOccPref       = pref + 'timeAvg_eFluxMax--with_NOAA--justhisto'
  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'SEA of 40 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        DO_DESPUNDB=do_despun, $
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
        HISTORANGE=[0.01,1.0], $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /TIMEAVGD_EFLUXMAX_SEA, $
        LOG_TIMEAVGD_EFLUXMAX=log_timeavgd_eFluxMax, $
        ;; WINDOW_SUM=window_sum, $
        ;; RUNNING_BIN_SPACING=running_bin_spacing, $
        ;; RUNNING_BIN_L_OFFSET=running_bin_l_offset, $
        ;; RUNNING_BIN_R_OFFSET=running_bin_r_offset, $
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
