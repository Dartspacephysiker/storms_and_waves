PRO JOURNAL__20160405__SEAS__11_TOTAL_EFLUX_AVG__LINEAR_TOTALVAR

  @journal__20160303__plot_defaults.pro

  hemi                     = 'NORTH'
  ;; hemi                     = 'SOUTH'

  pref                     = 'journal_20160404--SEA_largestorms'
  plotSuff                 = '--totalVar--' + hemi + '_hemi.png'

  maxInd                   = 11

  avg_type_maxInd          = 2
  divide_by_width_x        = 1

  include_total_var        = 1
  total_epoch_do_histoPlot = 1
  do_two_panels            = 1

  do_despun                = 0
  despunStr                = do_despun ? "--despun" : ""

  only_pos                 = 0
  only_neg                 = 1

  CASE 1 OF
     only_pos: BEGIN
        posNegStr          = '__POS'
        posNegNiceStr      = 'Positive '
     END
     only_neg: BEGIN
        posNegStr          = '__NEG'
        posNegNiceStr      = 'Negative '
     END
  ENDCASE

  probOccPref              = pref + '11_EFLUX_LOSSCONE_AVG' + posNegStr + despunStr + '--include_variation--with_NOAA'
  yTitle                   = posNegNiceStr + " e!U-!N Flux (mW m!U-2!N), 100 km"
  yRange_maxInd            = [4e-2,2e2]

  yRange_totalVar          = [[0,2.5e0],[0,2.5e0]] ;day, then night

  yLogScale_maxInd         = 1

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
        ONLY_POS=only_pos, $
        ONLY_NEG=only_neg, $
        WINDOW_GEOMAG=geomagWindow, $
        /PRINT_MAXIND_SEA_STATS, $
        ;; /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        LOG_DBQUANTITY=log_dbQuantity, $
        YLOGSCALE_MAXIND=yLogScale_maxInd, $
        AVG_TYPE_MAXIND=avg_type_maxInd, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        OVERPLOT_TOTAL_EPOCH_VARIATION=include_total_var, $
        DO_TWO_PANELS=do_two_panels, $
        SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=(i EQ 0), $
        YRANGE_TOTALVAR=yRange_totalVar[*,i], $
        YLOGSCALE_TOTALVAR=0, $
        ;; SECONDARY_AXIS__TOTALVAR_PLOT=(i GT 0), $
        SECONDARY_AXIS__TOTALVAR_PLOT=0, $
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
        SAVEMAXPLOT=(i EQ 1), $
        SYMCOLOR__HISTO_PLOT=symColor[i], $
        ;; /MAKE_LEGEND__AVG_PLOT, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        SAVEMPNAME=spn
  ENDFOR

END

