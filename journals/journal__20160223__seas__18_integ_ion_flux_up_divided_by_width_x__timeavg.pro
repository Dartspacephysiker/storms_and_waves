;2016/02/23 Now you know
PRO JOURNAL__20160223__SEAS__18_INTEG_ION_FLUX_UP_DIVIDED_BY_WIDTH_X__TIMEAVG

  @journal__20160223__plot_defaults.pro

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize          = 5

  do_despun             = 0

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff           = '--north_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff           = '--north_hemi.png'
  ENDELSE

  maxInd                = 18
  divide_by_width_x     = 1

  probOccPref           = pref + 'time_spatialAvg_18_INTEG_ION_FLUX_UP--with_NOAA'
  yTitle                = "Average Upward Ion Flux (cm!U-2!Ns!U-1!N) at 100 km"
  yRange_maxInd         = [10^(5.0),10^(9.5)]

  yLogScale_maxInd      = 1

  ;; hemi              = 'SOUTH'
  ;; IF do_despun THEN BEGIN
  ;;    plotSuff       = '--south_hemi--despun_db.png'
  ;; ENDIF ELSE BEGIN
  ;;    plotSuff       = '--south_hemi.png'
  ;; ENDELSE

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                  = do_these_plots[j]

     savePlotPref       = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn                = savePlotPref+plotSuff
     pT                 = 'SEA of 40 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        MAXIND=maxInd, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
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
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /TIMEAVGD_MAXIND_SEA, $
        LOG_DBQUANTITY=log_dbQuantity, $
        YLOGSCALE_MAXIND=yLogScale_maxInd, $
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
