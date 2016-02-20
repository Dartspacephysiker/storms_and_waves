;2015/10/21 This is a wrapper so that we don't have to do the gobbledigook below every time we want to see 'sup with these plots
;;mod history
;;;;;;;
;;TO DO
;;2015/11/30 1. Make all stormphase plots appear in one window instead of separating output
;;
PRO PLOT_ALFVEN_STATS_DURING_STORMPHASES,$
   DSTCUTOFF=dstCutoff, $
   CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
   MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
   DO_LSHELL=do_lShell, REVERSE_LSHELL=reverse_lShell, $
   MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
   BOTH_HEMIS=both_hemis, $
   NORTH=north, $
   SOUTH=south, $
   HEMI=hemi, $
   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
   MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
   DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, $
   EPLOTRANGE=ePlotRange, $
   EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
   ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
   ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
   NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
   PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
   NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
   IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
   NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
   CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
   NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
   CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
   NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
   ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
   ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
   DIVNEVBYAPPLICABLE=divNEvByApplicable, $
   NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
   MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
   ALL_LOGPLOTS=all_logPlots, $
   SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
   WHOLECAP=wholeCap, $
   DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
   NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
   WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
   SAVERAW=saveRaw, RAWDIR=rawDir, $
   JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
   PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
   MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, $
   DEL_PS=del_PS, $
   EPS_OUTPUT=eps_output, $
   LUN=lun, $
   PRINT_DATA_AVAILABILITY=print_data_availability, $
   COMBINE_STORMPHASE_PLOTS=combine_stormphase_plots, $
   COMBINED_TO_BUFFER=combined_to_buffer, $
   SAVE_COMBINED_WINDOW=save_combined_window, $
   SAVE_COMBINED_NAME=save_combined_name, $
   NO_COLORBAR=no_colorbar, $
   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
   CB_FORCE_OOBLOW=cb_force_oobLow, $
   FANCY_PLOTNAMES=fancy_plotNames, $
   VERBOSE=verbose, $
   _EXTRA=e

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  LOAD_DST_AE_DBS,dst,ae

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

  IF NOT (KEYWORD_SET(hemi) OR $
          KEYWORD_SET(north) OR KEYWORD_SET(south) OR $
          KEYWORD_SET(both_hemis) ) THEN BEGIN
     PRINTF,lun,"No hemi provided to PLOT_ALFVEN_STATS_DURING_STORMPHASES!"
     PRINTF,lun,"Defaulting to 'BOTH'"
     hemi = 'BOTH'
  ENDIF

  earliest_UTC = str_to_time('1996-10-06/16:26:02.417')
  latest_UTC = str_to_time('2000-10-06/00:08:45.188')

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
     DSTCUTOFF=DstCutoff, $
     STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp, $
     EARLIEST_UTC=earliest_UTC,LATEST_UTC=latest_UTC, $
     LUN=lun

  ;; justData = 1
  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  suff = STRING(FORMAT='("--Dstcutoff_",I0)',dstCutoff)
  strings=["nonstorm"+suff,"mainphase"+suff,"recoveryphase"+suff]
  niceStrings=["Non-storm","Main phase","Recovery phase"]

  IF KEYWORD_SET(combine_stormphase_plots) THEN BEGIN
     outTempFiles = !NULL
     no_colorbar  = [1,0,1]
  ENDIF ELSE BEGIN
     no_colorbar  = [0,0,0]
  ENDELSE

  FOR i=0,2 DO BEGIN
     inds=dst_i_list[i]

     GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
     t1_arr = dst.time[inds[start_dst_ii]]
     t2_arr = dst.time[inds[stop_dst_ii]]

     PLOT_ALFVEN_STATS_UTC_RANGES,maximus,T1_ARR=t1_arr,T2_ARR=t2_arr,$
                                  CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                  MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                  DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                  MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                  BOTH_HEMIS=both_hemis, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  HEMI=hemi, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  NPLOTS=nPlots, $
                                  EPLOTS=ePlots, $
                                  EPLOTRANGE=ePlotRange, $
                                  EFLUXPLOTTYPE=eFluxPlotType, $
                                  LOGEFPLOT=logEfPlot, $
                                  ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                  ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                  NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                  PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                  NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                  IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                  NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                  CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                  NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                  CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                  NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                                  ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                  ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                  NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                  DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                  NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                  PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  LOGPROBOCCURRENCE=logProbOccurrence, $
                                  TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                  TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                  LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                  TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                  TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                  LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
                                  MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                  ALL_LOGPLOTS=all_logPlots, $
                                  SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                                  WHOLECAP=wholeCap, $
                                  DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                  WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                  SAVERAW=saveRaw, RAWDIR=rawDir, $
                                  JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                  PLOTDIR=plotDir, PLOTPREFIX=strings[i], PLOTSUFFIX=plotSuffix, $
                                  MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                  OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                  DEL_PS=del_PS, $
                                  EPS_OUTPUT=eps_output, $
                                  OUT_TEMPFILE=out_tempFile, $
                                  NO_COLORBAR=no_colorbar[i], $
                                  CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                  CB_FORCE_OOBLOW=cb_force_oobLow, $
                                  FANCY_PLOTNAMES=fancy_plotNames, $
                                  /PRINT_DATA_AVAILABILITY, $
                                  _EXTRA = e  

     IF KEYWORD_SET(combine_stormphase_plots) THEN outTempFiles = [outTempFiles,out_tempFile]
              
  ENDFOR

  IF KEYWORD_SET(combine_stormphase_plots) THEN BEGIN

     IF KEYWORD_SET(eps_output) THEN fileSuff = '.ps' ELSE fileSuff = '.png'
     ;; COMBINE_ALFVEN_STATS_PLOTS,niceStrings, $
     ;;                            TEMPFILES=outTempFiles, $
     ;;                            OUT_IMGS_ARR=out_imgs_arr, $
     ;;                            OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
     ;;                            COMBINED_TO_BUFFER=combined_to_buffer, $
     ;;                            SAVE_COMBINED_WINDOW=save_combined_window, $
     ;;                            SAVE_COMBINED_NAME=save_combined_name, $
     ;;                            PLOTSUFFIX=plotSuffix, $
     ;;                            PLOTDIR=plotDir, $
     ;;                            /DELETE_PLOTS_WHEN_FINISHED

     PRINT,"Combining stormphase plots..."

     plotFileArr = !NULL
     FOR i=0,2 DO BEGIN
        RESTORE,outTempFiles[i]
        plotFileArr = [plotFileArr,plotDir + paramStr+dataNameArr[0] + fileSuff]
        ;; imArr[i]    = IMAGE(plotFileArr[i], $
        ;;                     LAYOUT=[3,1,i+1],$
        ;;                     MARGIN=0)
     ENDFOR

     IF ~KEYWORD_SET(save_combined_name) THEN BEGIN
        IF KEYWORD_SET(logAvgPlot) THEN BEGIN
           statType = 'log_avg'
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(medianPlot) THEN BEGIN
              statType = 'median'
           ENDIF ELSE BEGIN
              statType = 'avg'
           ENDELSE
        ENDELSE

        ;; hoyDia = GET_TODAY_STRING()
        save_combined_name = GET_TODAY_STRING() + '--' + dataNameArr[0] + $
                             (KEYWORD_SET(plotSuffix) ? plotSuffix : '') + $
                             '--' + statType + '--combined_phases' + fileSuff
     ENDIF

     PRINT,"Saving to " + save_combined_name + "..."
     TILE_STORMPHASE_PLOTS,plotFileArr,niceStrings, $
                           OUT_IMGARR=out_imgArr, $
                           OUT_TITLEOBJS=out_titleObjs, $
                           COMBINED_TO_BUFFER=combined_to_buffer, $
                           SAVE_COMBINED_WINDOW=save_combined_window, $
                           SAVE_COMBINED_NAME=save_combined_name, $
                           PLOTDIR=plotDir, $
                           /DELETE_PLOTS_WHEN_FINISHED

  ENDIF

END