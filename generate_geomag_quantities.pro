PRO GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NSTORMS=nStorms, $
                               USE_SYMH=use_SYMH,USE_AE=use_AE,DST=dst,SW_DATA=sw_data, $
                               GEOMAG_PLOT_I_LIST=geomag_plot_i_list,GEOMAG_DAT_LIST=geomag_dat_list,GEOMAG_TIME_LIST=geomag_time_list, $
                               GEOMAG_MIN=geomag_min,GEOMAG_MAX=geomag_max
 
  IF ~use_SYMH AND ~use_AE THEN BEGIN                                                ;Use DST for plots, not SYM-H
     ;; Now get a list of indices for DST data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(DST.time GE datStartStop(0,0) AND $ ;first initialize the list
                                     DST.time LE datStartStop(0,1)))
     geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
     
     geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))
     
     geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
     geomag_max = MAX(geomag_dat_list(0))
     
     FOR i=1,nStorms-1 DO BEGIN ;Then update it
        geomag_plot_i_list.add,WHERE(DST.time GE datStartStop(i,0) AND $
                                     DST.time LE datStartStop(i,1))
        geomag_dat_list.add,dst.dst(geomag_plot_i_list(i))
        
        geomag_time_list.add,dst.time(geomag_plot_i_list(i))
        
        tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
        IF tempMin LT geomag_min THEN geomag_min=tempMin
        IF tempMax GT geomag_max THEN geomag_max=tempMax
     ENDFOR
  ENDIF ELSE BEGIN              ;Use SYM-H or AE for plots 
     
     swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
     
     ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(swDat_UTC GE datStartStop(0,0) AND $ ;first initialize the list
                                     swDat_UTC LE datStartStop(0,1)))
     geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
     IF use_SYMH THEN BEGIN
        geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
        
        geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))
        
        FOR i=1,nStorms-1 DO BEGIN ;Then update it
           geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(i,0) AND $
                                        swDat_UTC LE datStartStop(i,1))
           geomag_dat_list.add,sw_data.sym_h.dat(geomag_plot_i_list(i))
           
           geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
           
           tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
           IF tempMin LT geomag_min THEN geomag_min=tempMin
           IF tempMax GT geomag_max THEN geomag_max=tempMax
        ENDFOR
     ENDIF ELSE BEGIN
        IF use_AE THEN BEGIN
           geomag_dat_list = LIST(sw_data.ae_index.dat(geomag_plot_i_list(0)))
           
           geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
           geomag_max = MAX(geomag_dat_list(0))
           
           FOR i=1,nStorms-1 DO BEGIN ;Then update it
              geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(i,0) AND $
                                           swDat_UTC LE datStartStop(i,1))
              geomag_dat_list.add,sw_data.ae_index.dat(geomag_plot_i_list(i))
              geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
              
              tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
              IF tempMin LT geomag_min THEN geomag_min=tempMin
              IF tempMax GT geomag_max THEN geomag_max=tempMax
           ENDFOR
        ENDIF
     ENDELSE
  ENDELSE
     
END