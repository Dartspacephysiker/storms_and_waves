;2015/10/21 This is a wrapper so that we don't have to do the gobbledigook below every time we want to see 'sup with these plots
;;mod history
;;;;;;;
;;TO DO
;; You kidding me?
;;
PRO PLOT_ALFVEN_STATS_DURING_STORMPHASES,$
   DSTCUTOFF=dstCutoff, $
   CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
   MINMLT=minMLT,MAXMLT=maxMLT, $
   BINMLT=binMLT, $
   SHIFTMLT=shiftM, $
   MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
   DO_LSHELL=do_lShell, REVERSE_LSHELL=reverse_lShell, $
   MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   BOTH_HEMIS=both_hemis, $
   NORTH=north, $
   SOUTH=south, $
   HEMI=hemi, $
   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
   ;; MIN_NEVENTS=min_nEvents, $
   MASKMIN=maskMin, $
   DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, $
   EPLOTRANGE=ePlotRange, $
   EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
   ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
   ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
   NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, $
   ENUMFLPLOTRANGE=ENumFlPlotRange, $
   AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
   NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
   NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
   NONALFVEN_FLUX_PLOTS=nonAlfven_flux_plots, $
   PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
   NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
   IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
   NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
   CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
   NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
   CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
   NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   ORBCONTRIBPLOT=orbContribPlot, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   ORBCONTRIB_NOMASK=orbContrib_noMask, $
   LOGORBCONTRIBPLOT=logOrbContribPlot, $
   ORBTOTPLOT=orbTotPlot, $
   ORBFREQPLOT=orbFreqPlot, $
   ORBTOTRANGE=orbTotRange, $
   ORBFREQRANGE=orbFreqRange, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, $
   LOGNEVENTPERORB=logNEventPerOrb, $
   NEVENTPERORBRANGE=nEventPerOrbRange, $
   DIVNEVBYAPPLICABLE=divNEvByApplicable, $
   NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
   NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
   NOWEPCO_RANGE=nowepco_range, $
   NOWEPCO_AUTOSCALE=nowepco_autoscale, $
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   THISTDENOMINATORPLOT=tHistDenominatorPlot, $
   THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
   THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
   THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
   THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
   NEWELLPLOTS=newellPlots, $
   NEWELL_PLOTRANGE=newell_plotRange, $
   LOG_NEWELLPLOT=log_newellPlot, $
   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
   NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
   TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
   WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
   WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
   DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   ADD_VARIANCE_PLOTS=add_variance_plots, $
   ONLY_VARIANCE_PLOTS=only_variance_plots, $
   VAR__PLOTRANGE=var__plotRange, $
   VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
   VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
   VAR__AUTOSCALE=var__autoscale, $
   PLOT_CUSTOM_MAXIND=plot_custom_maxInd, $
   CUSTOM_MAXINDS=custom_maxInds, $
   CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
   CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
   CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
   CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
   CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
   LOG_CUSTOM_MAXIND=log_custom_maxInd, $
   MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
   ALL_LOGPLOTS=all_logPlots, $
   SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
   WHOLECAP=wholeCap, $
   DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
   DO_CHASTDB=do_chastDB, $
   DO_DESPUNDB=do_despunDB, $
   NEVENTSPLOTRANGE=nEventsPlotRange, $
   LOGNEVENTSPLOT=logNEventsPlot, $
   NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
   NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
   WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
   SAVERAW=saveRaw, RAWDIR=rawDir, $
   JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
   PLOTDIR=plotDir, $
   PLOTPREFIX=plotPrefix, $
   PLOTSUFFIX=plotSuffix, $
   SAVE_ALF_STORMPHASE_INDICES=save_alf_stormphase_indices, $
   TXTOUTPUTDIR=txtOutputDir, $
   MEDHISTOUTDATA=medHistOutData, $
   MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, $
   DEL_PS=del_PS, $
   EPS_OUTPUT=eps_output, $
   LUN=lun, $
   PRINT_DATA_AVAILABILITY=print_data_availability, $
   COMBINE_STORMPHASE_PLOTS=combine_stormphase_plots, $
   ADD_CENTER_TITLE__STORMPHASE_PLOTS=add_center_title, $
   COMBINED_TO_BUFFER=combined_to_buffer, $
   SAVE_COMBINED_WINDOW=save_combined_window, $
   SAVE_COMBINED_NAME=save_combined_name, $
   NO_STORMPHASE_TITLES=no_stormphase_titles, $
   SUPPRESS_GRIDLABELS=suppress_gridLabels, $
   SUPPRESS_TITLES=suppress_titles, $
   LABELS_FOR_PRESENTATION=labels_for_presentation, $
   TILE_IMAGES=tile_images, $
   N_TILE_ROWS=n_tile_rows, $
   N_TILE_COLUMNS=n_tile_columns, $
   TILING_ORDER=tiling_order, $
   TILE__FAVOR_ROWS=tile__favor_rows, $
   TILEPLOTSUFF=tilePlotSuff, $
   TILEPLOTTITLE=tilePlotTitle, $
   NO_COLORBAR=no_colorbar, $
   COLORBAR_FOR_ALL=colorbar_for_all, $
   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
   CB_FORCE_OOBLOW=cb_force_oobLow, $
   FANCY_PLOTNAMES=fancy_plotNames, $
   VERBOSE=verbose, $
   _EXTRA=e

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  LOAD_DST_AE_DBS,dst,ae

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY
  SET_TXTOUTPUT_DIR,txtOutputDir,/FOR_STORMS,/ADD_TODAY

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
  phases = ["nonstorm","mainphase","recoveryphase"]
  strings=[phases[0]+suff,phases[1]+suff,phases[2]+suff]

  IF KEYWORD_SET(no_stormphase_titles) THEN BEGIN
     niceStrings = !NULL
  ENDIF ELSE BEGIN
     niceStrings=["Non-storm","Main phase","Recovery phase"]
  ENDELSE

  IF KEYWORD_SET(combine_stormphase_plots) THEN BEGIN
     outTempFiles = !NULL
     IF ~KEYWORD_SET(colorbar_for_all) THEN BEGIN
        no_colorbar  = [1,0,1]
     ENDIF ELSE BEGIN
        no_colorbar = [0,0,0]
     ENDELSE
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
                                  MINMLT=minMLT,MAXMLT=maxMLT, $
                                  BINMLT=binMLT, $
                                  SHIFTMLT=shiftM, $
                                  MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                  DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                  MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                  MIN_MAGCURRENT=minMC, $
                                  MAX_NEGMAGCURRENT=maxNegMC, $
                                  BOTH_HEMIS=both_hemis, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  HEMI=hemi, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  ;; MIN_NEVENTS=min_nEvents, $
                                  MASKMIN=maskMin, $
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  NPLOTS=nPlots, $
                                  EPLOTS=ePlots, $
                                  EPLOTRANGE=ePlotRange, $
                                  EFLUXPLOTTYPE=eFluxPlotType, $
                                  LOGEFPLOT=logEfPlot, $
                                  ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                  ENUMFLPLOTS=eNumFlPlots, $
                                  ENUMFLPLOTTYPE=eNumFlPlotType, $
                                  LOGENUMFLPLOT=logENumFlPlot, $
                                  ABSENUMFL=absENumFl, $
                                  NONEGENUMFL=noNegENumFl, $
                                  NOPOSENUMFL=noPosENumFl, $
                                  ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                  AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
                                  NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                                  NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                  NONALFVEN_FLUX_PLOTS=nonAlfven_flux_plots, $
                                  NONALFVEN_FOR_STORMS=KEYWORD_SET(nonAlfven_flux_plots) ? phases[i] : !NULL, $
                                  PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                  NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                  IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                  NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                  CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                  NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                  CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                  NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                                  AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
                                  DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
                                  DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                  ORBCONTRIBPLOT=orbContribPlot, $
                                  ORBCONTRIBRANGE=orbContribRange, $
                                  ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
                                  ORBCONTRIB_NOMASK=orbContrib_noMask, $
                                  LOGORBCONTRIBPLOT=logOrbContribPlot, $
                                  ORBTOTPLOT=orbTotPlot, $
                                  ORBFREQPLOT=orbFreqPlot, $
                                  ORBTOTRANGE=orbTotRange, $
                                  ORBFREQRANGE=orbFreqRange, $
                                  NEVENTPERORBPLOT=nEventPerOrbPlot, $
                                  LOGNEVENTPERORB=logNEventPerOrb, $
                                  NEVENTPERORBRANGE=nEventPerOrbRange, $
                                  DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                  NEVENTPERMINPLOT=nEventPerMinPlot, $
                                  LOGNEVENTPERMIN=logNEventPerMin, $
                                  NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
                                  NOWEPCO_RANGE=nowepco_range, $
                                  NOWEPCO_AUTOSCALE=nowepco_autoscale, $
                                  LOG_NOWEPCOPLOT=log_nowepcoPlot, $
                                  PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
                                  LOGPROBOCCURRENCE=logProbOccurrence, $
                                  THISTDENOMINATORPLOT=tHistDenominatorPlot, $
                                  THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                                  THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                                  THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                                  THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                                  NEWELLPLOTS=newellPlots, $
                                  NEWELL_PLOTRANGE=newell_plotRange, $
                                  LOG_NEWELLPLOT=log_newellPlot, $
                                  NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                  NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                  NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                                  TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                  TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                  LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                  TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                  TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                  LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
                                  DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                  DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                                  DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                                  WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                                  WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
                                  DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                                  DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                  MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                  ADD_VARIANCE_PLOTS=add_variance_plots, $
                                  ONLY_VARIANCE_PLOTS=only_variance_plots, $
                                  VAR__PLOTRANGE=var__plotRange, $
                                  VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
                                  VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
                                  VAR__AUTOSCALE=var__autoscale, $
                                  PLOT_CUSTOM_MAXIND=plot_custom_maxInd, $
                                  CUSTOM_MAXINDS=custom_maxInds, $
                                  CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
                                  CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
                                  CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
                                  CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
                                  CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
                                  LOG_CUSTOM_MAXIND=log_custom_maxInd, $
                                  MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                  ALL_LOGPLOTS=all_logPlots, $
                                  SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                                  WHOLECAP=wholeCap, $
                                  DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
                                  DO_CHASTDB=do_chastDB, $
                                  DO_DESPUNDB=do_despunDB, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, $
                                  LOGNEVENTSPLOT=logNEventsPlot, $
                                  NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
                                  NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
                                  WRITEASCII=writeASCII, $
                                  WRITEHDF5=writeHDF5, $
                                  WRITEPROCESSEDH2D=writeProcessedH2d, $
                                  SAVERAW=saveRaw, RAWDIR=rawDir, $
                                  JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                  PLOTDIR=plotDir, $
                                  PLOTPREFIX=strings[i], $
                                  PLOTSUFFIX=plotSuffix, $
                                  SAVE_ALF_INDICES=save_alf_stormphase_indices, $
                                  TXTOUTPUTDIR=txtOutputDir, $
                                  MEDHISTOUTDATA=medHistOutData, $
                                  MEDHISTOUTTXT=medHistOutTxt, $
                                  OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                  DEL_PS=del_PS, $
                                  EPS_OUTPUT=eps_output, $
                                  OUT_TEMPFILE=out_tempFile, $
                                  SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                                  SUPPRESS_TITLES=KEYWORD_SET(add_center_title), $
                                  LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                  TILE_IMAGES=tile_images, $
                                  N_TILE_ROWS=n_tile_rows, $
                                  N_TILE_COLUMNS=n_tile_columns, $
                                  TILING_ORDER=tiling_order, $
                                  TILE__FAVOR_ROWS=tile__favor_rows, $
                                  TILEPLOTSUFF=tilePlotSuff, $
                                  TILEPLOTTITLE=tilePlotTitle, $
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
        plotFileArr = [[plotFileArr],[plotDir + paramStr+'--'+dataNameArr[0:-2+KEYWORD_SET(nPlots)] + fileSuff]]
     ENDFOR

     ctrTitleArr       = !NULL
     FOR i=0,(N_ELEMENTS(dataNameArr)-2+KEYWORD_SET(nPlots)) DO BEGIN
        ctrTitleArr    = [ctrTitleArr,h2dStrArr[i].title]
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

        save_combined_name = paramStr + '--' + dataNameArr[0:-2+KEYWORD_SET(nPlots)] + $
                             '--combined_phases' + fileSuff
        ;; save_combined_name = GET_TODAY_STRING() + '--' + dataNameArr[0:-3+KEYWORD_SET(nPlots)] + $
        ;;                      (KEYWORD_SET(plotSuffix) ? plotSuffix : '') + $
        ;;                      '--' + statType + '--combined_phases' + fileSuff
     ENDIF

     FOR i=0,N_ELEMENTS(plotFileArr[*,0])-1 DO BEGIN

        PRINT,"Saving to " + save_combined_name[i] + "..."
        TILE_STORMPHASE_PLOTS,plotFileArr[i,*],niceStrings, $
                              ADD_CENTER_TITLE=KEYWORD_SET(add_center_title) ? ctrTitleArr[i] : !NULL, $
                              OUT_IMGARR=out_imgArr, $
                              OUT_TITLEOBJS=out_titleObjs, $
                              COMBINED_TO_BUFFER=combined_to_buffer, $
                              SAVE_COMBINED_WINDOW=save_combined_window, $
                              SAVE_COMBINED_NAME=save_combined_name[i], $
                              PLOTDIR=plotDir, $
                              /DELETE_PLOTS_WHEN_FINISHED
     ENDFOR
  ENDIF

END