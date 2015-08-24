;2015/08/15
;Redoing all these thangs with Brett's storm DB and the NOAA database of sudden storm commencements COMBINED, bro

;;2015/08/17
;;I totally hosed it. I should have redone this with the new stormtimes, for crying out loud, and not grabbed
;;all events, but just those corresponding to the biggest stormtimes (i.e., 0 hours before to 20 hours after).
;;See journal file 'JOURNAL__20150817__get_hours_0before_to_20after_stormtime', where I create the appropriate inds

;; 2015/08/24 added MLTbelowStr and allMLTbelowStr
;;            Also, there's some discrepancy... 
PRO JOURNAL__20150815__REDO_w_BrettNOAA__MLT_and_Lshell_dist_of_stormtime_events_below_73deg_ILAT__Alfven_storm_GRL
  
  dataDir='/SPENCEdata/Research/Cusp/database'
  dbFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'

  ;; indsFile = 'superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150817.dat'
  ;; indsFile = 'superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150821.dat'
  indsFile = 'superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150824.dat'
  
  justMLTS = 1

  do_storms_below_73degILAT = 1
  ;; do_storms_below_73degILAT = 1

  do_ALL_below_73degILAT = 0
  ;; do_ALL_below_73degILAT = 1

  ;; ;All those storms
  ;; restore,'superposed_largestorms_-15_to_5_hours.dat'
  ;; restore,dataDir+'/../storms_Alfvens/saves_output_etc/' + $
  ;;         'superposed_large_storm_output_w_n_Alfven_events--20150815.dat'
 
  restore,dataDir+'/../storms_Alfvens/saves_output_etc/' + indsFile
  
  largeStorm_ind=tot_plot_i_list(0) 
  FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]
  
  restore,dataDir+'/dartdb/saves/'+dbFile

  pos=[0.15,0.15,0.95,0.925]    ;Position of histos in window
  
  ILAT_legendLoc = [0.565, 0.90]
  MLT_legendLoc = [0.565, 0.90]
  lShell_legendLoc = [0.565, 0.90]

  ;**************************************************
  ;For overlaid plots
  
  xRange_lShell=[0,40]
  xRange_MLT=[0,24]
  xRange_ILAT=[50,90]
  
  yRange_MLT=[0,0.2]    ;These can be modded if below 73degilat is set
  yRange_ILAT=[0,0.25]
  ;; yRange_lShell=[0.,0.15] ;for binsize_ilat=1
  yRange_lShell=[0.,0.25]

  ;; binSize_lShell=1
  binSize_lShell=2
  binSize_ILAT=2
  binSize_MLT=1
  
  ;****************************************
  ;good_i
  good_i_all=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/BOTH_HEMIS)
  good_i_south=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/SOUTH)
  good_i_north=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/NORTH)
  
  belowStr = ''
  MLTbelowStr = ''

  IF do_storms_below_73degILAT THEN BEGIN

     belowStr = '--below_73_deg_ILAT'

     MLTbelowStr = ' below 73 deg ILAT'
     allMLTbelowStr = ''
     MLT_legendLoc = [0.365, 0.90]
     ILAT_legendLoc = [0.365, 0.90]
     lShell_legendLoc = [0.365, 0.90]

     old=N_ELEMENTS(largestorm_ind)
     largestorm_ind = cgsetintersection(largestorm_ind,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(largestorm_ind)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from storm inds..."

     yRange_MLT=[0,0.2]
     yRange_ILAT=[0,0.35]
     yRange_lShell=[0.,0.2]


  ENDIF 

  IF do_all_below_73degILAT THEN BEGIN

     ;; belowStr = '--below_73_deg_ILAT'
     belowStr = '--both_histos_below_73_deg_ILAT'

     MLTbelowStr = ' below 73 deg ILAT'
     allMLTbelowStr = ' below 73 deg ILAT'
     MLT_legendLoc = [0.365, 0.90]

     old=N_ELEMENTS(largestorm_ind)
     largestorm_ind = cgsetintersection(largestorm_ind,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(largestorm_ind)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from storm inds..."

     old=N_ELEMENTS(good_i_all)
     good_i_all = cgsetintersection(good_i_all,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(good_i_all)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from all inds..."

     old=N_ELEMENTS(good_i_north)
     good_i_north = cgsetintersection(good_i_north,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(good_i_north)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from north inds..."

     old=N_ELEMENTS(good_i_south)
     good_i_south = cgsetintersection(good_i_south,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(good_i_south)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from south inds..."

     yRange_MLT=[0,0.2]
     yRange_ILAT=[0,0.35]
     yRange_lShell=[0.,0.2]


  ENDIF

  
  ;lshell calc
  lShell=(cos(maximus.ilat*!PI/180.))^(-2)
   

  data_1_pref = 'Large-storm events' + MLTbelowStr + ': '
  data_2_pref = 'All other events' + allMLTbelowStr + ': '
  ;**************************************************
  ;overlay the two MLT plots
  data_1_ind=largeStorm_ind
  data_1=maximus.mlt(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
  data_2=maximus.mlt(data_2_ind)
  
  data_1_col='yellow'
  data_2_col='olive'
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  ;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_all),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  
  histTitle='Frequency of activity'
  
  BINSIZE=binSize_MLT
  yRange=yRange_MLT
  xRange=xRange_MLT
  xTitle='MLT'
  outFile='MLT' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=MLT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos,DO_BKCOLOR=do_storms_below_73degILAT OR do_ALL_below_73degILAT
  
  ;just northern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
  data_1=maximus.mlt(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
  data_2=maximus.mlt(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  
  histTitle='Frequency of activity, Northern'
  
  outFile='MLT--Northern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=MLT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos,DO_BKCOLOR=do_storms_below_73degILAT OR do_ALL_below_73degILAT
  
  ;just southern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
  data_1=maximus.mlt(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
  data_2=maximus.mlt(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  ;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_south),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  
  histTitle='Frequency of activity, Southern'
  
  outFile='MLT--Southern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=MLT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos,DO_BKCOLOR=do_storms_below_73degILAT OR do_ALL_below_73degILAT
  

  IF justMLTs THEN STOP
  ;**************************************************
  ;overlay two L-SHELL plots
  
  data_1_ind=largeStorm_ind
  data_1=lShell(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
  data_2=lShell(data_2_ind)
  
  data_1_col='yellow'
  data_2_col='olive'
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  
  histTitle='Frequency of activity'
  
  binsize=binSize_lShell
  ;; XRANGE=[-90,90]
  XRANGE=xRange_lShell
  yRange=yRange_lShell
  xTitle='L-SHELL'
  outFile='L-SHELL' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=lShell_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos
  
  
  ;just northern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
  data_1=lShell(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
  data_2=lShell(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  ;; xRange=[50,90]
  xRange=xRange_lShell
  histTitle='Frequency of activity, Northern'
  
  outFile='L-SHELL--Northern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=lShell_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos
  
  ;just southern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
  data_1=lShell(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
  data_2=lShell(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  xRange=xRange_lShell
  ;; xRange=[-90,-50]
  histTitle='Frequency of activity, Southern'
  
  outFile='L-SHELL--Southern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=lShell_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos
  
  
  ;**************************************************
  ;;overlay two ILAT plots
  
  data_1_ind=largeStorm_ind
  data_1=maximus.ilat(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
  data_2=maximus.ilat(data_2_ind)
  
  data_1_col='yellow'
  data_2_col='olive'
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  
  histTitle='Frequency of activity'
  
  binsize=binSize_ILAT
  XRANGE=[-xRange_ILAT[1],xRange_ILAT[1]]
  yRange=yRange_ILAT
  xTitle='ILAT'
  outFile='ILAT' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=ILAT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos
  
  
  ;;just northern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
  data_1=maximus.ilat(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
  data_2=maximus.ilat(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  XRANGE=xRange_ILAT
  histTitle='Frequency of activity, Northern'
  
  outFile='ILAT--Northern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=ILAT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos
  
  ;;just southern
  data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
  data_1=maximus.ilat(data_1_ind)
  
  data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
  data_2=maximus.ilat(data_2_ind)
  
  data_1_title=data_1_pref + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
  data_2_title=data_2_pref + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
  xRange=-REVERSE(xRange_ILAT)
  histTitle='Frequency of activity, Southern'
  
  outFile='ILAT--Southern' + belowStr + '--large_storms--NOAA_and_Brett--overlaid_w_all_events.png'
  OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                     DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title,LEGENDLOC=ILAT_legendLoc, $
                     BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                     OUTFILE=outFile,POS=pos


;***********************************************************
;Plots that are not overlaid
  ;;  ;**************************************************
  ;;  ;L-SHELL
  ;;  
  ;;  cghistoplot,lShell(largeStorm_ind),/OPROBABILITY, $
  ;;              BINSIZE=binSize_lShell,OUTPUT='L-SHELL' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png', $
  ;;              CHARSIZE=2.5,THICK=2.0
  ;;  ;Southern
  ;;  cghistoplot,lShell,MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
  ;;              /OPROBABILITY, $    ;Southern hemi
  ;;              BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Southern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  cghistoplot,ABS(lShell(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))),MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
  ;;              /OPROBABILITY, $    ;Southern hemi
  ;;              BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Southern--reversed' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  ;Northern
  ;;  cghistoplot,lShell(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))),MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
  ;;              /OPROBABILITY, $    ;Northern
  ;;              BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Northern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  ;**************************************************
  ;;  ;ILAT
  ;;  
  ;;  cghistoplot,maximus.ilat(largeStorm_ind),/OPROBABILITY, $
  ;;              BINSIZE=binSize_ILAT,OUTPUT='ILAT' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png',CHARSIZE=2.5,THICK=2.0
  ;;  ;Southern
  ;;  cghistoplot,maximus.ilat,MAXINPUT=-xRange_ILAT[0],MININPUT=-xRange_ILAT[1],/OPROBABILITY, $   ;Southern hemi
  ;;              BINSIZE=binSize_ILAT,OUTPUT='ILAT--Southern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  cghistoplot,ABS(maximus.ilat(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))),MAXINPUT=xRange_ILAT[1],MININPUT=xRange_ILAT[0], $
  ;;              /OPROBABILITY, $    ;Southern hemi
  ;;              BINSIZE=binSize_ILAT,OUTPUT='ILAT--Southern--reversed' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  ;Northern
  ;;  cghistoplot,maximus.ilat(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))), $
  ;;              MAXINPUT=xRange_ILAT[1],MININPUT=xRange_ILAT[0], $
  ;;              /OPROBABILITY, $    ;Northern
  ;;              BINSIZE=binSize_ILAT,OUTPUT='ILAT--Northern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  
  ;;  ;**************************************************
  ;;  ;MLT
  ;;  cghistoplot,maximus.mlt(largestorm_ind), $                                            ;South
  ;;              /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))), $ ;South
  ;;              /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT--Northern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;  cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0))), $ ;North
  ;;              /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT--Southern' + belowStr + '--histogram_and_cdf--large_storms--NOAA_and_Brett--1997-01-10_through_2000-10-05.png'
  ;;


END