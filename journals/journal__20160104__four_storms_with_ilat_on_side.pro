;Let's do dat, because as Professor LaBelle said, we can probably do something more useful than show the size
; of the observed current
PRO JOURNAL__20160104__FOUR_STORMS_WITH_ILAT_ON_SIDE

  ;;************************************************************
  ;;to be outputted
  savePlotPref      = '20160104--Four_largestorms--'
  ;; scOutPref         = '20160104--Largestorms_combinee--scatterplots--'  ;scatter plots, N and S Hemi

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st             = qi[0].list_i[0]
  q1_1              = qi[1].list_i[0]
  
  q1_utc            = conv_julday_to_utc(ssc1.julday[q1_1])

  rmDupes           = 1

  nPlotsPerWindow   = 4
  ;; colors            = ['red','blue','green','orange']
  colors            = ['red','blue','green','purple']

  ;inds are 
  ;;  0 ORBIT
  ;;  1 ALFVENIC
  ;;  2 TIME
  ;;  3 ALT
  ;;  4 MLT
  ;;  5 ILAT
  ;; maxInd            = 6
  ;; yRange_maxInd     = [-200,200]
  ;; yTitle_maxInd     = 'Current density ($\muA/m^2$)'
  maxInd            = 5
  ;; yRange_maxInd     = [54,86]
  yRange_maxInd     = [55,85]
  yTitle_maxInd     = 'ILAT'

  symTransparency   = 92
  ;; FOR i = 0, N_ELEMENTS(q1_st)-1,nPlotsPerWindow DO BEGIN
  ;; FOR i = 0, N_ELEMENTS(q1_st)-1,nPlotsPerWindow DO BEGIN
  FOR i = 0, 3,nPlotsPerWindow DO BEGIN
  ;;SSC-centered here
     iFirst         = i
     iLast          = i + nPlotsPerWindow - 1
     ;; scOutFilePref  = STRING(FORMAT='(A0,"--",A0,"--",I0,"-",I0,".png")',scOutPref,yTitle_maxInd,iFirst,iLast)
     savePlotFile   = STRING(FORMAT='(A0,"--",A0,"--",I0,"-",I0,".png")',savePlotPref,yTitle_maxInd,iFirst,iLast)
     
     STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID, $
        q1_utc[iFirst:iLast], $
        STORMTYPE=1, $
        EPOCHINDS=q1_st[iFirst:iLast], $
        /USE_DARTDB_START_ENDDATE, $
        TBEFOREEPOCH=15., $
        TAFTEREPOCH=60., $
        MAXIND=maxInd, $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND=yTitle_maxInd, $
        REMOVE_DUPES=rmDupes, $
        ;; RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist, $
        SAVEPLOTNAME=savePlotFile, $
        ;; EPOCHPLOT_COLORNAMES=colors, $
        SYMTRANSPARENCY=symTransparency, $
        ;; /DO_SCATTERPLOTS, $
        ;; SCATTEROUTPREFIX=scOutFilePref, $
        /SHOW_DATA_AVAILABILITY, $
        /JUST_ONE_LABEL, $
        /OVERPLOT_ALFVENDBQUANTITY
  ENDFOR

END