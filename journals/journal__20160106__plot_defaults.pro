
  ;;MLT params and stuff
  minM              = [6.0,-6.0]
  maxM              = [18.0,6.0]
  ;; hemi              = 'SOUTH'
  hemi              = 'BOTH'
  ptRegion          = ['Dayside','Nightside']
  psRegion          = ['dayside','nightside']
  hours_aft         = 120
                              
  do_these_plots    = [0,1]
  symColor          = ['red','blue']

  ;;Do a running logAvg window
  running_logAvg    = 10
  smooth_nPoints    = 3

  pref              = 'journal_20160106--SEA_largestorms'
  plotSuff          = '--with_NOAA--smoothed_running_logAvg--day_night__both_hemis.png'
  ;; plotSuff          = '--with_NOAA--smoothed_running_logAvg--day_night__south_hemi.png'
  ;; plotSuff          = '--with_NOAA--smoothed_running_logAvg--day_night__north_hemi.png'

  ;;strings 'n' things
  ;; fancy_plotNames   = 1
  @fluxplot_defaults

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

