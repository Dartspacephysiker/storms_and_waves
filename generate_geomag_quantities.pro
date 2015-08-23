;MOD 2015/08/22 Made this thing able to plot anyone we want in the OMNI dataset ... Pretty rad.

PRO GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NSTORMS=nStorms, $
                               SW_DATA=sw_data,DST=dst, $
                               USE_SYMH=use_SYMH,USE_AE=use_AE, $
                               OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                               GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                               GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max,DO_DST=do_Dst,YRANGE=yRange,SET_YRANGE=set_yRange
 
  defDo_Dst = 0
  defDstRange = [-150,50] 

  IF N_ELEMENTS(do_Dst) EQ 0 THEN do_DST = defDo_Dst

  IF do_Dst GT 0 THEN BEGIN do_DST = defDo_Dst
     geomag_time_utc = DST.time
     geomag_dat = DST.dst
     yRange = defDstRange
     PRINT,'GENERATE_GEOMAG_QUANTITIES: Using Dst...'
  ENDIF ELSE BEGIN
     geomag_time_utc = (sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
     
     IF STRLOWCASE(omni_quantity) EQ 'imf' THEN geomag_dat = sw_data.imf.dat

     IF STRLOWCASE(omni_quantity) EQ 'pls' THEN geomag_dat = sw_data.pls.dat
     IF STRLOWCASE(omni_quantity) EQ 'imf_pts' THEN geomag_dat = sw_data.imf_pts.dat
     IF STRLOWCASE(omni_quantity) EQ 'pls_pts' THEN geomag_dat = sw_data.pls_pts.dat

     IF STRLOWCASE(omni_quantity) EQ 'percent_interp' THEN geomag_dat = sw_data.percent_interp.dat
     IF STRLOWCASE(omni_quantity) EQ 'timeshift' THEN geomag_dat = sw_data.timeshift.dat
     IF STRLOWCASE(omni_quantity) EQ 'rms_timeshift' THEN geomag_dat = sw_data.rms_timeshift.dat
     IF STRLOWCASE(omni_quantity) EQ 'rms_phase' THEN geomag_dat = sw_data.rms_phase.dat
     IF STRLOWCASE(omni_quantity) EQ 'time_btwn_obs' THEN geomag_dat = sw_data.time_btwn_obs.dat

     IF STRLOWCASE(omni_quantity) EQ 'f' THEN geomag_dat = sw_data.f.dat

     IF STRLOWCASE(omni_quantity) EQ 'bx_gse' THEN geomag_dat = sw_data.bx_gse.dat
     IF STRLOWCASE(omni_quantity) EQ 'by_gse' THEN geomag_dat = sw_data.by_gse.dat
     IF STRLOWCASE(omni_quantity) EQ 'bz_gse' THEN geomag_dat = sw_data.bz_gse.dat
     IF STRLOWCASE(omni_quantity) EQ 'by_gsm' THEN geomag_dat = sw_data.by_gsm.dat
     IF STRLOWCASE(omni_quantity) EQ 'bz_gsm' THEN geomag_dat = sw_data.bz_gsm.dat
     IF STRLOWCASE(omni_quantity) EQ 'rms_sd_b' THEN geomag_dat = sw_data.rms_sd_b.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'flow_speed' THEN BEGIN
        badVal = 99999.8984375
        geomag_dat = sw_data.flow_speed.dat
     ENDIF

     IF STRLOWCASE(omni_quantity) EQ 'vx' THEN geomag_dat = sw_data.vx.dat
     IF STRLOWCASE(omni_quantity) EQ 'vy' THEN geomag_dat = sw_data.vy.dat
     IF STRLOWCASE(omni_quantity) EQ 'vz' THEN geomag_dat = sw_data.vz.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'proton_density' THEN geomag_dat = sw_data.proton_density.dat
     IF STRLOWCASE(omni_quantity) EQ 't' THEN geomag_dat = sw_data.t.dat
     IF STRLOWCASE(omni_quantity) EQ 'pressure' THEN geomag_dat = sw_data.pressure.dat
     IF STRLOWCASE(omni_quantity) EQ 'e' THEN geomag_dat = sw_data.e.dat
     IF STRLOWCASE(omni_quantity) EQ 'beta' THEN geomag_dat = sw_data.beta.dat
     IF STRLOWCASE(omni_quantity) EQ 'mach_num' THEN geomag_dat = sw_data.mach_num.dat
     IF STRLOWCASE(omni_quantity) EQ 'mgs_mach_num' THEN geomag_dat = sw_data.mgs_mach_num.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'bsn_x' THEN geomag_dat = sw_data.bsn_x.dat
     IF STRLOWCASE(omni_quantity) EQ 'bsn_y' THEN geomag_dat = sw_data.bsn_y.dat
     IF STRLOWCASE(omni_quantity) EQ 'bsn_z' THEN geomag_dat = sw_data.bsn_z.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'ae_index' THEN geomag_dat = sw_data.ae_index.dat
     IF STRLOWCASE(omni_quantity) EQ 'al_index' THEN geomag_dat = sw_data.al_index.dat
     IF STRLOWCASE(omni_quantity) EQ 'au_index' THEN geomag_dat = sw_data.au_index.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'sym_d' THEN geomag_dat = sw_data.sym_d.dat
     IF STRLOWCASE(omni_quantity) EQ 'sym_h' THEN geomag_dat = sw_data.sym_h.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'asy_d' THEN geomag_dat = sw_data.asy_d.dat
     IF STRLOWCASE(omni_quantity) EQ 'asy_h' THEN geomag_dat = sw_data.asy_h.dat
     
     IF STRLOWCASE(omni_quantity) EQ 'pc_n_index' THEN geomag_dat = sw_data.pc_n_index.dat
     IF STRLOWCASE(omni_quantity) EQ 'epoch' THEN geomag_dat = sw_data.epoch.dat

     IF N_ELEMENTS(badVal) NE 0 THEN BEGIN
        goodInd=WHERE(geomag_dat LT badVal,nGood,NCOMPLEMENT=nBad)
        PRINT,'Removing ' + STRCOMPRESS(nBad,/REMOVE_ALL) + ' bad data points from ' + omni_quantity + '...'
        PRINT,'Keeping ' + STRCOMPRESS(nGood,/REMOVE_ALL) + " good'ns points from " + omni_quantity + '...'
        geomag_dat = geomag_dat(goodInd)
        geomag_time_utc = geomag_time_utc(goodInd)
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
     PRINT,'Returning...'
     RETURN
  ENDIF ELSE BEGIN
     PRINT,'GENERATE_GEOMAG_QUANTITIES: Using ' + omni_quantity + '...'
  ENDELSE

  IF log_omni_quantity THEN BEGIN
     geomag_dat = ALOG10(geomag_dat)
     IF N_ELEMENTS(yRange) EQ 2 THEN yRange = ALOG10(yRange)
  ENDIF

     
  ;; Now get a list of indices for OMNI data to be plotted for the storm start/stop times in datStartStop
  geomag_plot_i_list = LIST(WHERE(geomag_time_utc GE datStartStop(0,0) AND $ ;first initialize the list
                                  geomag_time_utc LE datStartStop(0,1)))
  geomag_time_list = LIST(geomag_time_utc(geomag_plot_i_list(0)))

  geomag_dat_list = LIST(geomag_dat(geomag_plot_i_list(0)))
  
  geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
  geomag_max = MAX(geomag_dat_list(0))
  
  FOR i=1,nStorms-1 DO BEGIN    ;Then update it
     geomag_plot_i_list.add,WHERE(geomag_time_utc GE datStartStop(i,0) AND $
                                  geomag_time_utc LE datStartStop(i,1))
     geomag_dat_list.add,geomag_dat(geomag_plot_i_list(i))
     
     geomag_time_list.add,geomag_time_utc(geomag_plot_i_list(i))
     
     tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
     IF tempMin LT geomag_min THEN geomag_min=tempMin
     IF tempMax GT geomag_max THEN geomag_max=tempMax
  ENDFOR

  IF KEYWORD_SET(set_yRange) AND N_ELEMENTS(yRange) EQ 0 THEN yRange = [geomag_min,geomag_max]

END