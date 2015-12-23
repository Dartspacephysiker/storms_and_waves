;2015/12/23 Newfangled running median, too!
;Check out the journal from today where I list a bunch of really bad storms
;You'll notice that I've decided to remove a few from the team
PRO JOURNAL__20151223__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND_NIGHTSIDE__RUNNING_MEDIAN__MODDED_STORMLIST

  ;;MLT params and stuff
  minM              = [0,6,-6]
  maxM              = [24,18,6]
  ptRegion          = ['All MLTs','Dayside','Nightside']
  psRegion          = ['all_MLTs','dayside','nightside']
                              
  do_these_plots    = [0,1,2]
  symColor          = ['black','red','blue']

  ;;histo stuff
  ;; histoBinSize      =  15 ;in hrs

  ;;Do a running median window
  running_median    = 10


  ;;strings 'n' things
  probOccPref       = 'journal_20151223--SEA_largestorms--18-INTEG_ION_FLUX_UP--with_NOAA--running_avg'
  ptPref            = ''
  plotSuff          = '--all_MLT_day_night.png'

  maxInd            = 18
  yTitle            = "Integrated upward ion flux (N $cm^{-3}$)"

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;;Of the storms in the foregoing loaded list, these storms seem to be the biggest jerks:
  ;;#22--friggin triple phase!
  ;;#39--way bad double phase
  ;;#40--way bad double phase

  ;;Less offensive:
  ;;#14--way bad at tail end
  ;;#8
  ;;#20

  ;;Junk 'em
  ;; new_i = [INDGEN(14),INDGEN(21-16+1)+16,INDGEN(38-23+1)+23]
  new_i = [INDGEN(14),INDGEN(40-16+1)+16]
  q1_st=q1_st[new_i]

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1[new_i]])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                running_median)
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(I0,"-hr bins")', $
                                running_median)

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        HISTOBINSIZE=histoBinSize, $
        RUNNING_MEDIAN=running_median, $
        STORMTYPE=1, $
        /REMOVE_DUPES, $
        HOURS_AFT_FOR_NO_DUPES=60, $
        MAXIND=maxInd, $
        YRANGE_MAXIND=[1e8,1e13], $
        YTITLE_MAXIND=yTitle, $
        /YLOGSCALE_MAXIND, $
        AVG_TYPE_MAXIND=2, $
        NOMAXPLOTS=(i EQ 0), $
        SYMCOLOR__MAX_PLOT=symColor[i], $
        WINDOW_MAXIMUS=maximusWindow, $
        OUT_AVG_PLOT=out_avg_plot, $
        /ACCUMULATE__AVG_PLOTS, $
        TITLE__AVG_PLOT=pT, $
        N__AVG_PLOTS=3, $
        SYMCOLOR__AVG_PLOT=symColor[i], $
        /MAKE_LEGEND__AVG_PLOT, $
        NAME__AVG_PLOT=ptRegion[i], $
        /ONLY_POS, $
        /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        SAVEMAXPLOT=(i EQ 2), $
        SAVEMPNAME=spn
     
  ENDFOR



END