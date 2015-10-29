

;2015/10/29 This is one of the ideas that came out of a telecon with Chris Chaston
;           yesterday prior to my departing for SLC/Norge.
PRO JOURNAL__20151029__COMPARE_NEVENT_SEAS_ON_DAYSIDE_AND_NIGHTSIDE__NO_NOAA_MORE_STORMS__TELECON20151028

  
  ;;MLT params and stuff
  minM              = [-6,6,0]
  maxM              = [6,18,24]
  ptRegion          = ['Nightside','Dayside','All MLTs']
                              
  ;;histo stuff
  histoRange        = [0,12000]
  histoBinSize      =  5

  ;;strings 'n' things
  nEventsPref = 'journal_20151029--alfstorm2--Fig_3--SEA_nEvents--no_SSC--'
  ptPref            = ''
  plotSuff          = '.png'

  yTitle            = 'N Events'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  FOR i=2,N_ELEMENTS(minM)-1 DO BEGIN
     savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                                nEventsPref, $
                                (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
                                maxM[i])
     spn               = savePlotPref+plotSuff
     pt            = STRING(FORMAT='(A0," (",A0,", ",I0,"–",I0," MLT)")',ptPref,ptRegion[i], $
                             minM[0],maxM[i])

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES, $
     ;; EPOCHINDS=q1_st, $
     ;; SSC_TIMES_UTC=q1_utc, $
     /USE_DARTDB_START_ENDDATE, $
     STORMTYPE=1, $
     /REMOVE_DUPES, $
     ;; /NOGEOMAGPLOTS, $
     MINMLT=minM[i], $
     MAXMLT=maxM[i], $
     /NEVENTHISTS, $
     /OVERPLOT_HIST, $
     HISTOBINSIZE=histoBinSize, $
     HISTORANGE=histoRange, $
     PLOTTITLE=pT, $
     SAVEPLOTNAME=spn

  ENDFOR

END