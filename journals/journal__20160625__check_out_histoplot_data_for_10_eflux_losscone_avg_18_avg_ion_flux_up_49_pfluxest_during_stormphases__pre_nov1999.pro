;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;EFLUX
;; 
;; ;;DAY
;;  ***   0 : 10_EFLUX_LOSSCONE_INTEG--nonstorm--Dstcutoff_-20***
;;  1996-10- 2000-10-  82727       -0.7781    0.7523    0.2322    0.3163   -0.8133
;;  ***   1 : 10_EFLUX_LOSSCONE_INTEG--mainphase--Dstcutoff_-20***
;;  1996-10- 2000-10-  26326       -0.6818    0.7361    0.1203    0.1049   -0.7042
;;  ***   2 : 10_EFLUX_LOSSCONE_INTEG--recoveryphase--Dstcutoff_-20***
;;  1996-10- 2000-10-  25835       -0.6572    0.7167    0.1504   0.05633   -0.6795
;;  
;; IDL> 10.^(-0.6818)/10.^(-0.7781)
;;        1.2482456
;; 
;; ;;NIGHT
;;  Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;;  ***   0 : 10_EFLUX_LOSSCONE_INTEG--nonstorm--Dstcutoff_-20***
;;  1996-10- 2000-10-  20718       -0.4441    0.8322  -0.04526   0.06943   -0.4420
;;  ***   1 : 10_EFLUX_LOSSCONE_INTEG--mainphase--Dstcutoff_-20***
;;  1996-10- 2000-10-  9550       -0.04317    0.7564   -0.2539    0.2092  -0.01141
;;  ***   2 : 10_EFLUX_LOSSCONE_INTEG--recoveryphase--Dstcutoff_-20***
;;  1996-10- 2000-10-  6677        -0.2597    0.8606   -0.2955    0.2931   -0.2176
;;  Saving plot to /SPENCEdata/Research/Satellites/FAST/storms_Alfvens/plots/20160404/stormphase_histos--overlaid_phases--10_EFLUX_LOSSCONE_INTEG--6.0-18.0--18.0-6.0_MLT.png...
;;  IDL> 10.^(-0.4441)
;;        0.35966653
;;  IDL> 10.^(-0.04317)
;;        0.90537810
;;  IDL> 10.^(-0.04317)/10.^(-0.4441)
;;         2.5172710
;;  
;; 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;IONS
;; 
;; ;;DAY
;; Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;; ***   0 : 18_INTEG_ION_FLUX_UP--nonstorm--Dstcutoff_-20***
;; 1996-10- 2000-10-  81023         6.986     1.184    0.1500   -0.5119     6.917
;; ***   1 : 18_INTEG_ION_FLUX_UP--mainphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  26242         7.027     1.159  -0.08738   -0.6519     7.077
;; ***   2 : 18_INTEG_ION_FLUX_UP--recoveryphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  25689         6.823     1.205    0.1241   -0.6590     6.784
;; ;; 
;; 10.^(7.027)/10.^(6.986)
;;       1.0990056

;; ;;NIGHT
;; Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;; ***   0 : 18_INTEG_ION_FLUX_UP--nonstorm--Dstcutoff_-20***
;; 1996-10- 2000-10-  20257         6.639     1.240    0.2987   -0.4677     6.489
;; ***   1 : 18_INTEG_ION_FLUX_UP--mainphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  9353          6.771     1.166   0.07834   -0.5455     6.716
;; ***   2 : 18_INTEG_ION_FLUX_UP--recoveryphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  6628          6.396     1.139    0.4279   -0.2321     6.215

;; IDL> 10.^(6.771)/10.^(6.639)
;;        1.3551893
;; ;; 

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;PFLUX
;; 
;; ;;DAY
;; Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;; ***   0 : 49_PFLUXEST--nonstorm--Dstcutoff_-20***
;; 1996-10- 2000-10-  82729       -0.1640    0.5196    0.8452     1.498   -0.2381
;; ***   1 : 49_PFLUXEST--mainphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  26327       0.07217    0.6241    0.5884    0.1747  0.004619
;; ***   2 : 49_PFLUXEST--recoveryphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  25835      -0.04834    0.5928    0.7123    0.5589   -0.1342
;; 10.^(0.07217)/10.^(-0.1640)
;;     1.7225428

;; ;;NIGHT
;; Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;; ***   0 : 49_PFLUXEST--nonstorm--Dstcutoff_-20***
;; 1996-10- 2000-10-  20719        0.1639    0.6978    0.6140    0.6291   0.09549
;; ***   1 : 49_PFLUXEST--mainphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  9551         0.2641    0.7321    0.5766  -0.06458    0.1777
;; ***   2 : 49_PFLUXEST--recoveryphase--Dstcutoff_-20***
;; 1996-10- 2000-10-  6677        0.07489    0.6601    0.6895    0.3385  -0.01702;; Low (hr) High (hr) N         Mean      Std. dev. Skewness  Kurtosis  Median
;; 10.^(0.2641)/10.^(.1639)
;;        1.2595052
;; 

