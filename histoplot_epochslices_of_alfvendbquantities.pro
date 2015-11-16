;+
; NAME:                           HISTOPLOT_EPOCHSLICES_OF_ALFVENDBQUANTITIES
;
; PURPOSE:                        Take data from a bunch of geomagnetic storms, and plot the
;                                 histograms of each epoch slice (e.g., histogram of all upflowing
;                                 ion flux from hour -5 to hour 0 of the storm epoch.
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFOREEPOCH      : Amount of time (hours) to plot before a given DST min
;                              TAFTEREPOCH       : Amount of time (hours) to plot after a given DST min
;                              STARTDATE         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              EPOCHINDS         : Indices of epochs to be included within the given storm DB
;                              SSC_TIMES_UTC     : Times (in UTC) of sudden commencements
;                              REMOVE_DUPES      : Remove all duplicate epochs falling within [tBeforeEpoch,tAfterEpoch]
;                              STORMTYPE         : '0'=small, '1'=large, '2'=all <-- ONLY APPLICABLE TO BRETT'S DB
;                              USE_SYMH          : Use SYM-H geomagnetic index instead of DST for plots of storm epoch.
;                              NEVENTHISTS       : Create histogram of number of Alfvén events relative to storm epoch
;                              HISTOBINSIZE      : Size of histogram bins in hours
;                              NEG_AND_POS_SEPAR : Do plots of negative and positive log numbers separately
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    0: standard averaging; 1: log averaging (if /LOG_DBQUANTITY is set)
;                              LOG_DBQUANTITY    : Plot the quantity from the Alfven wave database on a log scale
;                              NO_SUPERPOSE      : Don't superpose Alfven wave DB quantities over Dst/SYM-H 
;                              NOPLOTS           : Do not plot anything.
;                              NOMAXPLOTS        : Do not plot output from Alfven wave/Chaston DB.
;                              NEG_AND_POS_LAYOUT: Set to array of plot layout for pos_and_neg_plots
;                               
;                              PLOTTITLE         : Title of superposed plot
;                              SAVEPLOTNAME      : Name of outputted file
;
; OUTPUTS:                     
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:   2015/11/09 Born en route a Oslo de Paris
;-

PRO HISTOPLOT_EPOCHSLICES_OF_ALFVENDBQUANTITIES,RESTOREFILE=restoreFile, $
   stormTimeArray_utc, $
   TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
   STARTDATE=startDate, STOPDATE=stopDate, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   EPOCHINDS=epochInds, SSC_TIMES_UTC=ssc_times_utc, $
   REMOVE_DUPES=remove_dupes, HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
   STORMTYPE=stormType, $
   USE_SYMH=use_symh,USE_AE=use_AE, $
   OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
   NEVENTHISTS=nEventHists, $
   HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
   PROBOCCURENCE_SEA=probOccurrence_sea, LOG_PROBOCCURRENCE=log_probOccurrence, $
   NEG_AND_POS_SEPAR=neg_and_pos_separ, $
   LAYOUT=layout, $
   POS_LAYOUT=pos_layout, $
   NEG_LAYOUT=neg_layout, $
   MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   LOG_DBQUANTITY=log_DBQuantity, $
   ;; YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
   TBINS=tBins, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   NOPLOTS=noPlots, NOGEOMAGPLOTS=noGeomagPlots, NOMAXPLOTS=noMaxPlots, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
   PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
   SAVEMAXPLOTNAME=saveMaxPlotName, $
   EPOCHPLOT_COLORNAMES=epochPlot_colorNames, $
   RANDOMTIMES=randomTimes, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   NORMALIZE_EPOCHSLICE_HISTS=normalize_epochSlice_hists, $
   EPOCHSLICE_HISTBINSIZE = epochSlice_histBinsize, $
   EPOCHSLICE_XTITLE=epochSlice_xTitle, $
   EPOCHSLICE_XPLOTRANGE=epochslice_xPlotRange, $
   EPOCHSLICE_YPLOTRANGE=epochslice_yPlotRange, $
   MAKE_MOVIE=make_movie, $
   MOVIE_FRAMERATE=movie_framerate, $
   PLOTPREFIX=plotPrefix
   
  

  date            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  newLine         = '!C'

  IF NOT KEYWORD_SET(epochSlice_histBinsize) THEN epochSlice_histBinsize     = 0.25

  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  SET_STORMS_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                              DAYSIDE=dayside,NIGHTSIDE=nightside, $
                              RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                              MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                              YLOGSCALE_MAXIND=yLogScale_maxInd, $

                              YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                              LAYOUT=layout, $
                              POS_LAYOUT=pos_layout, $
                              NEG_LAYOUT=neg_layout, $
                              USE_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
                              PROBOCCURENCE_SEA=probOccurrence_sea, $
                              SAVEMAXPLOTNAME=saveMaxPlotName, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                              NOPLOTS=noPlots,NOGEOMAGPLOTS=noGeomagPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots,EPOCHPLOT_COLORNAMES=epochPlot_colorNames,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  @utcplot_defaults.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,DB_BRETT=stormFile,DBDIR=stormDir
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DB_TFILE=DB_tFile,DBDIR=DBDir,DBFILE=DBFile

  IF ~use_SYMH AND ~use_AE AND ~omni_Quantity THEN BEGIN
     LOAD_DST_AE_DBS,dst,ae,DST_AE_DIR=DST_AEDir,DST_AE_FILE=DST_AEFile
     do_DST = 1 
  ENDIF ELSE BEGIN
     IF use_SYMH THEN omni_quantity = 'sym_h'
     IF use_AE THEN omni_quantity = 'ae_index'
     do_DST = 0                 ;Use DST for plots, not SYM-H
     PRINT,'OMNI Quantity: ' + omni_quantity
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified date range, if an array of times hasn't been provided
  

  SETUP_STORMTIMEARRAY_UTC,stormTimeArray_utc,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                             NEPOCHS=nEpochs,EPOCHINDS=epochInds,STORMFILE=stormFile, $
                             MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $   ;DBs
                             STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $          ;extra info
                             CENTERTIME=centerTime, DATSTARTSTOP=datStartStop, TSTAMPS=tStamps, $
                             STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds, $ ; outs
                             RANDOMTIMES=randomTimes, $
                             SAVEFILE=saveFile,SAVESTR=saveString

  IF KEYWORD_SET(remove_dupes) THEN BEGIN
     REMOVE_EPOCH_DUPES,NEPOCHS=nEpochs, $
                       CENTERTIME=centerTime, $
                       TSTAMPS=tStamps,$
                       DATSTARTSTOP=datStartStop, $
                       HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes,TAFTEREPOCH=tAfterEpoch
  ENDIF

  ;**************************************************
  ;generate geomag and stuff

  GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NEPOCHS=nEpochs,SW_DATA=sw_data, $
                             USE_SYMH=use_SYMH,USE_AE=use_AE,DST=dst, $
                             OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                             GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                             GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max,DO_DST=do_Dst, $
                             YRANGE=yRange,/SET_YRANGE,USE_DATA_MINMAX=use_data_minMax, $
                             DATATITLE=geomagTitle


  ;; Get ranges for plots
  IF    KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) $
     OR KEYWORD_SET(maxInd)      OR KEYWORD_SET(probOccurrence_sea) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
     ;; ;Get nearest events in Chaston DB
     GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                       CENTERTIME=centerTime, $
                                       DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                       NALFEPOCHS=nAlfEpochs,ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                       ALF_CENTERTIME=alf_centerTime,ALF_TSTAMPS=alf_tStamps, $
                                       RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                       MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                       DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                       DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                       SAVEFILE=saveFile,SAVESTR=saveStr
     

     IF KEYWORD_SET(maxInd) THEN BEGIN
        GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                                      ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                      MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                      LOG_DBQUANTITY=log_DBQuantity, $
                                      CENTERTIME=alf_centerTime,TSTAMPS=alf_tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                                      NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                      TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                      TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                      TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                      NEVTOT=nEvTot, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr
                                          
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(probOccurrence_sea) OR KEYWORD_SET(nEventHists) THEN BEGIN
           ;;use maxInd = 20 here to get current width
           GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=20,GOOD_I=good_i, $
                                      ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                      MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                      LOG_DBQUANTITY=log_DBQuantity, $
                                      CENTERTIME=alf_centerTime,TSTAMPS=alf_tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                                      NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                      TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                      TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                      TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                      NEVTOT=nEvTot
        ENDIF
     ENDELSE
     
     IF KEYWORD_SET(neg_AND_pos_separ) THEN BEGIN
        ;;First pos
        tot_alf_t_pos = LIST_TO_1DARRAY(tot_alf_t_pos_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_y_pos = LIST_TO_1DARRAY(tot_alf_y_pos_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_t_neg = LIST_TO_1DARRAY(tot_alf_t_neg_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_y_neg = LIST_TO_1DARRAY(tot_alf_y_neg_list,/WARN,/SKIP_NEG1_ELEMENTS)
        
        IF N_ELEMENTS(avg_type_maxInd) GT 0 THEN histoType = avg_type_maxind
        
        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t_pos,tot_alf_y_pos,HISTOTYPE=histoType, $
           HISTDATA=histData_pos, $
           HISTTBINS=histTBins_pos, $
           NEVHISTDATA=nEvHistData_pos, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_pos, $
           NONZERO_I=nz_i_pos
        ;;Now neg
        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t_neg,tot_alf_y_neg,HISTOTYPE=histoType, $
           HISTDATA=histData_neg, $
           HISTTBINS=histTBins_neg, $
           NEVHISTDATA=nEvHistData_neg, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_neg, $
           NONZERO_I=nz_i_neg
     ENDIF ELSE BEGIN
        tot_alf_t = LIST_TO_1DARRAY(tot_alf_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_y = LIST_TO_1DARRAY(tot_alf_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
        
        IF N_ELEMENTS(avg_type_maxInd) GT 0 THEN histoType = avg_type_maxind
        
        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t,tot_alf_y,HISTOTYPE=histoType, $
           HISTDATA=histData, $
           HISTTBINS=histTBins, $
           NEVHISTDATA=nEvHistData, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
           NONZERO_I=nz_i
        
        IF KEYWORD_SET(probOccurrence_sea) THEN BEGIN
           
           GET_FASTLOC_HISTOGRAM__EPOCH_ARRAY, $
              T1_ARR=datStartStop[*,0], $
              T2_ARR=datStartStop[*,1], $
              CENTERTIME=centerTime, $
              RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
              MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
              DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
              HEMI='BOTH', $
              NEPOCHS=nEpochs, $
              OUTINDSPREFIX=savePlotMaxName, $
              HISTDATA=fastLocHistData, $
              HISTTBINS=fastLocBins, $
              NEVHISTDATA=fastLoc_nEvHistData, $
              TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_fastLocHist, $
              FASTLOC_I_LIST=fastLoc_i_list,FASTLOC_T_LIST=fastLoc_t_list,FASTLOC_DT_LIST=fastLoc_dt_list, $
              NONZERO_I=nz_i_fastLoc
           
           IF N_ELEMENTS(nz_i_fastLoc) LT N_ELEMENTS(nz_i) THEN BEGIN
              PRINT,"How does the ephemeris have fewer histo bins than actual data?"
              STOP
           ENDIF
           nz_i_po = CGSETINTERSECTION(nz_i,nz_i_fastLoc)
           histData[nz_i_po] = histData[nz_i_po]/fastLocHistData[nz_i_po]
        ENDIF
        
     ENDELSE
  ENDIF
  
  IF NOT KEYWORD_SET(dataName) THEN dataName = (TAG_NAMES(maximus))[maxInd] ;;        = 'char_ion_energy'
  IF NOT KEYWORD_SET(plotPrefix) THEN plotPrefix = "" ELSE plotPrefix = plotPrefix + '--'
  ;;data out
  genFile_pref    = date + '--' + dataName + '--from_histoplot_epochslices_of_alfvendbquantities.pro'
  outstats        = date + '--' + dataName + '_moment_data_for_' + STRCOMPRESS(nEpochs,/REMOVE_ALL) + '_' + $
                    stormString + 'storms--no_NOAA_SSC.sav'
  SET_PLOT_DIR,plotDir,/FOR_STORMS,/VERBOSE,/ADD_TODAY
  sPP             = plotDir + dataName + '--' + plotPrefix + STRCOMPRESS(nEpochs,/REMOVE_ALL) + $
                    '_' + stormString + 'Storms--no_NOAA_SSC' ;savePlotPrefix
  
  ;;plot array/window setup
  nSlices    = N_ELEMENTS(histTBins)
  nWindows   = 5
  windowArr  = MAKE_ARRAY(nWindows,/OBJ)
  plotArr    = MAKE_ARRAY(nSlices,/OBJ)
  plotLayout = [3,2]
  nSlices    = N_ELEMENTS(histTBins)
  firstmarg  = [0.1,0.1,0.1,0.1]
  marg       = [0.01,0.01,0.1,0.01]
  nPPerWind  = plotLayout[0]*plotLayout[1]

  ;plot details
  xTitle     = KEYWORD_SET(epochSlice_xTitle) ? epochSlice_xTitle : dataName
  yTitle     = "Count"
  ;; xRange     = [histTBins[0],histTBins[-1]]
  xRange     = KEYWORD_SET(epochslice_xPlotRange) ? epochslice_xPlotRange : [MIN(tot_alf_y),MAX(tot_alf_y)]
  yRange     = KEYWORD_SET(epochSlice_yPlotRange) ? epochSlice_yPlotRange : [0,1000]
  pHP        = MAKE_HISTOPLOT_PARAM_STRUCT(NAME=dataName, $
                                           XTITLE=xTitle, $
                                           YTITLE=yTitle, $
                                           XRANGE=xRange, $
                                           YRANGE=yRange, $
                                           HISTBINSIZE=epochSlice_histBinsize, $
                                           XP_ARE_LOGGED=log_DBQuantity)

  ;;declare the slice structure array
  ssa = !NULL

  ;;First, all of the text output
  PRINT,FORMAT='("Low (hr)",T10,"High (hr)",T20,"N",T30,"Mean",T40,"Std. dev.",T50,"Skewness",T60,"Kurtosis")'
  FOR i=0,nSlices-2 DO BEGIN
     temp_ii   = WHERE(tot_alf_t GE histTBins[i] AND tot_alf_t LT histTBins[i+1])
     tempData  = tot_alf_y[temp_ii]
     ;; IF KEYWORD_SET(unlog) THEN BEGIN
     ;;    tempData                 = 10^(tempData)
     ;; ENDIF
     tempStats = MOMENT(tempData)

     tempESlice = MAKE_EPOCHSLICE_STRUCT(DATANAME=dataName, $
                                         EPOCHSTART=histTBins[i], $
                                         EPOCHEND=histTBins[i+1], $
                                         YDATA=tempData, $
                                         IS_LOGGED_YDATA=log_DBQuantity, $
                                         /DO_HIST, $
                                         HISTMIN=pHP.xRange[0], $
                                         HISTMAX=pHP.xRange[1], $
                                         HISTBINSIZE=epochSlice_histBinsize, $
                                         TDATA=tot_alf_t[temp_ii], $
                                         MOMENTSTRUCT=MAKE_MOMENT_STRUCT(tempData), $
                                         GENERATING_FILE=genFile)

     ssa = [ssa,tempESlice]

  PRINT,FORMAT='(I0,T10,I0,T20,I0,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4)', $
        tempESlice.eStart, $
        tempESlice.eEnd, $
        N_ELEMENTS(temp_ii), $
        tempESlice.moments.(0), $
        SQRT(tempESlice.moments.(1)), $
        tempESlice.moments.(2), $
        tempESlice.moments.(3)

  ENDFOR

  ;;Now the windows
  IF KEYWORD_SET(make_movie) THEN BEGIN

     ;set up video--ripped this from http://www.exelisvis.com/Learn/Blogs/IDLDataPointDetail/TabId/902/ArtMID/2926/ArticleID/12944/Making-movies-with-IDL-part-I.aspx
     video_file = STRING(FORMAT='(A0,"--epoch_",I0,"_through_",I0,".mp4")',sPP,histTBins[0],histTBins[-1])
     ;;video_file = 'dg_movie_ex.mp4'
     video      = idlffvideowrite(video_file)
     framerate  = KEYWORD_SET(movie_framerate) ? movie_framerate : 2
     framedims  = [640,512]
     stream     = video.addvideostream(framedims[0], framedims[1], framerate)

     ;;Set up plotting device
     SET_PLOT, 'z', /copy
     DEVICE, SET_RESOLUTION=framedims, SET_PIXEL_DEPTH=24, DECOMPOSED=0

     FOR i=0,nSlices-2 DO BEGIN
        
        ;;get which panel this is
        layout_i    = (i MOD nPPerWind)+1
        
        ;;the indata
        x           = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
        y           = ssa[i].yHistStr.hist[0] 
        
        integral    = TOTAL(y)
        IF KEYWORD_SET(normalize_epochSlice_hists) THEN BEGIN
           y        = y / integral
           pHP.yRange = [0,0.3]
           pHP.yTitle = 'Relative Freq.'
        ENDIF 
        
        title       = STRING(FORMAT='("Storm epoch hours ",I0," through ",I0)',ssa[i].eStart,ssa[i].eEnd)
        xTitle      = pHP.xTitle
        yTitle      = pHP.yTitle
        margin      = firstMarg
        
        ;; plotArr[i]  = plot(x,y, $
        ;;                    TITLE=title, $
        ;;                    XTITLE=xTitle, $
        ;;                    YTITLE=yTitle, $
        ;;                    XRANGE=pHP.xRange, $
        ;;                    YRANGE=pHP.yRange, $
        ;;                    /HISTOGRAM, $
        ;;                    MARGIN=margin, $
        ;;                    /BUFFER)
        PLOT,x,y, $
             TITLE=title, $
             XTITLE=xTitle, $
             YTITLE=yTitle, $
             XRANGE=pHP.xRange, $
             YRANGE=pHP.yRange, $
             PSYM=10 ;, $ ;for histo madness
             ;; MARGIN=margin
        
        timestamp = video.put(stream, TVRD(TRUE=1))

     ENDFOR

     ;;Close the vidzz
     DEVICE, /close
     SET_PLOT, STRLOWCASE(!version.os_family) eq 'windows' ? 'win' : 'x'
     video.cleanup
     PRINT, 'File "' + video_file + '" written to current directory.'

  ENDIF ELSE BEGIN ;;No video

     FOR i=0,nSlices-2 DO BEGIN
        ;;set up a new window, if need be
        IF (i MOD nPPerWind) EQ 0 THEN BEGIN
           wInd            = FLOOR(i/FLOAT(nWindows))
           t1              = histTbins[i]
           t2              = histTbins[i+nPPerWind]
           wTitle          = STRING(FORMAT='("Storm epoch hours ",F0.2," through ",F0.2)',t1,t2)
           saveName        = STRING(FORMAT='(A0,"--epoch_",I0,"_through_",I0,".png")',sPP,t1,t2)
           
           windowArr[wInd] = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])
           
        ENDIF
        
        ;;get which panel this is
        layout_i    = (i MOD nPPerWind)+1
        
        ;;the indata
        x           = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
        y           = ssa[i].yHistStr.hist[0] 
        
        integral    = TOTAL(y)
        IF KEYWORD_SET(normalize_epochSlice_hists) THEN BEGIN
           y        = y / integral
           pHP.yRange = [0,0.3]
           pHP.yTitle = 'Relative Freq.'
        ENDIF 
        
        ;; IF layout_i EQ 1 THEN BEGIN
        title       = STRING(FORMAT='("Storm epoch hours ",I0," through ",I0)',ssa[i].eStart,ssa[i].eEnd)
        xTitle      = layout_i GT plotLayout[0] ? pHP.xTitle : !NULL
        yTitle      = pHP.yTitle
        ;; yMajorTicks = 3
        ;; yTickName   = REPLICATE(' ',yMajorTicks)
        margin      = firstMarg
        ;; ENDIF ELSE BEGIN
        ;;    title       = STRING(FORMAT='(I0," through ",I0)',ssa[i].eStart,ssa[i].eEnd)
        ;;    xTitle      = !NULL
        ;;    yTitle      = !NULL
        ;;    yMajorTicks = !NULL
        ;;    yTickName   = !NULL
        ;;    margin      = marg
        ;; ENDELSE
        
        plotArr[i]  = plot(x,y, $
                           TITLE=title, $
                           XTITLE=xTitle, $
                           YTITLE=yTitle, $
                           XRANGE=pHP.xRange, $
                           YRANGE=pHP.yRange, $
                           ;; YTICKS=yMajorTicks, $
                           ;; YTICKNAME=yTickName, $
                           /HISTOGRAM, $
                           LAYOUT=[plotLayout,layout_i], $
                           MARGIN=margin, $
                           /CURRENT)
        
        ;;For the integral
        ;; intString   = STRING(FORMAT='("Integral  : ",I0)',integral)
        textStr     = STRING(FORMAT='(A0,I0,A0,A0,E0.2,A0,A0,E0.2,A0,A0,E0.2,A0,A0,E0.2,A0)', $
                             'Integral  : ', integral, newLine, $
                             'Mean      : ', ssa[i].moments.(0), newLine, $
                             'Std. dev. : ', ssa[i].moments.(1), newLine, $
                             'Skewness  : ', ssa[i].moments.(2), newLine, $
                             'Kurtosis  : ', ssa[i].moments.(3), newLine)
        
        
        int_x       = ( ( (layout_i - 1) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.05
        int_y       = 1 - 1/FLOAT(plotLayout[1]*2) - ( ( (layout_i - 1) / plotLayout[0] )) * 1/FLOAT(plotLayout[1]) + 1/FLOAT(plotLayout[1]*8)
        intText     = text(int_x,int_y,$
                           textStr, $
                           FONT_NAME='Courier', $
                           /NORMAL, $
                           TARGET=plotArr[i])
        
        
        IF (i GT 0) AND ( ( (i + 1) MOD nPPerWind ) EQ 0 ) THEN BEGIN
           windowArr[wInd].save,saveName,RESOLUTION=300
        ENDIF
        
     ENDFOR
  ENDELSE ;end separate windows

END