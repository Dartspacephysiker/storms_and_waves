;;2016/03/17 There was the slightest bug in my definition of main phase; it should have been events for which delta-Dst is LE 0, not LT 0
PRO JOURNAL__20160317__COMPARING_GROSS_RATES_DURING_STORMPHASES__FIXED_MAINPHASE_DEF,HEMI=hemi


  names       = ['up_ions','electron_precip','pflux']
  titles      = ["Upward ions (#/s)","L.C. e- precip (kW)","Poynting flux (kW)"]

  ;;First, what are the relative proportions of time in each storm phase?
  ;;(From Table 1)
  phases      = ['NON-STORM','MAIN','RECOVERY']
  ratios      = [.6716,.1416,.1868]

  IF ~KEYWORD_SET(hemi) THEN BEGIN
     hemi        = 'NORTH'
  ENDIF
  ;; hemi        = 'SOUTH'
  ;; hemi        = 'COMBINED'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Each sitiation (And I do mean sitiation)
  ;;FOR DESPUN DATABASE, WITH WIDTH_T UPPER LIMIT AT 2.5 s AS OF 2016/03/14

  elec_dayRates_S         = [1.06913E+08, 8.91511E+08, 6.38874E+08]
  pflux_dayRates_S        = [1.44937E+08, 2.10216E+09, 7.55678E+08]
  ion_dayRates_S          = [1.44910E+23, 3.97365E+24, 6.16879E+23]

  elec_nightRates_S       = [1.42842E+08, 1.44263E+09, 6.68246E+08]
  pflux_nightRates_S      = [1.45898E+08, 1.21288E+09, 5.97437E+08]
  ion_nightRates_S        = [1.62834E+23, 2.34763E+23, 4.48902E+23]

  elec_dayRates_N         = [1.63214E+08, 1.09160E+09, 9.48953E+08]
  pflux_dayRates_N        = [3.85926E+08, 2.38552E+09, 9.84860E+08]
  ion_dayRates_N          = [3.36656E+23, 1.68954E+24, 6.52536E+23]

  elec_nightRates_N       = [1.96354E+08, 9.92705E+08, 4.35238E+08]
  pflux_nightRates_N      = [3.61001E+08, 2.10689E+09, 6.05361E+08]
  ion_nightRates_N        = [1.94787E+23, 8.81453E+23, 1.68190E+23]


  CASE 1 OF
     STRUPCASE(hemi) EQ 'NORTH':BEGIN
        ion_dayRates      = ion_dayRates_N    
        elec_dayRates     = elec_dayRates_N   
        pflux_dayRates    = pflux_dayRates_N  
                                              
        ion_nightRates    = ion_nightRates_N  
        elec_nightRates   = elec_nightRates_N 
        pflux_nightRates  = pflux_nightRates_N
     END
     STRUPCASE(hemi) EQ 'SOUTH':BEGIN
        ion_dayRates      = ion_dayRates_S    
        elec_dayRates     = elec_dayRates_S   
        pflux_dayRates    = pflux_dayRates_S  
                                              
        ion_nightRates    = ion_nightRates_S  
        elec_nightRates   = elec_nightRates_S 
        pflux_nightRates  = pflux_nightRates_S
     END
     STRUPCASE(hemi) EQ 'COMBINED':BEGIN
        ion_dayRates      = ion_dayRates_S + ion_dayRates_N
        elec_dayRates     = elec_dayRates_S + elec_dayRates_N
        pflux_dayRates    = pflux_dayRates_S + pflux_dayRates_N
                                              
        ion_nightRates    = ion_nightRates_S + ion_nightRates_N
        elec_nightRates   = elec_nightRates_S + elec_nightRates_N
        pflux_nightRates  = pflux_nightRates_S + pflux_nightRates_N
     END
  ENDCASE

  ion_netRates            = ion_dayRates + ion_nightRates
  elec_netRates           = elec_dayRates + elec_nightRates
  pflux_netRates          = pflux_dayRates + pflux_nightRates

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;normed, with storm rates as last index
  ;;DAY
  ion_dayPercent        = ion_dayRates*ratios/TOTAL(ion_dayRates*ratios)*100.
  ion_dayPercent        = [ion_dayPercent,ion_dayPercent[1]+ion_dayPercent[2]]

  elec_dayPercent       = elec_dayRates*ratios/TOTAL(elec_dayRates*ratios)*100.
  elec_dayPercent       = [elec_dayPercent,elec_dayPercent[1]+elec_dayPercent[2]]

  pflux_dayPercent      = pflux_dayRates*ratios/TOTAL(pflux_dayRates*ratios)*100.
  pflux_dayPercent      = [pflux_dayPercent,pflux_dayPercent[1]+pflux_dayPercent[2]]

  ;;NIGHT
  ion_nightPercent      = ion_nightRates*ratios/TOTAL(ion_nightRates*ratios)*100.
  ion_nightPercent      = [ion_nightPercent,ion_nightPercent[1]+ion_nightPercent[2]]

  elec_nightPercent     = elec_nightRates*ratios/TOTAL(elec_nightRates*ratios)*100.
  elec_nightPercent     = [elec_nightPercent,elec_nightPercent[1]+elec_nightPercent[2]]

  pflux_nightPercent    = pflux_nightRates*ratios/TOTAL(pflux_nightRates*ratios)*100.
  pflux_nightPercent    = [pflux_nightPercent,pflux_nightPercent[1]+pflux_nightPercent[2]]

  ;NET
  ion_netPercent        = ion_netRates*ratios/TOTAL(ion_netRates*ratios)*100.
  ion_netPercent        = [ion_netPercent,ion_netPercent[1]+ion_netPercent[2]]

  elec_netPercent       = elec_netRates*ratios/TOTAL(elec_netRates*ratios)*100.
  elec_netPercent       = [elec_netPercent,elec_netPercent[1]+elec_netPercent[2]]

  pflux_netPercent      = pflux_netRates*ratios/TOTAL(pflux_netRates*ratios)*100.
  pflux_netPercent      = [pflux_netPercent,pflux_netPercent[1]+pflux_netPercent[2]]


  ;;LISTS
  dayRateList           = LIST(ion_dayRates,elec_dayRates,pflux_dayRates)
  nightRateList         = LIST(ion_nightRates,elec_nightRates,pflux_nightRates)
  netRateList           = LIST(ion_netRates,elec_netRates,pflux_netRates)
  
  dayPercList           = LIST(ion_dayPercent,elec_dayPercent,pflux_dayPercent)
  nightPercList         = LIST(ion_nightPercent,elec_nightPercent,pflux_nightPercent)
  netPercList           = LIST(ion_netPercent,elec_netPercent,pflux_netPercent)

  ;;First, a numbers table
  PRINT,'******************************'
  PRINT,' Gross rates (HEMI: ' + hemi + ')'
  PRINT,'******************************'
  PRINT,''
  PRINT,FORMAT='(T15,"Non-storm",T35,"Main phase",T55,"Recovery phase")'
  PRINT,'--------------------------------------------------------------------'
  FOR i=0,2 DO BEGIN
     PRINT,titles[i]
     PRINT,'-------------------'
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"DAYSIDE",dayRateList[i,0],dayRateList[i,1],dayRateList[i,2]
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"NIGHTSIDE",nightRateList[i,0],nightRateList[i,1],nightRateList[i,2]
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"NET",netRateList[i,0],netRateList[i,1],netRateList[i,2]
     PRINT,''
  ENDFOR
  PRINT,''

  ;;Now percentages weighted by the appropriate time ratio
  PRINT,'*****************************************************'
  PRINT,' Percentage  based on gross rate*(% four-year period)'
  PRINT,'*****************************************************'
  PRINT,''
  PRINT,FORMAT='(T15,"Non-storm",T35,"Main phase",T55,"Recovery phase",T75,"Storm comb.")'
  PRINT,'-------------------------------------------------------------------------------------'
  FOR i=0,2 DO BEGIN
     PRINT,titles[i]
     PRINT,'-------------------'
     PRINT,FORMAT='(A0,T15,F6.3,T35,F6.3,T55,F6.3,T75,F6.3)',"DAYSIDE",dayPercList[i,0],dayPercList[i,1],dayPercList[i,2],dayPercList[i,3]
     PRINT,FORMAT='(A0,T15,F6.3,T35,F6.3,T55,F6.3,T75,F6.3)',"NIGHTSIDE",nightPercList[i,0],nightPercList[i,1],nightPercList[i,2],nightPercList[i,3]
     PRINT,FORMAT='(A0,T15,F6.3,T35,F6.3,T55,F6.3,T75,F6.3)',"NET",netPercList[i,0],netPercList[i,1],netPercList[i,2],netPercList[i,3]
     PRINT,''
  ENDFOR

END