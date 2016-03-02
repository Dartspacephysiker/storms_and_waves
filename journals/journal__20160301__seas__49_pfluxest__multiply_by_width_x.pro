PRO JOURNAL__20160301__SEAS__49_PFLUXEST__MULTIPLY_BY_WIDTH_X

  @journal__20160301__plot_defaults.pro

  maxInd               = 49
                       
  avg_type_maxInd      = 2
  multiply_by_width_x  = 1

  probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x--DESPUN--with_NOAA'
  ;; probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x--DESPUN--minDst'
  yTitle                = 'Integrated Poynting Flux (mW/m) at 100 km' 
  ;; yRange_maxInd         = [.02,2]  ;;work well for despun data
  yRange_maxInd         = [2e2,3e4]

  yLogScale_maxInd      = 1

  do_despun             = 1

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
        MAKE_ERROR_BARS__AVG_PLOT=make_eb, $
        ERROR_BAR_NBOOT=eb_nBoot, $
        STORMTYPE=1, $
        ;; /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MAXIND=maxInd, $
        ;; /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        /YLOGSCALE_MAXIND, $
        AVG_TYPE_MAXIND=avg_type_maxInd, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        N__AVG_PLOTS=2, $
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
