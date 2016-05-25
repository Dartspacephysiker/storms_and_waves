PRO JOURNAL__20160525__PNG_OF_EACH_DST_TRACE_OF_EACH_STORM_USED_IN_OUR_STUDY

  ;;************************************************************
  ;;to be outputted
  todayStr          = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  savePlot          = 1
  savePlotPref      = todayStr + '--Largestorms_combinee--'
  scOutPref         = todayStr + '--Largestorms_combinee--'  ;scatter plots, N and S Hemi

  hemi              = 'BOTH'

  close_window_after_save = 1

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st             = qi[0].list_i[0]
  q1_1              = qi[1].list_i[0]
  
  q1_utc            = conv_julday_to_utc(ssc1.julday[q1_1])

  rmDupes           = 1

  nPlotsPerWindow   = 1
  ;; colors            = ['red','blue','green','orange']
  colors            = ['red','blue','green','purple']

  maxInd            = 6
  yRange_maxInd     = [-200,200]
  symTransparency   = 92
  ;; FOR i = 0, N_ELEMENTS(q1_st)-1,nPlotsPerWindow DO BEGIN
  FOR i = 0,N_ELEMENTS(q1_st)-1 DO BEGIN
     ;;SSC-centered here
     iFirst         = i
     ;; iLast          = i + nPlotsPerWindow - 1
     ;; scOutFilePref  = STRING(FORMAT='(A0,I0,"-",I0,".png")',scOutPref,iFirst,iLast)
     ;; savePlotFile   = STRING(FORMAT='(A0,I0,"-",I0,".png")',savePlotPref,iFirst,iLast)
     scOutFilePref  = STRING(FORMAT='(A0,"Storm_",I0,A0)',scOutPref,iFirst,'--scatterplots')
     savePlotFile   = STRING(FORMAT='(A0,"Storm_",I0,".png")',savePlotPref,iFirst)
     
     STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID, $
        ;; q1_utc[iFirst:iLast], $
        q1_utc[iFirst], $
        STORMTYPE=1, $
        HEMI=hemi, $
        ;; EPOCHINDS=q1_st[iFirst:iLast], $
        EPOCHINDS=q1_st[iFirst], $
        /USE_DARTDB_START_ENDDATE, $
        TBEFOREEPOCH=15., $
        TAFTEREPOCH=60., $
        MAXIND=maxInd, $
        PLOTTITLE='Storm #' + STRCOMPRESS(iFirst,/REMOVE_ALL), $
        YRANGE_MAXIND=yRange_maxInd, $
        YTITLE_MAXIND='Current density ($\muA/m^2$)', $
        REMOVE_DUPES=rmDupes, $
        ;; RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist, $
        SAVEPLOT=savePlot, $
        SAVEPNAME=savePlotFile, $
        /DO_SCATTERPLOTS, $
        CLOSE_WINDOW_AFTER_SAVE=close_window_after_save, $
        EPOCHPLOT_COLORNAMES=colors, $
        SYMTRANSPARENCY=symTransparency, $
        SCATTEROUTPREFIX=scOutFilePref, $
        /SHOW_DATA_AVAILABILITY, $
        /JUST_ONE_LABEL, $
        /OVERPLOT_ALFVENDBQUANTITY
  ENDFOR


END