;;2016/03/15 Using outputted gross rates from the other file, we're now going to take a look at just how awesome storm time really is
PRO JOURNAL__20160315__COMPARING_GROSS_RATES_DURING_STORMPHASES__ALT_FORMAT,HEMI=hemi


  names       = ['up_ions','electron_precip','pflux']
  titles      = ["Upward ions (#/s)","L.C. e- precip (kW)","Poynting flux (kW)"]

  ;;First, what are the relative proportions of time in each storm phase?
  ;;(From Table 1)
  phases      = ['NON-STORM','MAIN','RECOVERY']
  ratios      = [.691,.133,.176]

  IF ~KEYWORD_SET(hemi) THEN BEGIN
     hemi        = 'NORTH'
  ENDIF
  ;; hemi        = 'SOUTH'
  ;; hemi        = 'COMBINED'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Each sitiation (And I do mean sitiation)
  ;;FOR DESPUN DATABASE, WITH WIDTH_T UPPER LIMIT AT 2.5 s AS OF 2016/03/14

  elec_dayRates_S         = [3.37217E+07, 3.05561E+08, 2.57839E+08]
  pflux_dayRates_S        = [1.48817E+08, 1.30877E+09, 7.63675E+08]
  ion_dayRates_S          = [4.98354E+22, 1.22033E+24, 2.08995E+23]

  elec_nightRates_S       = [3.95962E+07, 4.29627E+08, 1.74829E+08]
  pflux_nightRates_S      = [1.67416E+08, 9.19637E+08, 5.67738E+08]
  ion_nightRates_S        = [4.64153E+22, 6.93853E+22, 1.29513E+23]

  ion_dayRates_N          = [8.69190E+22, 5.31678E+23, 2.55122E+23]
  elec_dayRates_N         = [4.26227E+07, 3.78223E+08, 3.93091E+08]
  pflux_dayRates_N        = [2.93000E+08, 1.68084E+09, 7.54956E+08]

  ion_nightRates_N        = [4.50073E+22, 2.43460E+23, 3.94174E+22]
  elec_nightRates_N       = [5.53654E+07, 2.85447E+08, 1.31137E+08]
  pflux_nightRates_N      = [3.05986E+08, 1.45478E+09, 4.55506E+08]


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