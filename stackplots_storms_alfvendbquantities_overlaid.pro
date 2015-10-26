;+
; NAME:                           STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID
;
; PURPOSE:                        TAKE A LIST OF STORMS, STACK THE PLOTS AND THE RELEVANT ALFVEN EVENTS
;
; CATEGORY:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFOREEPOCH      : Amount of time (hours) to plot before a given DST min
;                              TAFTEREPOCH       : Amount of time (hours) to plot after a given DST min
;                              STARTDATE         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              EPOCHINDS         : Indices of storms to be included within the given storm DB
;                              SSC_TIMES_UTC     : Times (in UTC) of sudden commencements
;                              REMOVE_DUPES      : Remove all duplicate storms falling within [tBeforeEpoch,tAfterEpoch]
;                              STORMTYPE         : '0'=small, '1'=large, '2'=all <-- ONLY APPLICABLE TO BRETT'S DB
;                              USE_SYMH          : Use SYM-H geomagnetic index instead of DST for plots of storm epoch.
;                              NEVENTHISTS       : Create histogram of number of Alfvén events relative to storm epoch
;                              NEVBINSIZE        : Size of histogram bins in hours
;                              NEG_AND_POS_SEPAR : Do plots of negative and positive log numbers separately
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    0: standard averaging; 1: log averaging (if /LOG_DBQUANTITY is set)
;                              LOG_DB_QUANTITY   : Plot the quantity from the Alfven wave database on a log scale
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
; MODIFICATION HISTORY:   2015/08/21 Ripping this off SUPERPOSE_STORMS_ALFVENDBQUANTITIES so we can do stackplots of storms
;                         2015/08/25 Added the OUT*PLOT and OUT*WINDOW keywords so I can do a rug plot
;                         2015/08/26 Added SHOW_DATA_AVAILABILITY keyword for gooder rug plot
;                           
;-


