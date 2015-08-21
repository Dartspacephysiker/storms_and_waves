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
;                         2015/08/14 Adding STORMINDS keywords so we can hand-pick our storms, and PLOTTITLE
;                         2015/08/17 Added NOPLOTS, NOMAXPLOTS keywords, for crying out loud.
;                           
;-


PRO superpose_storms_nevents,stormTimeArray_utc, $
                             TBEFORESTORM=tBeforeStorm,TAFTERSTORM=tAfterStorm, $
                             STARTDATE=startDate, STOPDATE=stopDate, $
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             STORMINDS=stormInds, SSC_TIMES_UTC=ssc_times_utc, $
                             REMOVE_DUPES=remove_dupes, HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
                             STORMTYPE=stormType, $
                             USE_SYMH=use_symh,USE_AE=use_AE, $
                             NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, NEVRANGE=nEvRange, $
                             RETURNED_NEV_TBINS_and_HIST=returned_nEv_tbins_and_Hist, BKGRND_HIST=bkgrnd_hist, $
                             NEG_AND_POS_SEPAR=neg_and_pos_separ, POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                             MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
                             RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                             LOG_DBQUANTITY=log_DBquantity, $
                             YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                             DBFILE=dbFile,DB_TFILE=db_tFile, $
                             NO_SUPERPOSE=no_superpose, $
                             NOPLOTS=noPlots, NOMAXPLOTS=noMaxPlots, $
                             USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
                             SAVEFILE=saveFile,OVERPLOT_HIST=overplot_hist, $
                             PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                             SAVEMAXPLOTNAME=saveMaxPlotName
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults

  SET_STORMS_NEVENTS_DEFAULTS,tBeforeStorm=tBeforeStorm,tAfterStorm=tAfterStorm,$
                              swDBDir=swDBDir,swDBFile=swDBFile, $
                              stormDir=stormDir,stormFile=stormFile, $
                              DST_AEDir=DST_AEDir,DST_AEFile=DST_AEFile, $
                              dbDir=dbDir,dbFile=dbFile,db_tFile=db_tFile, $
                              dayside=dayside,nightside=nightside, $
                              restrict_charERange=restrict_charERange,restrict_altRange=restrict_altRange, $
                              maxInd=maxInd,avg_type_maxInd=avg_type_maxInd,log_DBQuantity=log_DBQuantity, $
                              neg_and_pos_separ=neg_and_pos_separ,pos_layout=pos_layout,neg_layout=neg_layout, $
                              use_SYMH=use_SYMH,USE_AE=use_AE, $
                              nEvBinsize=nEvBinsize,min_NEVBINSIZE=min_NEVBINSIZE, $
                              saveFile=saveFile,SAVESTR=saveStr, $
                              noPlots=noPlots,noMaxPlots=noMaxPlots

  plotMargin=[0.13, 0.20, 0.13, 0.15]
  defSymTransp         = 97
  defLineTransp        = 75
  defLineThick         = 2.5

  ;; ;For nEvent histos
  defnEvBinsize        = 150.0D                                                                        ;in minutes
  defnEvYRange         = [0,5000]
                       
  ;;defs for maxPlots
  max_xtickfont_size=20
  max_xtickfont_style=1
  max_ytickfont_size=20
  max_ytickfont_style=1
  avg_symSize=2.0
  avg_symThick=2.0
  avg_Thick=2.5

  defXTitle='Hours since storm commencement'

  ;; nMajorTicks=5
  ;; nMinorTicks=3
  nMajorTicks=5
  nMinorTicks=2

  defRes = 200

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile

  IF ~use_SYMH THEN restore,dataDir+DST_AEDir+DST_AEFile

  restore,dataDir+DBDir+DBFile
  restore,dataDir+DBDir+DB_tFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified date range, if an array of times hasn't been provided
  

  IF N_ELEMENTS(stormTimeArray_utc) NE 0 THEN BEGIN

     nStorms = N_ELEMENTS(stormTimeArray_utc)
     centerTime = stormTimeArray_utc
     tStamps = TIME_TO_STR(stormTimeArray_utc)
     stormString = 'user-provided'

  ENDIF ELSE BEGIN              ;Looks like we're relying on Brett

     nStorms=N_ELEMENTS(stormStruct.time)
  
     GET_STORMTIME_UTC,nStorms=nStorms,STORMINDS=stormInds,STORMFILE=stormFile, $
                       MAXIMUS=maximus,STORMSTRUCTURE=stormStruct,USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $ ;DBs
                       STORMTYPE=stormType,STARTDATE=startDate,STOPDATE=stopDate,SSC_TIMES_UTC=ssc_times_utc, $ ;extra info
                       CENTERTIME=centerTime, TSTAMPS=tStamps, STORMSTRING=stormString,STORMSTRUCT_INDS=stormStruct_inds ; outs

     IF saveFile THEN saveStr+=',startDate,stopDate,stormType,stormStruct_inds'

  ENDELSE

  IF KEYWORD_SET(remove_dupes) THEN BEGIN
     PRINT,'Finding and trashing storms that would otherwise appear twice in the superposed epoch analysis...'
     
     IF N_ELEMENTS(hours_aft_for_no_dupes) EQ 0 THEN BEGIN
        PRINT,'No time before/after storms provided! Using tAfterStorm...'
        tAftNoDupes = tAfterStorm
        
     ENDIF ELSE BEGIN
        PRINT,'Using hours_aft_for_no_dupes = ' + STRCOMPRESS(hours_aft_for_no_dupes,/REMOVE_ALL) + $
              ' for duplicate removal...'
        tAftNoDupes = hours_aft_for_no_dupes
     ENDELSE

     keep_i = MAKE_ARRAY(nStorms,/INTEGER,VALUE=1)
     
     FOR i=0,nStorms-1 DO BEGIN
        
        FOR j=i+1,nStorms-1 DO BEGIN
           IF keep_i[i] AND keep_i[j] THEN BEGIN
              IF ( centerTime(j)-centerTime(i) )/3600. LT tAftNoDupes THEN keep_i[j] = 0
           ENDIF
        ENDFOR
     ENDFOR

     keep = WHERE(keep_i,nKeep,COMPLEMENT=bad_i,NCOMPLEMENT=nBad,/NULL)
     ;; ;resize everythang
     IF nBad GT 0 THEN BEGIN
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
     
  GENERATE_GEOMAG_QUANTITIES,datStartStop=datStartStop,NSTORMS=nStorms, $
                             use_SYMH=use_SYMH,USE_AE=use_AE,DST=dst,SW_DATA=sw_data, $
                             GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                             GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max

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
     IF ~noPlots THEN BEGIN
        geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormString + " storms: "+ $
                            tStamps(0) + " - " + $
                            tStamps(-1), $
                            DIMENSIONS=[1200,800])
        xTitle=defXTitle
        IF use_SYMH THEN BEGIN
           yTitle= 'SYM-H (nT)' 
        ENDIF ELSE BEGIN
           IF use_AE THEN BEGIN
              yTitle = 'AE (nT)' 
           ENDIF ELSE BEGIN
              yTitle = 'DST (nT)'
           ENDELSE
        ENDELSE
        
        xRange=[-tBeforeStorm,tAfterStorm]
        ;; yRange=[geomag_min,geomag_max]
        ;; yRange=[-300,100]
        yRange=(~use_SYMH AND ~ use_AE) ? [-300,100] : !NULL
        
        FOR i=0,nStorms-1 DO BEGIN
           IF N_ELEMENTS(geomag_time_list(i)) GT 1 AND ~noPlots THEN BEGIN
              plot=plot((geomag_time_list(i)-centerTime(i))/3600.,geomag_dat_list(i), $
                        NAME=yTitle, $
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
              
           ENDIF ELSE PRINT,'Losing storm #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
        ENDFOR
        
        axes=plot.axes
        ;; axes[0].MAJOR=(nMajorTicks EQ 4) ? nMajorTicks -1 : nMajorTicks
        axes[1].MINOR=nMinorTicks+1
        ;; ; Has user requested overlaying DST/SYM-H with the histogram?
     ENDIF ;end noplots
  ENDELSE

  ;; Get ranges for plots
  minMaxDat=MAKE_ARRAY(nStorms,2,/DOUBLE)
  
  cdb_ind_list = LIST(WHERE(maximus.(maxInd) GT 0))
  cdb_ind_list.add,WHERE(maximus.(maxInd) LT 0)
     
  IF neg_and_pos_separ OR ( log_DBQuantity AND (cdb_ind_list[1,0] NE -1)) THEN BEGIN
     PRINT,'Got some negs here...'
     WAIT,1
  ENDIF

  nAlfStorms = nStorms

  GET_RANGES_FOR_PLOTS_AND_GEN_HISTOS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i,CDB_STORM_I=cdb_storm_i,CDB_IND_LIST=cdb_ind_list, $
                                      MINMAXDAT=minMaxDat, NALFSTORMS=nAlfStorms,NSTORMS=nStorms, $
                                      CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterStorm=tAfterStorm,tBeforeStorm=tBeforeStorm, $
                                      nEventHists=nEventHists,avg_type_maxInd=avg_type_maxInd, $
                                      NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                      tot_plot_i_pos_list=tot_plot_i_pos_list,tot_cdb_t_pos_list=tot_cdb_t_pos_list,tot_cdb_y_pos_list=tot_cdb_y_pos_list, $
                                      tot_plot_i_neg_list=tot_plot_i_neg_list,tot_cdb_t_neg_list=tot_cdb_t_neg_list,tot_cdb_y_neg_list=tot_cdb_y_neg_list, $
                                      tot_plot_i_list=tot_plot_i_list,tot_cdb_t_list=tot_cdb_t_list,tot_cdb_y_list=tot_cdb_y_list, $
                                      nEvHist_pos=nEvHist_pos,nEvHist_neg=nEvHist_neg,all_nEvHist=all_nEvHist,tBin=tBin, $
                                      MIN_NEVBINSIZE=min_NEVBINSIZE,NEVTOT=nEvTot

  ;; FOR i=0,nStorms-1 DO BEGIN
     
  ;;    tempInds=cgsetintersection(good_i,[cdb_storm_i(i,0):cdb_storm_i(i,1):1])
  ;;    minMaxDat(i,1)=MAX(maximus.(maxInd)(tempInds),MIN=tempMin)
  ;;    minMaxDat(i,0)=tempMin

  ;;    IF neg_and_pos_separ THEN BEGIN
        
  ;;       ;; get appropriate indices
  ;;       plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        
  ;;       IF plot_i[0] EQ -1 THEN BEGIN
  ;;          PRINT,'No Alfven events for storm #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
  ;;          print,FORMAT='("Storm ",I0,":",TR5,A0)',i,tStamps(i) ;show me where!
  ;;          nAlfStorms--
  ;;          print,'nAlfStorms is now ' + STRCOMPRESS(nAlfStorms,/REMOVE_ALL) + '...'
  ;;       END

  ;;       plot_i_list = LIST(cgsetintersection(plot_i,cdb_ind_list[0])) ;pos and neg
  ;;       plot_i_list.add,cgsetintersection(plot_i,cdb_ind_list[1])
        
  ;;       ;; get relevant time range
  ;;       cdb_t=LIST( (DOUBLE(cdbTime(plot_i_list[0]))-DOUBLE(centerTime(i)))/3600. )
  ;;       cdb_t.add,( (DOUBLE(cdbTime(plot_i_list[1]))-DOUBLE(centerTime(i)))/3600. )
        
  ;;       ;; get corresponding data
  ;;       cdb_y=LIST(maximus.(maxInd)(plot_i_list[0]))
  ;;       cdb_y.add,ABS(maximus.(maxInd)(plot_i_list[1]))
        
  ;;       nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)
        
  ;;       IF i EQ 0 THEN BEGIN
  ;;          tot_plot_i_pos_list=LIST(plot_i_list[0])
  ;;          tot_cdb_t_pos_list=LIST((cdb_t[0]))
  ;;          tot_cdb_y_pos_list=LIST(cdb_y[0])
           
  ;;          tot_plot_i_neg_list=LIST(plot_i_list[1])
  ;;          tot_cdb_t_neg_list=LIST((cdb_t[1]))
  ;;          tot_cdb_y_neg_list=LIST(cdb_y[1])
           
  ;;       ENDIF ELSE BEGIN
  ;;          tot_plot_i_pos_list.add,plot_i_list[0]
  ;;          tot_cdb_t_pos_list.add,(cdb_t[0])
  ;;          tot_cdb_y_neg_list.add,cdb_y[0]
           
  ;;          tot_plot_i_neg_list.add,plot_i_list[1]
  ;;          tot_cdb_t_neg_list.add,(cdb_t[1])
  ;;          tot_cdb_y_neg_list.add,cdb_y[1]
           
  ;;       ENDELSE 
        
  ;;       IF (plot_i_list[0])(0) GT -1 AND N_ELEMENTS(plot_i_list[0]) GT 1 THEN BEGIN
           
  ;;          IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch

  ;;             IF N_ELEMENTS(nEvHist_pos) EQ 0 THEN BEGIN
  ;;                nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
  ;;                                      ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                      MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                      BINSIZE=min_NEVBINSIZE)
  ;;                nEvTot[0]=N_ELEMENTS(plot_i_list[0])
  ;;             ENDIF ELSE BEGIN
  ;;                nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
  ;;                                      ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                      MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                      BINSIZE=min_NEVBINSIZE, $
  ;;                                      INPUT=nEvHist_pos)
  ;;                nEvTot[0]+=N_ELEMENTS(plot_i_list[0])
  ;;             ENDELSE
  ;;          ENDIF                ;end nEventHists
  ;;       ENDIF
        
  ;;       IF (plot_i_list[1])(0) GT -1 AND (N_ELEMENTS(plot_i_list[1]) GT 1) THEN BEGIN
           
  ;;          IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
  ;;             IF N_ELEMENTS(nEvHist_neg) EQ 0 THEN BEGIN
  ;;                nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
  ;;                                      ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                      MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                      BINSIZE=min_NEVBINSIZE)
  ;;                nEvTot[1]=N_ELEMENTS(plot_i_list[1])
  ;;             ENDIF ELSE BEGIN
  ;;                nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
  ;;                                      ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                      MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                      BINSIZE=min_NEVBINSIZE, $
  ;;                                      INPUT=nEvHist_neg)
  ;;                nEvTot[1]+=N_ELEMENTS(plot_i_list[1])
  ;;             ENDELSE
  ;;          ENDIF                ;end nEventHists
  ;;       ENDIF
        
  ;;    ENDIF ELSE BEGIN
  ;;       ;; get appropriate indices
  ;;       plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        

  ;;       IF plot_i[0] EQ -1 THEN BEGIN
  ;;          PRINT,'No Alfven events for storm #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
  ;;          print,FORMAT='("Storm ",I0,":",TR5,A0)',i,tStamps(i) ;show me where!
  ;;          nAlfStorms--
  ;;          print,'nAlfStorms is now ' + STRCOMPRESS(nStorms,/REMOVE_ALL) + '...'
  ;;       END

  ;;       ;; get relevant time range
  ;;       cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(centerTime(i)))/3600.
        
  ;;       ;; get corresponding data
  ;;       cdb_y=maximus.(maxInd)(plot_i)
        
  ;;       IF i EQ 0 THEN BEGIN
  ;;          nEvTot=N_ELEMENTS(plot_i)
           
  ;;          tot_plot_i_list=LIST(plot_i)
  ;;          tot_cdb_t_list=LIST(cdb_t)
           
  ;;          tot_cdb_y_list=LIST(cdb_y)
  ;;          nEvTotList=LIST(nEvTot)
  ;;       ENDIF ELSE BEGIN
  ;;          nEvTot+=N_ELEMENTS(plot_i)
           
  ;;          tot_plot_i_list.add,plot_i
  ;;          tot_cdb_t_list.add,cdb_t
           
  ;;          tot_cdb_y_list.add,cdb_y
  ;;          nEvTotList.add,nEvTot
  ;;       ENDELSE 
        
        
  ;;       IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
           
  ;;          IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
  ;;             IF i EQ 0 THEN BEGIN
  ;;                all_nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
  ;;                                  ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                  MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                  BINSIZE=min_NEVBINSIZE)
  ;;             ENDIF ELSE BEGIN
  ;;                all_nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
  ;;                                  ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
  ;;                                  MAX=tAfterStorm,MIN=-tBeforeStorm, $
  ;;                                  BINSIZE=min_NEVBINSIZE, $
  ;;                                  INPUT=all_nEvHist)
  ;;             ENDELSE
  ;;          ENDIF                ;end nEventHists
  ;;       ENDIF
        
  ;;    ENDELSE
     
  ;; ENDFOR

  ;; PRINT,'Number of storms with Alfven events: ' + STRCOMPRESS(nAlfStorms,/REMOVE_ALL)

  IF KEYWORD_SET(nEventHists) THEN BEGIN
     IF neg_and_pos_separ THEN BEGIN
        
        IF (cdb_ind_list[0])(0) NE -1 THEN BEGIN

           cNEvHist_pos= TOTAL(nEvHist_pos, /CUMULATIVE) / nEvTot[0]

           IF ~noPlots THEN BEGIN
              histWindow_pos=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                    DIMENSIONS=[1200,800])
              
              plot_nEv_pos=plot(tBin,nEvHist_pos, $
                                ;; /STAIRSTEP, $
                                /HISTOGRAM, $
                                YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                                TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                                tStamps(0) + " - " + $
                                tStamps(-1), $
                                XTITLE=defXTitle, $
                                YTITLE='Number of Alfvén events', $
                                /CURRENT, LAYOUT=pos_layout,COLOR='red')
              
              cdf_nEv_pos=plot(tBin,cNEvHist_pos, $
                               XTITLE=defXTitle, $
                               YTITLE='Cumulative number of Alfvén events', $
                               /CURRENT, LAYOUT=pos_layout, AXIS_STYLE=1,COLOR='r')
              
              
           ENDIF
        ENDIF
        
        IF (cdb_ind_list[1])(0) NE -1 THEN BEGIN

           cNEvHist_neg= TOTAL(nEvHist_neg, /CUMULATIVE) / nEvTot[1]

           IF ~noPlots THEN BEGIN
              histWindow_neg=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                    DIMENSIONS=[1200,800])
              
              plot_nEv_neg=plot(tBin,nEvHist_neg, $
                                ;; /STAIRSTEP, $
                                /HISTOGRAM, $
                                YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                                TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                                tStamps(0) + " - " + $
                                tStamps(-1), $
                                XTITLE=defXTitle, $
                                YTITLE='Number of Alfvén events', $
                                /CURRENT,/OVERPLOT, LAYOUT=neg_layout,COLOR='b')
              
              cdf_nEv_neg=plot(tBin,cNEvHist_neg, $
                               XTITLE=defXTitle, $
                               YTITLE='Cumulative number of Alfvén events', $
                               /CURRENT, LAYOUT=neg_layout,/OVERPLOT, AXIS_STYLE=1,COLOR='b')
              
              ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize,min_NEVBINSIZE'
           ENDIF
        ENDIF
        
        IF saveFile THEN saveStr+=',cNEvHist_pos,nEvHist_pos,cNEvHist_neg,nEvHist_neg,tBin,nEvBinsize,min_NEVBINSIZE,tot_plot_i_pos_list,tot_plot_i_neg_list,maxInd'
        
     ENDIF ELSE BEGIN

        IF ~noPlots THEN BEGIN
        ;; IF KEYWORD_SET(overplot_hist) THEN BEGIN
        ;;    PRINT,'setting geomagwindow as current...'
        ;;    geomagWindow.setCurrent
        ;; ENDIF ELSE BEGIN
        ;;    histWindow=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
        ;;                   DIMENSIONS=[1200,800])
        ;; ENDELSE
           plot_nEv=plot(tBin,all_nEvHist, $
                         ;; /STAIRSTEP, $
                         /HISTOGRAM, $
                         TITLE=plotTitle, $
                         ;; TITLE='Number of Alfvén events relative to storm epoch for ' + stormString
                         ;; + ' storms, ' + $
                         ;; tStamps(0) + " - " + $
                         ;; tStamps(-1), $
                         YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                         NAME='Event histogram', $
                         ;; YRANGE=[MIN(all_nEvHist),MAX(all_nEvHist)], $
                         XRANGE=xRange, $
                         AXIS_STYLE=(KEYWORD_SET(overplot_hist)) ? 0 : 1, $
                         ;; XTITLE=defXTitle, $
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
                        TICKFONT_SIZE=max_ytickfont_size, $
                        TICKFONT_STYLE=max_ytickfont_style, $
                        TICKFORMAT='(I0)', $
                        ;; AXIS_RANGE=[minDat,maxDat], $
                        TEXTPOS=1, $
                        COLOR='red')
           
           IF KEYWORD_SET(bkgrnd_hist) AND ~noPlots THEN BEGIN
              plot_bkgrnd=plot(tBin,bkgrnd_hist, $
                               ;; /STAIRSTEP, $
                               /HISTOGRAM, $
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
           
           
           ;; cdf_nEv=plot(tBin,cAll_NEvHist, $
           ;;              XTITLE=defXTitle, $
           ;;              YTITLE='Cumulative number of Alfvén events', $
           ;;              /CURRENT, LAYOUT=[2,1,2], AXIS_STYLE=1,COLOR='blue')
           
           ;; IF saveFile THEN saveStr+=',cAll_NEvHist,cdf_nEv,plot_nEv,all_nEvHist,tBin,nEvBinsize,min_NEVBINSIZE'
        ENDIF

        cAll_NEvHist = TOTAL(all_nEvHist, /CUMULATIVE) / nEvTot
        IF saveFile THEN saveStr+=',cAll_NEvHist,all_nEvHist,tBin,nEvBinsize,min_NEVBINSIZE,tot_plot_i_list,maxInd,nAlfStorms'
        
     ENDELSE

     IF KEYWORD_SET(nEventHists) AND KEYWORD_SET(returned_nev_tbins_and_hist) THEN returned_nev_tbins_and_Hist=[[tbin],[all_nEvHist]]
  ENDIF                         ;end IF nEventHists
  
  IF KEYWORD_SET(savePlotName) THEN BEGIN
     PRINT,"Saving plot to file: " + savePlotName
     geomagWindow.save,savePlotName,RESOLUTION=defRes
  ENDIF

  IF KEYWORD_SET(maxInd) THEN BEGIN

     mTags=TAG_NAMES(maximus)
     
     IF ~(noPlots OR noMaxPlots) THEN maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
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
     xTitle=defXTitle
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

           IF (plot_i_list[0])(0) GT -1 AND N_ELEMENTS(plot_i_list[0]) GT 1 AND ~(noPlots OR noMaxPlots) THEN BEGIN

              plot_pos=plot((cdb_t[0]), $
                            (cdb_y[0]), $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
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
                            ;; XTICKFONT_SIZE=max_xtickfont_size, $
                            ;; XTICKFONT_STYLE=max_xtickfont_style, $
                            /CURRENT, $
                            OVERPLOT=(i EQ 0) ? 0: 1, $
                            LAYOUT=pos_layout, $
                            SYM_TRANSPARENCY=defSymTransp)
              
              
           ENDIF

           IF (plot_i_list[1])(0) GT -1 AND (N_ELEMENTS(plot_i_list[1]) GT 1) AND ~(noPlots OR noMaxPlots) THEN BEGIN

              plot_neg=plot((cdb_t[1]), $
                            (cdb_y[1]), $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
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
           
           IF plot_i(0) GT -1 AND (N_ELEMENTS(plot_i) GT 1) AND ~(noPlots OR noMaxPlots)  THEN BEGIN

              plot=plot(cdb_t, $
                        cdb_y, $
                        ;; (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                        XTITLE=defXTitle, $
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
                 temp_inds=WHERE(tot_cdb_t_pos GE (tBin(0) + i*Min_NEVBINSIZE) AND tot_cdb_t_pos LT (tBin(0)+(i+1)*min_NEVBINSIZE))
                 Avgs_pos[i] = TOTAL(avg_data_pos(temp_inds))/DOUBLE(nEvHist_pos[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_pos) AND Avgs_pos NE 0.)

              IF ~(noPlots OR noMaxPlots) THEN BEGIN
                 plot_pos=plot(tBin(safe_i)+0.5*min_NEVBINSIZE, $
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
                               COLOR='MAROON', $
                               SYMBOL='d', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               LAYOUT=pos_layout, $
                               /CURRENT,/OVERPLOT, $
                               SYM_SIZE=1.5, $
                               SYM_COLOR='MAROON') ;, $
                 
              ENDIF ;end no plots

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
                 temp_inds=WHERE(tot_cdb_t_neg GE (tBin(0) + i*Min_NEVBINSIZE) AND tot_cdb_t_neg LT (tBin(0)+(i+1)*min_NEVBINSIZE))
                 Avgs_neg[i] = TOTAL(avg_data_neg(temp_inds))/DOUBLE(nEvHist_neg[i])
              ENDFOR

              safe_i=WHERE(FINITE(Avgs_neg) AND Avgs_neg NE 0.)

              IF ~(noPlots OR noMaxPlots) THEN BEGIN
                 plot_neg=plot(tBin(safe_i)+0.5*min_NEVBINSIZE, $
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
                               COLOR='DARK GREEN', $
                               SYMBOL='d', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               LAYOUT=neg_layout, $
                               /CURRENT,/OVERPLOT, $
                               SYM_SIZE=1.5, $
                               SYM_COLOR='DARK GREEN') ;, $
                 
              ENDIF

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
              temp_inds=WHERE(tot_cdb_t GE (tBin(0) + i*Min_NEVBINSIZE) AND tot_cdb_t LT (tBin(0)+(i+1)*min_NEVBINSIZE))
              Avgs[i] = TOTAL(avg_data(temp_inds))/DOUBLE(all_nEvHist[i])
           ENDFOR

           safe_i=(log_DBQuantity) ? WHERE(FINITE(Avgs) AND Avgs GT 0.) : WHERE(FINITE(Avgs))

           IF ~(noPlots OR noMaxPlots) THEN BEGIN
              plot=plot(tBin(safe_i)+0.5*min_NEVBINSIZE, $
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
                        LINESTYLE='--', $
                        SYMBOL='d', $
                        XTICKFONT_SIZE=max_xtickfont_size, $
                        XTICKFONT_STYLE=max_xtickfont_style, $
                        YTICKFONT_SIZE=max_ytickfont_size, $
                        YTICKFONT_STYLE=max_ytickfont_style, $
                        /CURRENT,/OVERPLOT, $
                        SYM_SIZE=1.5, $
                        SYM_COLOR='g') ;, $
           ENDIF ;end no plots

        ENDELSE
     ENDIF

     IF KEYWORD_SET(saveMaxPlotName) AND ~(noPlots OR noMaxPlots) THEN BEGIN
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