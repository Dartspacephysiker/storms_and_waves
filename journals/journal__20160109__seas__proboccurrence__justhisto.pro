PRO JOURNAL__20160109__SEAS__PROBOCCURRENCE__JUSTHISTO

  @journal__20160108__plot_defaults.pro

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize      = 2.5

  ;;manual mod this
  plotSuff              = '--north_hemi.png'
  probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto'
  ;; probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto--despun_db'
  ;; do_despun         = 1
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
        HISTORANGE=[0,0.6], $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /PROBOCCURENCE_SEA, $
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