PRO STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID,stormTimeArray_utc, $
                             TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                             STARTDATE=startDate, STOPDATE=stopDate, $
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             EPOCHINDS=epochInds, SSC_TIMES_UTC=ssc_times_utc, $
                             REMOVE_DUPES=remove_dupes, HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
                             STORMTYPE=stormType, $
                             USE_SYMH=use_symh,USE_AE=use_AE, $
                             OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                             NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, NEVRANGE=nEvRange, $
                             RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist, BKGRND_HIST=bkgrnd_hist, $
                             NEG_AND_POS_SEPAR=neg_and_pos_separ, POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                             MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
                             RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                             LOG_DBQUANTITY=log_DBquantity, $
                             YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                             DBFILE=dbFile,DB_TFILE=db_tFile, $
                             OVERPLOT_ALFVENDBQUANTITY=overplot_alfvendbquantity, $
                             NO_SUPERPOSE=no_superpose, $
                             NOPLOTS=noPlots, NOMAXPLOTS=noMaxPlots, $
                             USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
                             SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
                             PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                             SAVEMAXPLOTNAME=saveMaxPlotName, $
                             DO_SCATTERPLOTS=do_scatterPlots,SCPLOT_COLORLIST=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                             JUST_ONE_LABEL=just_One_Label, $
                             OUT_MAXPLOTS=out_maxPlots, $ ;OUT_MAXWINDOW=out_maxWindow, $
                             OUT_GEOMAGPLOTS=out_geomagPlots,OUT_GEOMAGWINDOW=geomagWindow, $
                             OUT_DATSTARTSTOP=out_datStartStop, $
                             SHOW_DATA_AVAILABILITY= show_data_availability
  
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults

  SET_STORMS_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                              ;; SWDBDIR=swDBDir,SWDBFILE=swDBFile, $
                              ;; STORMDIR=stormDir,STORMFILE=stormFile, $
                              ;; DST_AEDIR=DST_AEDir,DST_AEFILE=DST_AEFile, $
                              ;; DBDIR=dbDir,DBFILE=dbFile,DB_TFILE=db_tFile, $
                              DAYSIDE=dayside,NIGHTSIDE=nightside, $
                              RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                              MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ,POS_LAYOUT=pos_layout,NEG_LAYOUT=neg_layout, $
                              USE_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                              NEVBINSIZE=nEvBinsize,HISTOBINSIZE=histoBinSize, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              NOPLOTS=noPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots,SCPLOT_COLORLIST=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                              SHOW_DATA_AVAILABILITY=show_data_availability

  @utcplot_defaults.pro
  ;; plotMargin=[0.1, 0.25, 0.1, 0.15]

  ;; defSymTransp         = 95
  ;; defLineTransp        = 60
  ;; defLineThick         = 2.0

  ;; ;; ;For nEvent histos
  ;; defnEvYRange         = [0,5000]
                       
  ;; ;;defs for maxPlots
  ;; max_xtickfont_size=14
  ;; max_xtickfont_style=1
  ;; max_ytickfont_size=14
  ;; max_ytickfont_style=1
  ;; avg_symSize=2.0
  ;; avg_symThick=2.0
  ;; avg_Thick=2.5

  ;; defXTitle='Hours since storm commencement'

  ;; ;; nMajorTicks=5
  ;; ;; nMinorTicks=3
  ;; nMajorTicks=5
  ;; nMinorTicks=1

  ;; defRes = 200

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  LOAD_OMNI_DB,sw_data,SWDBDIR=swDBDir,SWDBFILE=swDBFile
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

  IF KEYWORD_SET(returned_nev_tbins_and_hist) AND ~KEYWORD_SET(nEventHists) THEN BEGIN
     PRINT,"You've asked for returned_nev_tbins_and_hist, but you haven't set nEventHists! No can do."
     RETURN
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified date range, if an array of times hasn't been provided

  IF N_ELEMENTS(stormTimeArray_utc) NE 0 THEN BEGIN

     nEpochs = N_ELEMENTS(stormTimeArray_utc)
     centerTime = stormTimeArray_utc
     tStamps = TIME_TO_STR(stormTimeArray_utc)
     stormString = 'user-provided'

  ENDIF ELSE BEGIN              ;Looks like we're relying on Brett

     nEpochs=N_ELEMENTS(stormStruct.time)
  
     GET_STORMTIME_UTC,nStorms=nEpochs,EPOCHINDS=epochInds,STORMFILE=stormFile, $
                       MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $      ;DBs
                       STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $          ;extra info
                       CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds ; outs
     
     IF saveFile THEN saveStr+=',startDate,stopDate,stormType,stormStruct_inds'

  ENDELSE

  REMOVE_EPOCH_DUPES,NEPOCHS=nEpochs,CENTERTIME=centerTime,TSTAMPS=tStamps,$
                     HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes,TAFTEREPOCH=tAfterEpoch



  ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
  datStartStop = MAKE_ARRAY(nEpochs,2,/DOUBLE)
  datStartStop(*,0) = centerTime - tBeforeEpoch*3600.   ;(*,0) are the times before which we don't want data for each epoch
  datStartStop(*,1) = centerTime + tAfterEpoch*3600.    ;(*,1) are the times after which we don't want data for each storm

  out_datStartStop = datStartStop   
  ;**************************************************
  ;generate geomag and stuff

  GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NEPOCHS=nEpochs, $
                             USE_SYMH=use_SYMH,USE_AE=use_AE,DST=dst,SW_DATA=sw_data, $
                             OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                             GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                             GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max,DO_DST=do_Dst, $
                             YRANGE=yRange,/SET_YRANGE,USE_DATA_MINMAX=use_data_minMax, $
                             DATATITLE=geomagTitle

  ;; ;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     geomagWindow=WINDOW(WINDOW_TITLE=dataTitle, $
                         DIMENSIONS=[1200,800])
     
  ENDIF ELSE BEGIN              ;Just do a regular superposition of all the plots
     IF ~noPlots THEN BEGIN
        geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormString + " storms: "+ $
                            tStamps[0] + " - " + $
                            tStamps[-1], $
                            DIMENSIONS=[1200,800])

        xTitle=defXTitle
        yTitle = geomagTitle
        xRange=[-tBeforeEpoch,tAfterEpoch]
        
        out_geomagPlots = MAKE_ARRAY(nEpochs,/OBJ)
        FOR i=0,nEpochs-1 DO BEGIN
           IF N_ELEMENTS(geomag_time_list(i)) GT 1 AND ~noPlots THEN BEGIN
              geomagEpochSeconds = geomag_time_list[i]-centerTime[i]
              geomagEpochDat = geomag_dat_list[i]
              PLOT_SW_OR_GEOMAGQUANTITY_TRACE__EPOCH,geomagEpochSeconds,geomagEpochDat, $
                                                     NAME=omni_quantity, $
                                                     AXIS_STYLE=1, $
                                                     PLOTTITLE=plotTitle, $
                                                     XTITLE='Hours since ' + tstamps[i], $
                                                     XRANGE=xRange, $
                                                     YTITLE=KEYWORD_SET(just_one_label) ? (i EQ 1 ? yTitle : !NULL ) : yTitle, $
                                                     YRANGE=yRange, $
                                                     LOGYPLOT=logYPlot, $
                                                     LINETHICK=lineThick,LINETRANSP=lineTransp, $
                                                     OVERPLOT=0, $
                                                     CURRENT=1, $
                                                     MARGIN=plotMargin, $
                                                     LAYOUT=[1,nEpochs,i+1], $
                                                     CLIP=0, $
                                                     OUTPLOT=geomagPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array

              out_geomagPlots[i] = geomagPlot

           ENDIF ELSE PRINT,'Losing epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
        ENDFOR
        
        axes=geomagPlot.axes
        ;; axes[0].MAJOR=(nMajorTicks EQ 4) ? nMajorTicks -1 : nMajorTicks
        ;; axes[1].MINOR=nMinorTicks+1
        ;; ; Has user requested overlaying DST/SYM-H with the histogram?
     ENDIF ;end noplots
  ENDELSE

  IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) $
     OR KEYWORD_SET(maxInd) OR KEYWORD_SET(show_data_availability) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
     GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                       DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                       ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                       RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                       MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                       DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                       DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                       SAVEFILE=saveFile,SAVESTR=saveStr
  ENDIF 

  IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) OR KEYWORD_SET(maxInd) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
     
     nAlfEpochs = nEpochs
     GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                                      ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                      MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                      LOG_DBQUANTITY=log_dbquantity, $
                                      CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                                      NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                      TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                      TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                      TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                      NEVTOT=nEvTot
     


     ;; GET_ALFSTORM_HISTOS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
     ;;                     ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
     ;;                     MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
     ;;                     CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
     ;;                     NEG_AND_POS_SEPAR=neg_and_pos_separ, $
     ;;                     TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
     ;;                     TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
     ;;                     TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
     ;;                     NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,ALL_NEVHIST=all_nEvHist,TBIN=tBin, $
     ;;                     CNEVHIST_POS=cNEvHist_pos,CNEVHIST_NEG=cNEvHist_neg,CALL_NEVHIST=cAll_nEvHist, $
     ;;                     HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
     ;;                     SAVEFILE=saveFile,SAVESTR=saveStr,RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist

     IF KEYWORD_SET(neg_AND_pos_separ) THEN BEGIN
        
        ENDIF ELSE BEGIN
           GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t_list,tot_alf_y_list,HISTOTYPE=histoType, $
              HISTDATA=histData, $
              HISTTBINS=histTBins, $
              NEVHISTDATA=nEvHistData, $
              TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
              NONZERO_I=nz_i
        ENDELSE
     
  ENDIF
       

  IF KEYWORD_SET(maxInd) THEN BEGIN

     mTags=TAG_NAMES(maximus)
     IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = mTags[maxInd]
     out_maxPlots = MAKE_ARRAY(nEpochs,/OBJ)
     ;; IF ~(noPlots OR noMaxPlots) THEN 
     
     PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                 ALF_IND_LIST=alf_ind_list, $
                                 LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
     
     IF ~KEYWORD_SET(overplot_alfvendbquantity) THEN BEGIN
        maxWindow=WINDOW(WINDOW_TITLE="Stacked Alfven DB data for " + stormString + " storms: "+ $
                         tStamps[0] + " - " + $
                         tStamps[-1], $
                         DIMENSIONS=[1200,800])
     ENDIF

     FOR i=0,nEpochs-1 DO BEGIN
        ;; plot_i_pos = (N_ELEMENTS(tot_plot_i_pos_list) GT 0 ? tot_plot_i_pos_list[i] : !NULL )
        ;; alf_t_pos = (N_ELEMENTS(tot_alf_t_pos_list) GT 0 ? tot_alf_t_pos_list[i] : !NULL )
        ;; alf_y_pos = (N_ELEMENTS(tot_alf_y_pos_list) GT 0 ? tot_alf_y_pos_list[i] : !NULL )
        ;; plot_i_neg = (N_ELEMENTS(tot_plot_i_neg_list) GT 0 ? tot_plot_i_neg_list[i] : !NULL )
        ;; alf_t_neg = (N_ELEMENTS(tot_alf_t_neg_list) GT 0 ? tot_alf_t_neg_list[i] : !NULL )
        ;; alf_y_neg = (N_ELEMENTS(tot_alf_y_neg_list) GT 0 ? tot_alf_y_neg_list[i] : !NULL )
        ;; plot_i = (N_ELEMENTS(tot_plot_i_list) GT 0 ? tot_plot_i_list[i] : !NULL )
        ;; alf_t = (N_ELEMENTS(tot_alf_t_list) GT 0 ? tot_alf_t_list[i] : !NULL )
        ;; alf_y = (N_ELEMENTS(tot_alf_y_list) GT 0 ? tot_alf_y_list[i] : !NULL )
        ;; PLOT_EPOCH_ALFVENDB_QUANTITY,maxInd,mTags,LOOPIDX=loopIdx,NEVRANGE=nEvRange, LOG_DBQUANTITY=log_DBQuantity, $
        ;;                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
        ;;                              PLOT_I_POS=plot_i_pos,ALF_T_POS=alf_t_pos,ALF_Y_POS=alf_y_pos, $
        ;;                              PLOT_I_NEG=plot_i_neg,ALF_T_NEG=alf_t_neg,ALF_Y_NEG=alf_y_neg, $
        ;;                              POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
        ;;                              PLOT_I_ALL=plot_i,ALF_T_ALL=alf_t,ALF_Y_ALL=alf_y, $
        ;;                              PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
        ;;                              YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
        ;;                              OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg
        
        IF KEYWORD_SET(neg_and_pos_separ) THEN BEGIN
           FOR j = 0,1 DO BEGIN
              IF j EQ 0 THEN BEGIN
                 plot_i    = (N_ELEMENTS(tot_plot_i_pos_list) GT 0 ? tot_plot_i_pos_list[i] : !NULL )
                 alf_t     = (N_ELEMENTS(tot_alf_t_pos_list) GT 0 ? tot_alf_t_pos_list[i] : !NULL )
                 alf_y     = (N_ELEMENTS(tot_alf_y_pos_list) GT 0 ? tot_alf_y_pos_list[i] : !NULL )
              ENDIF ELSE BEGIN
                 plot_i    = (N_ELEMENTS(tot_plot_i_neg_list) GT 0 ? tot_plot_i_neg_list[i] : !NULL )
                 alf_t     = (N_ELEMENTS(tot_alf_t_neg_list) GT 0 ? tot_alf_t_neg_list[i] : !NULL )
                 alf_y     = (N_ELEMENTS(tot_alf_y_neg_list) GT 0 ? tot_alf_y_neg_list[i] : !NULL )
              ENDELSE
              IF N_ELEMENTS(alf_t) GT 0 THEN BEGIN
                 PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                      SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                                      ALFDBSTRUCT=maximus,ALFDBTIME=cdbTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                                      ALF_T=alf_t,ALF_Y=alf_y, $
                                                      PLOTTITLE=plotTitle, $
                                                      XTITLE=xTitle,XRANGE=xRange, $
                                                      YTITLE=yTitle_maxInd,YRANGE=[minDat[j],maxDat[j]],LOGYPLOT=logYPlot, $
                                                      OVERPLOT_ALFVENDBQUANTITY=overplot_alfvendbquantity, $
                                                      CURRENT=1, $
                                                      MARGIN=plotMargin, $
                                                      LAYOUT=[1,nEpochs,i+1], $
                                                      CLIP=0, $
                                                      OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
              ENDIF
           ENDFOR
        ENDIF ELSE BEGIN
           plot_i = (N_ELEMENTS(tot_plot_i_list) GT 0 ? tot_plot_i_list[i] : !NULL )
           alf_t = (N_ELEMENTS(tot_alf_t_list) GT 0 ? tot_alf_t_list[i] : !NULL )
           alf_y = (N_ELEMENTS(tot_alf_y_list) GT 0 ? tot_alf_y_list[i] : !NULL )
           IF N_ELEMENTS(alf_t) GT 0 THEN BEGIN
              PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                      SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                                      ALFDBSTRUCT=maximus,ALFDBTIME=cdbTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                                      ALF_T=alf_t,ALF_Y=alf_y, $
                                                      PLOTTITLE=plotTitle, $
                                                      XTITLE=xTitle,XRANGE=xRange, $
                                                      YTITLE=yTitle_maxInd,YRANGE=[minDat,maxDat],LOGYPLOT=logYPlot, $
                                                      OVERPLOT_ALFVENDBQUANTITY=overplot_alfvendbquantity, $
                                                      CURRENT=1, $
                                                      MARGIN=plotMargin, $
                                                      LAYOUT=[1,nEpochs,i+1], $
                                                      CLIP=0, $
                                                      OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
           ENDIF
        ENDELSE
     ENDFOR     
     
     
     IF avg_type_maxInd GT 0 THEN BEGIN

        PRINT,"THIS HASN'T BEEN UPDATED TO USE THE NEW PLOT_ALFVENDBQUANTITY ROUTINES"
        STOP

        nBins=N_ELEMENTS(tBin)
        IF neg_and_pos_separ THEN BEGIN
           
           ;;combine all plot_i        
           IF N_ELEMENTS(plot_pos) GT 0 THEN BEGIN
              tot_plot_i_pos=tot_plot_i_pos_list(0)
              tot_alf_t_pos=tot_alf_t_pos_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_pos_list)-1 DO BEGIN
                 tot_plot_i_pos=[tot_plot_i_pos,tot_plot_i_pos_list(i)]
                 tot_alf_t_pos=[tot_alf_t_pos,tot_alf_t_pos_list(i)]
              ENDFOR

              Avgs_pos=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_pos=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_pos))) : ABS(maximus.(maxInd)(tot_plot_i_pos))

              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_alf_t_pos GE (tBin(0) + i*HistoBinSize) AND tot_alf_t_pos LT (tBin(0)+(i+1)*histoBinSize))
                 Avgs_pos[i] = TOTAL(avg_data_pos(temp_inds))/DOUBLE(nEvHist_pos[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_pos) AND Avgs_pos NE 0.)

              IF ~(noPlots OR noMaxPlots) THEN BEGIN
                 plot_pos=plot(tBin(safe_i)+0.5*histoBinSize, $
                               (log_DBQuantity) ? 10^Avgs_pos(safe_i) : Avgs_pos(safe_i), $
                               TITLE=plotTitle, $
                               XTITLE=defXTitle, $
                               YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                       yTitle_maxInd : $
                                       mTags(maxInd)), $
                               XRANGE=xRange, $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat[0],maxDat[0]], $
                               LINESTYLE='--', $
                               COLOR=N_ELEMENTS(scPlot_colorList) GT 0 ? scplot_colorlist[i] :  'MAROON', $
                               SYMBOL='d', $
                               AXIS_STYLE=0, $
                               LINESTYLE=' ', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               LAYOUT=[1,nEpochs,i+1], $
                               ;; LAYOUT=pos_layout, $
                               /CURRENT,/OVERPLOT, $
                               SYM_SIZE=1.5, $
                               SYM_COLOR=N_ELEMENTS(scPlot_colorList) GT 0 ? scplot_colorlist[i] :  'MAROON')
                 
              ENDIF ;end no plots

           ENDIF

           IF N_ELEMENTS(plot_neg) GT 0 THEN BEGIN
              tot_plot_i_neg=tot_plot_i_neg_list(0)
              tot_alf_t_neg=tot_alf_t_neg_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_neg_list)-1 DO BEGIN
                 tot_plot_i_neg=[tot_plot_i_neg,tot_plot_i_neg_list(i)]
                 tot_alf_t_neg=[tot_alf_t_neg,tot_alf_t_neg_list(i)]
              ENDFOR

              Avgs_neg=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_neg=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_neg))) : ABS(maximus.(maxInd)(tot_plot_i_neg))

              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_alf_t_neg GE (tBin(0) + i*HistoBinSize) AND tot_alf_t_neg LT (tBin(0)+(i+1)*histoBinSize))
                 Avgs_neg[i] = TOTAL(avg_data_neg(temp_inds))/DOUBLE(nEvHist_neg[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_neg) AND Avgs_neg NE 0.)

              IF ~(noPlots OR noMaxPlots) THEN BEGIN
                 plot_neg=plot(tBin(safe_i)+0.5*histoBinSize, $
                               (log_DBQuantity) ? 10^Avgs_neg(safe_i) : Avgs_neg(safe_i), $
                               TITLE=plotTitle, $
                               XTITLE=defXTitle, $
                               YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                       yTitle_maxInd : $
                                       mTags(maxInd)), $
                               XRANGE=xRange, $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat[1],maxDat[1]], $
                               LINESTYLE='-:', $
                               COLOR=N_ELEMENTS(scPlot_colorList) GT 0 ? scplot_colorlist[i] : 'DARK GREEN', $
                               SYMBOL='d', $
                               AXIS_STYLE=0, $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               LAYOUT=[1,nEpochs,i+1], $
                               ;; LAYOUT=neg_layout, $
                               /CURRENT,/OVERPLOT, $
                               SYM_SIZE=1.5, $
                               SYM_COLOR=N_ELEMENTS(scPlot_colorList) GT 0 ? scplot_colorlist[i] : 'DARK GREEN')
                 
              ENDIF

           ENDIF

        ENDIF ELSE BEGIN

           ;combine all plot_i
           tot_plot_i=tot_plot_i_list(0)
           tot_alf_t=tot_alf_t_list(0)
           FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO BEGIN
              tot_plot_i=[tot_plot_i,tot_plot_i_list(i)]
              tot_alf_t=[tot_alf_t,tot_alf_t_list(i)]
           ENDFOR

           Avgs=MAKE_ARRAY(nBins,/DOUBLE)
           avg_data=log_DBQuantity ? ALOG10(maximus.(maxInd)(tot_plot_i)) : maximus.(maxInd)(tot_plot_i)
           ;now loop over histogram bins, perform average
           FOR i=0,nBins-1 DO BEGIN
              temp_inds=WHERE(tot_alf_t GE (tBin(0) + i*HistoBinSize) AND tot_alf_t LT (tBin(0)+(i+1)*histoBinSize))
              Avgs[i] = TOTAL(avg_data(temp_inds))/DOUBLE(all_nEvHist[i])
           ENDFOR

           safe_i=(log_DBQuantity) ? WHERE(FINITE(Avgs) AND Avgs GT 0.) : WHERE(FINITE(Avgs))

           IF ~(noPlots OR noMaxPlots) THEN BEGIN
              avgPlot=plot(tBin(safe_i)+0.5*histoBinSize, $
                        (log_DBQuantity) ? 10^Avgs(safe_i) : Avgs(safe_i), $
                        ;; Avgs(safe_i), $
                        TITLE=plotTitle, $
                        XTITLE=defXTitle, $
                        YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                yTitle_maxInd : $
                                mTags(maxInd)), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        AXIS_STYLE=0, $
                        LINESTYLE='--', $
                        SYMBOL='d', $
                        XTICKFONT_SIZE=max_xtickfont_size, $
                        XTICKFONT_STYLE=max_xtickfont_style, $
                        YTICKFONT_SIZE=max_ytickfont_size, $
                        YTICKFONT_STYLE=max_ytickfont_style, $
                        /CURRENT,/OVERPLOT, $
                        LAYOUT=[1,nEpochs,i+1], $
                        SYM_SIZE=1.5, $
                        SYM_COLOR=N_ELEMENTS(scPlot_colorList) GT 0 ? scplot_colorlist[i] : 'g')

           ENDIF                ;end no plots

        ENDELSE
     ENDIF

     ;; IF KEYWORD_SET(saveMaxPlotName) AND ~(noPlots OR noMaxPlots) THEN BEGIN
     ;;    PRINT,"Saving maxplot to file: " + saveMaxPlotName
     ;;    maximuswindow.save,savemaxplotname,RESOLUTION=defRes
     ;; ENDIF

  ENDIF
  
  IF KEYWORD_SET(show_data_availability) THEN BEGIN
     ;;First, find out where we had data
     avail_i = WHERE(maximus.sample_t LE 0.01) ;use these for deciding if data is avail

     FOR i=0,nEpochs-1 DO BEGIN
        GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=datStartStop[i,0],T2=datStartStop[i,1], $
                                            DBSTRUCT=maximus,DBTIMES=cdbTime, RESTRICT_W_THESEINDS=avail_i, $
                                            TRANGES_ORBS=tRanges_orbs,TSPANS_ORBS=tSpans_orbs, $
                                            /PRINT_DATA_AVAILABILITY
        
        PLOT_ALFVENDB_DATA_AVAILABILITY__EPOCH,tRanges_orbs,centerTime[i], $
                                               BOTTOM_YRANGE=minDat, $
                                               CURRENT=1, $
                                               MARGIN=plotMargin, $
                                               LAYOUT=[1,nEpochs,i+1], $
                                               SYM_COLOR=sym_color, $
                                               DATAAVAILPLOT=dataAvailPlot
     ENDFOR
  ENDIF

  IF KEYWORD_SET(savePlotName) THEN BEGIN
     PRINT,"Saving plot to file: " + savePlotName
     geomagWindow.save,savePlotName,RESOLUTION=defRes
  ENDIF
  ;; out_geomagWindow = geomagWindow

  IF do_ScatterPlots THEN BEGIN
     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,$
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,COLOR_LIST=scPlot_colorList,STRANS=95, $
                                ;; OUTFILE='scatterplot--northern--four_epochs--Yao_et_al_2008.png'
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--north.png' : !NULL

     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,/SOUTH, $
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,COLOR_LIST=scPlot_colorList,STRANS=95, $
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--south.png' : !NULL
  ENDIF

  IF saveFile THEN BEGIN
     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF

END