PRO JOURNAL__20160625__CHECK_OUT_HISTPLOT_DATA_FOR_10_EFLUX_LOSSCONE_AVG_18_AVG_ION_FLUX_UP_49_PFLUXEST_DURING_STORMPHASES__PRE_NOV1999

  RESTORE,'/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/journals/20160625--stormphase_histo_data--10_EFLCI_18_IIFU_49_PFE/20160625--stormphase_histos--overlaid_phases--49_49_PFLUXEST--6.0-18.0--18.0-6.0_MLT.sav'
  ;dayside pFlux

  PRINT,'*Dayside*'
  PRINT_EPOCHSLICE_STRUCT_STATS,saved_ssa_list[0]
  PRINT_EPOCHSLICE_STRUCT_STATS,saved_ssa_list[0],/PRINT_UNLOGGED
  PRINT,''

  PRINT,'*Nightside*'
  PRINT_EPOCHSLICE_STRUCT_STATS,saved_ssa_list[1]
  PRINT_EPOCHSLICE_STRUCT_STATS,saved_ssa_list[1],/PRINT_UNLOGGED
  PRINT,''

  PRINT,saved_ssa_list[0,1].yhiststr[0].locs[0,30]
  side                   = 1 
  stormphase             = 1 
  PLOT                   = PLOT(saved_ssa_list[side,stormphase].yhiststr[0].locs[0], $
              saved_ssa_list[side,stormphase].yhiststr[0].hist[0], $
              /HISTOGRAM)
  
  ;;Get bins
  day_bins_ns            = saved_ssa_list[0,0].yhiststr[0].locs[0]
  night_bins_ns          = saved_ssa_list[1,0].yhiststr[0].locs[0]
  
  day_bins_mp            = saved_ssa_list[0,1].yhiststr[0].locs[0]
  night_bins_mp          = saved_ssa_list[1,1].yhiststr[0].locs[0]
  
  day_bins_rp            = saved_ssa_list[0,2].yhiststr[0].locs[0]
  night_bins_rp          = saved_ssa_list[1,2].yhiststr[0].locs[0]
  
  test_dnbins_ns         = day_bins_ns-night_bins_ns
  test_dnbins_mp         = day_bins_mp-night_bins_mp
  test_dnbins_rp         = day_bins_rp-night_bins_rp
  test_ddbins_nsmp       = day_bins_ns-day_bins_mp
  test_ddbins_nsrp       = day_bins_ns-day_bins_rp
  test_ddbins_mprp       = day_bins_mp-day_bins_rp
  test_nnbins_nsmp       = day_bins_ns-day_bins_mp
  test_nnbins_nsrp       = day_bins_ns-day_bins_rp
  test_nnbins_mprp       = day_bins_mp-day_bins_rp

  ;;The above are all zeroes, so we don't need separate inds for all phases
  ;;See text and end of PRO for code, if you want it

  ;;Get indices
  dayInd_above_1_ns      = MIN(WHERE(day_bins_ns GE 0.0))
  nightInd_above_1_ns    = MIN(WHERE(night_bins_ns GE 0.0))
  
  ;;Above 5
  dayInd_above_5_ns      = MIN(WHERE(day_bins_ns GE 0.69))
  nightInd_above_5_ns    = MIN(WHERE(night_bins_ns GE 0.69))
  
  ;;Above 10
  dayInd_above_10_ns     = MIN(WHERE(day_bins_ns GE 1.0))
  nightInd_above_10_ns   = MIN(WHERE(night_bins_ns GE 1.0))
  
  ;;Above 50
  dayInd_above_50_ns     = MIN(WHERE(day_bins_ns GE 1.69))
  nightInd_above_50_ns   = MIN(WHERE(night_bins_ns GE 1.69))
  
  ;;Above 100
  dayInd_above_100_ns    = MIN(WHERE(day_bins_ns GE 2.0))
  nightInd_above_100_ns  = MIN(WHERE(night_bins_ns GE 2.0))
  

  ;;Get histos
  dayPFlux_ns_hist       = saved_ssa_list[0,0].yhiststr[0].hist[0]
  nightPFlux_ns_hist     = saved_ssa_list[1,0].yhiststr[0].hist[0]
  
  dayPFlux_mp_hist       = saved_ssa_list[0,1].yhiststr[0].hist[0]
  nightPFlux_mp_hist     = saved_ssa_list[1,1].yhiststr[0].hist[0]
  
  dayPFlux_rp_hist       = saved_ssa_list[0,2].yhiststr[0].hist[0]
  nightPFlux_rp_hist     = saved_ssa_list[1,2].yhiststr[0].hist[0]
  


  ;;Totals
  daytotal_ns            = TOTAL(dayPFlux_ns_hist)
  nighttotal_ns          = TOTAL(nightPFlux_ns_hist)
  
  daytotal_mp            = TOTAL(dayPFlux_mp_hist)
  nighttotal_mp          = TOTAL(nightPFlux_mp_hist)
  
  daytotal_rp            = TOTAL(dayPFlux_rp_hist)
  nighttotal_rp          = TOTAL(nightPFlux_rp_hist)
  
  dayfracabove1          = TOTAL(dayPFlux_rp_hist[dayind_above_1_ns:*])/daytotal
  nightfracabove1        = TOTAL(nightPFlux_rp_hist[dayind_above_1_ns:*])/nighttotal
  
  dayfracabove5          = TOTAL(dayPFlux_rp_hist[dayind_above_5_ns:*])/daytotal
  nightfracabove5        = TOTAL(nightPFlux_rp_hist[dayind_above_5_ns:*])/nighttotal
  
  dayfracabove10         = TOTAL(dayPFlux_rp_hist[dayind_above_10_ns:*])/daytotal
  nightfracabove10       = TOTAL(nightPFlux_rp_hist[dayind_above_10_ns:*])/nighttotal
  
  dayfracabove50         = TOTAL(dayPFlux_rp_hist[dayind_above_50_ns:*])/daytotal
  nightfracabove50       = TOTAL(nightPFlux_rp_hist[dayind_above_50_ns:*])/nighttotal
  
  dayfracabove100        = TOTAL(dayPFlux_rp_hist[dayind_above_100_ns:*])/daytotal
  nightfracabove100      = TOTAL(nightPFlux_rp_hist[dayind_above_100_ns:*])/nighttotal

