PRO JOURNAL__20160305__SEAS__18_INTEG_ION_FLUX_UP__LINEAR_TOTALVAR

  @journal__20160303__plot_defaults.pro

  maxInd               = 18

  avg_type_maxInd      = 2
  multiply_by_width_x  = 1

  include_total_var     = 1
  total_epoch_do_histoPlot = 1
  do_two_panels         = 1

  do_despun             = 0

  probOccPref           = pref + '18_INTEG_ION_FLUX_UP__include_relative_variation--with_NOAA'
  yTitle                = "Integ. Up. Ion Flux (cm!U-1!Ns!U-1!N), 100 km"
  yRange_maxInd         = [2e10,9e15]

  yRange_totalVar       = [[0,1.3e14],[0,1.3e13]] ;day, then night

  yLogScale_maxInd      = 1

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                  = do_these_plots[j]

     savePlotPref       = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn                = savePlotPref+plotSuff
     pT                 = 'SEA of 40 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        DO_DESPUNDB=do_despun, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=1, $
        HISTOBINSIZE=histoBinsize, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MAXIND=maxInd, $
        /NOGEOMAGPLOTS, $
        PLOTTITLE=pT, $
        ;; NOGEOMAGPLOTS=(i GT 0), $
        /ONLY_POS, $
        WINDOW_GEOMAG=geomagWindow, $
        /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        LOG_DBQUANTITY=log_dbQuantity, $
        YLOGSCALE_MAXIND=yLogScale_maxInd, $
        AVG_TYPE_MAXIND=avg_type_maxInd, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        DO_TWO_PANELS=do_two_panels, $
        SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=(i EQ 0), $
        YRANGE_TOTALVAR=yRange_totalVar[*,i], $
        YLOGSCALE_TOTALVAR=0, $
        SECONDARY_AXIS__TOTALVAR_PLOT=(i GT 0), $
        OVERPLOT_TOTAL_EPOCH_VARIATION=include_total_var, $
        ;; SYMCOLOR__TOTAL_EPOCH_VAR=symColor__totalVar[i], $
        SYMCOLOR__TOTAL_EPOCH_VAR=symColor[i], $
        TOTAL_EPOCH__DO_HISTOPLOT=total_epoch_do_histoPlot, $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        N__AVG_PLOTS=4, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        NAME__AVG_PLOT=ptRegion[i], $
        RUNNING_AVERAGE=running_logAvg, $
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_SMOOTH_NPOINTS=smooth_nPoints, $
        RUNNING_BIN_OFFSET=running_bin_r_offset, $
        /PRINT_MAXIND_SEA_STATS, $
        SAVEMAXPLOT=(i EQ 1), $
        SYMCOLOR__HISTO_PLOT=symColor[i], $
        ;; /MAKE_LEGEND__AVG_PLOT, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        SAVEMPNAME=spn
  ENDFOR

END
