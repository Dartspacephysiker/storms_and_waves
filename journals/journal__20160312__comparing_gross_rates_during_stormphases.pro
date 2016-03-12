;;2016/03/12 Using outputted gross rates from the other file, we're now going to take a look at just how awesome storm time really is
PRO JOURNAL__20160312__COMPARING_GROSS_RATES_DURING_STORMPHASES


  names       = ['up_ions','electron_precip','pflux']

  ;;First, what are the relative proportions of time in each storm phase?
  ;;(From Table 1)
  phases      = ['nonstorm','main','recovery']
  ratios      = [.691,.133,.176]

  ;;After having been log-averaged by n events
  elec_dayRates       = [ 42909.9,595588.,1.61977E+06]
  pflux_dayRates      = [195634.,1.12212E+06,945613.]
  ion_dayRates        = [1.65207E+19,3.99474E+20,1.16503E+20]

  elec_nightRates     = [27692.4,419258.,183860]
  pflux_nightRates    = [173642.,928184.,388376.]
  ion_nightRates      = [6.18476E+18,9.42991E+19,3.43980E+19]



  ;;done properly
  elec_dayRates           = [4.09943E+08, 3.61975E+08, 9.50122E+09]
  pflux_dayRates          = [7.45971E+08, 1.48619E+09, 3.08697E+08]
  ion_dayRates            = [2.56688E+23, 6.31104E+23, 2.15522E+25]

  elec_nightRates         = [1.15131E+08, 3.02612E+08, 5.63667E+07]
  pflux_nightRates        = [5.47625E+08, 1.66151E+09, 3.25556E+08]
  ion_nightRates          = [3.92495E+22, 1.44182E+23, 5.24504E+22]

  elec_netRates           = elec_dayRates + elec_nightRates
  pflux_netRates          = pflux_dayRates + pflux_nightRates
  ion_netRates            = ion_dayRates + ion_nightRates

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;normed
  elec_dayRatesNorm       = elec_dayRates*ratios/TOTAL(elec_dayRates)
  elec_dayRatesNorm       = elec_dayRatesNorm/TOTAL(elec_dayRatesNorm)

  pflux_dayRatesNorm      = pflux_dayRates*ratios/TOTAL(pflux_dayRates)
  pflux_dayRatesNorm      = pflux_dayRatesNorm/TOTAL(pflux_dayRatesNorm)

  ion_dayRatesNorm        = ion_dayRates*ratios/TOTAL(ion_dayRates)
  ion_dayRatesNorm        = ion_dayRatesNorm/TOTAL(ion_dayRatesNorm)

  elec_nightRatesNorm     = elec_nightRates*ratios/TOTAL(elec_nightRates)
  elec_nightRatesNorm     = elec_nightRatesNorm/TOTAL(elec_nightRatesNorm)

  pflux_nightRatesNorm    = pflux_nightRates*ratios/TOTAL(pflux_nightRates)
  pflux_nightRatesNorm    = pflux_nightRatesNorm/TOTAL(pflux_nightRatesNorm)

  ion_nightRatesNorm      = ion_nightRates*ratios/TOTAL(ion_nightRates)
  ion_nightRatesNorm      = ion_nightRatesNorm/TOTAL(ion_nightRatesNorm)

  elec_netRatesNorm       = elec_netRates*ratios/TOTAL(elec_netRates)
  elec_netRatesNorm       = elec_netRatesNorm/TOTAL(elec_netRatesNorm)

  pflux_netRatesNorm      = pflux_netRates*ratios/TOTAL(pflux_netRates)
  pflux_netRatesNorm      = pflux_netRatesNorm/TOTAL(pflux_netRatesNorm)

  ion_netRatesNorm        = ion_netRates*ratios/TOTAL(ion_netRates)
  ion_netRatesNorm        = ion_netRatesNorm/TOTAL(ion_netRatesNorm)

  ;; FOR i=0,2 DO BEGIN

     PRINT,


END