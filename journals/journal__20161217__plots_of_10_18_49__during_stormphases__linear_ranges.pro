;;2016/12/17 asdlfkjsafd;lkjalweoiruojdabcxbvxmbvclzjdahiw8392423
PRO JOURNAL__20161217__PLOTS_OF_10_18_49__DURING_STORMPHASES__LINEAR_RANGES

  dstCutoff                    = -20
  use_mostRecent_Dst_files     = 1

  use_prev_plot_i              = 1
  remake_prev_plot_file        = 0
  despunDB                     = 0

  include_32Hz                 = 1

  ;; orbRange                     = [1000,10600]
  orbRange                     = [1000,12670]
  ;; altRange                     = [ $
  ;;                                [ 500,4300], $
  ;;                                [1000,4300], $
  ;;                                [2000,4300], $
  ;;                                [3000,4300], $
  ;;                                [ 500,3000]  $
  ;;                                ]
  altRange                     = [ $
                                 [ 300,4300] $
                                 ]

  charE__Newell_the_cusp       = 0

  justData                     = 0
  ;; justInds                     = 0
  ;; justInds_saveToFile          = 'check_out_flux_things--NORTH.sav'

  EA_binning                   = 1

  use_AACGM                    = 0

  minMC                        = 1
  maxNegMC                     = -1

  show_integrals               = 1

  dont_blackball_maximus       = 1
  dont_blackball_fastLoc       = 1

  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 0
  probOccurrencePlot             = 0
  eNumFlPlots                    = 1
  ePlots                         = 0
  pPlots                         = 0
  charEPlots                     = 0
  tHistDenominatorPlot           = 0
  nPlots                         = 0
  sum_electron_and_poyntingflux  = 0


  divide_by_width_x              = 1
  do_timeAvg_fluxQuantities      = 1
  do_grossRate_fluxQuantities    = 0
  do_logAvg_the_timeAvg          = 0

  add_variance_plots             = 0
  only_variance_plots            = 0
  var__rel_to_mean_variance      = 0

  ;;Variance plots?
  ;; var__plotRange                 =  [[0.0,1.0], $
  ;;                                    [0.0,1.0], $
  ;;                                    [0.4,2.0]]
  var__plotRange                 = !NULL ;populate as we go

  var__do_stddev_instead         = 0

  fancyPresentationMode          = 0 ;Erases stormphase titles,
                                     ;suppresses gridlabels, blows up plot titles. Keep it.
  and_tiling_options             = 1
  group_like_plots_for_tiling    = 1

  cb_force_oobHigh = 0
  cb_force_oobLow  = 0

  write_obsArr_textFile          = 0
  write_obsArr__inc_IMF          = 1
  write_obsArr__orb_avg_obs      = 1
  writeProcessedH2D              = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minI                           = 60
  maxI                           = 90

  ;; hemi                           = 'SOUTH'
  ;; minI                           = -90
  ;; maxI                           = -60
  ;; orbRange                       = [(orbRange[0] > 2000),orbRange[1]]

  binI                           = 2.5
  binM                           = 1.0

  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 0

  colorbar_for_all               = 0
  autoscale_fluxPlots            = 0

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;08-ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ;; ePlotRange                     = [1e5,1e8]
  ePlotRange                     = [0,0.5]
  logEfPlot                      = 0
  noNegEflux                     = 1
  eFluxVarPlotRange              = [1e1,1e8]
  var__plotRange                 = [[var__plotRange],[eFluxVarPlotRange]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  ;; maxInd                         = 10
  ;; eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux','total_eflux_integ',"ESA_Current"]
  ;; noNegENumFl                    = [1,1,0,0]
  ;; ;; logENumFlPlot                  = [1,1]
  ;; ;; eNumFlPlotRange                = [[1e-3,1e0], $
  ;; ;;                                   [1e7,1e9]]
  ;; logENumFlPlot                  = [1,1,0,0]
  ;; eNumFlPlotRange                = [[1e-2,1e0], $
  ;;                                   [1e7 ,1e9], $
  ;;                                   [-0.25,0.25], $
  ;;                                   [-0.5,0.5]]



  eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux','total_eflux_integ',"ESA_Current"]
  noNegENumFl                    = [1,0,0,0]
  ;; logENumFlPlot                  = [1,1]
  ;; eNumFlPlotRange                = [[1e-3,1e0], $
  ;;                                   [1e7,1e9]]
  logENumFlPlot                  = [1,0,0,0]
  eNumFlPlotRange                = [[1e-2,1e0], $
                                    [-1e7 ,1e7], $
                                    [-0.25,0.25], $
                                    [-0.5,0.5]]
  ;; eNumFlVarPlotRange             = [[1e1,1e8], $
  ;;                                   [1e1,1e8]]
  ;; var__plotRange                 = [[var__plotRange],[eNumFlVarPlotRange]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifluxPlotType                  = ['INTEG_UP','integ']
  noNegIFlux                     = [1,0]
  ;; iPlotRange                     = [[1e6,1e8],[-1e7,1e7]]
  ;; logIFPlot                      = [1,0]
  iPlotRange                     = [[1e6,1e8],[-1e7,1e7]]
  logIFPlot                      = [1,0]
  iVarPlotRange                  = [1e1,1e8]

  charEType                      = ["losscone"]
  ;; logCharEPlot                   = 1
  ;; CharEPlotRange                 = [1e1,1e4]
  logCharEPlot                   = 0
  CharEPlotRange                 = [0,1500]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [1e-3,1e0]
  logPFPlot                      = 1
  pPlotRange                     = [1e-2,1e0]
  ;; multiply_pFlux_by_width_x      = 1
  pVarPlotRange                  = [1e1,1e8]
  var__plotRange                 = [[var__plotRange],[pVarPlotRange]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Time histogram
  tHistDenomPlotRange            = [0,300]
  ;; tHistDenomPlotAutoscale        = 1
  ;; tHistDenomPlotNormalize        = 0
  tHistDenomPlot_noMask          = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;N Events
  nEventsPlotRange               = [0,500]
  nEventsPlot__noMask            = 1

  summed_eFlux_pFluxplotRange    = [1e-2,1e0]
  summed_eFlux_pFlux_logPlot     = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  ;; probOccurrenceRange  = [1e-3,1e-1]
  ;; logProbOccurrence    = 1

  probOccurrenceRange  = [0,0.1]
  logProbOccurrence    = 0

  FOR k=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN

     altStr             = STRING(FORMAT='("orbs_",I0,"-",I0,"--",I0,"-",I0,"km")', $
                                 orbRange[0], $
                                 orbRange[1], $
                                 altRange[0,k], $
                                 altRange[1,k])

     altitudeRange      = altRange[*,k]

     plotPrefix           = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     SETUP_PASIS_TO_RUN_ALL_STORMPHASES, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        ALL_STORM_PHASES=all_storm_phases, $
        AND_TILING_OPTIONS=and_tiling_options, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        TILE_IMAGES=tile_images, $
        TILING_ORDER=tiling_order, $
        N_TILE_COLUMNS=n_tile_columns, $
        N_TILE_ROWS=n_tile_rows, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        COLORBAR_FOR_ALL=colorbar_for_all, $
        TILEPLOTSUFF=tilePlotSuff

     PLOT_ALFVEN_STATS__SETUP, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        NEED_FASTLOC_I=need_fastLoc_i, $
        USE_STORM_STUFF=use_storm_stuff, $
        AE_STUFF=ae_stuff, $    
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        CHARE__NEWELL_THE_CUSP=charE__Newell_the_cusp, $
        POYNTRANGE=poyntRange, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
        MINMLT=minM,MAXMLT=maxM, $
        BINMLT=binM, $
        SHIFTMLT=shiftM, $
        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
        EQUAL_AREA_BINNING=EA_binning, $
        DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
        REVERSE_LSHELL=reverse_lShell, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        DESPUNDB=despunDB, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
        LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
        LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
        HEMI=hemi, $
        NORTH=north, $
        SOUTH=south, $
        BOTH_HEMIS=both_hemis, $
        DAYSIDE=dayside, $
        NIGHTSIDE=nightside, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EFLUXPLOTTYPE=eFluxPlotType, $
        ENUMFLPLOTS=eNumFlPlots, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        PPLOTS=pPlots, $
        IONPLOTS=ionPlots, $
        IFLUXPLOTTYPE=ifluxPlotType, $
        CHAREPLOTS=charEPlots, $
        CHARETYPE=charEType, $
        CHARIEPLOTS=chariEPlots, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
        FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
        ORBCONTRIBPLOT=orbContribPlot, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $ 
        MEDIANPLOT=medianPlot, $
        LOGAVGPLOT=logAvgPlot, $
        PLOTMEDORAVG=plotMedOrAvg, $
        DATADIR=dataDir, $
        NO_BURSTDATA=no_burstData, $
        WRITEASCII=writeASCII, $
        WRITEHDF5=writeHDF5, $
        WRITEPROCESSEDH2D=writeProcessedH2D, $
        SAVERAW=saveRaw, $
        SAVEDIR=saveDir, $
        JUSTDATA=justData, $
        JUSTINDS_THENQUIT=justInds, $
        JUSTINDS_SAVETOFILE=justInds_saveToFile, $
        SHOWPLOTSNOSAVE=showPlotsNoSave, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        KEEPME=keepMe, $
        PARAMSTRING=paramString, $
        PARAMSTRPREFIX=plotPrefix, $
        PARAMSTRSUFFIX=plotSuffix,$
        PLOTH2D_CONTOUR=plotH2D_contour, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
        HOYDIA=hoyDia, $
        LUN=lun, $
        NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
        ESPEC__NO_MAXIMUS=no_maximus, $
        ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
        ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
        ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
        ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
        ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
        ESPEC__NOMAPTO100KM=eSpec__noMap, $
        ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
        ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
        ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
        ALL_STORM_PHASES=all_storm_phases, $
        DSTCUTOFF=dstCutoff, $
        SMOOTH_DST=smooth_dst, $
        USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
        USE_AE=use_ae, $
        USE_AU=use_au, $
        USE_AL=use_al, $
        USE_AO=use_ao, $
        AECUTOFF=AEcutoff, $
        SMOOTH_AE=smooth_AE, $
        AE_HIGH=AE_high, $
        AE_LOW=AE_low, $
        AE_BOTH=AE_both, $
        USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
        CLOCKSTR=clockStr, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        THETACONEMIN=tConeMin, $
        THETACONEMAX=tConeMax, $
        BYMIN=byMin, $
        BYMAX=byMax, $
        BZMIN=bzMin, $
        BZMAX=bzMax, $
        BTMIN=btMin, $
        BTMAX=btMax, $
        BXMIN=bxMin, $
        BXMAX=bxMax, $
        DO_ABS_BYMIN=abs_byMin, $
        DO_ABS_BYMAX=abs_byMax, $
        DO_ABS_BZMIN=abs_bzMin, $
        DO_ABS_BZMAX=abs_bzMax, $
        DO_ABS_BTMIN=abs_btMin, $
        DO_ABS_BTMAX=abs_btMax, $
        DO_ABS_BXMIN=abs_bxMin, $
        DO_ABS_BXMAX=abs_bxMax, $
        BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
        BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
        BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        OMNIPARAMSTR=OMNIparamStr, $
        OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        DELAY=delay, $
        MULTIPLE_DELAYS=multiple_delays, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        OUT_EXECUTING_MULTIPLES=executing_multiples, $
        OUT_MULTIPLES=multiples, $
        OUT_MULTISTRING=multiString, $
        RESOLUTION_DELAY=delay_res, $
        BINOFFSET_DELAY=binOffset_delay, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        EARLIEST_UTC=earliest_UTC, $
        LATEST_UTC=latest_UTC, $
        EARLIEST_JULDAY=earliest_julDay, $
        LATEST_JULDAY=latest_julDay, $
        RESET_STRUCT=reset

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        NEED_FASTLOC_I=need_fastLoc_i, $
        USE_STORM_STUFF=use_storm_stuff, $
        AE_STUFF=ae_stuff, $    
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        RESET_OMNI_INDS=reset_omni_inds, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EPLOTRANGE=ePlotRange, $
        EFLUXPLOTTYPE=eFluxPlotType, $
        LOGEFPLOT=logEfPlot, $
        ABSEFLUX=abseflux, $
        NOPOSEFLUX=noPosEFlux, $
        NONEGEFLUX=noNegEflux, $
        ENUMFLPLOTS=eNumFlPlots, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        LOGENUMFLPLOT=logENumFlPlot, $
        ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, $
        NOPOSENUMFL=noPosENumFl, $
        ENUMFLPLOTRANGE=ENumFlPlotRange, $
        AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
        NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
        NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
        NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
        PPLOTS=pPlots, $
        LOGPFPLOT=logPfPlot, $
        ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, $
        NOPOSPFLUX=noPosPflux, $
        PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, $
        IFLUXPLOTTYPE=ifluxPlotType, $
        LOGIFPLOT=logIfPlot, $
        ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, $
        NOPOSIFLUX=noPosIflux, $
        IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, $
        CHARETYPE=charEType, $
        LOGCHAREPLOT=logCharEPlot, $
        ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, $
        NOPOSCHARE=noPosCharE, $
        CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, $
        LOGCHARIEPLOT=logChariePlot, $
        ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, $
        NOPOSCHARIE=noPosCharie, $
        CHARIEPLOTRANGE=ChariePlotRange, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
        DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
        DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
        ORBCONTRIBPLOT=orbContribPlot, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        ORBCONTRIBRANGE=orbContribRange, $
        ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
        ORBCONTRIB__REFERENCE_ALFVENDB_NOT_EPHEMERIS=orbContrib__reference_alfvenDB, $
        ORBTOTRANGE=orbTotRange, $
        ORBFREQRANGE=orbFreqRange, $
        ORBCONTRIB_NOMASK=orbContrib_noMask, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        LOGNEVENTPERORB=logNEventPerOrb, $
        NEVENTPERORBRANGE=nEventPerOrbRange, $
        NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NEVENTPERMINRANGE=nEventPerMinRange, $
        LOGNEVENTPERMIN=logNEventPerMin, $
        NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
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
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
        THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        NEWELLPLOTS=newellPlots, $
        NEWELL_PLOTRANGE=newell_plotRange, $
        LOG_NEWELLPLOT=log_newellPlot, $
        NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
        NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
        ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
        ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
        ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
        ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
        WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
        WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
        ADD_VARIANCE_PLOTS=add_variance_plots, $
        ONLY_VARIANCE_PLOTS=only_variance_plots, $
        VAR__PLOTRANGE=var__plotRange, $
        VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
        VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
        VAR__AUTOSCALE=var__autoscale, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
        SUMMED_EFLUX_PFLUX_LOGPLOT=summed_eFlux_pFlux_logPlot, $
        MEDIANPLOT=medianPlot, $
        LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $
        DBFILE=dbfile, $
        RESET_GOOD_INDS=reset_good_inds, $
        NO_BURSTDATA=no_burstData, $
        DATADIR=dataDir, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        PLOTPREFIX=plotPrefix, $
        SUFFIX_TXTDIR=suffix_txtDir, $
        SUPPRESS_THICKGRID=fancyPresentationMode, $
        SUPPRESS_GRIDLABELS=fancyPresentationMode, $
        SUPPRESS_MLT_LABELS=fancyPresentationMode, $
        SUPPRESS_ILAT_LABELS=fancyPresentationMode, $
        SUPPRESS_MLT_NAME=suppress_MLT_name, $
        SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
        SUPPRESS_TITLES=fancyPresentationMode, $
        LABELS_FOR_PRESENTATION=fancyPresentationMode, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILING_ORDER=tiling_order, $
        TILE__FAVOR_ROWS=tile__favor_rows, $
        TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
        TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
        TILEPLOTSUFF=tilePlotSuff, $
        TILEPLOTTITLE=tilePlotTitle, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        SHOW_INTEGRALS=show_integrals, $
        MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
        MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
        INTEGRALSAVFILEPREF=integralSavFilePref, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file
  ENDFOR

END

