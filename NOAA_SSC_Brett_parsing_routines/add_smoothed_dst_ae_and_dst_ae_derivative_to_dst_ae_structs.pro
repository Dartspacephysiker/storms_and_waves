;2015/10/13
;If this seems unsafe to you, check out journal__20151013__check_for_gaps_in_dst.pro. It's all good.

PRO ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS

  load_dst_ae_dbs,dst,ae,DST_AE_DIR=dst_AE_dir,DST_AE_FILE=dst_AE_file

  ;; smoothedFile= 'idl_ae_dst_data--smoothed.dat'
  smoothedFile= 'idl_ae_dst_data--smoothed_w_deriv.dat'

  ;;Let's smooth Dst first
  dst_smoothed_6hr=SMOOTH(dst.dst,6,/EDGE_TRUNCATE)

  ae_smoothed_6hr=SMOOTH(ae.ae,6,/EDGE_TRUNCATE)
  au_smoothed_6hr=SMOOTH(ae.au,6,/EDGE_TRUNCATE)
  al_smoothed_6hr=SMOOTH(ae.al,6,/EDGE_TRUNCATE)
  ao_smoothed_6hr=SMOOTH(ae.ao,6,/EDGE_TRUNCATE)

  ;;These look good
  ;; dstplot=plot(dst.dst[100:199])  
  ;; dstsmoothplot=plot(dst_smooth6hr[100:199])

  ;; dt_dst_sm6hr = SHIFT(dst_smoothed_6hr,-1)-dst_smoothed_6hr

  ;; dt_ae_sm6hr = SHIFT(ae_smoothed_6hr,-1)-ae_smoothed_6hr
  ;; dt_au_sm6hr = SHIFT(au_smoothed_6hr,-1)-au_smoothed_6hr
  ;; dt_al_sm6hr = SHIFT(al_smoothed_6hr,-1)-al_smoothed_6hr
  ;; dt_ao_sm6hr = SHIFT(ao_smoothed_6hr,-1)-ao_smoothed_6hr

  dt_dst_sm6hr = DERIV(dst_smoothed_6hr)

  dt_ae_sm6hr = DERIV(ae_smoothed_6hr)
  dt_au_sm6hr = DERIV(au_smoothed_6hr)
  dt_al_sm6hr = DERIV(al_smoothed_6hr)
  dt_ao_sm6hr = DERIV(ao_smoothed_6hr)


  ;; dst_sm_str="Smoothing is performed using 6 Dst points, and dt_dst_sm6hr is obtained by simply subtracting one data point from the other, forward-difference style. See the pro ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS to learn more."

  ;; ae_sm_str="Smoothing is performed using 6 {AE,AU,AL,AO} points, and dt_{ae,au,al,ao}_sm6hr is obtained by simply subtracting one data point from the other, forward-difference style. See the pro ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS to learn more."

  dst_sm_str="Smoothing is performed using 6 Dst points, and dt_dst_sm6hr is obtained with the DERIV procedure. See the pro ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS to learn more."

  ae_sm_str="Smoothing is performed using 6 {AE,AU,AL,AO} points, and dt_{ae,au,al,ao}_sm6hr is obtained with the DERIV procedure. See the pro ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS to learn more."


  dst={date:dst.date, $
       time:dst.time, $
       doy:dst.doy, $
       dst:dst.dst, $
       dst_smoothed_6hr:dst_smoothed_6hr, $
       dt_dst_sm6hr:dt_dst_sm6hr, $
       info:dst_sm_str}

  ae={date:ae.date, $
      time:ae.time, $
      doy:ae.doy, $
      ae:ae.ae, $
      au:ae.au, $
      al:ae.al, $
      ao:ae.ao, $
      ae_smoothed_6hr:ae_smoothed_6hr, $
      au_smoothed_6hr:au_smoothed_6hr, $
      al_smoothed_6hr:al_smoothed_6hr, $
      ao_smoothed_6hr:ao_smoothed_6hr, $
      dt_ae_sm6hr:dt_ae_sm6hr, $
      dt_au_sm6hr:dt_au_sm6hr, $
      dt_al_sm6hr:dt_al_sm6hr, $
      dt_ao_sm6hr:dt_ao_sm6hr, $
      info:ae_sm_str}
      

  save,dst,ae,FILENAME=dst_ae_dir+smoothedFile

END