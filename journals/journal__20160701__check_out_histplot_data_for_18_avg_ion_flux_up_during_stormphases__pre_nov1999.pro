PRO JOURNAL__20160701__CHECK_OUT_HISTPLOT_DATA_FOR_18_AVG_ION_FLUX_UP_DURING_STORMPHASES__PRE_NOV1999

  RESTORE,'/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/journals/20160625--stormphase_histo_data--10_EFLCI_18_IIFU_49_PFE/20160625--stormphase_histos--overlaid_phases--18_18_INTEG_ION_FLUX_UP--6.0-18.0--18.0-6.0_MLT.sav'
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
  dayIF_ns_hist       = saved_ssa_list[0,0].yhiststr[0].hist[0]
  nightIF_ns_hist     = saved_ssa_list[1,0].yhiststr[0].hist[0]
  
  dayIF_mp_hist       = saved_ssa_list[0,1].yhiststr[0].hist[0]
  nightIF_mp_hist     = saved_ssa_list[1,1].yhiststr[0].hist[0]
  
  dayIF_rp_hist       = saved_ssa_list[0,2].yhiststr[0].hist[0]
  nightIF_rp_hist     = saved_ssa_list[1,2].yhiststr[0].hist[0]
  

  ;;Where's the peak?
  bigN_ns                = MAX(dayiF_ns_hist,ind_ns)
  maxBin_ns              = day_bins_ns[ind_ns]
  ;; maxBin                 = 10.^day_bins_ns[ind]
  bigN_mp                = MAX(dayiF_mp_hist,ind_mp)
  maxBin_mp              = day_bins_mp[ind_mp]

  bigN_rp                = MAX(dayiF_rp_hist,ind_rp)
  maxBin_rp              = day_bins_rp[ind_rp]

  ;;Totals
  daytotal_ns            = TOTAL(dayIF_ns_hist)
  nighttotal_ns          = TOTAL(nightIF_ns_hist)
  
  daytotal_mp            = TOTAL(dayIF_mp_hist)
  nighttotal_mp          = TOTAL(nightIF_mp_hist)
  
  daytotal_rp            = TOTAL(dayIF_rp_hist)
  nighttotal_rp          = TOTAL(nightIF_rp_hist)
  
  dayfracabove1          = TOTAL(dayIF_rp_hist[dayind_above_1_ns:*])/daytotal
  nightfracabove1        = TOTAL(nightIF_rp_hist[dayind_above_1_ns:*])/nighttotal
  
  dayfracabove5          = TOTAL(dayIF_rp_hist[dayind_above_5_ns:*])/daytotal
  nightfracabove5        = TOTAL(nightIF_rp_hist[dayind_above_5_ns:*])/nighttotal
  
  dayfracabove10         = TOTAL(dayIF_rp_hist[dayind_above_10_ns:*])/daytotal
  nightfracabove10       = TOTAL(nightIF_rp_hist[dayind_above_10_ns:*])/nighttotal
  
  dayfracabove50         = TOTAL(dayIF_rp_hist[dayind_above_50_ns:*])/daytotal
  nightfracabove50       = TOTAL(nightIF_rp_hist[dayind_above_50_ns:*])/nighttotal
  
  dayfracabove100        = TOTAL(dayIF_rp_hist[dayind_above_100_ns:*])/daytotal
  nightfracabove100      = TOTAL(nightIF_rp_hist[dayind_above_100_ns:*])/nighttotal

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
  

