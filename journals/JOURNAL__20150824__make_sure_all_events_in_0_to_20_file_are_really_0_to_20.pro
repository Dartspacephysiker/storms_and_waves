PRO JOURNAL__20150824__make_sure_all_events_in_0_to_20_file_are_really_0_to_20

  dataDir='/SPENCEdata/Research/Cusp/database/'
  DBFile='dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DB_tFile='dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  stormFile='saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--quadrant1--0_to_20_hours--20150824.dat'

  print,'Restoring ' + DBFile + '...'
  restore,dataDir+DBFile
  print,'Restoring ' + DB_tFile + '...'
  restore,dataDir+DB_tFile

  ;restore storm file and get inds
  print,'Restoring ' + stormFile + '...'
  restore,dataDir+'../storms_Alfvens/' + stormFile
  storm_i = tot_plot_i_list[0]
  diffs = cdbtime(tot_plot_i_list[0])-centerTime[0]
  FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO BEGIN
     storm_i = [storm_i,tot_plot_i_list[i]]
     diffs = [diffs,cdbtime(tot_plot_i_list[i])-centerTime[i]]
  ENDFOR
  nStormEv = N_ELEMENTS(storm_i)

  ;clean 'er out first, then set current limits
  good_i = get_chaston_ind(maximus,'OMNI',-1,/BOTH_HEMIS) & nGood=N_ELEMENTS(good_i)

  ;;Here's how you know it's bad
  cghistoplot,diffs/3600.
  cghistoplot,diffs/3600.,maxinput=30,mininput=-20
  print,max(diffs)/3600./24.
  print,n_elements(where(ABS(diffs)/3600. GT 20))

END