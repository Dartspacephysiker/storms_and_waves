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
                                        NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                        LAYOUT=layout, $
                                        POS_LAYOUT=pos_layout, $
                                        NEG_LAYOUT=neg_layout, $
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
                                        DO_SCATTERPLOTS=do_scatterPlots, $
                                        EPOCHPLOT_COLORNAMES=epochPlot_colorNames, $
                                        SCATTEROUTPREFIX=scatterOutPrefix, $
                                        RANDOMTIMES=randomTimes, $
                                        MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                        DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                        OUT_BKGRND_HIST=out_bkgrnd_hist,OUT_BKGRND_MAXIND=out_bkgrnd_maxind,OUT_TBINS=out_tBins, $
                                        OUT_MAXPLOT=out_maxPlot,OUT_GEOMAG_PLOT=out_geomag_plot
  
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  SET_STORMS_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                              DAYSIDE=dayside,NIGHTSIDE=nightside, $
                              RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                              MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                              LAYOUT=layout, $
                              POS_LAYOUT=pos_layout, $
                              NEG_LAYOUT=neg_layout, $
                              USE_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              NEVBINSIZE=nEvBinsize,HISTOBINSIZE=histoBinSize, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              NOPLOTS=noPlots,NOGEOMAGPLOTS=noGeomagPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots,EPOCHPLOT_COLORNAMES=epochPlot_colorNames,SCATTEROUTPREFIX=scatterOutPrefix, $
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

  ;; ;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     geomagWindow=WINDOW(WINDOW_TITLE=stormString + ' plots', $
                         DIMENSIONS=[1200,800])
     
  ENDIF ELSE BEGIN              ;Just do a regular superposition of all the plots

     xTitle=defXTitle
     xRange=[-tBeforeEpoch,tAfterEpoch]
     yTitle = geomagTitle
     
     IF ~noPlots AND ~noGeomagPlots THEN BEGIN
        geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormString + " storms: "+ $
                            tStamps[0] + " - " + $
                            tStamps(-1), $
                            DIMENSIONS=[1200,800])
        
        FOR i=0,nEpochs-1 DO BEGIN
           IF N_ELEMENTS(geomag_time_list[i]) GT 1 AND ~noPlots AND ~noGeomagPlots THEN BEGIN
              geomagEpochSeconds = geomag_time_list[i]-centerTime[i]
              geomagEpochDat = geomag_dat_list[i]
              PLOT_SW_OR_GEOMAGQUANTITY_TRACE__EPOCH,geomagEpochSeconds,geomagEpochDat, $
                                                     NAME=omni_quantity, $
                                                     AXIS_STYLE=1, $
                                                     PLOTTITLE=plotTitle, $
                                                     XTITLE=xTitle, $
                                                     XRANGE=xRange, $
                                                     YTITLE=yTitle, $
                                                     YRANGE=yRange, $
                                                     LOGYPLOT=logYPlot, $
                                                     LINETHICK=lineThick,LINETRANSP=lineTransp, $
                                                     OVERPLOT=(i EQ 0) ? 0 : 1, $
                                                     CURRENT=1, $
                                                     MARGIN=plotMargin, $
                                                     LAYOUT=!NULL, $
                                                     ;; CLIP=0, $
                                                     OUTPLOT=geomagPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array

              ;; out_geomagPlots[i] = geomagPlot

           ENDIF ELSE PRINT,'Losing epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
        ENDFOR
        
        axes=geomagPlot.axes
        axes[1].MINOR=nMinorTicks+1
     ENDIF ;end noplots 
  ENDELSE

  ;; Get ranges for plots
  IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) OR KEYWORD_SET(maxInd) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
     ;; ;Get nearest events in Chaston DB
     ;; GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
     ;;                                   DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
     ;;                                   ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
     ;;                                   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
     ;;                                   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
     ;;                                   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
     ;;                                   DAYSIDE=dayside,NIGHTSIDE=nightside, $
     ;;                                   SAVEFILE=saveFile,SAVESTR=saveStr

     GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                       DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                       ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                       RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                       MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                       DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                       DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                       SAVEFILE=saveFile,SAVESTR=saveStr
     

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
     ENDELSE
  ENDIF

  ;;now the plots
  IF KEYWORD_SET(nEventHists) AND ~noPlots THEN BEGIN

     IF KEYWORD_SET(neg_AND_pos_separ) THEN BEGIN
        PRINT,"Nevhists not implemented for neg and pos yet..."
        WAIT,5
     ENDIF ELSE BEGIN
        PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins,nEvhistData,NAME=name, $
                                               XRANGE=xRange, $
                                               HISTORANGE=histoRange, $
                                               YTITLE=yTitle, $
                                               MARGIN=plotMargin, $
                                               PLOTTITLE=plotTitle, $
                                               OVERPLOT_HIST=overplot_hist, $
                                               LAYOUT=layout, $
                                               WINDOW=window,HISTOPLOT=histoPlot, $
                                               BKGRND_HIST=bkgrnd_hist,BKGRNDHISTOPLOT=bkgrndHistoPlot, $
                                               OUTPLOT=outPlot,OUTBKGRNDPLOT=outBkgrndPlot, $
                                               ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array   
     ENDELSE

  ENDIF                         ;end IF nEventHists
  
  IF KEYWORD_SET(savePlotName) THEN BEGIN
     PRINT,"Saving plot to file: " + savePlotName
     geomagWindow.save,savePlotName,RESOLUTION=defRes
  ENDIF

  IF KEYWORD_SET(maxInd) THEN BEGIN

     mTags=TAG_NAMES(maximus)
     yTitle = (KEYWORD_SET(yTitle_maxInd) ? yTitle_maxInd : mTags[maxInd])
     IF ~(noPlots OR noMaxPlots) THEN BEGIN
        maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
                             DIMENSIONS=[1200,800])
        maximusWindow.setCurrent
     ENDIF

     PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                 ALF_IND_LIST=alf_ind_list, $
                                 LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
     
     ;; FOR i=0,nEpochs-1 DO BEGIN
        IF KEYWORD_SET(neg_and_pos_separ) THEN BEGIN
           posneg_colors = MAKE_ARRAY(2,/STRING)
           IF KEYWORD_SET(pos_color) THEN posneg_colors[0] = pos_color ELSE posneg_colors[0] = defPosColor
           IF KEYWORD_SET(neg_color) THEN posneg_colors[1] = pos_color ELSE posneg_colors[1] = defNegColor
           FOR j = 0,1 DO BEGIN
              IF j EQ 0 THEN BEGIN
                 ;; plot_i    = (N_ELEMENTS(tot_plot_i_pos_list) GT 0 ? tot_plot_i_pos_list[i] : !NULL )
                 ;; alf_t     = (N_ELEMENTS(tot_alf_t_pos_list) GT 0 ? tot_alf_t_pos_list[i] : !NULL )
                 ;; alf_y     = (N_ELEMENTS(tot_alf_y_pos_list) GT 0 ? tot_alf_y_pos_list[i] : !NULL )
                 alf_t     = tot_alf_t_pos
                 alf_y     = tot_alf_y_pos
                 IF KEYWORD_SET(pos_layout) THEN pn_layout = pos_layout ELSE pn_layout = [1,1,1]
              ENDIF ELSE BEGIN
                 ;; plot_i    = (N_ELEMENTS(tot_plot_i_neg_list) GT 0 ? tot_plot_i_neg_list[i] : !NULL )
                 ;; alf_t     = (N_ELEMENTS(tot_alf_t_neg_list) GT 0 ? tot_alf_t_neg_list[i] : !NULL )
                 ;; alf_y     = (N_ELEMENTS(tot_alf_y_neg_list) GT 0 ? tot_alf_y_neg_list[i] : !NULL )
                 alf_t     = tot_alf_t_neg
                 alf_y     = tot_alf_y_neg
                 IF N_ELEMENTS(neg_layout) GT 0 THEN pn_layout = [[pn_layout],[neg_layout]] ELSE pn_layout = [[pn_layout],[1,1,1]]
                 
              ENDELSE
              IF N_ELEMENTS(alf_t) GT 0 AND ~(KEYWORD_SET(noPlots) OR KEYWORD_SET(noMaxPlots)) THEN BEGIN
                 IF KEYWORD_SET(log_dbquantity) THEN alf_y =  10.0^(alf_y)
                 PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                      SYMCOLOR=posneg_colors[j],SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                                      ;; ALFDBSTRUCT=maximus,ALFDBTIME=cdbTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                                      ALF_T=alf_t,ALF_Y=alf_y, $
                                                      PLOTTITLE=plotTitle, $
                                                      XTITLE=xTitle, $
                                                      XRANGE=xRange, $
                                                      YTITLE=yTitle, $
                                                      YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat[j],maxDat[j]], $
                                                      LOGYPLOT=logYPlot, $
                                                      OVERPLOT_ALFVENDBQUANTITY=(j EQ 0) ? 0 : 1, $
                                                      CURRENT=N_ELEMENTS(maximusWindow) GT 0, $
                                                      MARGIN=plotMargin, $
                                                      LAYOUT=pn_layout[*,j], $
                                                      CLIP=0, $
                                                      OUTPLOT=(j EQ 0) ? out_maxPlotPos : out_maxPlotNeg, $
                                                      ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
              ENDIF
           ENDFOR
        ENDIF ELSE BEGIN
           ;; plot_i = (N_ELEMENTS(tot_plot_i_list) GT 0 ? tot_plot_i_list[i] : !NULL )
           ;; alf_t = (N_ELEMENTS(tot_alf_t_list) GT 0 ? tot_alf_t_list[i] : !NULL )
           ;; alf_y = (N_ELEMENTS(tot_alf_y_list) GT 0 ? tot_alf_y_list[i] : !NULL )
           ;; symColor = N_ELEMENTS(epochPlot_colorNames) GT 0 ? epochPlot_colorNames[i MOD N_ELEMENTS(epochPlot_colorNames)] : symColor
           alf_t     = tot_alf_t
           alf_y     = tot_alf_y
           symColor = N_ELEMENTS(epochPlot_colorNames) GT 0 ? epochPlot_colorNames[0] : symColor
           IF N_ELEMENTS(alf_t) GT 0 AND ~(KEYWORD_SET(noPlots) OR KEYWORD_SET(noMaxPlots)) THEN BEGIN
              IF KEYWORD_SET(log_dbquantity) THEN alf_y =  10.0^(alf_y)
              PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                   SYMCOLOR=symColor, $
                                                   SYMTRANSPARENCY=symTransparency, $
                                                   SYMBOL=symbol, $
                                                   ALF_T=alf_t, $
                                                   ALF_Y=alf_y, $
                                                   PLOTTITLE=plotTitle, $
                                                   XTITLE=xTitle, $
                                                   XRANGE=xRange, $
                                                   YTITLE=yTitle, $
                                                   YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                                                   LOGYPLOT=log_dbquantity, $
                                                   ;; OVERPLOT_ALFVENDBQUANTITY=(i EQ 0) ? 0 : 1, $
                                                   OVERPLOT_ALFVENDBQUANTITY=0, $
                                                   CURRENT=N_ELEMENTS(maximusWindow) GT 0, $
                                                   MARGIN=plotMargin, $
                                                   LAYOUT=layout, $
                                                   ;; CLIP=0, $
                                                   OUTPLOT=out_maxPlotAll, $
                                                   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
           ENDIF
        ENDELSE
        ;; Add the legend, if neg_and_pos_separ
        IF neg_and_pos_separ THEN BEGIN
           IF N_ELEMENTS(out_maxPlotPos) GT 0 AND N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN
              leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                           POSITION=[-20.,((KEYWORD_SET(nEvRange) ? nEvRange : [0,7500])[1])]*0.45, /DATA, $
                           /AUTO_TEXT_COLOR)
           ENDIF
        ENDIF
     ;; ENDFOR
     
     IF avg_type_maxInd GT 0 THEN BEGIN
        ;; histoType = avg_type_maxind

        IF ~(noPlots OR noMaxPlots) THEN BEGIN
           
           PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH,histData,histTBins,HISTOTYPE=histoType,$
              ;; NEVHISTDATA=nEvHistData, $
              TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize, $
              NONZERO_I=nz_i, $
              SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
              PLOTNAME=plotName, $
              PLOTTITLE=plotTitle, $
              XTITLE=xTitle, $
              XRANGE=xRange, $
              YTITLE=yTitle, $
              YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
              LOGYPLOT=log_dbquantity, $
              OVERPLOT=overPlot, $
              CURRENT=1, $
              MARGIN=plotMargin, $
              LAYOUT=layout, $
              OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
           ;; PLOT_STORM_ALFVENDB_AVGS,maximus,TBIN=tBin, LOG_DBQUANTITY=log_DBQuantity, $
           ;;                          AVGS_POS=avgs_pos,AVGS_NEG=avgs_neg,AVGS=avgs,SAFE_I=safe_i, $
           ;;                          ALL_NEVHIST=nEvHistData,NEVHISTDATA_POS=nEvHistData_pos,NEVHISTDATA_NEG=nEvHistData_neg,NEVTOT=nEvTot, $
           ;;                          POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
           ;;                          PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
           ;;                          YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
           ;;                          OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg, $
           ;;                          OUT_TBINS=out_tBins,OUT_BKGRND_MAXIND=out_bkgrnd_maxInd
        ENDIF
     ENDIF

     IF KEYWORD_SET(bkgrnd_maxInd) AND ~noPlots THEN BEGIN

        safe_i=(log_DBQuantity) ? WHERE(FINITE(bkgrnd_maxInd) AND bkgrnd_maxInd GT 0.) : WHERE(FINITE(bkGrnd_maxInd))

        y_offset = (log_DBQuantity) ? 1. : TOTAL(bkgrnd_maxind[safe_i])*0.1
        ;; y_offset = 0.
        IF N_ELEMENTS(tBins) EQ 0 THEN STOP
        plot_bkgrnd_max=plot(tBins[safe_i]+0.5*histoBinSize, $
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
        ;; guide_linestyle='__'
        ;; plot_bkgrnd_8=plot(tBins[safe_i]+0.5*histoBinSize, $
        ;;                      MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^8), $
        ;;                      XRANGE=xRange, $
        ;;                      YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
        ;;                      yRange_maxInd : [minDat,maxDat], $
        ;;                      YLOG=(log_DBQuantity) ? 1 : 0, $
        ;;                      AXIS_STYLE=0, $
        ;;                      LINESTYLE=guide_linestyle, $
        ;;                      ;; SYMBOL='', $
        ;;                      ;; SYM_SIZE=1.5, $
        ;;                      COLOR='black', $
        ;;                      THICK=1.5, $
        ;;                      MARGIN=plotMargin_max, $
        ;;                      /CURRENT)
        ;; plot_bkgrnd_7=plot(tBins[safe_i]+0.5*histoBinSize, $
        ;;                      MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^7), $
        ;;                      XRANGE=xRange, $
        ;;                      YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
        ;;                      yRange_maxInd : [minDat,maxDat], $
        ;;                      YLOG=(log_DBQuantity) ? 1 : 0, $
        ;;                      AXIS_STYLE=0, $
        ;;                      LINESTYLE=guide_linestyle, $
        ;;                      ;; SYMBOL='', $
        ;;                      ;; SYM_SIZE=1.5, $
        ;;                      COLOR='black', $
        ;;                      THICK=1.5, $
        ;;                      MARGIN=plotMargin_max, $
        ;;                      /CURRENT)
        ;; plot_bkgrnd_6=plot(tBins[safe_i]+0.5*histoBinSize, $
        ;;                      MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^6), $
        ;;                      XRANGE=xRange, $
        ;;                      YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
        ;;                      yRange_maxInd : [minDat,maxDat], $
        ;;                      YLOG=(log_DBQuantity) ? 1 : 0, $
        ;;                      AXIS_STYLE=0, $
        ;;                      LINESTYLE=guide_linestyle, $
        ;;                      ;; SYMBOL='', $
        ;;                      ;; SYM_SIZE=1.5, $
        ;;                      COLOR='black', $
        ;;                      THICK=1.5, $
        ;;                      MARGIN=plotMargin_max, $
        ;;                      /CURRENT)

        ;; out_maxPlotAll = plot_bkgrnd_max

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