;2016/08/19 Now we need OMNI to do it too
PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES, $
   OMNI_COORDS=OMNI_coords, $
   RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_MAG_COORDS=use_MAG, $
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

  COMPILE_OPT idl2

  @common__omni_stability.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun

  PRINTF,lun,'Restoring culled OMNI data to get mag_utc ...'
  dataDir                        = "/SPENCEdata/Research/database/"
  RESTORE,dataDir + "/OMNI/culled_OMNI_magdata.dat"

  OMNI__SELECT_COORDS,Bx, $
                      By_GSE,Bz_GSE,Bt_GSE, $
                      thetaCone_GSE,phiClock_GSE,cone_overClock_GSE,Bxy_over_Bz_GSE, $
                      By_GSM,Bz_GSM,Bt_GSM, $
                      thetaCone_GSM,phiClock_GSM,cone_overClock_GSM,Bxy_over_Bz_GSM, $
                      OMNI_COORDS=OMNI_coords, $
                      LUN=lun

  C_OMNI__clean_i = GET_CLEAN_OMNI_I(C_OMNI__Bx,C_OMNI__By,C_OMNI__Bz, $
                                     LUN=lun)
  C_OMNI__time_i  = GET_OMNI_TIME_I(mag_UTC, $
                                    RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                    LUN=lun)

  good_i   = CGSETINTERSECTION(C_OMNI__clean_i,C_OMNI__time_i,COUNT=nGood)
  IF nGood LE 1 THEN BEGIN
     PRINT,'WHATTTTTTT'
     STOP
  ENDIF

  ;;Cast in the parlance of other routines
  dbTimes  = TEMPORARY(mag_utc)
  dbString = 'OMNI DB'

  todaysFile = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES(DSTCUTOFF=dstCutoff)
  
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

  IF FILE_TEST(todaysFile) THEN BEGIN
     PRINTF,lun,"Already have nonstorm and storm " + dbString + " inds! Restoring today's file..."
     RESTORE,todaysFile
  ENDIF ELSE BEGIN
     
     FOR i=0,2 DO BEGIN
        inds=dst_i_list[i]
        help,inds
        GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
        
        GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
           T1_ARR=dst.time[inds[start_dst_ii]], $
           T2_ARR=dst.time[inds[stop_dst_ii]], $
           DBSTRUCT=dbStruct, $
           DBTIMES=dbTimes, $
           RESTRICT_W_THESEINDS=good_i, $
           /FOR_OMNI_DB, $
           OUT_INDS_LIST=inds_list, $
           PRINT_DATA_AVAILABILITY=0, $
           VERBOSE=0, $
           /LIST_TO_ARR
        
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

     PRINTF,lun,"Saving " + dbString + " nonstorm/storm indices for today..."
     SAVE,ns_i,mp_i,rp_i,s_dst_i,ns_dst_i,mp_dst_i,rp_dst_i, $
          n_s,n_ns,n_mp,n_rp, $
          ns_t1,ns_t2,mp_t1,mp_t2,rp_t1,rp_t2, $
          FILENAME=todaysFile

  ENDELSE

END