END


  ;; ;;Get indices
  ;; dayInd_above_1_ns      = MIN(WHERE(day_bins_ns GE 2.0))
  ;; nightInd_above_1_ns    = MIN(WHERE(night_bins_ns GE 2.0))
  
  ;; dayInd_above_1_mp      = MIN(WHERE(day_bins_mp GE 2.0))
  ;; nightInd_above_1_mp    = MIN(WHERE(night_bins_mp GE 2.0))
  
  ;; dayInd_above_1_rp      = MIN(WHERE(day_bins_rp GE 2.0))
  ;; nightInd_above_1_rp    = MIN(WHERE(night_bins_rp GE 2.0))
  
  ;; ;;Above 5
  ;; dayInd_above_5_ns      = MIN(WHERE(day_bins_ns GE 2.0))
  ;; nightInd_above_5_ns    = MIN(WHERE(night_bins_ns GE 2.0))
  
  ;; dayInd_above_5_mp      = MIN(WHERE(day_bins_mp GE 2.0))
  ;; nightInd_above_5_mp    = MIN(WHERE(night_bins_mp GE 2.0))
  
  ;; dayInd_above_5_rp      = MIN(WHERE(day_bins_rp GE 2.0))
  ;; nightInd_above_5_rp    = MIN(WHERE(night_bins_rp GE 2.0))
  
  ;; ;;Above 10
  ;; dayInd_above_10_ns     = MIN(WHERE(day_bins_ns GE 2.0))
  ;; nightInd_above_10_ns   = MIN(WHERE(night_bins_ns GE 2.0))
  
  ;; dayInd_above_10_mp     = MIN(WHERE(day_bins_mp GE 2.0))
  ;; nightInd_above_10_mp   = MIN(WHERE(night_bins_mp GE 2.0))
  
  ;; dayInd_above_10_rp     = MIN(WHERE(day_bins_rp GE 2.0))
  ;; nightInd_above_10_rp   = MIN(WHERE(night_bins_rp GE 2.0))
  
  ;; ;;Above 50
  ;; dayInd_above_50_ns     = MIN(WHERE(day_bins_ns GE 2.0))
  ;; nightInd_above_50_ns   = MIN(WHERE(night_bins_ns GE 2.0))
  
  ;; dayInd_above_50_mp     = MIN(WHERE(day_bins_mp GE 2.0))
  ;; nightInd_above_50_mp   = MIN(WHERE(night_bins_mp GE 2.0))
  
  ;; dayInd_above_50_rp     = MIN(WHERE(day_bins_rp GE 2.0))
  ;; nightInd_above_50_rp   = MIN(WHERE(night_bins_rp GE 2.0))
  
  ;; ;;Above 100
  ;; dayInd_above_100_ns    = MIN(WHERE(day_bins_ns GE 2.0))
  ;; nightInd_above_100_ns  = MIN(WHERE(night_bins_ns GE 2.0))
  
  ;; dayInd_above_100_mp    = MIN(WHERE(day_bins_mp GE 2.0))
  ;; nightInd_above_100_mp  = MIN(WHERE(night_bins_mp GE 2.0))
  
  ;; dayInd_above_100_rp    = MIN(WHERE(day_bins_rp GE 2.0))
  ;; nightInd_above_100_rp  = MIN(WHERE(night_bins_rp GE 2.0))
  

