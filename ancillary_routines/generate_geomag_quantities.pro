;; THIS is the regexp to find
;; \(     if strlowcase(omni_quantity) eq '\)\([[:alnum:]_]*\)\(' then \)\(.*\)$

;; THIS is the regexp to replace!
;; \1'\2'\3 BEGIN
;; 	badVal = sw_data.\2.fillVal
;; 	\4
;; 	dataTitle = sw_data.\2.fieldNam
;; 	yRange = [sw_data.\2.validMin,sw_data.\2.validMax]
;; ENDIF

;MOD 2015/08/22 Made this thing able to plot anyone we want in the OMNI dataset ... Pretty rad.

PRO GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NEPOCHS=nEpochs, $
                               SW_DATA=sw_data,DST=dst, $
                               USE_SYMH=use_SYMH,USE_AE=use_AE, $
                               OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                               SMOOTHWINDOW=smoothWindow, $
                               GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                               GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max,DO_DST=do_Dst, $
                               YRANGE=yRange,SET_YRANGE=set_yRange,USE_DATA_MINMAX=use_data_minMax, $
                               DATATITLE=dataTitle
 
  COMPILE_OPT idl2

  defUse_data_minMax = 0

  defDo_Dst = 0
  defDstRange = [-300,100] 
  ;; defDstRange = [-120,30] 

  IF N_ELEMENTS(sw_data) EQ 0 THEN BEGIN
     LOAD_OMNI_DB,sw_data,SWDBDIR=swDBDir,SWDBFILE=swDBFile
  ENDIF

  IF N_ELEMENTS(use_data_minMax) EQ 0 THEN use_data_minMax = defUse_data_minMax

  IF N_ELEMENTS(omni_quantity) EQ 0 THEN BEGIN
     IF N_ELEMENTS(do_Dst) EQ 0 THEN do_DST = defDo_Dst
  ENDIF

  IF do_Dst GT 0 THEN BEGIN 
     do_DST = defDo_Dst
     omni_quantity = 'Dst'
     dataTitle = 'Dst (nT)'
     geomag_time_utc = DST.time
     geomag_dat = DST.dst
     yRange = defDstRange
     PRINT,'GENERATE_GEOMAG_QUANTITIES: Using Dst...'
  ENDIF ELSE BEGIN
     ;; geomag_time_utc = (sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
     geomag_time_utc = CDF_EPOCH_TO_UTC(sw_data.epoch.dat) ;For conversion between SW DB and ours
     
     IF STRLOWCASE(omni_quantity) EQ 'imf' THEN BEGIN
        badVal        = sw_data.imf.fillVal
        geomag_dat    = sw_data.imf.dat
        dataTitle     = sw_data.imf.lablAxis + '(' + sw_data.imf.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.imf.validMin,sw_data.imf.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'pls' THEN BEGIN
        badVal        = sw_data.pls.fillVal
        geomag_dat    = sw_data.pls.dat
        dataTitle     = sw_data.pls.lablAxis + '(' + sw_data.pls.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.pls.validMin,sw_data.pls.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'imf_pts' THEN BEGIN
        badVal        = sw_data.imf_pts.fillVal
        geomag_dat    = sw_data.imf_pts.dat
        dataTitle     = sw_data.imf_pts.lablAxis + '(' + sw_data.imf_pts.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.imf_pts.validMin,sw_data.imf_pts.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'pls_pts' THEN BEGIN
        badVal        = sw_data.pls_pts.fillVal
        geomag_dat    = sw_data.pls_pts.dat
        dataTitle     = sw_data.pls_pts.lablAxis + '(' + sw_data.pls_pts.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.pls_pts.validMin,sw_data.pls_pts.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'percent_interp' THEN BEGIN
        badVal        = sw_data.percent_interp.fillVal
        geomag_dat    = sw_data.percent_interp.dat
        dataTitle     = sw_data.percent_interp.lablAxis + '(' + sw_data.percent_interp.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.percent_interp.validMin,sw_data.percent_interp.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'timeshift' THEN BEGIN
        badVal        = sw_data.timeshift.fillVal
        geomag_dat    = sw_data.timeshift.dat
        dataTitle     = sw_data.timeshift.lablAxis + '(' + sw_data.timeshift.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.timeshift.validMin,sw_data.timeshift.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'rms_timeshift' THEN BEGIN
        badVal        = sw_data.rms_timeshift.fillVal
        geomag_dat    = sw_data.rms_timeshift.dat
        dataTitle     = sw_data.rms_timeshift.lablAxis + '(' + sw_data.rms_timeshift.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.rms_timeshift.validMin,sw_data.rms_timeshift.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'rms_phase' THEN BEGIN
        badVal        = sw_data.rms_phase.fillVal
        geomag_dat    = sw_data.rms_phase.dat
        dataTitle     = sw_data.rms_phase.lablAxis + '(' + sw_data.rms_phase.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.rms_phase.validMin,sw_data.rms_phase.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'time_btwn_obs' THEN BEGIN
        badVal        = sw_data.time_btwn_obs.fillVal
        geomag_dat    = sw_data.time_btwn_obs.dat
        dataTitle     = sw_data.time_btwn_obs.lablAxis + '(' + sw_data.time_btwn_obs.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.time_btwn_obs.validMin,sw_data.time_btwn_obs.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'f' THEN BEGIN
        badVal        = sw_data.f.fillVal
        geomag_dat    = sw_data.f.dat
        dataTitle     = sw_data.f.lablAxis + '(' + sw_data.f.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.f.validMin,sw_data.f.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'bx_gse' THEN BEGIN
        badVal        = sw_data.bx_gse.fillVal
        geomag_dat    = sw_data.bx_gse.dat
        dataTitle     = sw_data.bx_gse.lablAxis + '(' + sw_data.bx_gse.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bx_gse.validMin,sw_data.bx_gse.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'by_gse' THEN BEGIN
        badVal        = sw_data.by_gse.fillVal
        geomag_dat    = sw_data.by_gse.dat
        dataTitle     = sw_data.by_gse.lablAxis + '(' + sw_data.by_gse.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.by_gse.validMin,sw_data.by_gse.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'bz_gse' THEN BEGIN
	badVal        = sw_data.bz_gse.fillVal
        geomag_dat    = sw_data.bz_gse.dat
        dataTitle     = sw_data.bz_gse.lablAxis + '(' + sw_data.bz_gse.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bz_gse.validMin,sw_data.bz_gse.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'by_gsm' THEN BEGIN
        badVal        = sw_data.by_gsm.fillVal
        geomag_dat    = sw_data.by_gsm.dat
        dataTitle     = sw_data.by_gsm.lablAxis + '(' + sw_data.by_gsm.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.by_gsm.validMin,sw_data.by_gsm.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'bz_gsm' THEN BEGIN
        badVal        = sw_data.bz_gsm.fillVal
        geomag_dat    = sw_data.bz_gsm.dat
        dataTitle     = sw_data.bz_gsm.lablAxis + '(' + sw_data.bz_gsm.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bz_gsm.validMin,sw_data.bz_gsm.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'rms_sd_b' THEN BEGIN
        badVal        = sw_data.rms_sd_b.fillVal
        geomag_dat    = sw_data.rms_sd_b.dat
        dataTitle     = sw_data.rms_sd_b.lablAxis + '(' + sw_data.rms_sd_b.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.rms_sd_b.validMin,sw_data.rms_sd_b.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'flow_speed' THEN BEGIN
        badVal        = 99999.8984375
        geomag_dat    = sw_data.flow_speed.dat
        dataTitle     = 'Flow Speed (km/s), GSE'
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'vx' THEN BEGIN
        badVal        = sw_data.vx.fillVal
        geomag_dat    = sw_data.vx.dat
        dataTitle     = sw_data.vx.lablAxis + '(' + sw_data.vx.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.vx.validMin,sw_data.vx.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'vy' THEN BEGIN
        badVal        = sw_data.vy.fillVal
        geomag_dat    = sw_data.vy.dat
        dataTitle     = sw_data.vy.lablAxis + '(' + sw_data.vy.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.vy.validMin,sw_data.vy.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'vz' THEN BEGIN
        badVal        = sw_data.vz.fillVal
        geomag_dat    = sw_data.vz.dat
        dataTitle     = sw_data.vz.lablAxis + '(' + sw_data.vz.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.vz.validMin,sw_data.vz.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'proton_density' THEN BEGIN
        badVal        = sw_data.proton_density.fillVal
        geomag_dat    = sw_data.proton_density.dat
        dataTitle     = sw_data.proton_density.lablAxis + '(' + sw_data.proton_density.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.proton_density.validMin,sw_data.proton_density.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 't' THEN BEGIN
        badVal        = sw_data.t.fillVal
        geomag_dat    = sw_data.t.dat
        dataTitle     = sw_data.t.lablAxis + '(' + sw_data.t.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.t.validMin,sw_data.t.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'pressure' THEN BEGIN
        badVal        = sw_data.pressure.fillVal
        geomag_dat    = sw_data.pressure.dat
        dataTitle     = sw_data.pressure.lablAxis + '(' + sw_data.pressure.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.pressure.validMin,sw_data.pressure.validMax]
     ENDIF
     ;; IF STRLOWCASE(omni_quantity) EQ 'pressure' THEN BEGIN
     ;;    badVal     = 99.9900
     ;;    geomag_dat = sw_data.pressure.dat
     ;;    dataTitle  = 'Flow pressure (nPa)'
     ;; ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'e' THEN BEGIN
        badVal        = sw_data.e.fillVal
        geomag_dat    = sw_data.e.dat
        dataTitle     = sw_data.e.lablAxis + '(' + sw_data.e.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.e.validMin,sw_data.e.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'beta' THEN BEGIN
        badVal        = sw_data.beta.fillVal
        geomag_dat    = sw_data.beta.dat
        dataTitle     = sw_data.beta.lablAxis + '(' + sw_data.beta.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.beta.validMin,sw_data.beta.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'mach_num' THEN BEGIN
        badVal        = sw_data.mach_num.fillVal
        geomag_dat    = sw_data.mach_num.dat
        dataTitle     = sw_data.mach_num.lablAxis + '(' + sw_data.mach_num.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.mach_num.validMin,sw_data.mach_num.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'mgs_mach_num' THEN BEGIN
        badVal        = sw_data.mgs_mach_num.fillVal
        geomag_dat    = sw_data.mgs_mach_num.dat
        dataTitle     = sw_data.mgs_mach_num.lablAxis + '(' + sw_data.mgs_mach_num.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.mgs_mach_num.validMin,sw_data.mgs_mach_num.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'bsn_x' THEN BEGIN
        badVal        = sw_data.bsn_x.fillVal
        geomag_dat    = sw_data.bsn_x.dat
        dataTitle     = sw_data.bsn_x.lablAxis + '(' + sw_data.bsn_x.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bsn_x.validMin,sw_data.bsn_x.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'bsn_y' THEN BEGIN
        badVal        = sw_data.bsn_y.fillVal
        geomag_dat    = sw_data.bsn_y.dat
        dataTitle     = sw_data.bsn_y.lablAxis + '(' + sw_data.bsn_y.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bsn_y.validMin,sw_data.bsn_y.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'bsn_z' THEN BEGIN
        badVal        = sw_data.bsn_z.fillVal
        geomag_dat    = sw_data.bsn_z.dat
        dataTitle     = sw_data.bsn_z.lablAxis + '(' + sw_data.bsn_z.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.bsn_z.validMin,sw_data.bsn_z.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'ae_index' THEN BEGIN
        badVal        = sw_data.ae_index.fillVal
        geomag_dat    = sw_data.ae_index.dat
        dataTitle     = sw_data.ae_index.lablAxis + '(' + sw_data.ae_index.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.ae_index.validMin,sw_data.ae_index.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'al_index' THEN BEGIN
        badVal        = sw_data.al_index.fillVal
        geomag_dat    = sw_data.al_index.dat
        dataTitle     = sw_data.al_index.lablAxis + '(' + sw_data.al_index.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.al_index.validMin,sw_data.al_index.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'au_index' THEN BEGIN
        badVal        = sw_data.au_index.fillVal
        geomag_dat    = sw_data.au_index.dat
        dataTitle     = sw_data.au_index.lablAxis + '(' + sw_data.au_index.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.au_index.validMin,sw_data.au_index.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'sym_d' THEN BEGIN
        badVal        = sw_data.sym_d.fillVal
        geomag_dat    = sw_data.sym_d.dat
        dataTitle     = sw_data.sym_d.lablAxis + '(' + sw_data.sym_d.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.sym_d.validMin,sw_data.sym_d.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'sym_h' THEN BEGIN
        badVal        = sw_data.sym_h.fillVal
        geomag_dat    = sw_data.sym_h.dat
        dataTitle     = sw_data.sym_h.lablAxis + '(' + sw_data.sym_h.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.sym_h.validMin,sw_data.sym_h.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'asy_d' THEN BEGIN
        badVal        = sw_data.asy_d.fillVal
        geomag_dat    = sw_data.asy_d.dat
        dataTitle     = sw_data.asy_d.lablAxis + '(' + sw_data.asy_d.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.asy_d.validMin,sw_data.asy_d.validMax]
     ENDIF
     IF STRLOWCASE(omni_quantity) EQ 'asy_h' THEN BEGIN
        badVal        = sw_data.asy_h.fillVal
        geomag_dat    = sw_data.asy_h.dat
        dataTitle     = sw_data.asy_h.lablAxis + '(' + sw_data.asy_h.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.asy_h.validMin,sw_data.asy_h.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'pc_n_index' THEN BEGIN
        badVal        = sw_data.pc_n_index.fillVal
        geomag_dat    = sw_data.pc_n_index.dat
        dataTitle     = sw_data.pc_n_index.lablAxis + '(' + sw_data.pc_n_index.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.pc_n_index.validMin,sw_data.pc_n_index.validMax]
     ENDIF
     ;; IF STRLOWCASE(omni_quantity) EQ 'pc_n_index' THEN BEGIN
     ;;    badVal     = 999.990
     ;;    geomag_dat = sw_data.pc_n_index.dat
     ;;    yRange     = KEYWORD_SET(yRange) ? yRange : [-5.0,25.0]
     ;;    dataTitle  = 'PC(N) Index'
     ;; ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'epoch' THEN BEGIN
        badVal        = sw_data.epoch.fillVal
        geomag_dat    = sw_data.epoch.dat
        dataTitle     = sw_data.epoch.lablAxis + '(' + sw_data.epoch.units + ')'
        yRange        = KEYWORD_SET(yRange) ? yRange : [sw_data.epoch.validMin,sw_data.epoch.validMax]
     ENDIF
     
     IF STRLOWCASE(omni_quantity) EQ 'ssn' THEN BEGIN
        LOAD_SSN_DB,ssn
        badVal        = -1
        DO_alt_badval = 1
        geomag_dat    = ssn.ssn
        geomag_time_utc = ssn.time
        dataTitle     = 'Sunspot number'
        yRange        = KEYWORD_SET(yRange) ? yRange : [0,250]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'tiltangle' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.angle
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Dipole Tilt Angle (degrees)'
        yRange        = KEYWORD_SET(yRange) ? yRange : [-27,20.2]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_gsm__z' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[2,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Z comp. (GSM) of Northern Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [0.8,1.0]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_gsm__z' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[2,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Z comp. (GSM) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-1.0,0.8]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_geo__z' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[2,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Z comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [0.8,1.0]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_geo__z' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[2,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Z comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [0.8,1.0]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_gsm__x' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[0,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'X comp. (GSM) of Northern Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.45,0.35]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_gsm__x' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[0,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'X comp. (GSM) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.35,0.45]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_geo__x' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[0,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'X comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.1,0.1]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_geo__x' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[0,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'X comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.1,0.1]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_gsm__y' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[1,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Y comp. (GSM) of Northern Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [0.8,1.0]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_gsm__y' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GSM[1,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Y comp. (GSM) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-1.0,0.8]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_n_geo__y' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[1,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Y comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.2,0.2]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'cusploc_s_geo__y' THEN BEGIN
        LOAD_tiltAngle_DB,tiltAngle
        geomag_dat    = tiltAngle.cusploc_n_GEO[1,*]
        geomag_time_utc = tiltAngle.time
        dataTitle     = 'Y comp. (GEO) of South Cusp '
        yRange        = KEYWORD_SET(yRange) ? yRange : [-0.2,0.2]
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'dst' THEN BEGIN
        LOAD_DST_AE_DBS,dst
        ;; do_DST        = 0
        omni_quantity = 'Dst'
        dataTitle     = 'Dst (nT)'
        geomag_time_utc = DST.time
        geomag_dat    = DST.dst
        yRange        = KEYWORD_SET(yRange) ? yRange : defDstRange
        PRINT,'GENERATE_GEOMAG_QUANTITIES: Using Dst...'
     ENDIF

     ;;Smooth, if requested
     IF KEYWORD_SET(smoothWindow) THEN BEGIN
        PRINT,'Smoothing ' + omni_quantity + ' with ' + STRCOMPRESS(smoothWindow,/REMOVE_ALL) + '-min window ...'
        CASE SIZE(geomag_dat,/TYPE) OF 
           2 OR 3: BEGIN
              geomag_dat  = SMOOTH(geomag_dat,smoothWindow,/EDGE_TRUNCATE,MISSING=badVal)
           END
           4: BEGIN
              badInds    = WHERE(ABS(geomag_dat-badVal) LE 0.1)
              geomag_dat[badInds] = !VALUES.F_NaN
              geomag_dat  = SMOOTH(geomag_dat,smoothWindow,/EDGE_TRUNCATE,/NAN)
           END
           5: BEGIN
              badInds    = WHERE(ABS(geomag_dat-badVal) LE 0.01)
              geomag_dat[badInds] = !VALUES.D_NaN
              geomag_dat  = SMOOTH(geomag_dat,smoothWindow,/EDGE_TRUNCATE,/NAN)
           END
        ENDCASE
     ENDIF
     
     ;;Junk the bad
     IF N_ELEMENTS(badVal) NE 0 THEN BEGIN
        IF KEYWORD_SET(do_alt_badval) THEN BEGIN
           goodInd=WHERE(geomag_dat NE badVal,nGood,NCOMPLEMENT=nBad)
        ENDIF ELSE BEGIN
           goodInd=WHERE(geomag_dat LT badVal,nGood,NCOMPLEMENT=nBad)
        ENDELSE
        PRINT,'Removing ' + STRCOMPRESS(nBad,/REMOVE_ALL) + ' bad data points from ' + omni_quantity + '...'
        PRINT,'Keeping ' + STRCOMPRESS(nGood,/REMOVE_ALL) + " good'ns points from " + omni_quantity + '...'
        geomag_dat = geomag_dat[goodInd]
        geomag_time_utc = geomag_time_utc[goodInd]
     ENDIF
     
  ENDELSE
  
  ;get anything?
  IF geoMag_dat EQ !NULL THEN BEGIN
     PRINT,"No quantity specified or identified!"
     PRINT,"omni_quantity : " + omni_quantity
     PRINT,''
     PRINT,'Here they are:'
     PRINT,"IMF"
     PRINT,"PLS"
     PRINT,"IMF_PTS"
     PRINT,"PLS_PTS"
     PRINT,"PERCENT_INTERP"
     PRINT,"TIMESHIFT"
     PRINT,"RMS_TIMESHIFT"
     PRINT,"RMS_PHASE"
     PRINT,"TIME_BTWN_OBS"
     PRINT,"F"
     PRINT,"BX_GSE"
     PRINT,"BY_GSE"
     PRINT,"BZ_GSE"
     PRINT,"BY_GSM"
     PRINT,"BZ_GSM"
     PRINT,"RMS_SD_B"
     PRINT,"FLOW_SPEED"
     PRINT,"VX"
     PRINT,"VY"
     PRINT,""
     PRINT,"VZ"
     PRINT,"PROTON_DENSITY"
     PRINT,"T"
     PRINT,"PRESSURE"
     PRINT,"E"
     PRINT,"BETA"
     PRINT,"MACH_NUM"
     PRINT,"MGS_MACH_NUM"
     PRINT,"BSN_X"
     PRINT,"BSN_Y"
     PRINT,"BSN_Z"
     PRINT,"AE_INDEX"
     PRINT,"AL_INDEX"
     PRINT,"AU_INDEX"
     PRINT,"SYM_D"
     PRINT,"SYM_H"
     PRINT,"ASY_D"
     PRINT,"ASY_H"
     PRINT,"PC_N_INDEX"
     PRINT,"EPOCH"
     PRINT,"SSN"
     PRINT,"TILTANGLE"
     PRINT,"DST"
     PRINT,'Returning...'
     RETURN
  ENDIF ELSE BEGIN
     PRINT,'GENERATE_GEOMAG_QUANTITIES: Using ' + omni_quantity + '...'
  ENDELSE

  IF KEYWORD_SET(log_omni_quantity) THEN BEGIN
     goodDat_i = WHERE(geomag_dat NE 0 AND FINITE(geomag_dat),COMPLEMENT=badDat_i,NCOMPLEMENT=nBad)

     PRINT,"Logging OMNI data!"
     PRINT,"Losing " + STRCOMPRESS(nBad,/REMOVE_ALL) + " unloggable points..."
     geomag_dat           = ALOG10(geomag_dat[goodDat_i])
     geomag_time_utc      = geomag_time_utc[goodDat_i]
     IF N_ELEMENTS(yRange) EQ 2 THEN BEGIN
        logme             = WHERE(ABS(yRange) GT 0.0,COMPLEMENT=dontlogme)
        yRange[logMe]     = ALOG10(yRange[logme])
        yRange[dontLogMe] = -5.
        ENDIF
  ENDIF
     
  ;; Now get a list of indices for OMNI data to be plotted for the epoch start/stop times in datStartStop
  geomag_plot_i_list = LIST(WHERE(geomag_time_utc GE datStartStop[0,0] AND $ ;first initialize the list
                                  geomag_time_utc LE datStartStop[0,1]))
  geomag_time_list   = LIST(geomag_time_utc[geomag_plot_i_list[0]])

  geomag_dat_list    = LIST(geomag_dat[geomag_plot_i_list[0]])
  
  IF N_ELEMENTS(geomag_min) EQ 0 THEN geomag_min = MIN(geomag_dat_list[0]) ;For plots, we need the range
  IF N_ELEMENTS(geomag_max) EQ 0 THEN geomag_max = MAX(geomag_dat_list[0])
  
  FOR i=1,nEpochs-1 DO BEGIN    ;Then update it
     geomag_plot_i_list.add,WHERE(geomag_time_utc GE datStartStop[i,0] AND $
                                  geomag_time_utc LE datStartStop[i,1])
     geomag_dat_list.add,geomag_dat[geomag_plot_i_list[i]]
     
     geomag_time_list.add,geomag_time_utc[geomag_plot_i_list[i]]
     
     tempMin = MIN(geomag_dat_list[i],MAX=tempMax)
     IF tempMin LT geomag_min THEN geomag_min=tempMin
     IF tempMax GT geomag_max THEN geomag_max=tempMax
  ENDFOR

  IF KEYWORD_SET(set_yRange) AND ( N_ELEMENTS(yRange) EQ 0 OR KEYWORD_SET(use_data_minMax) ) THEN yRange = [geomag_min,geomag_max]
  IF N_ELEMENTS(dataTitle) EQ 0 THEN dataTitle = omni_quantity

END