;+
; NAME:                           HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES
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
;                              NEG_AND_POS_SEPAR : Do plots of negative and positive log numbers separately
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    0: standard averaging; 1: log averaging (if /LOG_DBQUANTITY is set)
;                              LOG_DBQUANTITY    : Plot the quantity from the Alfven wave database on a log scale
;                              NO_SUPERPOSE      : Don't superpose Alfven wave DB quantities over Dst/SYM-H 
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

PRO HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES,RESTOREFILE=restoreFile, $
   stormTimeArray_utc, $
   START_UTC=start_UTC, STOP_UTC=stop_UTC, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   NEG_AND_POS_SEPAR=neg_and_pos_separ, $
   LAYOUT=layout, $
   MAXIND=maxInd, $
   NORMALIZE_MAXIND_HIST=normalize_maxInd_hist, $
   HISTXRANGE_MAXIND=histXRange_maxInd, $
   HISTYRANGE_MAXIND=histYRange_maxInd, $
   HISTXTITLE_MAXIND=histXTitle_maxInd, $
   HISTBINSIZE_MAXIND=histBinsize_maxInd, $
   AVG_TYPE_MAXIND=avg_type_maxInd, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   LOG_DBQUANTITY=log_DBQuantity, $
   TBINS=tBins, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
   PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
   SAVEMAXPLOTNAME=saveMaxPlotName, $
   RANDOMTIMES=randomTimes, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   PLOTPREFIX=plotPrefix, $
   OUTPLOTARR=outPlotArr

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
                              YLOGSCALE_MAXIND=yLogScale_maxInd, $

                              YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                              NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                              LAYOUT=layout, $
                              POS_LAYOUT=pos_layout, $
                              NEG_LAYOUT=neg_layout, $
                              USE_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              ;; HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
                              ;; PROBOCCURENCE_SEA=probOccurrence_sea, $
                              SAVEMAXPLOTNAME=saveMaxPlotName, $
                              SAVEFILE=saveFile,SAVESTR=saveStr, $
                              PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                              NOPLOTS=noPlots,NOGEOMAGPLOTS=noGeomagPlots,NOMAXPLOTS=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots, $
