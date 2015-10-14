PRO JOURNAL__20151014__CHECK_THAT_NONSTORM_MAINPHASE_RECOVERYPHASE_IDENTIFICATION_IS_OK__ALFSTORM2

  LOAD_DST_AE_DBS,dst,ae

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_I=s_i,NONSTORM_I=ns_i,MAINPHASE_I=mp_i,RECOVERYPHASE_I=rp_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  GET_STREAKS,mp_i,START_I=start_ii,STOP_I=stop_ii,SINGLE_I=single_i

  PRINT,WHERE((stop_ii-start_ii) GT 10)

  ;;looks like 192 is a good one
  lucky_iii=192
   
  PRINT,time_to_str(dst.time[mp_i[start_i[lucky_iii]]]),time_to_str(dst.time[mp_i[stop_i[lucky_iii]]])

  plot,dst.dst[mp_i[start_i[lucky_iii]]:mp_i[stop_i[lucky_iii]]]
  plot,dst.dst_smoothed_6hr[mp_i[start_i[lucky_iii]]:mp_i[stop_i[lucky_iii]]]
  plot,dst.dt_dst_sm6hr[mp_i[start_i[lucky_iii]]:mp_i[stop_i[lucky_iii]]]

END