PRO JOURNAL__20151028__FIG3__SEAS_ALL_MLTS__ALFSTORM2

  savePlotPref = 'alfstorm2--Fig_3--SEA--'
  plotSuff          = '.png'
  histoBinSize      = 5.0

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  maxInd_arr = [49,14,19,16]
  plotTitle_arr = ['Poynting flux estimate (mW $m^{-1}$)', $
                   'Characteristic Ion Energy (eV)', $
                   'Ion energy flux (units?)', $
                   'Maximum upward ion flux (N $cm^{-3} s^{-1}$']
  plotName_arr  = ['pFlux', $
                   'char_ion_energy', $
                   'ion_eFlux', $
                   'ion_flux_up']
  plotRange_arr = [[5e-5,1e-1], $ ;5e-5
                   [3e-6,3e-1], $ ;
                   [2,4e2], $
                   [1e5,1e10]]
  ;; maxInd = 49 ;Poynting flux estimate
  ;; maxInd = 19 ;char ion energy
  ;; maxInd = 14 ;ion_energy_flux
  ;; maxInd = 16 ;ion_energy_flux

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR i=0,N_ELEMENTS(maxInd_arr)-1 DO BEGIN
     mInd = maxInd_arr[i]
     pT = plotTitle_arr[i]
     pN = plotName_arr[i]
     pR = plotRange_arr[*,i]
     spN  = savePlotPref + pN + '--log' + plotSuff
     SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                         /USE_DARTDB_START_ENDDATE,STORMTYPE=1,/REMOVE_DUPES,/NOGEOMAGPLOTS, $
                                         MAXIND=mInd, $
                                         AVG_TYPE_MAXIND=2, $ ;log avg
                                         YRANGE_MAXIND=pR, $
                                         YTITLE_MAXIND=pT, $
                                         /LOG_DBQUANTITY, $
                                         HISTOBINSIZE=histoBinSize, $
                                         SAVEMAXPLOTNAME=spN
  ENDFOR
END