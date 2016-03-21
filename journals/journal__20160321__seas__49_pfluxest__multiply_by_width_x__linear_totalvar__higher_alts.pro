;2016/03/21 The idea here is to see the way that outflow changes if I restrict altitude a bit. It's clear to me from the scatter
;plots that I made last weekend that the bimodality of the ion flux distribution disappears with altitude
PRO JOURNAL__20160321__SEAS__49_PFLUXEST__MULTIPLY_BY_WIDTH_X__LINEAR_TOTALVAR__HIGHER_ALTS

  @journal__20160303__plot_defaults.pro

  maxInd               = 49
                       
  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  restrict_altRange = [0340,2000] & yRange_totalVar = [[0,2.0e3],[0,3.6e3]] ;day, then night
  ;; restrict_altRange = [2000,4175] & yRange_totalVar = [[0,2.0e3],[0,4.0e2]] ;day, then night

  symTransp            = 93

  ;; hemi                 = 'SOUTH'
  ;; plotSuff             = '--totalVar--south_hemi.png'

  avg_type_maxInd      = 2
  multiply_by_width_x  = 1

  include_total_var     = 1
  total_epoch_do_histoPlot = 1
  do_two_panels         = 1

  do_despun             = 0

  probOccPref           = pref + '49_PFLUXEST_multiply_by_width_x__include_relative_variation--with_NOAA' + $
                          STRING(FORMAT='("altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])

  yTitle                = 'Integ. Poynting Flux (mW/m), 100 km' 
  yRange_maxInd         = [5e1,5e4]

  yLogScale_maxInd      = 1

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                  = do_these_plots[j]

     savePlotPref       = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                running_logAvg)
     spn                = savePlotPref+plotSuff
     pT                 = 'SEA of 40 storms ' + STRING(FORMAT='("(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        RESTRICT_ALTRANGE=restrict_altRange, $
        DO_DESPUNDB=do_despun, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        HISTOBINSIZE=histoBinSize, $
        RUNNING_AVERAGE=running_logAvg, $
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_SMOOTH_NPOINTS=smooth_nPoints, $
        RUNNING_BIN_OFFSET=running_bin_r_offset, $
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
        SYMTRANSP_MAXIND=symTransp, $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        DO_TWO_PANELS=do_two_panels, $
        OVERPLOT_TOTAL_EPOCH_VARIATION=include_total_var, $
        SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=(i EQ 0), $
        YRANGE_TOTALVAR=yRange_totalVar[*,i], $
        YLOGSCALE_TOTALVAR=0, $
        SECONDARY_AXIS__TOTALVAR_PLOT=(i GT 0), $
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
        TITLE__HISTO_PLOT=pT, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HEMI=hemi, $
        SAVEMAXPLOT=(i EQ 1), $
        SAVEMPNAME=spn
     
  ENDFOR



END
