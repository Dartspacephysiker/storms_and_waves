;2016/03/21 The idea here is to see how everything changes if I restrict altitude a bit. It's clear to me from the scatter
;plots that I made last weekend that the bimodality of the ion flux distribution disappears with altitude.
PRO JOURNAL__20160321__SEAS__PROBOCCURRENCE__HIGHER_ALTS

  @journal__20160108__plot_defaults.pro

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize      = 5.0

  HEMI              = 'NORTH'
  HEMI              = 'SOUTH'

  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  ;; restrict_altRange = [0000,2000] & histoRange = [0,0.03]
  restrict_altRange = [2000,4175] & histoRange = [0,0.1]

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi.png'
  ENDELSE

  do_despun         = 1

  probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto' + $
                          STRING(FORMAT='("altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])

  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'SEA of 40 storms' + STRING(FORMAT='("(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        RESTRICT_ALTRANGE=restrict_altRange, $
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
        HISTORANGE=histoRange, $
        HISTOBINSIZE=histoBinsize, $
        /OVERPLOT_HIST, $
        /PROBOCCURRENCE_SEA, $
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
