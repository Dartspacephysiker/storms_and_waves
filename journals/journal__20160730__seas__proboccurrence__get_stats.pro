;2016/07/30 In order to satisify Referee #1, I'm getting to the bottom of this proboccurrence business--specifically, I'm figuring out
;what the relative increases are going from pre-storm to main phase on both dayside and nightside.

PRO JOURNAL__20160730__SEAS__PROBOCCURRENCE__GET_STATS

  do_bef_nov1999_file       = 1
  use_dartDB__bef_nov1999   = 1

  minI                      = 60
  maxI                      = 85

  print_maxInd_SEA_stats    = 1
  print_maxInd__statType    = 'sum'

  @journal__20160625__plot_defaults.pro

  orbRange                  = [500,12670]

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  histobinsize      = 2.5

  HEMI              = 'NORTH'
  ;; HEMI              = 'SOUTH'

  do_despun         = 0

  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,4180] & histoRange = [0,0.1]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  ;; restrict_altRange = [0340,2000] & histoRange = [0,0.065]
  ;; restrict_altRange = [340,4180] & histoRange = [0,0.1]

  histoRange        = [0,0.1]

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi.png'
  ENDELSE

  ;; probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto' + $
  ;;                         STRING(FORMAT='("--altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])
  probOccPref       = pref + 'PROBOCCURRENCE--with_NOAA--justhisto'

  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn               = savePlotPref+plotSuff
     ;; pT                = 'SEA of 40 storms' + STRING(FORMAT='("(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])
     pT                = 'SEA of 31 storms'

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        RESTRICT_ORBRANGE=orbRange, $
        ;; RESTRICT_ALTRANGE=restrict_altRange, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        USE_DARTDB__BEF_NOV1999=use_dartDB__bef_nov1999, $
        DO_DESPUNDB=do_despun, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=hours_aft, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        MINILAT=minI, $
        MAXILAT=maxI, $
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
        PRINT_MAXIND_SEA_STATS=print_maxInd_SEA_stats, $
        PRINT_MAXIND_SEA__STAT_TYPE=print_maxInd__statType, $
        SAVEPNAME=spn
  ENDFOR

END
