;;2016/03/12 Using outputted gross rates from the other file, we're now going to take a look at just how awesome storm time really is
PRO JOURNAL__20160312__COMPARING_GROSS_RATES_DURING_STORMPHASES


  names       = ['up_ions','electron_precip','pflux']

  ;;First, what are the relative proportions of time in each storm phase?
  ;;(From Table 1)
  phases      = ['NON-STORM','MAIN','RECOVERY']
  ratios      = [.691,.133,.176]

  ;;After having been log-averaged by n events
  elec_dayRates       = [ 42909.9,595588.,1.61977E+06]
  pflux_dayRates      = [195634.,1.12212E+06,945613.]
  ion_dayRates        = [1.65207E+19,3.99474E+20,1.16503E+20]

  elec_nightRates     = [27692.4,419258.,183860]
  pflux_nightRates    = [173642.,928184.,388376.]
  ion_nightRates      = [6.18476E+18,9.42991E+19,3.43980E+19]


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;done properly
  ;;FOR DESPUN DATABASE, WITH WIDTH_T UPPER LIMIT AT 2.5 s AS OF 2016/03/14
  elec_dayRates           = [4.26227E+07, 3.78223E+08, 3.93091E+08]
  pflux_dayRates          = [2.93000E+08, 1.68084E+09, 7.54956E+08]
  ion_dayRates            = [8.69190E+22, 5.31678E+23, 2.55122E+23]

  elec_nightRates         = [5.53654E+07, 2.85447E+08, 1.31137E+08]
  pflux_nightRates        = [3.05986E+08, 1.45478E+09, 4.55506E+08]
  ion_nightRates          = [4.50073E+22, 2.43460E+23, 3.94174E+22]

  elec_netRates           = elec_dayRates + elec_nightRates
  pflux_netRates          = pflux_dayRates + pflux_nightRates
  ion_netRates            = ion_dayRates + ion_nightRates

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;normed
  elec_dayRatesNorm       = elec_dayRates*ratios/TOTAL(elec_dayRates)
  elec_dayRatesNorm       = elec_dayRatesNorm/TOTAL(elec_dayRatesNorm)*100.

  pflux_dayRatesNorm      = pflux_dayRates*ratios/TOTAL(pflux_dayRates)
  pflux_dayRatesNorm      = pflux_dayRatesNorm/TOTAL(pflux_dayRatesNorm)*100.

  ion_dayRatesNorm        = ion_dayRates*ratios/TOTAL(ion_dayRates)
  ion_dayRatesNorm        = ion_dayRatesNorm/TOTAL(ion_dayRatesNorm)*100.

  elec_nightRatesNorm     = elec_nightRates*ratios/TOTAL(elec_nightRates)
  elec_nightRatesNorm     = elec_nightRatesNorm/TOTAL(elec_nightRatesNorm)*100.

  pflux_nightRatesNorm    = pflux_nightRates*ratios/TOTAL(pflux_nightRates)
  pflux_nightRatesNorm    = pflux_nightRatesNorm/TOTAL(pflux_nightRatesNorm)*100.

  ion_nightRatesNorm      = ion_nightRates*ratios/TOTAL(ion_nightRates)
  ion_nightRatesNorm      = ion_nightRatesNorm/TOTAL(ion_nightRatesNorm)*100.

  elec_netRatesNorm       = elec_netRates*ratios/TOTAL(elec_netRates)
  elec_netRatesNorm       = elec_netRatesNorm/TOTAL(elec_netRatesNorm)*100.

  pflux_netRatesNorm      = pflux_netRates*ratios/TOTAL(pflux_netRates)
  pflux_netRatesNorm      = pflux_netRatesNorm/TOTAL(pflux_netRatesNorm)*100.

  ion_netRatesNorm        = ion_netRates*ratios/TOTAL(ion_netRates)
  ion_netRatesNorm        = ion_netRatesNorm/TOTAL(ion_netRatesNorm)*100.


  ;;First, a numbers table
  PRINT,'******************************'
  PRINT,'        Gross rates           '
  PRINT,'******************************'
  PRINT,''
  PRINT,FORMAT='(T10,"Upward ions (#/s)",T30,"L.C. e- precip (kW)",T50,"Poynting flux (kW)")'
  PRINT,'-------------------------------------------------------------------'
  FOR i=0,2 DO BEGIN
     PRINT,phases[i]
     PRINT,'----------'
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"DAYSIDE",ion_dayRates[i],elec_dayRates[i],pflux_dayRates[i]
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"NIGHTSIDE",ion_nightRates[i],elec_nightRates[i],pflux_nightRates[i]
     PRINT,FORMAT='(A0,T10,G15.5,T30,G15.5,T50,G15.5)',"NET",ion_netRates[i],elec_netRates[i],pflux_netRates[i]
     PRINT,''
  ENDFOR
  PRINT,''

  ;;Now percentages weighted by the appropriate time ratio
  PRINT,'*****************************************************'
  PRINT,' Percentage  based on gross rate*(% four-year period)'
  PRINT,'*****************************************************'
  PRINT,''
  PRINT,FORMAT='(T10,"Upward ions",T30,"L.C. e- precip",T50,"Poynting flux")'
  PRINT,'-------------------------------------------------------------------'
  FOR i=0,2 DO BEGIN
     PRINT,phases[i]
     PRINT,'----------'
     PRINT,FORMAT='(A0,T14,F6.3,T30,F6.3,T50,F6.3)',"DAYSIDE",ion_dayRatesNorm[i],elec_dayRatesNorm[i],pflux_dayRatesNorm[i]
     PRINT,FORMAT='(A0,T14,F6.3,T30,F6.3,T50,F6.3)',"NIGHTSIDE",ion_nightRatesNorm[i],elec_nightRatesNorm[i],pflux_nightRatesNorm[i]
     PRINT,FORMAT='(A0,T14,F6.3,T30,F6.3,T50,F6.3)',"NET",ion_netRatesNorm[i],elec_netRatesNorm[i],pflux_netRatesNorm[i]
     PRINT,''
  ENDFOR


END