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
;;  Saving plot to /SPENCEdata/Research/Cusp/storms_Alfvens/plots/20160404/stormphase_histos--overlaid_phases--10_EFLUX_LOSSCONE_INTEG--6.0-18.0--18.0-6.0_MLT.png...
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
RESTORE,'/SPENCEdata/Research/Cusp/storms_Alfvens/journals/20160404--stormphase_histo_data--10_EFLCI_18_IIFU_49_PFE/20160404--stormphase_histos--overlaid_phases--49_49_PFLUXEST--6.0-18.0--18.0-6.0_MLT.sav'
;dayside pFlux
print,saved_ssa_list[0,1].yhiststr[0].locs[0,30]
side = 0 
stormphase = 1 
plot=plot(saved_ssa_list[side,stormphase].yhiststr[0].locs[0],saved_ssa_list[0,stormphase].yhiststr[0].hist[0],/HISTOGRAM)


daytotal = TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0])
nighttotal = TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0])

dayfracabove1=TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0,20:*])/daytotal
nightfracabove1=TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0,20:*])/nighttotal

dayfracabove5=TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0,27:*])/daytotal
nightfracabove5=TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0,27:*])/nighttotal

dayfracabove10=TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0,30:*])/daytotal
nightfracabove10=TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0,30:*])/nighttotal

dayfracabove50=TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0,37:*])/daytotal
nightfracabove50=TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0,37:*])/nighttotal

dayfracabove100=TOTAL(saved_ssa_list[0,2].yhiststr[0].hist[0,40:*])/daytotal
nightfracabove100=TOTAL(saved_ssa_list[1,2].yhiststr[0].hist[0,40:*])/nighttotal