EPOCHPLOT_COLORNAMES=epochPlot_colorNames,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  @utcplot_defaults.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,DB_BRETT=stormFile,DBDIR=stormDir

  ;;********************************************************
  ;;Now clean and tap the database
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DB_TFILE=DB_tFile,DBDIR=DBDir,DBFILE=DBFile
  good_i = GET_CHASTON_IND(maximus,satellite,lun, $
                           DBTIMES=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb,HEMI=hemi, $
                           ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                           MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                           HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd)
     
  ;;******************************
  ;;Get indices for storm phases
  LOAD_DST_AE_DBS,dst,ae

  IF NOT KEYWORD_SET(hemi) THEN hemi = 'BOTH'

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
  alf_i_list=LIST()

  IF NOT KEYWORD_SET(dataName) THEN dataName = (TAG_NAMES(maximus))[maxInd] ;;        = 'char_ion_energy'
  IF NOT KEYWORD_SET(plotPrefix) THEN plotPrefix = "" ELSE plotPrefix = plotPrefix + '--'
  ;;data out
  genFile_pref    = date + '--' + dataName + '--from_histoplot_alfvendbquantities_during_stormphases.pro'
  outstats        = date + '--' + dataName + '_moment_data_for_stormphases.sav'
  SET_PLOT_DIR,plotDir,/FOR_STORMS,/VERBOSE,/ADD_TODAY
  sPP             = plotDir + dataName + '--' + plotPrefix + 'stormphases' ;savePlotPrefix
  

  ;;declare the slice structure array, null lists
  ssa            = !NULL
  nFinite        = !NULL
  nTotal         = !NULL
  tot_alf_t_list = LIST()
  tot_alf_y_list = LIST()

  FOR i=0,2 DO BEGIN

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
     
     alf_i_list.add,alf_i
     tot_alf_t_list.add,cdbTime[alf_i]
     IF KEYWORD_SET(log_DBQuantity) THEN BEGIN
        tot_alf_y_list.add,ALOG10(maximus.(maxInd)[alf_i])
     ENDIF ELSE BEGIN
        tot_alf_y_list.add,maximus.(maxInd)[alf_i]
     ENDELSE
     ;; tot_alf_t = cdbTime[alf_i]
     ;; tot_alf_y = maximus.(maxInd)[alf_i]
     nFinite = [nFinite,N_ELEMENTS(WHERE(FINITE(tot_alf_y_list[i])))]
     nTotal  = [nTotal,N_ELEMENTS(tot_alf_y_list[i])]
     IF nFinite[i] NE nTotal[i] THEN BEGIN
        PRINT,FORMAT='(A0,T15,":",T18,I0," finite, ",I0," total!")',strings[i],nFinite[i],nTotal[i]
        PRINT,"Beware ... why do you have negs in these data?"
        WAIT,1
        ENDIF
  ENDFOR

  ;;plot details
  xTitle     = KEYWORD_SET(histXTitle_maxInd) ? histXTitle_maxInd : dataName
  yTitle     = "Count"
  ;; xRange     = KEYWORD_SET(histXRange_maxInd) ? histXRange_maxInd : $
  ;;              [MIN([ssa[0].yList[0],ssa[1].yList[0],ssa[2].yList[0]]), $
  ;;               MAX([ssa[0].yList[0],ssa[1].yList[0],ssa[2].yList[0]])]
  ;; yRange     = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,1000]
  ;; this=LIST_TO_1DARRAY(tot_alf_y_list)
  xRange     = KEYWORD_SET(histXRange_maxInd) ? histXRange_maxInd : $
               [MIN(LIST_TO_1DARRAY(tot_alf_y_list,/WARN)), $
                MAX(LIST_TO_1DARRAY(tot_alf_y_list,/WARN))]
  yRange     = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,1000]
  
  pHP        = MAKE_HISTOPLOT_PARAM_STRUCT(NAME=dataName, $
                                           XTITLE=xTitle, $
                                           YTITLE=yTitle, $
                                           XRANGE=xRange, $
                                           YRANGE=yRange, $
                                           HISTBINSIZE=histBinsize_maxInd, $
                                           XP_ARE_LOGGED=log_DBQuantity)

  FOR i=0,2 DO BEGIN

     ;; tempData   = maximus.(maxInd)[alf_i_list[i]]
     tempData   = tot_alf_y_list[i]
     ;; IF KEYWORD_SET(unlog) THEN BEGIN
     ;;    tempData                 = 10^(tempData)
     ;; ENDIF
     tempStats  = MOMENT(tempData)
     tempESlice = MAKE_EPOCHSLICE_STRUCT(DATANAME=dataName, $
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
  PRINT,FORMAT='("Low (hr)",T10,"High (hr)",T20,"N",T30,"Mean",T40,"Std. dev.",T50,"Skewness",T60,"Kurtosis")'
  FOR i=0,N_ELEMENTS(ssa)-1 DO BEGIN
     
     PRINT,FORMAT='(A0,T10,A0,T20,I0,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4)', $
           TIME_TO_STR(ssa[i].eStart), $
           TIME_TO_STR(ssa[i].eEnd), $
           N_ELEMENTS(ssa[i].yList[0]), $
           ssa[i].moments.(0), $
           SQRT(ssa[i].moments.(1)), $
           ssa[i].moments.(2), $
           ssa[i].moments.(3)
     
  ENDFOR

  ;; IF KEYWORD_SET(neg_AND_pos_separ) THEN BEGIN
  ;;    ;;First pos
  ;;    alf_i_pos = alf_i[WHERE(maximus.(maxInd)[alf_i] GE 0.0,nPos)]
  ;;    alf_i_neg = alf_i[WHERE(maximus.(maxInd)[alf_i] LT 0.0,nNeg)]
     
  ;;    tot_alf_t_pos = cdbTime[alf_i_pos]
  ;;    tot_alf_y_pos = maximus.(maxInd)[alf_i_pos]
  ;;    tot_alf_t_neg = cdbTime[alf_i_neg]
  ;;    tot_alf_y_neg = maximus.(maxInd)[alf_i_neg]
     
  ;;    yHistStr = MAKE_ALFVENDBQUANTITY_HIST_STRUCT(yData, $
  ;;                                                 MINVAL=hMin, $
  ;;                                                 MAXVAL=hMax, $
  ;;                                                 BINSIZE=hBinsize, $
  ;;                                                 DO_REVERSE_INDS=hDoRI)
  ;; ENDIF ELSE BEGIN
  ;;    tot_alf_t = cdbTime[alf_i]
  ;;    tot_alf_y = maximus.(maxInd)[alf_i]
     
  ;;    yHistStr = MAKE_ALFVENDBQUANTITY_HIST_STRUCT(tot_alf_y, $
  ;;                                                 MINVAL=hMin, $
  ;;                                                 MAXVAL=hMax, $
  ;;                                                 BINSIZE=hBinsize, $
  ;;                                                 DO_REVERSE_INDS=hDoRI)
     
  ;; ENDELSE

  ;;window setup
  wTitle        = dataName + ' during storm phases'
  window        = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])

  ;;plot array/window setup
  plotLayout = [3,1]
  nPPerWind  = plotLayout[0]*plotLayout[1]
  plotArr    = MAKE_ARRAY(nPPerWind,/OBJ)
  ;; nSlices    = N_ELEMENTS(histTBins)
  firstmarg  = [0.1,0.1,0.1,0.1]
  marg       = [0.01,0.01,0.1,0.01]

  FOR i=0,2 DO BEGIN
     ;;the indata
     x             = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
     y             = ssa[i].yHistStr.hist[0] 
     
     integral      = TOTAL(y)
     IF KEYWORD_SET(normalize_maxInd_hist) THEN BEGIN
        y          = y / integral
        pHP.yRange = KEYWORD_SET(histYRange_maxInd) ? histYRange_maxInd : [0,0.3]
        pHP.yTitle = 'Relative Freq.'
     ENDIF 
     
     ;; IF layout_i EQ 1 THEN BEGIN
     ;; title         = STRING(FORMAT='(A0,T15," : ",A0," through ",A0)',strings[i],TIME_TO_STR(ssa[i].eStart),TIME_TO_STR(ssa[i].eEnd))
     title         = STRING(FORMAT='(A0)',strings[i])
     ;; xTitle      = i GT plotLayout[0] ? pHP.xTitle : !NULL
     xTitle      = pHP.xTitle
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
                        LAYOUT=[plotLayout,i+1], $
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
     
     
     int_x       = ( ( (i) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.05
     int_y       = 1 - 1/FLOAT(plotLayout[1]*2) - ( ( (i) / plotLayout[0] )) * 1/FLOAT(plotLayout[1]) + 1/FLOAT(plotLayout[1]*8)
     intText     = text(int_x,int_y,$
                        textStr, $
                        FONT_NAME='Courier', $
                        /NORMAL, $
                        TARGET=plotArr[i])
     
     
     ;; IF (i GT 0) AND ( ( (i + 1) MOD nPPerWind ) EQ 0 ) THEN BEGIN
     ;;    windowArr[wInd].save,saveName,RESOLUTION=300
     ;; ENDIF
        
  ENDFOR
  
  outPlotArr = plotArr

END