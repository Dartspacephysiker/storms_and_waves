PRO JOURNAL__20160303__SEAS__49_PFLUXEST__MULTIPLY_BY_WIDTH_X__INCLUDE_RELATIVE_VARIATION

  @journal__20160303__plot_defaults.pro

  maxInd               = 49
                       
  avg_type_maxInd      = 2
  multiply_by_width_x  = 1

  include_total_var     = 1
  total_epoch_do_histoPlot = 1
  do_two_panels         = 1

  do_despun             = 0

  probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x__include_relative_variation--with_NOAA'
  yTitle                = 'Integ. Poynting Flux (mW/m), 100 km' 
  yRange_maxInd         = [9e1,5e4]

  yLogScale_maxInd      = 1

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                running_logAvg)
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(I0,"-hr bins, ")', $
                                running_logAvg)

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        DO_DESPUNDB=do_despun, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        HISTOBINSIZE=histoBinSize, $
        RUNNING_AVERAGE=running_logAvg, $
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_SMOOTH_NPOINTS=smooth_nPoints, $
        RUNNING_BIN_L_OFFSET=running_bin_l_offset, $
        RUNNING_BIN_R_OFFSET=running_bin_r_offset, $
        /PRINT_MAXIND_SEA_STATS, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MAXIND=maxInd, $
        /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        /YLOGSCALE_MAXIND, $
        MAKE_LEGEND__AVG_PLOT=make_legend__avg_plot, $
        AVG_TYPE_MAXIND=avg_type_maxInd, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        DO_TWO_PANELS=do_two_panels, $
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
        /ONLY_POS, $
        /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        SAVEMAXPLOT=(i EQ 1), $
        SAVEMPNAME=spn
     
  ENDFOR



END