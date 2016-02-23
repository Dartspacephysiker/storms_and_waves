;2016/02/23 Now you know
PRO JOURNAL__20160223__SEAS__18_INTEG_ION_FLUX_UP_DIVIDED_BY_WIDTH_X

  @journal__20160223__plot_defaults.pro

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize          = 2

  do_despun             = 1

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff           = '--north_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff           = '--north_hemi.png'
  ENDELSE

  maxInd                = 18
  divide_by_width_x     = 1
  yTitle                = "Spatially averaged " + title__alfDB_ind_18
  yRange_maxInd         = [10^(5.0),10^(10.0)]
  yLogScale_maxInd      = 1

  ;; hemi              = 'SOUTH'
  ;; IF do_despun THEN BEGIN
  ;;    plotSuff       = '--south_hemi--despun_db.png'
  ;; ENDIF ELSE BEGIN
  ;;    plotSuff       = '--south_hemi.png'
  ;; ENDELSE

  probOccPref           = pref + 'spatialAvg_18_INTEG_ION_FLUX_UP--with_NOAA'
  ptPref                = ''

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
        /NOGEOMAGPLOTS, $
        PLOTTITLE=pT, $
        ;; NOGEOMAGPLOTS=(i GT 0), $
        WINDOW_GEOMAG=geomagWindow, $
        /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        ;; /TIMEAVGD_MAXIND_SEA, $
        LOG_DBQUANTITY=log_dbQuantity, $
        YLOGSCALE_MAXIND=yLogScale_maxInd, $
        AVG_TYPE_MAXIND=2, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        N__AVG_PLOTS=2, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        NAME__AVG_PLOT=ptRegion[i], $
        /ONLY_POS, $
        RUNNING_AVERAGE=running_logAvg, $
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_SMOOTH_NPOINTS=smooth_nPoints, $
        RUNNING_BIN_L_OFFSET=running_bin_l_offset, $
        RUNNING_BIN_R_OFFSET=running_bin_r_offset, $
        SAVEMAXPLOT=(i EQ 1), $
        SYMCOLOR__HISTO_PLOT=symColor[i], $
        /MAKE_LEGEND__AVG_PLOT, $
        SAVEMPNAME=spn
  ENDFOR

END
