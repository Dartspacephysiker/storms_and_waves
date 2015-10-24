PRO JOURNAL__20151021__TEST_NONSTORM_MAINPHASE_RECOVERYPHASE_DBPLOTS__ALFSTORM2

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


  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  strings=["nonstorm","mainphase","recoveryphase"]

  FOR i=0,2 DO BEGIN
     inds=dst_i_list[i]
     help,inds
     GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
  
     GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=dst.time[inds[start_dst_ii]],T2_ARR=dst.time[inds[stop_dst_ii]], $
        DBSTRUCT=maximus,DBTIMES=cdbTime, RESTRICT_W_THESEINDS=good_i, $
        OUT_INDS_LIST=inds_list, $
        UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
        INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
        PRINT_DATA_AVAILABILITY=0,VERBOSE=0,/LIST_TO_ARR

     PLOT_ALFVEN_STATS_UTC_RANGES,maximus,T1_ARR=dst.time[inds[start_dst_ii]],T2_ARR=dst.time[inds[stop_dst_ii]],$
                                  /PRINT_DATA_AVAILABILITY, /VERBOSE, _EXTRA = e  
              
  ENDFOR

END