PRO JOURNAL__20151029__SEAS__LOG_AVG_OR_AVG_THESE_QUANTITIES__TELECON20151028

  minM              = 0
  maxM              = 24
  symTransp         = 97   ;default in utcplot as of today, 2015/10/29, is 97
  defRes = 200

  savePlotPref      = STRING(FORMAT='("journal_20151029--alfstorm2_no_noaa--histograms--all_MLTs--",I02,"_",I02,"_MLT--")', $
                             (minM LT 0) ? minM + 24 : minM, $
                             maxM)
  plotSuff          = '.png'
  histoBinSize      = 5.0

  maxInd_arr = [49,14,19,16]
  plotTitle_arr = ['Poynting flux estimate (mW $m^{-1}$)', $
                   'Characteristic Ion Energy (eV)', $
                   'Ion energy flux (units?)', $
                   'Maximum upward ion flux (N $cm^{-3} s^{-1}$']
  plotName_arr  = ['pFlux', $
                   'char_ion_energy', $
                   'ion_eFlux', $
                   'ion_flux_up']
  hRange_arr    = [[5e-5,1e-1], $ ;5e-5
                   [3e-6,3e-1], $ ;
                   [2,4e2], $
                   [1e5,1e10]]
  binsize_arr   = [1e-3, $
                   5e-4, $
                   2, $
                   1e7]
  ;; logbinsize_arr= MAKE_ARRAY(N_ELEMENTS(maxInd_arr),VALUE=ALOG10(3))
  logbinsize_arr= MAKE_ARRAY(N_ELEMENTS(maxInd_arr),VALUE=0.2)

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime

  good_i = GET_CHASTON_IND(maximus,'OMNI',/BOTH_HEMIS)

  ;; FOR i=0,N_ELEMENTS(maxInd_arr)-1 DO BEGIN
     mInd = maxInd_arr[i]
     pT   = plotTitle_arr[i]
     pN   = 'h' + plotName_arr[i]
     hR   = hRange_arr[*,i]
     spN  = savePlotPref + pN + plotSuff
     slpN  = savePlotPref + pN + 'log' + plotSuff

     dat  = maximus.(mInd)[good_i]
     bs   = binsize_arr[i]
     lbs  = logbinsize_arr[i]

     h    = histogram(dat, $
                      BINSIZE=bs, $
                      MAX=hR[1], $
                      MIN=hR[0], $
                      LOCATIONS=hB)

     lh   = histogram(ALOG10(ABS(dat)), $
                      BINSIZE=lbs, $
                      MAX=ALOG10(hR[1]), $
                      MIN=ALOG10(hR[0]), $
                      LOCATIONS=lHB)
                          
     ;;;;;;;;;;;;;;;;;;
     ;;Nå for dem plots
     p    = plot(hB,h, $
                 /HISTOGRAM, $
                 TITLE="Histogram", $
                 XTITLE=pT, $
                 YTITLE='Count', $
                 NAME=pN)

     lp   = plot(lHB,lh, $
                 /HISTOGRAM, $
                 TITLE="Log histogram", $
                 XTITLE='Log ' + pT, $
                 YTITLE='Count', $
                 NAME='log_'+pN)

     p.save,spN,RESOLUTION=defRes
     lp.save,slpN,RESOLUTION=defRes

  ;; ENDFOR



END