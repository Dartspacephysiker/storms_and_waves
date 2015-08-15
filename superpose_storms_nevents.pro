;+
; NAME:                           SUPERPOSE_STORMS_NEVENTS
;
; PURPOSE:                        TAKE A LIST OF STORMS, SUPERPOSE THE STORMS AS WELL AS THE RELEVANT DB QUANTITIES
;
; CATEGORY:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFORESTORM      : Amount of time (hours) to plot before a given DST min
;                              TAFTERSTORM       : Amount of time (hours) to plot after a given DST min
;                              STARTDATE         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              STORMINDS         : Indices of storms to be included within the given storm DB
;                              SSC_TIMES_UTC     : Times (in UTC) of sudden commencements
;                              REMOVE_DUPES      : Remove all duplicate storms falling within [tBeforeStorm,tAfterStorm]
;                              STORMTYPE         : '0'=small, '1'=large, '2'=all <-- ONLY APPLICABLE TO BRETT'S DB
;                              USE_SYMH          : Use SYM-H geomagnetic index instead of DST for plots of storm epoch.
;                              NEVENTHISTS       : Create histogram of number of Alfvén events relative to storm epoch
;                              NEVBINSIZE        : Size of histogram bins in hours
;                              NEG_AND_POS_SEPAR : Do plots of negative and positive log numbers separately
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    1: standard averaging; 2: log averaging
;                              LOG_DB_QUANTITY   : Plot the quantity from the Alfven wave database on a log scale
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
; MODIFICATION HISTORY:   2015/06/20 Born on the flight from Boston to Akron, OH en route to DC
;                         2015/08/14 Adding STORMINDS keywords so we can hand-pick our storms, and PLOTTITLE
;                           
;-


