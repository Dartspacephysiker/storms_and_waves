;2015/12/07 Turns out this thing is pretty much not that great
PRO JOURNAL__20151207__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND_NIGHTSIDE__LIMITED_TO_PM_20HRS

  ;;MLT params and stuff
  minM              = [-6,6,0]
  maxM              = [6,18,24]
  ptRegion          = ['Nightside','Dayside','All MLTs']
  psRegion          = ['nightside','dayside','all_MLTs']
                              
  tEpochRange       = [20,20]

  do_these_plots    = [0,1,2]
  ;; do_these_plots    = [0]

  ;;histo stuff
  histoBinSize      =  5 ;in hrs

  ;;strings 'n' things
  probOccPref       = 'journal_20151207--SEA--18-INTEG_ION_FLUX_UP--with_NOAA--'
  ptPref            = ''
  plotSuff          = '.png'

  maxInd            = 18
  yTitle            = "Integrated upward ion flux (N $cm^{-3}$)"

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--",A0)', $
                                probOccPref, $
                                (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
                                maxM[i], $
                                psRegion[i])
     spn               = savePlotPref+plotSuff
     pt                = STRING(FORMAT='(A0," (",A0,", ",I0,"–",I0," MLT)")', $
                                ptPref, $
                                ptRegion[i], $
                                minM[0],maxM[i])

     SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
        TBEFOREEPOCH=tEpochRange[0], $
        TAFTEREPOCH=tEpochRange[1], $
        EPOCHINDS=q1_st, $
        SSC_TIMES_UTC=q1_utc, $
        /USE_DARTDB_START_ENDDATE, $
        STORMTYPE=1, $
        ;; /REMOVE_DUPES, $
        MAXIND=maxInd, $
        YTITLE_MAXIND=yTitle, $
        AVG_TYPE_MAXIND=2, $
        ;; /LOG_DBQUANTITY, $
        /ONLY_POS, $
        YRANGE_MAXIND=[1e7,1e14], $
        /YLOGSCALE_MAXIND, $
        /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HISTOBINSIZE=histoBinSize, $
        PLOTTITLE=pT, $
        /SAVEMAXPLOT, $
        SAVEMPNAME=spn
     
  ENDFOR



END