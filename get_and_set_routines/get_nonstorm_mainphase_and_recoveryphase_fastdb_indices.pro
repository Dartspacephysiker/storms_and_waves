;2015/10/14

PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES,NONSTORM_I=ns_i,MAINPHASE_I=mp_i,RECOVERYPHASE_I=rp_i, $
   STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
   N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  LOAD_DST_AE_DBS,dst,ae
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime

  good_i=alfven_db_cleaner(maximus)

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  strings=["nonstorm","mainphase","recoveryphase"]

  FOR i=0,2 DO BEGIN
     inds=dst_i_list[i]
     help,inds
     GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
  
     ;; OPENW,this,'/SPENCEdata/Research/Cusp/storms_Alfvens/get_and_set_routines/startstop_'+strings[i],/GET_LUN
     ;; FOR j=0,N_ELEMENTS(start_dst_ii)-1 DO BEGIN
     ;;    printf,this,FORMAT='(I10,T15,I10)',inds[start_dst_ii[j]],inds[stop_dst_ii[j]]
     ;; ENDFOR
     ;; CLOSE,this

     GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=dst.time[inds[start_dst_ii]],T2_ARR=dst.time[inds[stop_dst_ii]], $
        DBSTRUCT=maximus,DBTIMES=cdbTime, RESTRICT_W_THESEINDS=good_i, $
        OUT_INDS_LIST=inds_list, $
        UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
        INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
        PRINT_DATA_AVAILABILITY=0,VERBOSE=0,/LIST_TO_ARR

     IF i EQ 0 THEN BEGIN
        ns_i = inds_list
     ENDIF ELSE BEGIN
        IF i EQ 1 THEN BEGIN
           mp_i = inds_list 
        ENDIF ELSE BEGIN
           IF i EQ 2 THEN BEGIN
              rp_i = inds_list
           ENDIF
        ENDELSE
     ENDELSE
              
  ENDFOR

END