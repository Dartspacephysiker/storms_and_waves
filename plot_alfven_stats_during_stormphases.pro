;2015/10/21 This is a wrapper so that we don't have to do the gobbledigook below every time we want to see 'sup with these plots
PRO PLOT_ALFVEN_STATS_DURING_STORMPHASES,$
                                 CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                 ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                 MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                 DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                 HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                 MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                 HEMI=hemi, $
                                 DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                 NPLOTS=nPlots, $
                                 EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                                 ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                 ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                 NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                 PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                 NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                 IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                 NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                 CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                 NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                 ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                 ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                 NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                 DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                 NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                 PROBOCCURRENCEPLOT=probOccurrencePlot,PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                                 MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                 ALL_LOGPLOTS=all_logPlots, $
                                 SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                 DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                 WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                 SAVERAW=saveRaw, RAWDIR=rawDir, $
                                 JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                 PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
                                 MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                 OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                 LUN=lun, PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose, _EXTRA=e

  LOAD_DST_AE_DBS,dst,ae

  earliest_UTC = str_to_time('1996-10-06/16:26:02.417')
  latest_UTC = str_to_time('2000-10-06/00:08:45.188')

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp, $
     EARLIEST_UTC=earliest_UTC,LATEST_UTC=latest_UTC, $
     LUN=lun

  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  strings=["nonstorm","mainphase","recoveryphase"]

  FOR i=0,2 DO BEGIN
     inds=dst_i_list[i]

     GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
     t1_arr = dst.time[inds[start_dst_ii]]
     t2_arr = dst.time[inds[stop_dst_ii]]

     PLOT_ALFVEN_STATS_UTC_RANGES,maximus,T1_ARR=t1_arr,T2_ARR=t2_arr,$
                                  CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                  MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                  DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                  HEMI=hemi, $
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  NPLOTS=nPlots, $
                                  EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                                  ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                  ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                  NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                  PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                  NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                  IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                  NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                  CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                  NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                  ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                  ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                  NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                  DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                  NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                  PROBOCCURRENCEPLOT=probOccurrencePlot,PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                                  MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                  ALL_LOGPLOTS=all_logPlots, $
                                  SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                  DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                  WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                  SAVERAW=saveRaw, RAWDIR=rawDir, $
                                  JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                  PLOTDIR=plotDir, PLOTPREFIX=strings[i], PLOTSUFFIX=plotSuffix, $
                                  MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                  OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                  /PRINT_DATA_AVAILABILITY, _EXTRA = e  
              
  ENDFOR

END