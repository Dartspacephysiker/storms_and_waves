PRO JOURNAL__20160111__SEAS__PROBOCCURRENCE__STATS

  @journal__20160111__proboccurrence_plot_defaults.pro

  ;;manual mod this
  plotSuff              = '--north_hemi.png'
  probOccPref       = pref + 'PROBOCCURRENCE--justhisto'
  ;; probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto--despun_db'
  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
  ;; FOR j=1,0,-1 DO BEGIN
     i                 = do_these_plots[j]

     window_sum           = r_binWidth 
     running_bin_spacing  = rb_spacing
     running_bin_r_offset = rb_r_offset
     running_bin_l_offset = rb_l_offset
     HEMI                 = hem
     minM                 = minMLT
     maxM                 = maxMLT
     despun               = DO_despun

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                ;; histoBinsize)
                                window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'SEA of 40 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        DO_DESPUNDB=despun, $
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
        HISTORANGE=[0,0.6], $
        ;; HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /PROBOCCURENCE_SEA, $
        WINDOW_SUM=window_sum, $
        RUNNING_BIN_SPACING=running_bin_spacing, $
        RUNNING_BIN_L_OFFSET=running_bin_l_offset, $
        ;; RUNNING_BIN_R_OFFSET=running_bin_r_offset, $
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
