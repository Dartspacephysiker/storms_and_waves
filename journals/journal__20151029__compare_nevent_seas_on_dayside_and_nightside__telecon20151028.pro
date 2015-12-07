;2015/10/29 This is one of the ideas that came out of a telecon with Chris Chaston
;           yesterday prior to my departing for SLC/Norge.
PRO JOURNAL__20151029__COMPARE_NEVENT_SEAS_ON_DAYSIDE_AND_NIGHTSIDE__TELECON20151028

  
  ;;MLT params and stuff
  minM              = [-6,6]
  maxM              = [6,18]
  ptRegion          = ['Nightside','Dayside']
                              
  ;;histo stuff
  histoRange        = [0,5000]
  histoBinSize      =  5

  ;;strings 'n' things
  nEventsPref = 'alfstorm2--Fig_3--SEA_nEvents--'
  ptPref            = ''
  plotSuff          = '.png'

  yTitle            = 'N Events'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  FOR i=0,N_ELEMENTS(minM)-1 DO BEGIN
     savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                                nEventsPref, $
                                (minM[i] LT 0) ? minM[i] + 24 : minM[i], $
                                maxM[i])
     spn               = savePlotPref+plotSuff
     pt            = STRING(FORMAT='(A0," (",A0,", ",I0,"–",I0," MLT)")',ptPref,ptRegion[i], $
                             minM[0],maxM[i])

  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,EPOCHINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
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
                                      /SAVEPLOT, $
                                      SAVEPNAME=spn

  ENDFOR

END