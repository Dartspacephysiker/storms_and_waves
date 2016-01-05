;I've got this idea that it might be cool to see how the ratios of the two peaks on the nightside distributions decrease 
; with storm phase. Let's have a look! 
;-->The conclusion is this:
;; Ratio of distributions halves: 
;; nonstorm, main, recovery
;;      0.570715     0.654589     0.389596
;; Ratio of peaks: 
;; nonstorm, main, recovery
;;      0.729527     0.852038     0.594822
;;-->So the rate of intense oxygen outflow actually decreases on the whole
PRO JOURNAL__20160105__HISTOPLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES__OVERLAID_PHASES__PART2__EXPLORE_DATA


  dataName                = '18-INTEG_ION_FLUX_UP'
  saveDir                 = '/SPENCEdata/Research/Cusp/storms_Alfvens/temp/'
  saveFile                = saveDir + 'journal__20160105--histoplot_data--'+dataName+'.sav'

  restore,saveFile        

  nightDists              = saved_ssa_list[1]
  ;; dayDists               = saved_ssa_list[0]

  structs                 = !NULL
  hists                   = !NULL
  FOR i=0,2 DO BEGIN
     structs              = [structs,nightDists[i].yhiststr[0]]
     hists                = [[hists],[nightDists[i].yhiststr[0].hist[0]]]
  ENDFOR
  locs                    = structs[0].locs[0]

  ns_ns_max1              = max(hists[*,0],ns_ns_ind1)         ;first nightside non-storm max
  ns_ns_max2              = max(hists[ns_ns_ind1+4:-1,0],ns_ns_ind2) ;second
  ns_ns_ind2              = ns_ns_ind1+4+ns_ns_ind2

  ;; print,locs
  histInds_l              = [ns_ns_ind1-1:ns_ns_ind1+1]
  histInds_h              = [ns_ns_ind2-1:ns_ns_ind2+1]

  mid                     = N_ELEMENTS(locs)/2+1
  midVal                  = locs[mid]
  histInds_lHalf          = WHERE(locs LT midVal)
  histInds_uHalf          = WHERE(locs GT midVal)

  totArr_l                = !NULL
  totArr_h                = !NULL
  peakTotArr_l            = !NULL
  peakTotArr_h            = !NULL
  lh_ratioArr             = !NULL
  lh_peakRatioArr         = !NULL

  FOR i=0,2 DO BEGIN
     totArr_l             = [totArr_l,TOTAL(hists[histInds_lHalf,i])]
     totArr_h             = [totArr_h,TOTAL(hists[histInds_uHalf,i])]
     peakTotArr_l         = [peakTotArr_l,TOTAL(hists[histInds_l,i])]
     peakTotArr_h         = [peakTotArr_h,TOTAL(hists[histInds_h,i])]

     lh_ratioArr          = [lh_ratioArr,totArr_h[i]/totArr_l[i]]
     lh_peakRatioArr      = [lh_peakRatioArr,peakTotArr_h[i]/peakTotArr_l[i]]
  ENDFOR

  print,'Ratio of distributions halves: '
  print,'nonstorm, main, recovery'
  print,lh_ratioArr
  print,'Ratio of peaks: '
  print,'nonstorm, main, recovery'
  print,lh_peakRatioArr

END