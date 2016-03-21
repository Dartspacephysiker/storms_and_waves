;+
; NAME:                           HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES
;
; PURPOSE:                        Take data from a bunch of geomagnetic storms, and plot the
;                                 histograms of each epoch slice (e.g., histogram of all upflowing
;                                 ion flux from hour -5 to hour 0 of the storm epoch.
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFOREEPOCH      : Amount of time (hours) to plot before a given DST min
;                              TAFTEREPOCH       : Amount of time (hours) to plot after a given DST min
;                              START_UTC         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOP_UTC          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    0: standard averaging; 1: log averaging (if /LOG_DBQUANTITY is set)
;                              LOG_DBQUANTITY    : Plot the quantity from the Alfven wave database on a log scale
;                              NO_SUPERPOSE      : Don't superpose Alfven wave DB quantities over Dst/SYM-H 
;                               
;                              PLOTTITLE         : Title of superposed plot
;                              SAVEFILE          : Save histoplot data. Note, it won't erase other saved histoplot data provided
;                                                    they are stored in the variable 'saved_ssa_list'.
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
; MODIFICATION HISTORY:   2015/12/04 Ripped off HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES because
;                                    Professor LaBelle and I would like to see storm phases overlaid
;                         2016/01/05 Added some stuff for SAVEFILE keyword so that we can save histoplot data for examination.
;                         2016/01/26 Added USING_HEAVIES keywords below in case we're using heavy-ion data
;-
PRO HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
   RESTOREFILE=restoreFile, $
   stormTimeArray_utc, $
   START_UTC=start_UTC, STOP_UTC=stop_UTC, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   HEMI=hemi, $
   LAYOUT=layout, $
   MAXIND=maxInd, $
   CUSTOM_MAXIND=custom_maxInd, $
   CUSTOM_MAXNAME=custom_maxName, $
   NORMALIZE_MAXIND_HIST=normalize_maxInd_hist, $
   HISTXRANGE_MAXIND=histXRange_maxInd, $
   HISTXTITLE_MAXIND=histXTitle_maxInd, $
   HISTYRANGE_MAXIND=histYRange_maxInd, $
   HISTYTITLE__ONLY_ONE=histYTitle__only_one, $
   HISTBINSIZE_MAXIND=histBinsize_maxInd, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   ONLY_POS=only_pos, $
   ONLY_NEG=only_neg, $
   ABSVAL=absVal, $
   AVG_TYPE_MAXIND=avg_type_maxInd, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   LOG_DBQUANTITY=log_DBQuantity, $
   DO_UNLOGGED_STATISTICS=unlog_statistics, $
   DO_LOGGED_STATISTICS=log_statistics, $
   DO_BOOTSTRAP_MEDIAN=bootstrap_median, $
   TBINS=tBins, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   DO_DESPUNDB=do_despundb, $
   SAVEFILE=saveFile, $
   SAVEDIR=saveDir, $
   PLOTTITLE=plotTitle, $
   SAVEPLOT=savePlot, $
   ;; SAVEPNAME=savePName, $
   RANDOMTIMES=randomTimes, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   PLOTSUFFIX=plotSuffix, $
   PLOTCOLOR=plotColor, $
   OUTPLOTARR=outPlotArr, $
   HISTOPLOT_PARAM_STRUCT=pHP, $
   NO_STATISTICS_TEXT=no_statistics_text, $
   NO_LEGEND=no_legend, $
   ;; OVERPLOTARR=overplotArr, $
   CURRENT_WINDOW=window, $
   FILL_BACKGROUND=fill_background, $
   FILL_TRANSPARENCY=fill_transparency, $
   FILL_COLOR=fill_color

  date            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  newLine         = '!C'

  IF NOT KEYWORD_SET(histBinsize_maxInd) THEN histBinsize_maxInd     = 0.25

  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  SET_STORMS_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                              DAYSIDE=dayside,NIGHTSIDE=nightside, $
                              RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                              MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                              USING_HEAVIES=using_heavies, $
                              YLOGSCALE_MAXIND=yLogScale_maxInd, $
                              YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                              LAYOUT=layout, $
                              ;; POS_LAYOUT=pos_layout, $
                              ;; NEG_LAYOUT=neg_layout, $
                              USE_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              SAVEMPNAME=saveMPName, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              PLOTTITLE=plotTitle,SAVEPNAME=savePName, $
                              NOPLOTS=noPlots,NOGEOMAGPLOTS=noGeomagPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots, $
EPOCHPLOT_COLORNAMES=epochPlot_colorNames,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  COMPILE_OPT idl2

  @utcplot_defaults.pro

  IF NOT KEYWORD_SET(hemi) THEN hemi = 'BOTH'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,DB_BRETT=stormFile,DBDIR=stormDir

  ;;********************************************************
  ;;Now clean and tap the database
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DB_TFILE=DB_tFile,DBDIR=DBDir,DBFILE=DBFile, $
                           DO_DESPUNDB=do_despundb,USING_HEAVIES=using_heavies
  good_i = GET_CHASTON_IND(maximus,satellite,lun, $
                           DBTIMES=cdbTime,dbfile=dbfile, $
                           CHASTDB=do_chastdb, $
                           DESPUNDB=do_despundb, $
                           USING_HEAVIES=using_heavies, $
                           HEMI=hemi, $
                           ORBRANGE=orbRange, $
                           ALTITUDERANGE=N_ELEMENTS(restrict_altRange) EQ 1 ? [1000,5000] : (N_ELEMENTS(restrict_altRange) GT 1 ? restrict_altRange : !NULL), $
                           CHARERANGE=N_ELEMENTS(restrict_charERange) EQ 1 ? [4,4000] : (N_ELEMENTS(restrict_charERange) GT 1 ? restrict_charERange : !NULL), $
                           POYNTRANGE=poyntRange, $
                           MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                           HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd, $
                           DAYSIDE=dayside,NIGHTSIDE=nightside)
     
  ;;******************************
  ;;Get indices for storm phases
  LOAD_DST_AE_DBS,dst,ae

  IF NOT KEYWORD_SET(start_UTC) THEN start_UTC = str_to_time('1996-10-06/16:26:02.417')
  IF NOT KEYWORD_SET(stop_UTC)  THEN stop_UTC  = str_to_time('2000-10-06/00:08:45.188')

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
     DSTCUTOFF=DstCutoff, $
     STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp, $
     EARLIEST_UTC=start_UTC,LATEST_UTC=stop_UTC, $
     LUN=lun


  ;;******************************
  ;;Some setup stuff
  justData = 1
  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  suff = STRING(FORMAT='("--Dstcutoff_",I0)',dstCutoff)
  strings=["nonstorm"+suff,"mainphase"+suff,"recoveryphase"+suff]
  niceStrings=["Non-storm", $
               ;; 'Main phase (Dst < ' + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + ' nT)', $
               'Main phase', $
               'Recovery phase']
  alf_i_list=LIST()

  IF KEYWORD_SET(custom_maxInd) THEN BEGIN
     IF KEYWORD_SET(custom_maxName) THEN dataName = custom_maxName ELSE dataName = 'custom_maxInd'
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(custom_maxName) THEN dataName = custom_maxName ELSE dataName = STRING(FORMAT='(I2)',maxInd) + '_' + (TAG_NAMES(maximus))[maxInd]
  ENDELSE

  IF NOT KEYWORD_SET(plotSuffix) THEN tempSuffix = "" ELSE tempSuffix = '--' + plotSuffix
  ;;data out
  genFile_pref    = date + '--' + dataName + '--from_histoplot_alfvendbquantities_during_stormphases__overlaid_phases.pro'
  outstats        = date + '--' + dataName + '_moment_data_for_stormphases.sav'

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/VERBOSE,/ADD_TODAY

  saveName        = plotDir + 'stormphase_histos--overlaid_phases--' + dataName + tempSuffix + '.png' ;savePlotSuffix
  

  ;;declare the slice structure array, null lists
  ssa            = !NULL
  integralArr    = MAKE_ARRAY(3,/INTEGER)

  nFinite        = !NULL
  nTotal         = !NULL
  tot_alf_t_list = LIST()
  tot_alf_y_list = LIST()

  FOR i=0,2 DO BEGIN

     temptempSuffix = tempSuffix

     temp_dst_i=dst_i_list[i]

     ;;Now you've got the start and stop times
     GET_STREAKS,temp_dst_i,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
     t1_arr = dst.time[temp_dst_i[start_dst_ii]]
     t2_arr = dst.time[temp_dst_i[stop_dst_ii]]

     GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
        DBSTRUCT=maximus,DBTIMES=cdbTime, RESTRICT_W_THESEINDS=good_i, $
        OUT_INDS_LIST=alf_i,  $
        UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
        INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
        PRINT_DATA_AVAILABILITY=print_data_availability, $
        LIST_TO_ARR=1,$
        VERBOSE=verbose, DEBUG=debug, LUN=lun
     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Now actually get the data
     IF KEYWORD_SET(custom_maxInd) THEN BEGIN
        tempData = GET_CUSTOM_ALFVENDB_QUANTITY(custom_maxInd,MAXIMUS=maximus,/VERBOSE)
        tempData = tempData[alf_i]
     ENDIF ELSE BEGIN
        tempData = maximus.(maxInd)[alf_i]
     ENDELSE
     
     IF KEYWORD_SET(only_pos) OR KEYWORD_SET(only_neg) OR KEYWORD_SET(absVal) THEN BEGIN
        PRINT,"Splitting data..."
        tempData = CONV_QUANTITY_TO_POS_NEG_OR_ABS(tempData, $
                   QUANTITY_NAME=dataName, $
                   ONLY_POS=only_pos, $
                   ONLY_NEG=only_neg, $
                   ABSVAL=absVal, $
                   INDICES=new_ii, $
                   USER_RESPONSE=user_response, $
                   ADD_SUFF_TO_THIS_STRING=temptempSuffix, $
                   LUN=lun)

        alf_i = alf_i[new_ii]
     ENDIF ;ELSE BEGIN
     ;;    tempData = maximus.(maxInd)[alf_i]
     ;; ENDELSE

     IF ~KEYWORD_SET(custom_maxInd) THEN BEGIN
        IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
           PRINT,'Dividing by WIDTH_X!'
           
           inds_to_scale_to_cm       = [15,16,17,18,26,28,30]
           scale_to_cm               = WHERE(maxInd EQ inds_to_scale_to_cm) 
           IF scale_to_cm[0] EQ -1 THEN BEGIN
              factor = 1.D
           ENDIF ELSE BEGIN 
              factor = .01D 
              PRINT,'...Scaling WIDTH_X to centimeters for maxInd='+STRCOMPRESS(maxInd,/REMOVE_ALL)+'...'
           ENDELSE
           
           inds_needing_scaled_width = [10,11,17,18]
           need_to_scale_width       = WHERE(maxInd EQ inds_needing_scaled_width)
           IF need_to_scale_width[0] EQ -1 THEN BEGIN
              magFieldFactor         = 1.0D
           ENDIF ELSE BEGIN
              PRINT,'Scaling width to ionosphere before dividing!'
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DO_DESPUNDB=maximus.despun
              magFieldFactor         = SQRT(mapRatio.ratio[WHERE(FINITE(tempData))]) ;This scales width_x to the ionosphere
           ENDELSE
           
           tempData[WHERE(FINITE(tempData))] = tempData[WHERE(FINITE(tempData))]*factor*magFieldFactor/maximus.width_x[WHERE(FINITE(tempData))]
        ENDIF
        
        IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
           PRINT,'Multiplying by WIDTH_X!'
           
           inds_to_scale_to_cm       = [999] ;Just ESA number flux, which isn't currently implemented
           scale_to_cm               = WHERE(maxInd EQ inds_to_scale_to_cm) 
           IF scale_to_cm[0] EQ -1 THEN BEGIN
              factor = 1.D
           ENDIF ELSE BEGIN 
              factor = .01D 
              PRINT,'...Scaling WIDTH_X to centimeters for maxInd='+STRCOMPRESS(maxInd,/REMOVE_ALL)+'...'
           ENDELSE
           
           CASE maxInd OF
              49: BEGIN
                 LOAD_MAPPING_RATIO_DB,mapRatio, $
                                       DO_DESPUNDB=maximus.despun
                 IF maximus.corrected_fluxes THEN BEGIN ;Assume that pFlux has been multiplied by mapRatio
                    PRINT,'Undoing a square-root factor of multiplication by magField ratio for Poynting flux ...'
                    magFieldFactor        = 1.D/SQRT(mapRatio.ratio[WHERE(FINITE(tempData))]) ;This undoes the full multiplication by mapRatio performed in CORRECT_ALFVENDB_FLUXES
                 ENDIF ELSE BEGIN
                    magFieldFactor        = SQRT(mapRatio.ratio[WHERE(FINITE(tempData))])
                 ENDELSE
              END
              ELSE: BEGIN
                 magFieldFactor           = 1.0
              END
           ENDCASE

           tempData[WHERE(FINITE(tempData))] = tempData[WHERE(FINITE(tempData))]*factor*magFieldFactor*maximus.width_x[WHERE(FINITE(tempData))]
        ENDIF
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(divide_by_width_x) OR KEYWORD_SET(multiply_by_width_x) THEN BEGIN
           PRINT,"Can't divide or multiply by width_x! You're set for a custom maxInd!"
           STOP
        ENDIF
     ENDELSE

     IF KEYWORD_SET(log_DBQuantity) THEN BEGIN
        PRINT,"Logging these data..."
        tempData = ALOG10(tempData)
     ENDIF

     ;;check data to make sure they're safe
     nFinite = [nFinite,N_ELEMENTS(WHERE(FINITE(tempData)))]
     nTotal  = [nTotal,N_ELEMENTS(alf_i)]
     IF nFinite[i] NE nTotal[i] THEN BEGIN
        PRINT,FORMAT='(A0,T30,":",T33,I0," finite, ",I0," total!")',strings[i],nFinite[i],nTotal[i]
        PRINT,"Beware ... why do you have negs in these data?"
        tempData = prompt__conv_quantity_to_pos_neg_or_abs(maximus.(maxInd)[alf_i], $
                                                           INDICES=new_ii, $
                                                           ADD_SUFF_TO_THIS_STRING=temptempSuffix)
        IF KEYWORD_SET(log_DBQuantity) THEN BEGIN
           PRINT,"Logging these data..."
           tempData = ALOG10(tempData)
        ENDIF


        tot_alf_y_list.add,tempData
        alf_i    = alf_i[new_ii]
        ;;update savename
        saveName = plotDir + 'stormphase_histos--' + dataName + temptempSuffix + '.png'

     ENDIF ELSE BEGIN
        ;; IF KEYWORD_SET(log_DBQuantity) THEN BEGIN
        ;;    tot_alf_y_list.add,ALOG10(maximus.(maxInd)[alf_i])
        ;; ENDIF ELSE BEGIN
        ;;    tot_alf_y_list.add,maximus.(maxInd)[alf_i]
        ;; ENDELSE
        tot_alf_y_list.add,tempData
     ENDELSE

     alf_i_list.add,alf_i
     tot_alf_t_list.add,cdbTime[alf_i]


  ENDFOR

  ;;plot details
  xTitle     = KEYWORD_SET(histXTitle_maxInd) ? histXTitle_maxInd : dataName
  yTitle     = "Count"
  xRange     = KEYWORD_SET(histXRange_maxInd) ? histXRange_maxInd : $
               [MIN(LIST_TO_1DARRAY(tot_alf_y_list,/WARN)), $
                MAX(LIST_TO_1DARRAY(tot_alf_y_list,/WARN))]
  ;;yRange handled below--you'll see why

  pHP        = N_ELEMENTS(pHP) GT 0 ? pHP : MAKE_HISTOPLOT_PARAM_STRUCT(NAME=dataName, $
                                                                        XTITLE=xTitle, $
                                                                        YTITLE=yTitle, $
                                                                        XRANGE=xRange, $
                                                                        YRANGE=yRange, $
                                                                        HISTBINSIZE=histBinsize_maxInd, $
                                                                        XP_ARE_LOGGED=log_DBQuantity)

  ;;make the structs
  FOR i=0,2 DO BEGIN

     tempData   = tot_alf_y_list[i]

     ;;doing logged or unlogged statistics?
     IF KEYWORD_SET(log_DBQuantity) THEN BEGIN
        IF KEYWORD_SET(unlog_statistics) THEN BEGIN
           tempStats = MOMENT(10^tempData)
        ENDIF ELSE BEGIN
           tempStats = MOMENT(tempData)
        ENDELSE
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(log_statistics) THEN BEGIN
           tempStats = MOMENT(ALOG10(tempData))
        ENDIF ELSE BEGIN
           tempStats = MOMENT(tempData)
        ENDELSE
     ENDELSE

     tempStats  = MOMENT(tempData)
     tempESlice = MAKE_EPOCHSLICE_STRUCT(DATANAME=dataName+'--'+strings[i], $
                                         EPOCHSTART=t1_arr[0], $
                                         EPOCHEND=t2_arr[-1], $
                                         YDATA=tempData, $
                                         IS_LOGGED_YDATA=log_DBQuantity, $
                                         /DO_HIST, $
                                         HISTMIN=pHP.xRange[0], $
                                         HISTMAX=pHP.xRange[1], $
                                         HISTBINSIZE=histBinsize_maxInd, $
                                         TDATA=tot_alf_t, $
                                         MOMENTSTRUCT=MAKE_MOMENT_STRUCT(tempData), $
                                         GENERATING_FILE=genFile)

     ssa        = [ssa,tempESlice]
  ENDFOR

  ;;print stats
  PRINT_EPOCHSLICE_STRUCT_STATS,ssa

  ;;window setup
  IF N_ELEMENTS(window) EQ 0 THEN BEGIN
     wTitle        = dataName + ' during storm phases'
     window     = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])
  ENDIF

  ;;plot array/window setup
  plotLayout = KEYWORD_SET(layout) ? layout : [1,1,1]
  nPPerWind  = plotLayout[0]*plotLayout[1]*3
  plotArr    = N_ELEMENTS(outPlotArr) EQ 0 ? MAKE_ARRAY(nPPerWind,/OBJ) : outPlotArr
  ;; firstmarg  = [0.1,0.1,0.1,0.1]
  ;; firstmarg  = [0.18,0.09,0.08,0.09]

  IF KEYWORD_SET(histYRange_maxInd) THEN php.yRange = histYRange_maxInd ELSE BEGIN
     IF NOT KEYWORD_SET(normalize_maxInd_hist) THEN BEGIN
        tempMax      = MAX(ssa[0].yHistStr.hist[0])
        pHP.yRange   = [0,CEIL(tempMax/10.^(FLOOR(ALOG10(tempMax))))*10.^(FLOOR(ALOG10(tempMax)))]
     ENDIF 
  ENDELSE
  ;; yRange     = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,1000]


  ;;plot settings and colors for each storm phase
  stormColors          = ["blue","red","black"] ;nonstorm, main phase, recovery phase
  ;; stormFill            = [1,1,1]
  stormFill            = [0,0,0]
  stormTransp          = KEYWORD_SET(normalize_maxInd_hist) ? $ 
                         [80,80,85] : $
                         [80,80,80]
  stormLineThick       = KEYWORD_SET(normalize_maxInd_hist) ? $
                         [4.2,4.2,4.2] : $
                         [5.0,5.0,5.0]
  stormLinestyle       = [0,0,2] ;solid, solid, dash
                         

  FOR i=0,2 DO BEGIN
     ;;the indata
     x                 = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
     y                 = ssa[i].yHistStr.hist[0] 
     
     integral          = TOTAL(y)
     integralArr[i]    = integral
     IF KEYWORD_SET(normalize_maxInd_hist) THEN BEGIN
        y              = y / integral
        pHP.yRange     = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,0.3]

        ;; y              = y / DOUBLE(MAX(y))
        ;; pHP.yRange     = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,1.0]

        pHP.yTitle     = 'Relative Frequency'
     ENDIF 
     
     ;; title             = STRING(FORMAT='(A0)',niceStrings[i])
     ;; xTitle            = pHP.xTitle

     CASE plotLayout[2] OF
        1: BEGIN
           yShowText   = 1
           yTitle      = pHP.yTitle
           margin      = defHPlot__firstMarg
           
        END
        2: BEGIN
           margin      = defHPlot__lastMarg
           
           IF KEYWORD_SET(histYTitle__only_one) THEN BEGIN
              yTitle      = !NULL
              ;; yShowText   = 0
           ENDIF ELSE BEGIN
              yTitle      = pHP.yTitle
              ;; yShowText   = 1
           ENDELSE
           
        END
     ENDCASE

     plot_i            = i+3*(plotLayout[2]-1)

     plotArr[plot_i]   = plot(x,y, $
                              TITLE=(i EQ 0 AND KEYWORD_SET(plotTitle)) ? plotTitle : !NULL, $
                              NAME=niceStrings[i], $
                              ;; XTITLE=xTitle, $
                              YTITLE=yTitle, $
                              XMINOR=4, $
                              XRANGE=pHP.xRange, $
                              YMINOR=4, $
                              YRANGE=pHP.yRange, $
                              YSHOWTEXT=yShowText, $
                              /HISTOGRAM, $
                              ;; LAYOUT=[plotLayout,i+1], $
                              LAYOUT=plotLayout, $
                              FONT_SIZE=defHPlot_xTitle__fSize, $
                              MARGIN=margin, $
                              CURRENT=window, $
                              ;; COLOR=plotColor, $
                              COLOR=stormColors[i], $
                              TRANSPARENCY=(i EQ 0) ? 40 : 40, $
                              THICK=stormLineThick[i], $
                              LINESTYLE=stormLinestyle[i], $
                              OVERPLOT=(i GT 0) ? 1 : 0, $ ;N_ELEMENTS(outplotArr) GT 0 ? outplotArr[i] : !NULL, $
                              ;; FILL_BACKGROUND=fill_background, $
                              FILL_BACKGROUND=stormFill[i], $
                              ;; FILL_TRANSPARENCY=KEYWORD_SET(fill_transparency) ? fill_transparency : 70, $
                              ;; FILL_COLOR=KEYWORD_SET(fill_color) ? fill_color : plotColor)
                              FILL_TRANSPARENCY=stormTransp[i], $
                              FILL_COLOR=stormColors[i])
     
     ;;adjust axes
     ax                = plotArr[plot_i].axes

     
     CASE plotLayout[2] OF
        1: BEGIN
           ax[1].showText = 1
           ax[3].showText = 0
        END
        2: BEGIN
           ax[1].showText = 0
           ax[3].showText = 1
        END
     ENDCASE

     ;;;;;;;;;;;;;
     ;;The new way
     ;; IF N_ELEMENTS(outplotArr) EQ 0 THEN BEGIN
     IF ~KEYWORD_SET(no_statistics_text) THEN BEGIN
        IF i EQ 0 THEN BEGIN
           textStr     = STRING(FORMAT=$
                                '(A0,I0,A0,' + $
                                'A0,E0.2,A0,' + $
                                'A0,E0.2,A0,' + $
                                'A0,E0.2,A0,' + $
                                'A0,E0.2,A0,' + $
                                'A0,E0.2,A0)', $
                                'Integral  : ', integral          , newLine, $
                                'Mean      : ', ssa[i].moments.(0), newLine, $
                                'Median    : ', ssa[i].moments.(4)[1], newLine, $
                                'Std. dev. : ', ssa[i].moments.(1), newLine, $
                                'Skewness  : ', ssa[i].moments.(2), newLine, $
                                'Kurtosis  : ', ssa[i].moments.(3), newLine)
           
           ;; int_x       = 1/FLOAT(plotLayout[0]) + 0.14/plotLayout[0]
           int_x       = (plotLayout[2]-1)/FLOAT(plotLayout[0]) + 0.08
           
        ENDIF ELSE BEGIN
           textStr     = STRING(FORMAT=$
                                '(I0,A0,' + $
                                'E0.2,A0,' + $
                                'E0.2,A0,' + $
                                'E0.2,A0,' + $
                                'E0.2,A0,' + $
                                'E0.2,A0)', $
                                integral          , newLine, $
                                ssa[i].moments.(0), newLine, $
                                ssa[i].moments.(4)[1], newLine, $
                                ssa[i].moments.(1), newLine, $
                                ssa[i].moments.(2), newLine, $
                                ssa[i].moments.(3), newLine)
           
           ;; int_x       = ( ( (i) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.22
           IF i EQ 1 THEN BEGIN
              ;; int_x       = ( ( (i) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.14/plotLayout[0] + 0.19/plotLayout[0]
              int_x       = (plotLayout[2]-1)/FLOAT(plotLayout[0]) + 0.08 + 0.19
           ENDIF ELSE BEGIN
              ;; int_x       = ( ( (i) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.14/plotLayout[0] + 0.28/plotLayout[0]
              int_x       = (plotLayout[2]-1)/FLOAT(plotLayout[0]) + 0.08 + 0.28
           ENDELSE
        ENDELSE
        int_y             = .75
        
        
        intText           = text(int_x,int_y,$
                                 textStr, $
                                 FONT_NAME='Courier', $
                                 FONT_COLOR=stormColors[i], $
                                 /NORMAL, $
                                 TARGET=plotArr[plot_i])
     ENDIF
        
  ENDFOR

  IF plot_i EQ 2 AND ~KEYWORD_SET(no_legend) THEN BEGIN
     legend         = LEGEND(TARGET=plotArr[3*(plotLayout[2]-1):3*(plotLayout[2]-1)+2], $
                             POSITION=[0.58/plotLayout[0]+(plotLayout[0] GT 1 ? 0.1 : 0.0),0.875], $
                             ;; POSITION=[0.87/plotLayout[0],0.87], $
                             HORIZONTAL_ALIGNMENT=0.5, $
                             VERTICAL_SPACING=defHPlot_legend__vSpace, $
                             /NORMAL, $
                             /AUTO_TEXT_COLOR)


  ENDIF

  IF KEYWORD_SET(histXTitle_maxInd) THEN BEGIN
     titleText = text(defHPlot_xTitle__xCoord,defHPlot_xTitle__yCoord, $
                      histXTitle_maxInd, $
                      ;; FONT_NAME='Courier', $
                      ALIGNMENT=defHPlot_xTitle__hAlign, $
                      FONT_SIZE=defHPlot_xTitle__fSize, $
                      /NORMAL, $
                      TARGET=window, $
                      CLIP=0)
  ENDIF

  ;; IF KEYWORD_SET(plotTitle) THEN BEGIN
  ;;    titleText   = text(0.5,0.96,plotTitle, $
  ;;                       FONT_SIZE=14, $
  ;;                       /NORMAL, $
  ;;                       TARGET=window, $
  ;;                       CLIP=0)
  ;; ENDIF

  IF KEYWORD_SET(savePlot) THEN BEGIN
     PRINT,'Saving plot to ' + saveName + '...'
     window.save,saveName,RESOLUTION=300
  ENDIF

  outPlotArr = plotArr

  IF KEYWORD_SET(saveFile) THEN BEGIN

     IF N_ELEMENTS(saveFileName) EQ 0 THEN BEGIN
        saveFileName        = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--stormphase_histos--overlaid_phases--' + STRING(FORMAT='(I2)',maxInd) + $
                              '_' + dataName + tempSuffix + '.sav'
     ENDIF

     IF KEYWORD_SET(saveDir) THEN saveFileName = saveDir + '/' + saveFileName

     IF FILE_TEST(saveFileName) THEN BEGIN
        PRINT,'histoplot savefile "' + saveFileName + '" exists!'
        PRINT,'Restoring...'
        RESTORE,saveFileName

        IF N_ELEMENTS(saved_ssa_list) EQ 0 THEN BEGIN
           PRINT,"No saved storm slice arrays in this file. Creating a new one ..."
           saved_ssa_list = LIST(ssa)
        ENDIF ELSE BEGIN
           PRINT,"This file contains " + STRCOMPRESS(n_ELEMENTS(saved_ssa_list),/REMOVE_ALL) + " storm slice arrays. Adding ..."
           saved_ssa_list.add,ssa
        ENDELSE

     ENDIF ELSE BEGIN
        PRINT,'histoplot savefile "' + saveFileName + '" does not exist; creating a new one ...'
        saved_ssa_list = LIST(ssa)
     ENDELSE 

     PRINT,'Saving histoplot data to "' + saveFileName + '" ...'
     SAVE,saved_ssa_list,FILENAME=saveFileName
  ENDIF

END