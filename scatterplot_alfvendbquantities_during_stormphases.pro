;+
; NAME:                           SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASE
;
; PURPOSE:                        Take data acquired during geomagnetic storms, and plot the
;                                 observed quantities versus each other!
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          
;                              
;                              START_UTC         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOP_UTC          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              PLOTTITLE         : Title of superposed plot
;                              SAVEFILE          : Save scatter data. Note, it won't erase other saved scatterplot data provided
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
; MODIFICATION HISTORY:   2015/12/04 Ripped off HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERPLAY_PHASES
;                                    
;
;-
PRO SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
   RESTOREFILE=restoreFile, $
   stormTimeArray_utc, $
   START_UTC=start_UTC, STOP_UTC=stop_UTC, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   HEMI=hemi, $
   NPLOTROWS=nPlotRows, $
   NPLOTCOLUMNS=nPlotColumns, $
   MAXIND1=maxInd1, $
   MAXIND2=maxInd2, $
   CUSTOM_MAXIND1=custom_maxInd1, $
   CUSTOM_MAXNAME1=custom_maxName1, $
   CUSTOM_MAXIND2=custom_maxInd2, $
   CUSTOM_MAXNAME2=custom_maxName2, $
   ;; NORMALIZE_MAXIND_HIST=normalize_maxInd_hist, $
   RANGE_MAXIND1=range_maxInd1, $
   TITLE_MAXIND1=title_maxInd1, $
   RANGE_MAXIND2=range_maxInd2, $
   TITLE_MAXIND2=title_maxInd2, $
   LOG_MAXIND1=log_maxInd1, $
   LOG_MAXIND2=log_maxInd2, $
   LOGPLOT_MAXIND1=logPlot_maxInd1, $
   LOGPLOT_MAXIND2=logPlot_maxInd2, $
   ONLY_POS1=only_pos1, $
   ONLY_POS2=only_pos2, $
   ONLY_NEG1=only_neg1, $
   ONLY_NEG2=only_neg2, $
   ABSVAL1=absVal1, $
   ABSVAL2=absVal2, $
   XMINOR=xMinor, $
   YMINOR=yMinor, $
   RESTRICT_ALTRANGE=restrict_altRange, $
   RESTRICT_CHARERANGE=restrict_charERange, $
   DO_UNLOGGED_STATISTICS=unlog_statistics, $
   DO_LOGGED_STATISTICS=log_statistics, $
   DBFILE=dbFile, $
   DB_TFILE=db_tFile, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   DO_DESPUNDB=do_despundb, $
   SAVEFILE=saveFile, $
   SAVEDIR=saveDir, $
   PLOTTITLE=plotTitle, $
   SAVEPLOT=savePlot, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   PLOTSUFFIX=plotSuffix, $
   PLOTCOLOR=plotColor, $
   OUTPLOTARR=outPlotArr, $
   OUT_PLOT_I=out_plot_i, $
   OUTLINFITSTR_LIST=outLinFitStr_list, $
   OUTLINEPLOTARR=outLinePlotArr, $
   WINDOW_TITLE=window_title, $
   CURRENT_WINDOW=window, $
   SYM_TRANSPARENCY=sym_transparency, $
   SYM_COLOR=sym_color

  date            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  newLine         = '!C'

  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  SET_STORMS_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                              DAYSIDE=dayside,NIGHTSIDE=nightside, $
                              RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                              MAXIND=maxInd, $
                              LOG_DBQUANTITY=log_maxInd1, $
                              USING_HEAVIES=using_heavies, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                              ;; LAYOUT=layout, $
                              SAVEMPNAME=saveMPName, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              PLOTTITLE=plotTitle,SAVEPNAME=savePName

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
                           ALTITUDERANGE=restrict_altRange, $
                           CHARERANGE=charERange, $
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
               'Main phase', $
               'Recovery phase']
  alf_i_list=LIST()

  IF KEYWORD_SET(custom_maxInd1) THEN BEGIN
     IF KEYWORD_SET(custom_maxName1) THEN dataName1 = custom_maxName1 ELSE dataName1 = 'custom_maxInd1'
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(custom_maxName1) THEN dataName1 = custom_maxName1 ELSE dataName1 = STRING(FORMAT='(I2)',maxInd1) + '_' + (TAG_NAMES(maximus))[maxInd1]
  ENDELSE

  IF KEYWORD_SET(custom_maxInd2) THEN BEGIN
     IF KEYWORD_SET(custom_maxName2) THEN dataName2 = custom_maxName2 ELSE dataName2 = 'custom_maxInd2'
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(custom_maxName2) THEN dataName2 = custom_maxName2 ELSE dataName2 = STRING(FORMAT='(I2)',maxInd2) + '_' + (TAG_NAMES(maximus))[maxInd2]
  ENDELSE

  IF NOT KEYWORD_SET(plotSuffix) THEN tempSuffix = "" ELSE tempSuffix = '--' + plotSuffix
  ;;data out
  genFile_pref    = date + '--scatterplot_stormphases--' + dataName1 + '_vs_' + dataName2 + '.pro'
  outstats        = date + 'scatterplot_stormphases--' + dataName1 + '_vs_' + dataName2 + '--data.sav'

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/VERBOSE,/ADD_TODAY

  saveName        = plotDir + date + '--scatterplot_stormphases--' + dataName1 + '_vs_' + dataName2 + tempSuffix + '.png'
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;declare the slice structure array, null lists
  ssa            = N_ELEMENTS(out_ssa) EQ 0? !NULL : out_ssa
  ;; linFitStrArr   = !NULL
  linFitStr_list = N_ELEMENTS(outLinFitStr_list) EQ 0 ? LIST() :  outLinFitStr_list

  nFinite1       = !NULL
  nFinite2       = !NULL
  nTotal1        = !NULL
  nTotal2        = !NULL

  tot_alf_x_list = LIST()
  tot_alf_y_list = LIST()

  FOR i=0,2 DO BEGIN

     temptempSuffix1 = tempSuffix
     temptempSuffix2 = tempSuffix

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
     
     ;;maxInd1
     IF KEYWORD_SET(custom_maxInd1) THEN BEGIN
        tempData1 = GET_CUSTOM_ALFVENDB_QUANTITY(custom_maxInd1,MAXIMUS=maximus,/VERBOSE)
        tempData1 = tempData1[alf_i]
     ENDIF ELSE BEGIN
        tempData1 = maximus.(maxInd1)[alf_i]
     ENDELSE
     IF KEYWORD_SET(custom_maxInd2) THEN BEGIN
        tempData2 = GET_CUSTOM_ALFVENDB_QUANTITY(custom_maxInd2,MAXIMUS=maximus,/VERBOSE)
        tempData2 = tempData2[alf_i]
     ENDIF ELSE BEGIN
        tempData2 = maximus.(maxInd2)[alf_i]
     ENDELSE     

     IF KEYWORD_SET(only_pos1) OR KEYWORD_SET(only_neg1) OR KEYWORD_SET(absVal1) THEN BEGIN
        PRINT,"Splitting data1..."
        junk = CONV_QUANTITY_TO_POS_NEG_OR_ABS(tempData1, $
                                                    QUANTITY_NAME=dataName1, $
                                                    ONLY_POS=only_pos1, $
                                                    ONLY_NEG=only_neg1, $
                                                    ABSVAL=absVal1, $
                                                    INDICES=new_ii_1, $
                                                    USER_RESPONSE=user_response, $
                                                    ADD_SUFF_TO_THIS_STRING=temptempSuffix1, $
                                                    LUN=lun)
        edited1 = 1
     ENDIF ELSE edited1 = 0

     IF KEYWORD_SET(only_pos2) OR KEYWORD_SET(only_neg2) OR KEYWORD_SET(absVal2) THEN BEGIN
        PRINT,"Splitting data2..."
        junk = CONV_QUANTITY_TO_POS_NEG_OR_ABS(tempData2, $
                                                    QUANTITY_NAME=dataName2, $
                                                    ONLY_POS=only_pos2, $
                                                    ONLY_NEG=only_neg2, $
                                                    ABSVAL=absVal2, $
                                                    INDICES=new_ii_2, $
                                                    USER_RESPONSE=user_response, $
                                                    ADD_SUFF_TO_THIS_STRING=temptempSuffix2, $
                                                    LUN=lun)
        edited2 = 1
     ENDIF ELSE edited2 = 0

     CASE 1  OF
        edited1 AND edited2: BEGIN
           new_ii = CGSETINTERSECTION(new_ii_1,new_ii_2)
           edited = 1
        END
        edited1 AND ~edited2: BEGIN
           new_ii = new_ii_1
           edited = 1
        END
        ~edited1 AND edited2: BEGIN
           new_ii = new_ii_2
           edited = 1
        END
        ~edited1 AND ~edited2: BEGIN
           edited = 0
        END
     ENDCASE

     IF edited THEN BEGIN
        alf_i     = alf_i[new_ii]
        tempData1 = tempData1[new_ii]
        tempData2 = tempData2[new_ii]
     ENDIF

     IF KEYWORD_SET(log_maxInd1) THEN BEGIN
        tempData1 = ALOG10(tempData1)
     ENDIF
     IF KEYWORD_SET(log_maxInd2) THEN BEGIN
        tempData2 = ALOG10(tempData2)
     ENDIF

     ;;check data to make sure they're safe
     nFinite1 = [nFinite1,N_ELEMENTS(WHERE(FINITE(tempData1)))]
     nTotal1  = [nTotal1,N_ELEMENTS(alf_i)]
     nFinite2 = [nFinite2,N_ELEMENTS(WHERE(FINITE(tempData2)))]
     nTotal2  = [nTotal2,N_ELEMENTS(alf_i)]
     IF (nFinite1[i] NE nTotal1[i]) THEN BEGIN
        PRINT,FORMAT='(A0,T30,":",T33,I0," finite, ",I0," total!")',strings[i],nFinite1[i],nTotal1[i]
        PRINT,"Beware ... why do you have negs in " + dataName1 + "?"
        STOP
     ENDIF ELSE BEGIN
        IF (nFinite2[i] NE nTotal2[i]) THEN BEGIN
           PRINT,FORMAT='(A0,T30,":",T33,I0," finite, ",I0," total!")',strings[i],nFinite2[i],nTotal2[i]
           PRINT,"Beware ... why do you have negs in " + dataName2 + "?"
           STOP
        ENDIF ELSE BEGIN
           tot_alf_y_list.add,tempData2
           tot_alf_x_list.add,tempData1
           alf_i_list.add,alf_i
        ENDELSE
     ENDELSE
     


  ENDFOR

  ;;make the structs
  FOR i=0,2 DO BEGIN

     tempData1   = tot_alf_x_list[i]
     tempData2   = tot_alf_y_list[i]

     ;;doing logged or unlogged statistics?
     IF KEYWORD_SET(log_maxInd1) THEN BEGIN
        IF KEYWORD_SET(unlog_statistics) THEN BEGIN
           tempStats1 = MOMENT(10^tempData1)
           tempStats2 = MOMENT(10^tempData2)
        ENDIF ELSE BEGIN
           tempStats1 = MOMENT(tempData1)
           tempStats2 = MOMENT(tempData2)
        ENDELSE
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(log_statistics) THEN BEGIN
           tempStats1 = MOMENT(ALOG10(tempData1))
           tempStats2 = MOMENT(ALOG10(tempData2))
        ENDIF ELSE BEGIN
           tempStats1 = MOMENT(tempData1)
           tempStats2 = MOMENT(tempData2)
        ENDELSE
     ENDELSE

     tempScatterStruct = MAKE_SCATTERPLOT_STRUCT(DATANAME1=dataName1+'--'+strings[i], $
                                                 DATANAME2=dataName2+'--'+strings[i], $
                                                 EPOCHSTART=t1_arr[0], $
                                                 EPOCHEND=t1_arr[-1], $
                                                 DATA1=tempData1, $
                                                 DATA2=tempData2, $
                                                 IS_LOGGED_DATA1=log_maxInd1, $
                                                 IS_LOGGED_DATA2=log_maxInd2, $
                                                 MOMENTSTRUCT1=MAKE_MOMENT_STRUCT(tempData1), $
                                                 MOMENTSTRUCT2=MAKE_MOMENT_STRUCT(tempData2), $
                                                 GENERATING_FILE=genFile)

     tempLinFitStruct = MAKE_LINFIT_STRUCT(tempData1,tempData2)

     ;;add 'em
     ssa              = [ssa,tempScatterStruct]
     linFitStr_list.add,tempLinFitStruct
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;print stats
  ;; PRINT_EPOCHSLICE_STRUCT_STATS,ssa

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;window setup
  IF N_ELEMENTS(window) EQ 0 THEN BEGIN
     wTitle        = 'Storm-phase Scatter Plots'
     window     = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1250,900])
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;plot array/window setup
  nPlots      = nPlotRows*nPlotColumns
  plotArr     = N_ELEMENTS(outPlotArr) EQ 0 ? MAKE_ARRAY(nPlots,/OBJ) : outPlotArr
  linePlotArr = N_ELEMENTS(outLinePlotArr) EQ 0 ? MAKE_ARRAY(nPlots,/OBJ) : outLinePlotArr

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;plot details
  xTitle     = !NULL ;KEYWORD_SET(title_maxInd1) ? title_maxInd1 : dataName1
  yTitle     = !NULL ;KEYWORD_SET(title_maxInd2) ? title_maxInd2 : dataName2
  xRange     = KEYWORD_SET(range_maxInd1) ? range_maxInd1 : $
               [MIN(LIST_TO_1DARRAY(tot_alf_x_list,/WARN)), $
                MAX(LIST_TO_1DARRAY(tot_alf_x_list,/WARN))]
  yRange     = KEYWORD_SET(range_maxInd2) ? range_maxInd2 : $
               [MIN(LIST_TO_1DARRAY(tot_alf_y_list,/WARN)), $
                MAX(LIST_TO_1DARRAY(tot_alf_y_list,/WARN))]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;plot settings and colors for each storm phase
  stormColors          = ["blue","red","black"] ;nonstorm, main phase, recovery phase

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;do it
  plot_i               = N_ELEMENTS(out_plot_i) GT 0 ? out_plot_i : 1
  FOR i=0,2 DO BEGIN
     x                 = ssa[i].xList[0]      ;the indata
     y                 = ssa[i].yList[0]
     
     sym_color         = stormColors[i]

     ;; layout            = [nPlotColumns,nPlotRows,plot_i]
     plotColumn       = ( (plot_i - 1) MOD nPlotColumns )
     plotRow          = (plot_i - 1)/nPlotColumns

     ;;for titles
     mLeft               = 0.06
     mBottom             = 0.06
     mRight              = 0.02
     mTop                = KEYWORD_SET(window_title) ? 0.04 : 0.02
     hSpaceTwixt         = 0.04
     vSpaceTwixt         = 0.03

     plotPos             = CALC_PLOT_POSITION(plot_i,nPlotColumns,nPlotRows, $
                                              WMARGIN_LEFT=mLeft, $
                                              WMARGIN_RIGHT=mRight, $
                                              WMARGIN_BOTTOM=mBottom, $
                                              WMARGIN_TOP=mTop, $
                                              SPACE_HORIZ_BETWEEN_COLS=hSpaceTwixt, $
                                              SPACE_VERT_BETWEEN_ROWS=vSpaceTwixt)
     
     plotArr[plot_i-1]   = SCATTERPLOT(x,y, $
                                       ;; TITLE=(i EQ 0 AND KEYWORD_SET(plotTitle)) ? plotTitle : !NULL, $
                                       NAME=niceStrings[i], $
                                       XTITLE=xTitle, $
                                       YTITLE=yTitle, $
                                       XMINOR=xMinor, $
                                       XRANGE=xRange, $
                                       YMINOR=yMinor, $
                                       XLOG=logPlot_maxInd1, $
                                       YLOG=logPlot_maxInd2, $
                                       YRANGE=yRange, $
                                       XSHOWTEXT=(plotRow EQ nPlotRows-1) ? !NULL : 0, $
                                       YSHOWTEXT=(plotColumn EQ 0) ? !NULL : 0, $
                                       ;; LAYOUT=layout, $
                                       POSITION=plotPos, $
                                       ;; FONT_SIZE=defHPlot_xTitle__fSize, $
                                       ;; MARGIN=margin, $
                                       CURRENT=window, $
                                       SYM_COLOR=sym_color, $
                                       SYM_TRANSPARENCY=KEYWORD_SET(sym_transparency) ? sym_transparency : 90) ; $

     
     linePlotArr[plot_i-1] = PLOT(x,linFitStr_list[plot_i-1].yFit, $
                                  /OVERPLOT, $
                                  ;; LAYOUT=layout, $
                                  POSITION=position, $
                                  LINESTYLE=0, $
                                  XRANGE=xRange, $
                                  YRANGE=yRange, $
                                  XLOG=logPlot_maxInd1, $
                                  YLOG=logPlot_maxInd2, $
                                  ;; COLOR=stormColors[i], $
                                  ;; TRANSPARENCY=(i EQ 0) ? 80 : 80, $
                                  THICK=1.5, $
                                  CURRENT=window)
     

     leText = TEXT(0.5,0.09, $
                   STRING(FORMAT='("y = ",F0.3," + (",F0.3,")x",A0,' $
                          + '"r = ",F0.3,A0,' $
                          ;; + '"p = ",F0.3,A0,' $
                          + '"N = ",I0)', $
                          linFitStr_list[plot_i-1].fitParams[0], $
                          linFitStr_list[plot_i-1].fitParams[1],newLine, $
                          ;; linFitStr_list[plot_i-1].chiSqr, newLine, $
                          CORRELATE(x,y), newLine, $
                          ;; linFitStr_list[plot_i-1].prob,newLine, $
                         N_ELEMENTS(y)), $
                   ;; FONT_COLOR='green', $
                   FONT_SIZE=10, $
                   FONT_STYLE='italic', $
                   /RELATIVE, $
                   TARGET=linePlotArr[plot_i-1])

     ;; ;adjust axes
     ;; ax                   = plotArr[plot_i-1].axes

     IF plotRow EQ 0 THEN BEGIN
        phaseText = TEXT(MEAN([plotPos[0],plotPos[2]]),plotPos[1]-0.55*hSpaceTwixt,niceStrings[i], $
                         FONT_SIZE=15, $
                         ALIGNMENT=0.5, $
                         TARGET=window)
     ENDIF

     plot_i++

  ENDFOR

  IF KEYWORD_SET(title_maxInd1) THEN BEGIN
     xTitleText = text(mLeft+0.5*(1.0-mLeft-mRight),0.013, $
                      title_maxInd1, $
                      ;; FONT_NAME='Courier', $
                      ALIGNMENT=defHPlot_xTitle__hAlign, $
                      FONT_SIZE=defHPlot_xTitle__fSize, $
                      /NORMAL, $
                      TARGET=window, $
                      CLIP=0)
  ENDIF

  IF KEYWORD_SET(title_maxInd2) THEN BEGIN
     yTitleText = TEXT(0.02,0.5, $
                       title_maxInd2, $
                       ;; FONT_NAME='Courier', $
                       ALIGNMENT=defHPlot_xTitle__hAlign, $
                       FONT_SIZE=defHPlot_xTitle__fSize, $
                       ORIENTATION=90, $
                       /NORMAL, $
                       TARGET=window, $
                       CLIP=0)
  ENDIF

  IF KEYWORD_SET(window_title) AND plotRow EQ 0 THEN BEGIN
     winTitleText = TEXT(mLeft+0.5*(1.0-mLeft-mRight),1.0-mTop*0.65, $
                         window_title, $
                         ALIGNMENT=0.5, $
                         FONT_SIZE=defHPlot_xTitle__fSize, $
                         /NORMAL, $
                         TARGET=window, $
                         CLIP=0)
  ENDIF

  IF KEYWORD_SET(savePlot) THEN BEGIN
     PRINT,'Saving plot to ' + saveName + '...'
     window.save,saveName,RESOLUTION=300
  ENDIF

  outPlotArr        = plotArr
  outLinFitStr_list = linFitStr_list
  out_plot_i        = plot_i
  outLinePlotArr    = linePlotArr

  IF KEYWORD_SET(saveFile) THEN BEGIN

     IF N_ELEMENTS(saveFileName) EQ 0 THEN BEGIN
        saveFileName        = date + plotDir + date + '--scatterplot_stormphases--' + dataName1 + '_vs_' + dataName2 + tempSuffix + '.sav'
     ENDIF

     IF KEYWORD_SET(saveDir) THEN saveFileName = saveDir + '/' + saveFileName

     IF FILE_TEST(saveFileName) THEN BEGIN
        PRINT,'scatterplot savefile "' + saveFileName + '" exists!'
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
        PRINT,'scatterplot savefile "' + saveFileName + '" does not exist; creating a new one ...'
        saved_ssa_list = LIST(ssa)
     ENDELSE 

     PRINT,'Saving scatterplot data to "' + saveFileName + '" ...'
     SAVE,saved_ssa_list,FILENAME=saveFileName
  ENDIF

END