PRO superpose_storms_nevents,stormTimeArray_utc, $
                             TBEFORESTORM=tBeforeStorm,TAFTERSTORM=tAfterStorm, $
                             STARTDATE=startDate, STOPDATE=stopDate, $
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             STORMINDS=stormInds, SSC_TIMES_UTC=ssc_times_utc, $
                             REMOVE_DUPES=remove_dupes, STORMTYPE=stormType, $
                             USE_SYMH=use_symh, $
                             NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, NEVRANGE=nEvRange, $
                             RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist, BKGRND_HIST=bkgrnd_hist, $
                             NEG_AND_POS_SEPAR=neg_and_pos_separ, POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                             MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
                             RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                             LOG_DBQUANTITY=log_DBquantity, $
                             YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                             DBFILE=dbFile,DB_TFILE=db_tFile, $
                             NO_SUPERPOSE=no_superpose, $
                             USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
                             SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
                             PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                             SAVEMAXPLOTNAME=saveMaxPlotName
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  plotMargin=[0.13, 0.20, 0.13, 0.15]

  defTBeforeStorm      = 60.0D                                                                       ;in hours
  defTAfterStorm       = 60.0D                                                                       ;in hours
  defStormType         =  2
                       
  defswDBDir           = 'sw_omnidata/'
  defswDBFile          = 'sw_data.dat'
                       
  defStormDir          = 'sw_omnidata/'
  defStormFile         = 'large_and_small_storms--1985-2011--Anderson.sav'
                       
  defDST_AEDir         = 'processed/'
  defDST_AEFile        = 'idl_ae_dst_data.dat'
                       
  defDBDir             = 'dartdb/saves/'
  ;; defDBFile            = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  ;; defDB_tFile          = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  defDBFile            = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  defDB_tFile          = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
                       
  defUse_SYMH          = 0
                       
  defMaxInd            = 6

  defRestrict_altRange = 0
  defRestrict_charERange = 0

  defavg_type_maxInd   = 0
  defLogDBQuantity     = 0

  defNeg_and_pos_separ = 0
  defPos_layout= [1,1,1]
  defNeg_layout= [1,1,1]

  defSymTransp         = 97
  defLineTransp        = 75
  defLineThick         = 2.5

  ;; ;For nEvent histos
  defnEvBinsize        = 150.0D                                                                        ;in minutes
  defnEvYRange         = [0,5000]
                       
  defSaveFile          = 0

  ;;defs for maxPlots
  max_xtickfont_size=18
  max_xtickfont_style=1
  max_ytickfont_size=18
  max_ytickfont_style=1
  avg_symSize=2.0
  avg_symThick=2.0
  avg_Thick=2.5

  ;; nMajorTicks=5
  ;; nMinorTicks=3
  nMajorTicks=4
  nMinorTicks=4

  defRes = 200
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Check defaults
  IF N_ELEMENTS(tBeforeStorm) EQ 0 THEN tBeforeStorm = defTBeforeStorm
  IF N_ELEMENTS(tAfterStorm) EQ 0 THEN tAfterStorm = defTAfterStorm

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  IF KEYWORD_SET(dayside) THEN print,"Only considering dayside stuff!"
  IF KEYWORD_SET(nightside) THEN print,"Only considering nightside stuff!"

  IF N_ELEMENTS(restrict_charERange) EQ 0 THEN restrict_charERange = defRestrict_charERange
  IF N_ELEMENTS(restrict_altRange) EQ 0 THEN restrict_altRange = defRestrict_altRange

  IF N_ELEMENTS(avg_type_maxInd) EQ 0 THEN avg_type_maxInd=defAvg_type_maxInd

  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLogDBQuantity

  IF N_ELEMENTS(neg_and_pos_separ) EQ 0 THEN neg_and_pos_separ=defNeg_and_pos_separ
  IF N_ELEMENTS(pos_layout) EQ 0 Then pos_layout=defPos_layout
  IF N_ELEMENTS(neg_layout) EQ 0 Then neg_layout=defNeg_layout

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH

  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize
  nEvBinsize = nEvBinsize/60.

  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile

  IF ~use_SYMH THEN restore,dataDir+DST_AEDir+DST_AEFile

  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile

  IF saveFile THEN BEGIN 
     saveStr='save' 
     IF SIZE(saveFile,/TYPE) NE 7 THEN saveFile='superpose_storms_alfven_db_quantities.dat'
  ENDIF ELSE saveStr=''

  IF KEYWORD_SET(savePlotName) THEN BEGIN
     IF SIZE(savePlotName,/TYPE) NE 7 THEN savePlotName="SYM-H_plus_histogram.png"
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified date range, if an array of times hasn't been provided
  

  IF N_ELEMENTS(stormTimeArray_utc) NE 0 THEN BEGIN

     nStorms = N_ELEMENTS(stormTimeArray_utc)
     centerTime = stormTimeArray_utc
     tStamps = TIME_TO_STR(stormTimeArray_utc)
     stormString = 'user-provided'

  ENDIF ELSE BEGIN              ;Looks like we're relying on Brett

     totDBStorms=N_ELEMENTS(stormStruct.time)

     IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
        startDate=str_to_time(maximus.time(0))
        stopDate=str_to_time(maximus.time(-1))
        PRINT,'Using start and stop time from Dartmouth/Chaston database.'
        PRINT,'Start time: ' + maximus.time(0)
        PRINT,'Stop time: ' + maximus.time(-1)
     ENDIF
     
     IF KEYWORD_SET(STARTDATE) THEN BEGIN
        IF N_ELEMENTS(STOPDATE) EQ 0 THEN BEGIN
           PRINT,"No stop year specified! Plotting data up to a full year after startDate."
           stopDate=startDate+86400.*31.*12.
        ENDIF
        
     ENDIF ELSE BEGIN
        PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
        RETURN
     ENDELSE
     
     stormStruct_inds=WHERE(stormStruct.time GE startDate AND stormStruct.time LE stopDate,/NULL)
     
     IF KEYWORD_SET(stormInds) THEN BEGIN
        PRINT,'Using provided storm indices (' + STRCOMPRESS(N_ELEMENTS(stormInds),/REMOVE_ALL) + ' storms)...'
        PRINT,"Database: " + stormFile
        
        stormStruct_inds = cgsetintersection(stormStruct_inds,stormInds)
     ENDIF
     
     ;; Check storm type
     IF N_ELEMENTS(stormType) EQ 0 THEN stormType=defStormType
     
     IF stormType EQ 1 THEN BEGIN ;Only large storms
        stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 1,/NULL))
        stormString='large'
     ENDIF ELSE BEGIN
        IF stormType EQ 0 THEN BEGIN
           stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 0,/NULL))
           stormString='small'
        ENDIF ELSE BEGIN
           IF stormType EQ 2 THEN BEGIN
              stormString='all'
           ENDIF
        ENDELSE
     ENDELSE
     
     nStorms=N_ELEMENTS(stormStruct_inds)     
     PRINT,"Storm type: " + stormString 
     PRINT,STRCOMPRESS(N_ELEMENTS(stormStruct_inds),/REMOVE_ALL)+" storms (out of " + STRCOMPRESS(totDBStorms,/REMOVE_ALL) + " in the DB) selected"
     
     IF nStorms EQ 0 THEN BEGIN
        PRINT,"No storms found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     IF KEYWORD_SET(ssc_times_utc) THEN BEGIN 
        centerTime = ssc_times_utc
        tStamps = time_to_str(ssc_times_utc)
     ENDIF ELSE BEGIN
        centerTime = stormStruct.time(stormStruct_inds)
        tStamps = stormStruct.tstamp(stormStruct_inds)
     ENDELSE
     
     IF saveFile THEN saveStr+=',startDate,stopDate,stormType,stormStruct_inds'

  ENDELSE

  IF KEYWORD_SET(remove_dupes) THEN BEGIN
     PRINT,'Finding and trashing storms that would otherwise appear twice in the superposed epoch analysis...'
     
     keep_i = MAKE_ARRAY(nStorms,/INTEGER,VALUE=1)
     
     FOR i=0,nStorms-1 DO BEGIN
        
        FOR j=i+1,nStorms-1 DO BEGIN
           IF keep_i[i] AND keep_i[j] THEN BEGIN
              IF ( centerTime(j)-centerTime(i) )/3600. LT tAfterStorm THEN keep_i[j] = 0
           ENDIF
        ENDFOR
     ENDFOR

     keep = WHERE(keep_i,nKeep,COMPLEMENT=bad_i,NCOMPLEMENT=nBad,/NULL)
     ;; ;resize everythang
     IF N_ELEMENTS(bad_i) GT 0 THEN BEGIN
        PRINT,'Losing ' + STRCOMPRESS(N_ELEMENTS(bad_i),/REMOVE_ALL) + ' storms that would otherwise be duplicated in the SEA...'

        FOR j=0,N_ELEMENTS(bad_i)-1 DO print,FORMAT='("Storm ",I0,":",TR5,A0)',bad_i(j),tStamps(bad_i(j)) ;show me where!

        nStorms = nKeep
        centerTime = centerTime(keep)
        tStamps = tStamps(keep)

     ENDIF ELSE PRINT,"No dupes to be had here!"

  ENDIF

  ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
  datStartStop = MAKE_ARRAY(nStorms,2,/DOUBLE)
  datStartStop(*,0) = centerTime - tBeforeStorm*3600.   ;(*,0) are the times before which we don't want data for each storm
  datStartStop(*,1) = centerTime + tAfterStorm*3600.    ;(*,1) are the times after which we don't want data for each storm
     
  IF ~use_SYMH THEN BEGIN       ;Use DST for plots, not SYM-H
     ;; Now get a list of indices for DST data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(DST.time GE datStartStop(0,0) AND $ ;first initialize the list
                                     DST.time LE datStartStop(0,1)))
     geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
     
     ;; IF KEYWORD_SET(ssc_times_utc) THEN geomag_time_list = LIST(ssc_times_utc[0]) $
     ;; ELSE geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))
     geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))
     
     geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
     geomag_max = MAX(geomag_dat_list(0))
     
     FOR i=1,nStorms-1 DO BEGIN ;Then update it
        geomag_plot_i_list.add,WHERE(DST.time GE datStartStop(i,0) AND $
                                     DST.time LE datStartStop(i,1))
        geomag_dat_list.add,dst.dst(geomag_plot_i_list(i))
        
        ;; IF KEYWORD_SET(ssc_times_utc) THEN geomag_time_list.add,ssc_times_utc[i] $
        ;; ELSE geomag_time_list.add,dst.time(geomag_plot_i_list(i))
        geomag_time_list.add,dst.time(geomag_plot_i_list(i))
        
        tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
        IF tempMin LT geomag_min THEN geomag_min=tempMin
        IF tempMax GT geomag_max THEN geomag_max=tempMax
     ENDFOR
  ENDIF ELSE BEGIN              ;Use SYM-H for plots 
     
     swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
     
     ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(swDat_UTC GE datStartStop(0,0) AND $ ;first initialize the list
                                     swDat_UTC LE datStartStop(0,1)))
     geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
     
     ;; IF KEYWORD_SET(ssc_times_utc) THEN geomag_time_list = LIST(ssc_times_utc[0]) $
     ;; ELSE geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
     geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
     
     geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
     geomag_max = MAX(geomag_dat_list(0))
     
     FOR i=1,nStorms-1 DO BEGIN ;Then update it
        geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(i,0) AND $
                                     swDat_UTC LE datStartStop(i,1))
        geomag_dat_list.add,sw_data.sym_h.dat(geomag_plot_i_list(i))
        
        ;; IF KEYWORD_SET(ssc_times_utc) THEN geomag_time_list.add,ssc_times_utc[i] $
        ;; ELSE geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
        geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
        
        tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
        IF tempMin LT geomag_min THEN geomag_min=tempMin
        IF tempMax GT geomag_max THEN geomag_max=tempMax
     ENDFOR
  ENDELSE
  
  ;; ;Get nearest events in Chaston DB
  cdb_storm_t=MAKE_ARRAY(nStorms,2,/DOUBLE)
  cdb_storm_i=MAKE_ARRAY(nStorms,2,/L64)
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS, $
                         ALTITUDERANGE=(restrict_altRange) ? [1000,5000] : !NULL, $
                         CHARERANGE=(restrict_charERange) ? [4,300] : !NULL, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside)
  
  FOR i=0,nStorms-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop(i,j)-cdbTime(good_i)),tempClosest_ii)
        cdb_storm_i(i,j)=good_i(tempClosest_ii)
        cdb_storm_t(i,j)=cdbTime(good_i(tempClosest_ii))
     ENDFOR
  ENDFOR

  IF saveFile THEN saveStr+=',nStorms,centerTime,tStamps,stormString,dbFile,tBeforeStorm,tAfterStorm,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list'

  ;; ;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     geomagWindow=WINDOW(WINDOW_TITLE="SYM-H plots", $
                         DIMENSIONS=[1200,800])
     
  ENDIF ELSE BEGIN              ;Just do a regular superposition of all the plots
     
     geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormString + " storms: "+ $
                         tStamps(0) + " - " + $
                         tStamps(-1), $
                         DIMENSIONS=[1200,800])
     xTitle='Hours since storm commencement'
     yTitle=(~use_SYMH) ? 'DST (nT)' : 'SYM-H (nT)'
     
     xRange=[-tBeforeStorm,tAfterStorm]
     ;; yRange=[geomag_min,geomag_max]
     yRange=[-300,100]
     
     FOR i=0,nStorms-1 DO BEGIN
        IF N_ELEMENTS(geomag_time_list(i)) GT 1 THEN BEGIN
           plot=plot((geomag_time_list(i)-centerTime(i))/3600.,geomag_dat_list(i), $
                     NAME=yTitle, $
                     AXIS_STYLE=1, $
                     MARGIN=plotMargin, $
                     ;; XRANGE=[0,7000./60.], $
                     XTITLE=xTitle, $
                     YTITLE=yTitle, $
                     XRANGE=xRange, $
                     YRANGE=yRange, $
                     XTICKFONT_SIZE=20, $
                     XTICKFONT_STYLE=1, $
                     YTICKFONT_SIZE=20, $
                     YTICKFONT_STYLE=1, $
                     ;; LAYOUT=[1,4,i+1], $
                     /CURRENT,OVERPLOT=(i EQ 0) ? 0 : 1, $
                     SYM_TRANSPARENCY=defSymTransp, $
                     TRANSPARENCY=defLineTransp, $
                     THICK=defLineThick) 
           
        ENDIF ELSE PRINT,'Losing storm #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
     ENDFOR
     
     axes=plot.axes
     axes[0].MAJOR=(nMajorTicks EQ 4) ? nMajorTicks -1 : nMajorTicks
     axes[1].MINOR=nMinorTicks
     ;; ; Has user requested overlaying DST/SYM-H with the histogram?
     
  ENDELSE

  ;; Get ranges for plots
  minMaxDat=MAKE_ARRAY(nStorms,2,/DOUBLE)
  
  cdb_ind_list = LIST(WHERE(maximus.(maxInd) GT 0))
  cdb_ind_list.add,WHERE(maximus.(maxInd) LT 0)
     
  IF neg_and_pos_separ OR ( log_DBQuantity AND (cdb_ind_list[1,0] NE -1)) THEN BEGIN
     PRINT,'Got some negs here...'
     WAIT,1
  ENDIF

  FOR i=0,nStorms-1 DO BEGIN
     
     tempInds=cgsetintersection(good_i,[cdb_storm_i(i,0):cdb_storm_i(i,1):1])
     minMaxDat(i,1)=MAX(maximus.(maxInd)(tempInds),MIN=tempMin)
     minMaxDat(i,0)=tempMin
     
     IF neg_and_pos_separ THEN BEGIN
        
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        
        plot_i_list = LIST(cgsetintersection(plot_i,cdb_ind_list[0])) ;pos and neg
        plot_i_list.add,cgsetintersection(plot_i,cdb_ind_list[1])
        
        ;; get relevant time range
        cdb_t=LIST( (DOUBLE(cdbTime(plot_i_list[0]))-DOUBLE(centerTime(i)))/3600. )
        cdb_t.add,( (DOUBLE(cdbTime(plot_i_list[1]))-DOUBLE(centerTime(i)))/3600. )
        
        ;; get corresponding data
        cdb_y=LIST(maximus.(maxInd)(plot_i_list[0]))
        cdb_y.add,ABS(maximus.(maxInd)(plot_i_list[1]))
        
        nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)
        
        IF i EQ 0 THEN BEGIN
           tot_plot_i_pos_list=LIST(plot_i_list[0])
           tot_cdb_t_pos_list=LIST((cdb_t[0]))
           tot_cdb_y_pos_list=LIST(cdb_y[0])
           
           tot_plot_i_neg_list=LIST(plot_i_list[1])
           tot_cdb_t_neg_list=LIST((cdb_t[1]))
           tot_cdb_y_neg_list=LIST(cdb_y[1])
           
        ENDIF ELSE BEGIN
           tot_plot_i_pos_list.add,plot_i_list[0]
           tot_cdb_t_pos_list.add,(cdb_t[0])
           tot_cdb_y_neg_list.add,cdb_y[0]
           
           tot_plot_i_neg_list.add,plot_i_list[1]
           tot_cdb_t_neg_list.add,(cdb_t[1])
           tot_cdb_y_neg_list.add,cdb_y[1]
           
        ENDELSE 
        
        IF (plot_i_list[0])(0) GT -1 AND N_ELEMENTS(plot_i_list[0]) GT 1 THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
              IF N_ELEMENTS(nEvHist_pos) EQ 0 THEN BEGIN
                 nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
                                       MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                       BINSIZE=nEvBinsize)
                 nEvTot[0]=N_ELEMENTS(plot_i_list[0])
              ENDIF ELSE BEGIN
                 nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
                                       MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                       BINSIZE=nEvBinsize, $
                                       INPUT=nEvHist_pos)
                 nEvTot[0]+=N_ELEMENTS(plot_i_list[0])
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
        IF (plot_i_list[1])(0) GT -1 AND (N_ELEMENTS(plot_i_list[1]) GT 1) THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
              IF N_ELEMENTS(nEvHist_neg) EQ 0 THEN BEGIN
                 nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
                                       MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                       BINSIZE=nEvBinsize)
                 nEvTot[1]=N_ELEMENTS(plot_i_list[1])
              ENDIF ELSE BEGIN
                 nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
                                       MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                       BINSIZE=nEvBinsize, $
                                       INPUT=nEvHist_neg)
                 nEvTot[1]+=N_ELEMENTS(plot_i_list[1])
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
     ENDIF ELSE BEGIN
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        
        ;; get relevant time range
        cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(centerTime(i)))/3600.
        
        ;; get corresponding data
        cdb_y=maximus.(maxInd)(plot_i)
        
        IF i EQ 0 THEN BEGIN
           nEvTot=N_ELEMENTS(plot_i)
           
           tot_plot_i_list=LIST(plot_i)
           tot_cdb_t_list=LIST(cdb_t)
           
           tot_cdb_y_list=LIST(cdb_y)
           nEvTotList=LIST(nEvTot)
        ENDIF ELSE BEGIN
           nEvTot+=N_ELEMENTS(plot_i)
           
           tot_plot_i_list.add,plot_i
           tot_cdb_t_list.add,cdb_t
           
           tot_cdb_y_list.add,cdb_y
           nEvTotList.add,nEvTot
        ENDELSE 
        
        
        IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
              IF i EQ 0 THEN BEGIN
                 nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                   BINSIZE=nEvBinsize)
              ENDIF ELSE BEGIN
                 nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                   BINSIZE=nEvBinsize, $
                                   INPUT=nEvHist)
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
     ENDELSE
     
  ENDFOR
  
  IF KEYWORD_SET(nEventHists) THEN BEGIN
     IF neg_and_pos_separ THEN BEGIN
        
        IF (cdb_ind_list[0])(0) NE -1 THEN BEGIN
           histWindow_pos=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                 DIMENSIONS=[1200,800])
           
           plot_nEv_pos=plot(tBin,nEvHist_pos, $
                             /STAIRSTEP, $
                             YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                             TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                             tStamps(0) + " - " + $
                             tStamps(-1), $
                             XTITLE='Hours since storm commencement', $
                             YTITLE='Number of Alfvén events', $
                             /CURRENT, LAYOUT=pos_layout,COLOR='red')
           
           cNEvHist_pos= TOTAL(nEvHist_pos, /CUMULATIVE) / nEvTot[0]
           cdf_nEv_pos=plot(tBin,cNEvHist_pos, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE='Cumulative number of Alfvén events', $
                            /CURRENT, LAYOUT=pos_layout, AXIS_STYLE=1,COLOR='r')
           
           
        ENDIF
        
        IF (cdb_ind_list[1])(0) NE -1 THEN BEGIN
           histWindow_neg=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                 DIMENSIONS=[1200,800])
           
           plot_nEv_neg=plot(tBin,nEvHist_neg, $
                             /STAIRSTEP, $
                             YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                             TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                             tStamps(0) + " - " + $
                             tStamps(-1), $
                             XTITLE='Hours since storm commencement', $
                             YTITLE='Number of Alfvén events', $
                             /CURRENT,/OVERPLOT, LAYOUT=neg_layout,COLOR='b')
           
           cNEvHist_neg= TOTAL(nEvHist_neg, /CUMULATIVE) / nEvTot[1]
           cdf_nEv_neg=plot(tBin,cNEvHist_neg, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE='Cumulative number of Alfvén events', $
                            /CURRENT, LAYOUT=neg_layout,/OVERPLOT, AXIS_STYLE=1,COLOR='b')
           
           ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize'
        ENDIF
        
        IF saveFile THEN saveStr+=',cNEvHist_pos,nEvHist_pos,cNEvHist_neg,nEvHist_neg,tBin,nEvBinsize,tot_plot_i_pos_list,tot_plot_i_neg_list,maxInd'
        
     ENDIF ELSE BEGIN
        ;; IF KEYWORD_SET(overplot_hist) THEN BEGIN
        ;;    PRINT,'setting geomagwindow as current...'
        ;;    geomagWindow.setCurrent
        ;; ENDIF ELSE BEGIN
        ;;    histWindow=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
        ;;                   DIMENSIONS=[1200,800])
        ;; ENDELSE
        plot_nEv=plot(tBin,nEvHist, $
                      /STAIRSTEP, $
                      TITLE=plotTitle, $
                      ;; TITLE='Number of Alfvén events relative to storm epoch for ' + stormString
                      ;; + ' storms, ' + $
                      ;; tStamps(0) + " - " + $
                      ;; tStamps(-1), $
                      YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                      NAME='Event histogram', $
                      ;; YRANGE=[MIN(nEvHist),MAX(nEvHist)], $
                      XRANGE=xRange, $
                      AXIS_STYLE=(KEYWORD_SET(overplot_hist)) ? 0 : 1, $
                      ;; XTITLE='Hours since storm commencement', $
                      ;; YTITLE='Number of Alfvén events', $
                      ;; /CURRENT, LAYOUT=[1,1,1]
                      COLOR='red', $
                      MARGIN=plotMargin, $
                      THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                      CURRENT=KEYWORD_SET(overplot_hist))
        
        yaxis = AXIS('Y', LOCATION='right', TARGET=plot_nEv, $
                     TITLE='Number of events', $
                     MAJOR=nMajorTicks, $
                     MINOR=nMinorTicks, $
                     TICKFONT_SIZE=20, $
                     TICKFONT_STYLE=1, $
                     ;; AXIS_RANGE=[minDat,maxDat], $
                     TEXTPOS=1, $
                     COLOR='red')
        
        IF KEYWORD_SET(bkgrnd_hist) THEN BEGIN
           plot_bkgrnd=plot(tBin,bkgrnd_hist, $
                            /STAIRSTEP, $
                            YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : [0,7500], $
                            NAME='Background histogram (average)', $
                            XRANGE=xRange, $
                            AXIS_STYLE=0, $
                            COLOR='blue', $
                            MARGIN=plotMargin, $
                            THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                            /CURRENT,TRANSPARENCY=50)
           
           leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                        POSITION=[0.1,0.1], /NORMAL, $
                        /AUTO_TEXT_COLOR)
        ENDIF     
        
        ;; xaxis = AXIS('Y', LOCATION='right', TARGET=plot_nEv, $
        ;;              TITLE='Number of events', $
        ;;              MAJOR=nMajorTicks, $
        ;;              MINOR=nMinorTicks, $
        ;;              ;; AXIS_RANGE=[minDat,maxDat], $
        ;;              TEXTPOS=1, $
        ;;              COLOR='red')
        
        
        cNEvHist = TOTAL(nEvHist, /CUMULATIVE) / nEvTot
        ;; cdf_nEv=plot(tBin,cNEvHist, $
        ;;              XTITLE='Hours since storm commencement', $
        ;;              YTITLE='Cumulative number of Alfvén events', $
        ;;              /CURRENT, LAYOUT=[2,1,2], AXIS_STYLE=1,COLOR='blue')
        
        ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize'
        IF saveFile THEN saveStr+=',cNEvHist,nEvHist,tBin,nEvBinsize,tot_plot_i_list,maxInd'
     ENDELSE
     returned_nev_tbins_and_Hist=[[tbin],[nEvHist]]
  ENDIF                         ;end IF nEventHists
  
  IF KEYWORD_SET(savePlotName) THEN BEGIN
     PRINT,"Saving plot to file: " + savePlotName
     geomagWindow.save,savePlotName,RESOLUTION=defRes
  ENDIF

  IF KEYWORD_SET(maxInd) THEN BEGIN

     mTags=TAG_NAMES(maximus)
     
     maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
                     DIMENSIONS=[1200,800])
     
     IF ( log_DBQuantity AND (cdb_ind_list[1,0] NE -1)) OR neg_and_pos_separ THEN BEGIN

        ;Are there negs? Handle, if so
        IF (cdb_ind_list[0])(0) NE -1 THEN BEGIN

           temp=WHERE(minMaxDat(*,1) GE 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN maxDat=LIST(MAX(ABS(minMaxDat(temp,1)))) ELSE maxDat=LIST(!NULL)
           temp=WHERE(minMaxDat(*,0) GE 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN minDat=LIST(MIN(ABS(minMaxDat(temp,0)))) ELSE minDat=LIST(!NULL)

        ENDIF ELSE BEGIN
           maxDat=LIST(!NULL)
           minDat=LIST(!NULL)
        ENDELSE

        IF (cdb_ind_list[1])(0) NE -1 THEN BEGIN

           PRINT,"There are negs in this quantity, and you've asked me to log it. Can't do it"
           RETURN
           neg_and_pos_separ = 1

           temp=WHERE(minMaxDat(*,1) LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN maxDat.add,MAX(ABS(minMaxDat(temp,1))) ELSE maxDat.add,!NULL
           temp=WHERE(minMaxDat(*,0) LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN minDat.add,MIN(ABS(minMaxDat(temp,0))) ELSE minDat.add,!NULL

           ENDIF ELSE BEGIN
           maxDat.add,!NULL
           minDat.add,!NULL
        ENDELSE

        IF (cdb_ind_list[0])(0) NE -1 AND (cdb_ind_list[1])(0) NE -1 THEN BEGIN
           
           IF N_ELEMENTS(maxDat[0]) EQ 0 THEN BEGIN
              IF N_ELEMENTS(maxDat[1]) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              maxDat[0]=maxDat[1]
           ENDIF
           IF N_ELEMENTS(maxDat[1]) EQ 0 THEN BEGIN
              maxDat[1]=maxDat[0]
           ENDIF

           IF N_ELEMENTS((minDat[0])) EQ 0 THEN BEGIN
              IF N_ELEMENTS((minDat[1])) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              minDat[0]=minDat[1]
           ENDIF
           IF N_ELEMENTS((minDat[1])) EQ 0 THEN BEGIN
              minDat[1]=minDat[0]
           ENDIF

           IF (maxDat[0]) GE (maxDat[1]) THEN maxDat[1]=maxDat[0] $
           ELSE maxDat[0]=maxDat[1]

           IF (minDat[0]) LE (minDat[1]) THEN minDat[1]=minDat[0] $
           ELSE minDat[0]=minDat[1]
        ENDIF

     ENDIF ELSE BEGIN
        maxDat=MAX(minMaxDat(*,1))
        minDat=MIN(minMaxDat(*,0))
     ENDELSE
     
     ;; ;And NOW let's plot quantity from the Alfven DB to see how it fares during storms
     xTitle='Hours since storm commencement'
     ;; yTitle='Maximus:
     
     xRange=[-tBeforeStorm,tAfterStorm]
     yRange=[geomag_min,geomag_max]

     FOR i=0,nStorms-1 DO BEGIN
        
        IF neg_and_pos_separ THEN BEGIN
           ;; get appropriate indices
           plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))

           plot_i_list = LIST(cgsetintersection(plot_i,cdb_ind_list[0]))
           plot_i_list.add,cgsetintersection(plot_i,cdb_ind_list[1])

           ;; get relevant time range
           cdb_t=LIST( (DOUBLE(cdbTime(plot_i_list[0]))-DOUBLE(centerTime(i)))/3600. )
           cdb_t.add,( (DOUBLE(cdbTime(plot_i_list[1]))-DOUBLE(centerTime(i)))/3600. )
           
           ;; get corresponding data
           cdb_y=LIST(maximus.(maxInd)(plot_i_list[0]))
           cdb_y.add,ABS(maximus.(maxInd)(plot_i_list[1]))
           
           nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)

           IF (plot_i_list[0])(0) GT -1 AND N_ELEMENTS(plot_i_list[0]) GT 1 THEN BEGIN

              plot_pos=plot((cdb_t[0]), $
                            (cdb_y[0]), $
                            TITLE=plotTitle, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags(maxInd)), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [(minDat[0]),(maxDat[0])], $
                            YLOG=(log_DBQuantity) ? 1 : 0, $
                            LINESTYLE=' ', $
                            SYMBOL='+', $
                            SYM_COLOR='r', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            YTICKFONT_SIZE=max_ytickfont_size, $
                            YTICKFONT_STYLE=max_ytickfont_style, $
                            ;; XTICKFONT_SIZE=10, $
                            ;; XTICKFONT_STYLE=1, $
                            /CURRENT, $
                            OVERPLOT=(i EQ 0) ? 0: 1, $
                            LAYOUT=pos_layout, $
                            SYM_TRANSPARENCY=defSymTransp)
              
              
           ENDIF

           IF (plot_i_list[1])(0) GT -1 AND (N_ELEMENTS(plot_i_list[1]) GT 1) THEN BEGIN

              plot_neg=plot((cdb_t[1]), $
                            (cdb_y[1]), $
                            TITLE=plotTitle, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags(maxInd)), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [(minDat[1]),(maxDat[1])], $
                            YLOG=(log_DBQuantity) ? 1 : 0, $
                            LINESTYLE=' ', $
                            SYMBOL='+', $
                            SYM_COLOR='SEA GREEN', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            YTICKFONT_SIZE=max_ytickfont_size, $
                            YTICKFONT_STYLE=max_ytickfont_style, $
                            /CURRENT, $
                            OVERPLOT=1, $
                            LAYOUT=neg_layout, $
                            SYM_TRANSPARENCY=defSymTransp)

           ENDIF

        ENDIF ELSE BEGIN
           ;; get appropriate indices
           plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
           
           ;; get relevant time range
           cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(centerTime(i)))/3600.
           
           ;; get corresponding data
           cdb_y=maximus.(maxInd)(plot_i)
           
           IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN

              plot=plot(cdb_t, $
                        cdb_y, $
                        ;; (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                        XTITLE='Hours since storm commencement', $
                        YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                yTitle_maxInd : $
                                mTags(maxInd)), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        YLOG=(log_DBQuantity) ? 1 : 0, $
                        LINESTYLE=' ', $
                        SYMBOL='+', $
                        XTICKFONT_SIZE=max_xtickfont_size, $
                        XTICKFONT_STYLE=max_xtickfont_style, $
                        YTICKFONT_SIZE=max_ytickfont_size, $
                        YTICKFONT_STYLE=max_ytickfont_style, $
                        /CURRENT, $
                        OVERPLOT=(i EQ 0) ? 0: 1, $
                        SYM_TRANSPARENCY=defSymTransp)
              
           ENDIF
           
        ENDELSE                 ;end ~neg_and_pos_separ
     ENDFOR

     ;; Add the legend, if neg_and_pos_separ
     IF neg_and_pos_separ THEN BEGIN
        IF N_ELEMENTS(plot_pos) GT 0 AND N_ELEMENTS(plot_neg) GT 0 THEN BEGIN
           leg = LEGEND(TARGET=[plot_pos,plot_neg], $
                        POSITION=[0.1,0.1], /NORMAL, $
                        /AUTO_TEXT_COLOR)
        ENDIF
     ENDIF

     IF avg_type_maxInd GT 0 THEN BEGIN

        nBins=N_ELEMENTS(tBin)
        IF neg_and_pos_separ THEN BEGIN
           
           ;;combine all plot_i        
           IF N_ELEMENTS(plot_pos) GT 0 THEN BEGIN
              tot_plot_i_pos=tot_plot_i_pos_list(0)
              tot_cdb_t_pos=tot_cdb_t_pos_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_pos_list)-1 DO BEGIN
                 tot_plot_i_pos=[tot_plot_i_pos,tot_plot_i_pos_list(i)]
                 tot_cdb_t_pos=[tot_cdb_t_pos,tot_cdb_t_pos_list(i)]
              ENDFOR

              Avgs_pos=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_pos=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_pos))) : ABS(maximus.(maxInd)(tot_plot_i_pos))

              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_cdb_t_pos GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t_pos LT (tBin(0)+(i+1)*nEvBinSize))
                 Avgs_pos[i] = TOTAL(avg_data_pos(temp_inds))/DOUBLE(nEvHist_pos[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_pos) AND Avgs_pos NE 0.)
              plot_pos=plot(tBin(safe_i)+0.5*nEvBinsize, $
                            (log_DBQuantity) ? 10^Avgs_pos(safe_i) : Avgs_pos(safe_i), $
                            TITLE=plotTitle, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE=mTags(maxInd), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [minDat[0],maxDat[0]], $
                            LINESTYLE='--', $
                            COLOR='MAROON', $
                            SYMBOL='d', $
                            XTICKFONT_SIZE=10, $
                            XTICKFONT_STYLE=1, $
                            LAYOUT=pos_layout, $
                            /CURRENT,/OVERPLOT, $
                            SYM_SIZE=1.5, $
                            SYM_COLOR='MAROON') ;, $
              
           ENDIF

           IF N_ELEMENTS(plot_neg) GT 0 THEN BEGIN
              tot_plot_i_neg=tot_plot_i_neg_list(0)
              tot_cdb_t_neg=tot_cdb_t_neg_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_neg_list)-1 DO BEGIN
                 tot_plot_i_neg=[tot_plot_i_neg,tot_plot_i_neg_list(i)]
                 tot_cdb_t_neg=[tot_cdb_t_neg,tot_cdb_t_neg_list(i)]
              ENDFOR

              Avgs_neg=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_neg=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_neg))) : ABS(maximus.(maxInd)(tot_plot_i_neg))

              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_cdb_t_neg GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t_neg LT (tBin(0)+(i+1)*nEvBinSize))
                 Avgs_neg[i] = TOTAL(avg_data_neg(temp_inds))/DOUBLE(nEvHist_neg[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_neg) AND Avgs_neg NE 0.)
              plot_neg=plot(tBin(safe_i)+0.5*nEvBinsize, $
                            (log_DBQuantity) ? 10^Avgs_neg(safe_i) : Avgs_neg(safe_i), $
                            TITLE=plotTitle, $
                            XTITLE='Hours since storm commencement', $
                            YTITLE=mTags(maxInd), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [minDat[1],maxDat[1]], $
                            LINESTYLE='-:', $
                            COLOR='DARK GREEN', $
                            SYMBOL='d', $
                            XTICKFONT_SIZE=10, $
                            XTICKFONT_STYLE=1, $
                            LAYOUT=neg_layout, $
                            /CURRENT,/OVERPLOT, $
                            SYM_SIZE=1.5, $
                            SYM_COLOR='DARK GREEN') ;, $
              
           ENDIF

        ENDIF ELSE BEGIN

           ;combine all plot_i
           tot_plot_i=tot_plot_i_list(0)
           tot_cdb_t=tot_cdb_t_list(0)
           FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO BEGIN
              tot_plot_i=[tot_plot_i,tot_plot_i_list(i)]
              tot_cdb_t=[tot_cdb_t,tot_cdb_t_list(i)]
           ENDFOR

           Avgs=MAKE_ARRAY(nBins,/DOUBLE)
           avg_data=log_DBQuantity ? ALOG10(maximus.(maxInd)(tot_plot_i)) : maximus.(maxInd)(tot_plot_i)
           ;now loop over histogram bins, perform average
           FOR i=0,nBins-1 DO BEGIN
              temp_inds=WHERE(tot_cdb_t GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t LT (tBin(0)+(i+1)*nEvBinSize))
              Avgs[i] = TOTAL(avg_data(temp_inds))/DOUBLE(nEvHist[i])
           ENDFOR

           safe_i=(log_DBQuantity) ? WHERE(FINITE(Avgs) AND Avgs GT 0.) : WHERE(FINITE(Avgs))
           plot=plot(tBin(safe_i)+0.5*nEvBinsize, $
                     (log_DBQuantity) ? 10^Avgs(safe_i) : Avgs(safe_i), $
                     ;; Avgs(safe_i), $
                     TITLE=plotTitle, $
                     XTITLE='Hours since storm commencement', $
                     YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                             yTitle_maxInd : $
                             mTags(maxInd)), $
                     XRANGE=xRange, $
                     YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                     yRange_maxInd : [minDat,maxDat], $
                     LINESTYLE='--', $
                     SYMBOL='d', $
                     XTICKFONT_SIZE=max_xtickfont_size, $
                     XTICKFONT_STYLE=max_xtickfont_style, $
                     YTICKFONT_SIZE=max_ytickfont_size, $
                     YTICKFONT_STYLE=max_ytickfont_style, $
                     /CURRENT,/OVERPLOT, $
                     SYM_SIZE=1.5, $
                     SYM_COLOR='g') ;, $
           
        ENDELSE
     ENDIF

     IF KEYWORD_SET(saveMaxPlotName) THEN BEGIN
        PRINT,"Saving maxplot to file: " + saveMaxPlotName
        maximuswindow.save,savemaxplotname,RESOLUTION=defRes
     ENDIF

  ENDIF
  
  IF saveFile THEN BEGIN
     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF

END