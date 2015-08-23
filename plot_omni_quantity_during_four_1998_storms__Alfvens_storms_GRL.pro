;2015/08/22
;Pssh, this draft is so stupidly overdue. It's difficult to care now... I gotta check out what the solar wind is up to!

;; IDL> print,tag_names(sw_data)
;; IMF PLS IMF_PTS PLS_PTS PERCENT_INTERP TIMESHIFT RMS_TIMESHIFT RMS_PHASE
;; TIME_BTWN_OBS F BX_GSE BY_GSE BZ_GSE BY_GSM BZ_GSM RMS_SD_B FLOW_SPEED VX VY VZ
;; PROTON_DENSITY T PRESSURE E BETA MACH_NUM MGS_MACH_NUM BSN_X BSN_Y BSN_Z
;; AE_INDEX AL_INDEX AU_INDEX SYM_D SYM_H ASY_D ASY_H PC_N_INDEX EPOCH

PRO PLOT_OMNI_QUANTITY_DURING_FOUR_1998_STORMS__ALFVENS_STORMS_GRL,OMNI_QUANTITY=omni_quantity,DATE=date,OUTPUT_PLOTS=output_plots, $
   LOGPLOTS=logPlots,USE_DATA_MINMAX=use_data_minMax

  ;;************************************************************
  ;;to be outputted

  IF NOT KEYWORD_SET(date) THEN BEGIN
     date = 'WHENNNNN'
  ENDIF

  IF NOT KEYWORD_SET(omni_quantity) THEN BEGIN
     PRINT,'IMF PLS IMF_PTS PLS_PTS PERCENT_INTERP TIMESHIFT RMS_TIMESHIFT RMS_PHASE'
     PRINT,'TIME_BTWN_OBS F BX_GSE BY_GSE BZ_GSE BY_GSM BZ_GSM RMS_SD_B FLOW_SPEED VX VY VZ'
     PRINT,'PROTON_DENSITY T PRESSURE E BETA MACH_NUM MGS_MACH_NUM BSN_X BSN_Y BSN_Z'
     PRINT,'AE_INDEX AL_INDEX AU_INDEX SYM_D SYM_H ASY_D ASY_H PC_N_INDEX EPOCH'
     ;; RETURN
  ENDIF
  ;; omni_quantity = 'flow_speed'

  ;scatter plots, N and S Hemi

  IF N_ELEMENTS(output_Plots) GT 0 THEN BEGIN
     savePlotName='four_storms_from_1998--' + omni_quantity + '--' + date + '.png'
     ;; scOutPref='scatterplots--four_storms_in_1998--' + omni_quantity + '--' + date
  ENDIF
  
  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_BRETT = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  INDS_FILE = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'

  PRINT,"Restoring " + DB_BRETT + "..."
  RESTORE,DBDIR+DB_BRETT

  PRINT,"Restoring " + DB_NOAA + "..."
  RESTORE,DBDIR+DB_NOAA

  RESTORE,DBDIR+INDS_FILE

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  ;;none of these have storms in them!!
  ;; q1_st=q1_st[[34,35,36,39]]
  ;; q1_1=q1_1[[34,35,36,39]]
  ;; 2000-02-11T23:52:00Z 2000-05-23T17:02:00Z 2000-06-08T09:10:00Z
  ;; 2000-08-11T18:46:00Z

  ;;four random storms from 1998

  ;; this=generate_rands_between_two_values(4,12.,23.,/NO_DUPLICATES,/SORT_PLEASE)
  ;; print,this

  this=[13,14,17,20]

  q1_st=q1_st[this]
  q1_1=q1_1[this]

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  maxInd=6 ;ion_flux_up
  yRange_maxInd=[-300,300]

  rmDupes = 1

  ;;SSC-centered here
  stackplots_storms_nevents_overlaid,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc, $
                                     /USE_DARTDB_START_ENDDATE,TBEFORESTORM=15.,TAFTERSTORM=60., $
                                     MAXIND=maxInd, REMOVE_DUPES=rmDupes, $
                                     YRANGE_MAXIND=yRange_maxInd, $
                                     /JUST_ONE_LABEL, $
                                     SAVEPLOTNAME=savePlotName, $
                                     ;; /DO_SCATTERPLOTS,SCPLOT_COLORLIST=['red','blue','green','purple'], SCATTEROUTPREFIX=scOutPref, $
                                     SCPLOT_COLORLIST=['red','blue','green','purple'], $                                   
                                     OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=logPlots,USE_DATA_MINMAX=use_data_minMax

END