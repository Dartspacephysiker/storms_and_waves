;2016/03/03
PRO JOURNAL__20160303__SEAS__49_PFLUXEST__MULTIPLY_BY_WIDTH_X__RELATIVE_VARIATION_HISTO

  @journal__20160223__plot_defaults.pro

  histoBinsize          = 5.0

  do_despun             = 0

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff           = '--north_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff           = '--north_hemi.png'
  ENDELSE

  maxInd                = 49

  ;; hemi              = 'SOUTH'
  ;; IF do_despun THEN BEGIN
  ;;    plotSuff       = '--south_hemi--despun_db.png'
  ;; ENDIF ELSE BEGIN
  ;;    plotSuff       = '--south_hemi.png'
  ;; ENDELSE



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; ;;for not-time-averaged SEA!
  hist_maxInd_sea       = 1
  ;; probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x__histo--DESPUN--with_NOAA--'
  probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x__relative_variation_histo--with_NOAA--'

  ;; probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x__histo--DESPUN--minDst--'

  avg_type_maxInd       = 2   ;Use log average--pFluxEst * width_x is definitely log normal
  multiply_by_width_x   = 1
  yRange_maxInd         = [7e2,6e3]
  yTitle                = 'Integrated Poynting Flux (mW/m) at 100 km' 

  include_total_var     = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; ;;for Time-averaged SEA!
  ;; timeAvgd_maxInd_sea   = 1
  ;; probOccPref           = pref + '49_PFLUXEST_timeAvg__histo--DESPUN--minDst'
  ;; avg_type_maxInd       = 0   ;Use log average--pFluxEst * width_x is definitely log normal
  ;; multiply_by_width_x   = 0
  ;; yRange_maxInd         = [1e-2,2e0]
  ;; yTitle                = 'Average Poynting Flux (mW/m!U2!N) at 100 km' 


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
        MAXIND=maxInd, $
        ;; DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        DO_DESPUNDB=do_despun, $
        STORMTYPE=2, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        HIST_MAXIND_SEA=hist_maxInd_sea, $
        AVG_TYPE_MAXIND=avg_type_maxInd, $
        /NOMAXPLOTS, $
        PLOTTITLE=pT, $
        NOGEOMAGPLOTS=(i GT 0), $
        WINDOW_GEOMAG=geomagWindow, $
        /XLABEL_MAXIND__SUPPRESS, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle, $
        HISTOBINSIZE=KEYWORD_SET(do_window_sum) ? !NULL : histoBinsize, $
        /OVERPLOT_HIST, $
        LOG_DBQUANTITY=log_dbQuantity, $
        YLOGSCALE_MAXIND=yLogScale_maxInd, $
        ;; WINDOW_SUM=KEYWORD_SET(do_window_sum) ? histoBinsize : !NULL, $
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
