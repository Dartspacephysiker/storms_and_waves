
PRO JOURNAL__20150825__ion_upflow_boxplots__stormtime_vs_othertimes__Alfvens_storms_GRL

  dataDir='/SPENCEdata/Research/Cusp/database'
  dbFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'

  indsFile = 'superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150824.dat'
  
  justMLTS = 1

  do_storms_below_73degILAT = 1
  ;; do_storms_below_73degILAT = 1

  do_ALL_below_73degILAT = 0
  ;; do_ALL_below_73degILAT = 1

  restore,dataDir+'/../storms_Alfvens/saves_output_etc/' + indsFile
  
  largeStorm_ind=tot_plot_i_list(0) 
  FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]
  
  restore,dataDir+'/dartdb/saves/'+dbFile

  
  ILAT_legendLoc = [0.565, 0.90]
  MLT_legendLoc = [0.565, 0.90]
  lShell_legendLoc = [0.565, 0.90]

  ;**************************************************
  ;For overlaid plots
  
  ;; xRange_lShell=[0,40]
  ;; xRange_MLT=[0,24]
  ;; xRange_ILAT=[50,90]
  
  ;; yRange_MLT=[0,0.2]    ;These can be modded if below 73degilat is set
  ;; yRange_ILAT=[0,0.25]
  ;; ;; yRange_lShell=[0.,0.15] ;for binsize_ilat=1
  ;; yRange_lShell=[0.,0.25]

  ;; ;; binSize_lShell=1
  ;; binSize_lShell=2
  ;; binSize_ILAT=2
  ;; binSize_MLT=1
  
  ;****************************************
  ;good_i
  good_i_all=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/BOTH_HEMIS)
  good_i_south=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/SOUTH)
  good_i_north=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/NORTH)
  
  belowStr = ''
  MLTbelowStr = ''

  IF do_storms_below_73degILAT THEN BEGIN

     ;; belowStr = '--below_73_deg_ILAT'

     ;; MLTbelowStr = ' below 73 deg ILAT'
     ;; allMLTbelowStr = ''
     ;; MLT_legendLoc = [0.365, 0.90]

     old=N_ELEMENTS(largestorm_ind)
     largestorm_ind = cgsetintersection(largestorm_ind,where(ABS(maximus.ILAT) LT 73))
     new=N_ELEMENTS(largestorm_ind)
     diff=old-new
     PRINT,"Removing " + STRCOMPRESS(diff,/REMOVE_ALL) + " of " + STRCOMPRESS(old,/REMOVE_ALL) + " elements above 73 deg ILAT from storm inds..."

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

  ENDIF

  
  ind=largeStorm_ind
  other_ind=cgsetdifference(good_i_all,largeStorm_ind)
  
  ;just northern
  ind_n=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
  other_ind_n=cgsetdifference(good_i_north,largeStorm_ind)
  
  ;just southern
  ind_s=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
  other_ind_s=cgsetdifference(good_i_south,largeStorm_ind)
  
  
  bpWindow = WINDOW(WINDOW_TITLE='Boxplots, storm and otherwise')

  storm_bp = MAXIMUS_BOXPLOT(INDS=ind,IND_NORTH=ind_n,IND_SOUTH=ind_s,MAXIMUS=maximus,MAXIND=16,/LOG,/PRINT_STATS,PLOTTITLE='Storm events,0 to 20 hrs', $
                             CURRENTWINDOW=bpWindow)

  other_bp = MAXIMUS_BOXPLOT(INDS=other_ind,IND_NORTH=other_ind_n,IND_SOUTH=other_ind_s, $
                             MAXIMUS=maximus,MAXIND=16,/LOG,/PRINT_STATS, $
                             /OVERPLOT,CURRENTWINDOW=bpWindow, $
                             PLOTTITLE='All others')
  


END