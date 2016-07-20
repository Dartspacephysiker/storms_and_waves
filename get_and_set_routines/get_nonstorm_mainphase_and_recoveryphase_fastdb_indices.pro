;2015/10/14
;2016/01/01 If this has already been done once today, then don't do it again
;2016/01/01 Also output t1 and t2 for each phase, if desired
;2016/04/04 Added DO_DESPUN keyword for fear
PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
   DO_DESPUNDB=do_despunDB, $
   NONSTORM_I=ns_i, $
   MAINPHASE_I=mp_i, $
   RECOVERYPHASE_I=rp_i, $
   DSTCUTOFF=dstCutoff, $
   STORM_DST_I=s_dst_i, $
   NONSTORM_DST_I=ns_dst_i, $
   MAINPHASE_DST_I=mp_dst_i, $
   RECOVERYPHASE_DST_I=rp_dst_i, $
   N_STORM=n_s, $
   N_NONSTORM=n_ns, $
   N_MAINPHASE=n_mp, $
   N_RECOVERYPHASE=n_rp, $
   NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
   NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,LUN=lun,DO_DESPUNDB=do_despunDB

  good_i = ALFVEN_DB_CLEANER(maximus)

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
     DSTCUTOFF=dstCutoff, $
     STORM_DST_I=s_dst_i, $
     NONSTORM_DST_I=ns_dst_i, $
     MAINPHASE_DST_I=mp_dst_i, $
     RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s, $
     N_NONSTORM=n_ns, $
     N_MAINPHASE=n_mp, $
     N_RECOVERYPHASE=n_rp,LUN=lun

  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  strings=["nonstorm","mainphase","recoveryphase"]

  todaysFile = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES(DO_DESPUN=do_despunDB,DSTCUTOFF=dstCutoff)

  IF FILE_TEST(todaysFile) THEN BEGIN
     PRINTF,lun,"Already have nonstorm and storm FAST DB inds! Restoring today's file..."
     RESTORE,todaysFile
  ENDIF ELSE BEGIN
     
     FOR i=0,2 DO BEGIN
        inds=dst_i_list[i]
        help,inds
        GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
        
        ;; OPENW,this,'/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/get_and_set_routines/startstop_'+strings[i],/GET_LUN
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
           ns_i                = inds_list
           ns_t1               = dst.time[inds[start_dst_ii]]
           ns_t2               = dst.time[inds[stop_dst_ii]]
        ENDIF ELSE BEGIN
           IF i EQ 1 THEN BEGIN
              mp_i             = inds_list 
              mp_t1            = dst.time[inds[start_dst_ii]]
              mp_t2            = dst.time[inds[stop_dst_ii]]
           ENDIF ELSE BEGIN
              IF i EQ 2 THEN BEGIN
                 rp_i          = inds_list
                 rp_t1         = dst.time[inds[start_dst_ii]]
                 rp_t2         = dst.time[inds[stop_dst_ii]]
              ENDIF
           ENDELSE
        ENDELSE
        
     ENDFOR

     PRINTF,lun,"Saving FAST nonstorm/storm indices for today..."
     SAVE,ns_i,mp_i,rp_i,s_dst_i,ns_dst_i,mp_dst_i,rp_dst_i, $
          n_s,n_ns,n_mp,n_rp, $
          ns_t1,ns_t2,mp_t1,mp_t2,rp_t1,rp_t2, $
          FILENAME=todaysFile

  ENDELSE

END