
  ;;MLT params and stuff
  minM                  = [6.0,-6.0]
  maxM                  = [18.0,6.0]
  hemi                  = 'NORTH'
  ptRegion              = ['Dayside','Nightside']
  psRegion              = ['dayside','nightside']
  hours_aft             = 60
                              
  do_these_plots        = [0,1]
  symColor              = ['red','blue']

  symColor__totalVar    = ['purple','green']

  ;;Do a running logAvg window
  ;; running_logAvg        = 20
  running_logAvg        = 10
  running_bin_spacing   = 2.5
  running_bin_r_offset  = -5
  ;; smooth_nPoints    = 3
  make_eb               = 0
  eb_nBoot              = 1000

  histoBinsize          = 5

  pref                  = 'journal_20160303--SEA_largestorms'
  ;; plotSuff          = '--error_bars_showing_2stddev--5-hr_spacing--no_smoothing--north_hemi.png'
  plotSuff              = '--totalVar--north_hemi.png'

  ;;strings 'n' things
  ;; fancy_plotNames   = 1
  @fluxplot_defaults

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])
