;+
; NAME:                           SUPERPOSE_STORMS_ALFVENDBQUANTITIES
;
; PURPOSE:                        TAKE A LIST OF STORMS, SUPERPOSE THE STORMS AS WELL AS THE RELEVANT DB QUANTITIES
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
;                              EPOCHINDS         : Indices of epochs to be included within the given storm DB
;                              SSC_TIMES_UTC     : Times (in UTC) of sudden commencements
;                              REMOVE_DUPES      : Remove all duplicate epochs falling within [tBeforeEpoch,tAfterEpoch]
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
; MODIFICATION HISTORY:   2015/06/20 Born on the flight from Boston to Akron, OH en route to DC
;                         2015/08/14 Adding EPOCHINDS keywords so we can hand-pick our storms, and PLOTTITLE
;                         2015/08/17 Added NOPLOTS, NOMAXPLOTS keywords, for crying out loud.
;                         2015/08/25 Added the OUT*PLOT and OUT*WINDOW keywords so I can do rug plots and otherwise fiddle
;                         2015/10/16 Added {min,max}{mlt,ilat,lshell}                           
;                         2015/10/19 Finally suppressed creation of plot of geomagnetic quantity (Dst, SYM-H, etc.) when not desired
;                                       through NOGEOMAGPLOTS keyword.
;-
PRO SUPERPOSE_STORMS_ALFVENDBQUANTITIES,stormTimeArray_utc, $
                             TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                             STARTDATE=startDate, STOPDATE=stopDate, $
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             EPOCHINDS=epochInds, SSC_TIMES_UTC=ssc_times_utc, $
                             REMOVE_DUPES=remove_dupes, HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
                             STORMTYPE=stormType, $
                             USE_SYMH=use_symh,USE_AE=use_AE, $
                             OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                             NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, NEVRANGE=nEvRange, $
                             RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist, $
                             NEG_AND_POS_SEPAR=neg_and_pos_separ, POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                             MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
                             RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                             LOG_DBQUANTITY=log_DBquantity, $
                             YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                             BKGRND_HIST=bkgrnd_hist, BKGRND_MAXIND=bkgrnd_maxInd,TBINS=tBins, $
                             DBFILE=dbFile,DB_TFILE=db_tFile, $
                             NO_SUPERPOSE=no_superpose, $
                             NOPLOTS=noPlots, NOGEOMAGPLOTS=noGeomagPlots, NOMAXPLOTS=noMaxPlots, $
                             USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
                             SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
                             PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                             SAVEMAXPLOTNAME=saveMaxPlotName, $
                             DO_SCATTERPLOTS=do_scatterPlots,epochPlot_colorNames=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                             RANDOMTIMES=randomTimes, $
                             MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                             DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                             OUT_BKGRND_HIST=out_bkgrnd_hist,OUT_BKGRND_MAXIND=out_bkgrnd_maxind,OUT_TBINS=out_tBins, $
                             OUT_MAXPLOT=out_maxPlot,OUT_GEOMAG_PLOT=out_geomag_plot
  
  
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
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              NEVBINSIZE=nEvBinsize,MIN_NEVBINSIZE=min_NEVBINSIZE, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              NOPLOTS=noPlots,NOGEOMAGPLOTS=noGeomagPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots,epochPlot_colorNames=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  @utcplot_defaults.pro

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

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified date range, if an array of times hasn't been provided
  

  SETUP_STORMTIMEARRAY_UTC,stormTimeArray_utc,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                             nEpochs=nEpochs,EPOCHINDS=epochInds,STORMFILE=stormFile, $
                             MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $   ;DBs
                             STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $          ;extra info
                             CENTERTIME=centerTime, DATSTARTSTOP=datStartStop, TSTAMPS=tStamps, $
                             STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds, $ ; outs
                             RANDOMTIMES=randomTimes, $
                             SAVEFILE=saveFile,SAVESTR=saveString

  IF KEYWORD_SET(remove_dupes) THEN BEGIN
     REMOVE_EPOCH_DUPES,NEPOCHS=nEpochs,CENTERTIME=centerTime,TSTAMPS=tStamps,$
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

  ;; ;Get nearest events in Chaston DB
  GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                    DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                    ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                    RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                    MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                    DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                    DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                    SAVEFILE=saveFile,SAVESTR=saveStr

  ;; ;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     geomagWindow=WINDOW(WINDOW_TITLE=stormString + ' plots', $
                         DIMENSIONS=[1200,800])
     
  ENDIF ELSE BEGIN              ;Just do a regular superposition of all the plots

     xTitle=defXTitle
     yTitle = geomagTitle
     
     xRange=[-tBeforeEpoch,tAfterEpoch]
     
     IF ~noPlots AND ~noGeomagPlots THEN BEGIN
        geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormString + " storms: "+ $
                            tStamps[0] + " - " + $
                            tStamps(-1), $
                            DIMENSIONS=[1200,800])
        
        FOR i=0,nEpochs-1 DO BEGIN
           IF N_ELEMENTS(geomag_time_list[i]) GT 1 AND ~noPlots AND ~noGeomagPlots THEN BEGIN
              geomagPlot=plot((geomag_time_list[i]-centerTime[i])/3600.,geomag_dat_list[i], $
                        NAME=omni_quantity, $
                        AXIS_STYLE=1, $
                        MARGIN=plotMargin, $
                        ;; XRANGE=[0,7000./60.], $
                        XTITLE=xTitle, $
                        YTITLE=yTitle, $
                        XRANGE=xRange, $
                        YRANGE=yRange, $
                        XTICKFONT_SIZE=max_xtickfont_size, $
                        XTICKFONT_STYLE=max_xtickfont_style, $
                        YTICKFONT_SIZE=max_ytickfont_size, $
                        YTICKFONT_STYLE=max_ytickfont_style, $
                        ;; LAYOUT=[1,4,i+1], $
                        /CURRENT,OVERPLOT=(i EQ 0) ? 0 : 1, $
                        SYM_TRANSPARENCY=defSymTransp, $
                        TRANSPARENCY=defLineTransp, $
                        THICK=defLineThick) 
              
           ENDIF ELSE PRINT,'Losing epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
        ENDFOR
        
        axes=geomagPlot.axes
        ;; axes[0].MAJOR=(nMajorTicks EQ 4) ? nMajorTicks -1 : nMajorTicks
        axes[1].MINOR=nMinorTicks+1
        ;; ; Has user requested overlaying DST/SYM-H with the histogram?
     ENDIF ;end noplots 
  ENDELSE

  ;; Get ranges for plots
  minMaxDat=MAKE_ARRAY(nEpochs,2,/DOUBLE)
  
  alf_ind_list = LIST(WHERE(maximus.(maxInd) GT 0))
  alf_ind_list.add,WHERE(maximus.(maxInd) LT 0)
     
  IF neg_and_pos_separ OR ( log_DBQuantity AND (alf_ind_list[1,0] NE -1)) THEN BEGIN
     PRINT,'Got some negs here...'
     WAIT,1
  ENDIF

  nAlfEpochs = nEpochs
  GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                                ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                                NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,ALL_NEVHIST=all_nEvHist,TBIN=tBin, $
                                MIN_NEVBINSIZE=min_NEVBINSIZE,NEVTOT=nEvTot

  IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
     GET_ALFSTORM_HISTOS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                         ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                         MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                         CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                         NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                         TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                         TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                         TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                         NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,ALL_NEVHIST=all_nEvHist,TBIN=tBin, $
                         CNEVHIST_POS=cNEvHist_pos,CNEVHIST_NEG=cNEvHist_neg,CALL_NEVHIST=cAll_nEvHist, $
                         MIN_NEVBINSIZE=min_NEVBINSIZE,NEVTOT=nEvTot, $
                         SAVEFILE=saveFile,SAVESTR=saveStr,RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist

  ENDIF

  ;;now the plots
  IF KEYWORD_SET(nEventHists) AND ~noPlots THEN BEGIN

     PLOT_STORM_NEVENT_HISTS,TBIN=tBin,TSTAMPS=tStamps, $
                            NEVRANGE=nEvRange, NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                            ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                            ALF_IND_LIST=alf_ind_list, $
                            PLOTTITLE=plotTitle, OVERPLOT_HIST=overplot_hist, $
                            POS_LAYOUT=pos_layout,NEG_LAYOUT=neg_layout, $
                            GEOMAGWINDOW=geomagWindow,PLOT_NEV=plot_nEv,PLOT_BKGRND=plot_bkgrnd, $
                            RETURNED_NEV_TBINS_AND_HIST=returned_nev_tbins_and_hist ;, $
                            ;; SAVEPLOTNAME=savePlotName,SAVEFILE=saveFile,SAVESTR=saveStr

  ENDIF                         ;end IF nEventHists
  
  IF KEYWORD_SET(savePlotName) THEN BEGIN
     PRINT,"Saving plot to file: " + savePlotName
     geomagWindow.save,savePlotName,RESOLUTION=defRes
  ENDIF

  IF KEYWORD_SET(maxInd) THEN BEGIN

     mTags=TAG_NAMES(maximus)
     
     IF ~(noPlots OR noMaxPlots) THEN maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
                                                           DIMENSIONS=[1200,800])
     
     PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                 ALF_IND_LIST=alf_ind_list, $
                                 LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
     
     FOR i=0,nEpochs-1 DO BEGIN
        plot_i_pos = (N_ELEMENTS(tot_plot_i_pos_list) GT 0 ? tot_plot_i_pos_list[i] : !NULL )
        alf_t_pos = (N_ELEMENTS(tot_alf_t_pos_list) GT 0 ? tot_alf_t_pos_list[i] : !NULL )
        alf_y_pos = (N_ELEMENTS(tot_alf_y_pos_list) GT 0 ? tot_alf_y_pos_list[i] : !NULL )
        plot_i_neg = (N_ELEMENTS(tot_plot_i_neg_list) GT 0 ? tot_plot_i_neg_list[i] : !NULL )
        alf_t_neg = (N_ELEMENTS(tot_alf_t_neg_list) GT 0 ? tot_alf_t_neg_list[i] : !NULL )
        alf_y_neg = (N_ELEMENTS(tot_alf_y_neg_list) GT 0 ? tot_alf_y_neg_list[i] : !NULL )
        plot_i = (N_ELEMENTS(tot_plot_i_list) GT 0 ? tot_plot_i_list[i] : !NULL )
        alf_t = (N_ELEMENTS(tot_alf_t_list) GT 0 ? tot_alf_t_list[i] : !NULL )
        alf_y = (N_ELEMENTS(tot_alf_y_list) GT 0 ? tot_alf_y_list[i] : !NULL )
        PLOT_EPOCH_ALFVENDB_QUANTITY,maxInd,mTags,LOOPIDX=loopIdx,NEVRANGE=nEvRange, LOG_DBQUANTITY=log_DBQuantity, $
                                     NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                     PLOT_I_POS=plot_i_pos,ALF_T_POS=alf_t_pos,ALF_Y_POS=alf_y_pos, $
                                     PLOT_I_NEG=plot_i_neg,ALF_T_NEG=alf_t_neg,ALF_Y_NEG=alf_y_neg, $
                                     POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                                     PLOT_I_ALL=plot_i,ALF_T_ALL=alf_t,ALF_Y_ALL=alf_y, $
                                     PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
                                     YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
                                     OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg
        
        ;; Add the legend, if neg_and_pos_separ
        IF neg_and_pos_separ THEN BEGIN
           IF N_ELEMENTS(out_maxPlotPos) GT 0 AND N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN
              leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                           POSITION=[-20.,((KEYWORD_SET(nEvRange) ? nEvRange : [0,7500])[1])]*0.45, /DATA, $
                           /AUTO_TEXT_COLOR)
           ENDIF
        ENDIF
     ENDFOR
     
     IF avg_type_maxInd GT 0 THEN BEGIN
        
        IF neg_and_pos_separ THEN BEGIN
           IF N_ELEMENTS(out_maxPlotPos) GT 0 THEN BEGIN
              tot_plot_i_pos=tot_plot_i_pos_list[0]
              tot_alf_t_pos=tot_alf_t_pos_list[0]
              FOR i=1,N_ELEMENTS(tot_plot_i_pos_list)-1 DO BEGIN
                 tot_plot_i_pos=[tot_plot_i_pos,tot_plot_i_pos_list[i]]
                 tot_alf_t_pos=[tot_alf_t_pos,tot_alf_t_pos_list[i]]
              ENDFOR
           ENDIF

           IF N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN
              tot_plot_i_neg=tot_plot_i_neg_list[0]
              tot_alf_t_neg=tot_alf_t_neg_list[0]
              FOR i=1,N_ELEMENTS(tot_plot_i_neg_list)-1 DO BEGIN
                 tot_plot_i_neg=[tot_plot_i_neg,tot_plot_i_neg_list[i]]
                 tot_alf_t_neg=[tot_alf_t_neg,tot_alf_t_neg_list[i]]
              ENDFOR
           ENDIF
        ENDIF ELSE BEGIN
           tot_plot_i=tot_plot_i_list[0]
           tot_alf_t=tot_alf_t_list[0]
           FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO BEGIN
              tot_plot_i=[tot_plot_i,tot_plot_i_list[i]]
              tot_alf_t=[tot_alf_t,tot_alf_t_list[i]]
           ENDFOR
        ENDELSE

        GET_STORM_ALFVENDB_AVGS,maximus,TBIN=tBin, $
                            ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                            TOT_PLOT_I_POS=tot_plot_i_pos,TOT_ALF_T_POS=tot_alf_t_pos, $
                            TOT_PLOT_I_NEG=tot_plot_i_neg,TOT_ALF_T_NEG=tot_alf_t_neg, $
                            AVGS_POS=avgs_pos,AVGS_NEG=avgs_neg,AVGS=avgs,SAFE_I=safe_i, $
                            OUT_TBINS=out_tBins,OUT_BKGRND_MAXIND=out_bkgrnd_maxInd

        IF ~(noPlots OR noMaxPlots) THEN BEGIN
           PLOT_STORM_ALFVENDB_AVGS,maximus,TBIN=tBin, LOG_DBQUANTITY=log_DBQuantity, $
                                    AVGS_POS=avgs_pos,AVGS_NEG=avgs_neg,AVGS=avgs,SAFE_I=safe_i, $
                                    ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                                    POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                                    PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
                                    YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
                                    OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg, $
                                    OUT_TBINS=out_tBins,OUT_BKGRND_MAXIND=out_bkgrnd_maxInd
        ENDIF
     ENDIF

     IF KEYWORD_SET(bkgrnd_maxInd) AND ~noPlots THEN BEGIN

        safe_i=(log_DBQuantity) ? WHERE(FINITE(bkgrnd_maxInd) AND bkgrnd_maxInd GT 0.) : WHERE(FINITE(bkGrnd_maxInd))

        y_offset = (log_DBQuantity) ? 1. : TOTAL(bkgrnd_maxind[safe_i])*0.1
        ;; y_offset = 0.
        IF N_ELEMENTS(tBins) EQ 0 THEN STOP
        plot_bkgrnd_max=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                             (log_DBQuantity) ? 10^(bkgrnd_maxInd[safe_i]-y_offset) : bkgrnd_maxInd[safe_i]-y_offset, $
                             XRANGE=xRange, $
                             YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                             yRange_maxInd : [minDat,maxDat], $
                             YLOG=(log_DBQuantity) ? 1 : 0, $
                             NAME='Background Alfvén activity', $
                             AXIS_STYLE=0, $
                             LINESTYLE='--', $
                             COLOR='blue', $
                             THICK=2.0, $
                             SYMBOL='d', $
                             SYM_SIZE=2.5, $
                             MARGIN=plotMargin_max, $
                             /CURRENT)
        
        legPosY=(KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat])
        IF (log_DBQuantity) THEN BEGIN
           ;; legPosY=10.^MEAN(ALOG10(legPosY))
           legPosY=10.^(ALOG10(legPosY[1])-ALOG10(5))
        ENDIF ELSE legPosY=MEAN(legPosY)

        leg = LEGEND(TARGET=[avgplot,plot_bkgrnd_max], $
                     POSITION=[-15.,legPosY], /DATA, $
                     /AUTO_TEXT_COLOR)

        
        ;;For plotting guidelines
        guide_linestyle='__'
        plot_bkgrnd_8=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                             MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^8), $
                             XRANGE=xRange, $
                             YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                             yRange_maxInd : [minDat,maxDat], $
                             YLOG=(log_DBQuantity) ? 1 : 0, $
                             AXIS_STYLE=0, $
                             LINESTYLE=guide_linestyle, $
                             ;; SYMBOL='', $
                             ;; SYM_SIZE=1.5, $
                             COLOR='black', $
                             THICK=1.5, $
                             MARGIN=plotMargin_max, $
                             /CURRENT)
        plot_bkgrnd_7=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                             MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^7), $
                             XRANGE=xRange, $
                             YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                             yRange_maxInd : [minDat,maxDat], $
                             YLOG=(log_DBQuantity) ? 1 : 0, $
                             AXIS_STYLE=0, $
                             LINESTYLE=guide_linestyle, $
                             ;; SYMBOL='', $
                             ;; SYM_SIZE=1.5, $
                             COLOR='black', $
                             THICK=1.5, $
                             MARGIN=plotMargin_max, $
                             /CURRENT)
        plot_bkgrnd_6=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                             MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^6), $
                             XRANGE=xRange, $
                             YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                             yRange_maxInd : [minDat,maxDat], $
                             YLOG=(log_DBQuantity) ? 1 : 0, $
                             AXIS_STYLE=0, $
                             LINESTYLE=guide_linestyle, $
                             ;; SYMBOL='', $
                             ;; SYM_SIZE=1.5, $
                             COLOR='black', $
                             THICK=1.5, $
                             MARGIN=plotMargin_max, $
                             /CURRENT)

        out_maxPlotAll = plot_bkgrnd_max

     ENDIF
     
     IF KEYWORD_SET(saveMaxPlotName) AND ~(noPlots OR noMaxPlots) THEN BEGIN
        PRINT,"Saving maxplot to file: " + saveMaxPlotName
        maximuswindow.save,savemaxplotname,RESOLUTION=defRes
     ENDIF

  ENDIF
  
  IF do_ScatterPlots THEN BEGIN
     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,$
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,STRANS=98, $
                                ;; OUTFILE='scatterplot--northern--four_storms--Yao_et_al_2008.png'
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--north.png' : !NULL

     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,/SOUTH, $
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,STRANS=98, $
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--south.png' : !NULL
  ENDIF

  IF saveFile THEN BEGIN
     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF

END