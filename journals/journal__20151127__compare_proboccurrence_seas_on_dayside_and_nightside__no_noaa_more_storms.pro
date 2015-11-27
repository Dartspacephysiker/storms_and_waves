

;2015/11/27 This idea comes out of a meeting with Prof. LaBelle yesterday (Thanksgiving!) 
; at Andøya Rakettskytefelt
PRO JOURNAL__20151127__COMPARE_PROBOCCURRENCE_SEAS_ON_DAYSIDE_AND_NIGHTSIDE__NO_NOAA_MORE_STORMS
  
  ;;MLT params and stuff
  minM              = [-6,6,0]
  maxM              = [6,18,24]
  ptRegion          = ['Nightside','Dayside','All MLTs']
                              
  ;;histo stuff
  ;; histoRange        = [[0,6000],[0,6000],[0,12000]]
  histoRange        = [[0,0.15],[0,0.15],[0,0.15]]
  histoBinSize      =  5

  ;;strings 'n' things
  probOccPref = 'journal_20151127--alfstorm2--Fig_3--SEA_probOccurrence--no_SSC--'
  ptPref            = ''
  plotSuff          = '.png'
  yTitle            = 'Probability of Occurrence'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  FOR i=0,N_ELEMENTS(minM)-1 DO BEGIN
     savePlotPref      = STRING(FORMAT='(A0,I02,"_",I02,"_MLT--")', $
                                probOccPref, $
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
        /PROBOCCURENCE_SEA, $
        YTITLE_MAXIND=yTitle, $
        /OVERPLOT_HIST, $
        ;; /NOGEOMAGPLOTS, $
        MINMLT=minM[i], $
        MAXMLT=maxM[i], $
        HISTOBINSIZE=histoBinSize, $
        HISTORANGE=histoRange[*,i], $
        PLOTTITLE=pT, $
        /SAVEPLOT, $
        SAVEPNAME=spn
     
  ENDFOR
  
END