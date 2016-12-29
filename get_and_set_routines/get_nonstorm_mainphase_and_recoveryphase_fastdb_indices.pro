;2015/10/14
;2016/01/01 If this has already been done once today, then don't do it again
;2016/01/01 Also output t1 and t2 for each phase, if desired
;2016/04/04 Added DO_DESPUN keyword for fear
PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   GET_TIME_I_NOT_ALFDB_I=get_time_i_not_alfDB_i, $
   GET_ESPECDB_I_NOT_ALFDB_I=get_eSpecdb_i_not_alfDB_i, $
   GET_IONDB_I_NOT_ALFDB_I=get_iondb_i_not_alfDB_i, $
   NONSTORM_I=ns_i, $
   MAINPHASE_I=mp_i, $
   RECOVERYPHASE_I=rp_i, $
   ;; DSTCUTOFF=dstCutoff, $
   ;; SMOOTH_DST=smooth_dst, $
   USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
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
   GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun

  CASE 1 OF
     KEYWORD_SET(get_eSpecdb_i_not_alfDB_i): BEGIN
        @common__newell_espec.pro

        other_guys = alfDB_plot_struct.load_dILAT OR alfDB_plot_struct.load_dAngle OR alfDB_plot_struct.load_dx

        LOAD_NEWELL_ESPEC_DB, $
           UPGOING=alfDB_plot_struct.eSpec__downgoing, $
           FAILCODES=failCode, $
           USE_UNSORTED_FILE=use_unsorted_file, $
           NEWELLDBDIR=NewellDBDir, $
           NEWELLDBFILE=NewellDBFile, $
           FORCE_LOAD_DB=force_load_db, $
           DONT_CONVERT_TO_STRICT_NEWELL=~KEYWORD_SET(alfDB_plot_struct.espec__newell_2009_interp), $
           USE_2000KM_FILE=alfDB_plot_struct.eSpec__use_2000km_file, $
           DONT_MAP_TO_100KM=alfDB_plot_struct.eSpec__noMap, $
           LOAD_DELTA_T=( (KEYWORD_SET(alfDB_plot_struct.do_timeAvg_fluxQuantities) OR $
                           KEYWORD_SET(alfDB_plot_struct.t_probOccurrence) $
                          ) $
                          AND ~other_guys), $
           LOAD_DELTA_ILAT_FOR_WIDTH_TIME=alfDB_plot_struct.load_dILAT, $
           LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=alfDB_plot_struct.load_dAngle, $
           LOAD_DELTA_X_FOR_WIDTH_TIME=alfDB_plot_struct.load_dx, $
           /REDUCED_DB, $
           LUN=lun, $
           QUIET=quiet

        dbString    = 'eSpec DB'
        pdbStruct   = PTR_NEW(NEWELL__eSpec)

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_ESPECDB, $
                      UPGOING_ESPEC=alfDB_plot_struct.eSpec__upgoing, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files)
     END
     KEYWORD_SET(get_iondb_i_not_alfDB_i): BEGIN
        @common__newell_ion_db.pro

        other_guys = alfDB_plot_struct.load_dILAT OR alfDB_plot_struct.load_dAngle OR alfDB_plot_struct.load_dx

        LOAD_NEWELL_ION_DB, $
           DOWNGOING=alfDB_plot_struct.ion__downgoing, $
           NEWELLDBDIR=NewellDBDir, $
           NEWELLDBFILE=NewellDBFile, $
           FORCE_LOAD_DB=force_load_db, $
           DONT_MAP_TO_100KM=alfDB_plot_struct.ion__noMap, $
           LOAD_DELTA_T=( (KEYWORD_SET(alfDB_plot_struct.do_timeAvg_fluxQuantities) OR $
                           KEYWORD_SET(alfDB_plot_struct.t_probOccurrence) $
                          ) $
                          AND ~other_guys), $
           LOAD_DELTA_ILAT_FOR_WIDTH_TIME=alfDB_plot_struct.load_dILAT, $
           LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=alfDB_plot_struct.load_dAngle, $
           LOAD_DELTA_X_FOR_WIDTH_TIME=alfDB_plot_struct.load_dx, $
           LUN=lun, $
           QUIET=quiet

        dbString    = 'ion DB'
        pdbStruct   = PTR_NEW(NEWELL_I__ion)

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_IONDB, $
                      DOWNGOING_ION=alfDB_plot_struct.ion__downgoing, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files)
     END
     KEYWORD_SET(get_time_i_not_alfDB_I): BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           @common__fastloc_espec_vars.pro
        ENDIF ELSE BEGIN
           @common__fastloc_vars.pro
        ENDELSE        

        IF ( KEYWORD_SET(for_eSpec_DBs) AND (N_ELEMENTS(FL_eSpec__fastLoc) EQ 0)) OR $
           (~KEYWORD_SET(for_eSpec_DBs) AND (N_ELEMENTS(FL__fastLoc      ) EQ 0))    $
           THEN BEGIN

           LOAD_FASTLOC_AND_FASTLOC_TIMES, $
              COORDINATE_SYSTEM=MIMC_struct.coordinate_system, $
              USE_AACGM_COORDS=MIMC_struct.use_AACGM, $
              USE_MAG_COORDS=MIMC_struct.use_MAG, $
              FOR_ESPEC_DBS=for_eSpec_DBs, $
              INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
              LUN=lun
        ENDIF

        pdbStruct   = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc)
        pdbTimes    = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times  : FASTLOC__times)

        good_i      = FASTLOC_CLEANER(*pdbStruct, $
                                      FOR_ESPEC_DBS=for_eSpec_DBs, $
                                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                                      INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t)

        dbString    = 'fastLoc'
        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_FASTLOC, $
                      FASTLOC_FOR_ESPEC=for_eSpec_DBs, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files)
     END
     ELSE: BEGIN
        @common__maximus_vars.pro
        IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
           LOAD_MAXIMUS_AND_CDBTIME, $
              CHASTDB=alfDB_plot_struct.chastDB, $
              DESPUNDB=alfDB_plot_struct.despunDB, $
              COORDINATE_SYSTEM=MIMC_struct.coordinate_system, $
              USE_AACGM=MIMC_struct.use_AACGM, $
              USE_MAG_COORDS=MIMC_struct.use_MAG, $
              LUN=lun
        ENDIF

        pdbStruct   = PTR_NEW(MAXIMUS__maximus)
        pdbTimes    = PTR_NEW(MAXIMUS__times)
        dbString    = 'Alfven DB'

        good_i      = ALFVEN_DB_CLEANER( $
                      *pdbstruct, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t)

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_ALFVENDB, $
                      DESPUN_ALFDB=alfDB_plot_struct.despunDB, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files)

     END
  ENDCASE

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
     DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
     SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
     EARLIEST_UTC=IMF_struct.earliest_UTC, $
     LATEST_UTC=IMF_struct.latest_UTC, $
     USE_JULDAY_NOT_UTC=IMF_struct.use_julDay_not_UTC, $
     EARLIEST_JULDAY=IMF_struct.earliest_julDay, $
     LATEST_JULDAY=IMF_struct.latest_julDay, $
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
     PRINTF,lun,"Already have nonstorm and storm " + dbString + $
            " inds! Restoring today's file..."
     RESTORE,todaysFile
  ENDIF ELSE BEGIN
     
     FOR i=0,2 DO BEGIN
        inds=dst_i_list[i]
        help,inds
        GET_STREAKS,inds, $
                    START_I=start_dst_ii, $
                    STOP_I=stop_dst_ii, $
                    SINGLE_I=single_dst_ii
        
        GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
           T1_ARR=dst.time[inds[start_dst_ii]], $
           T2_ARR=dst.time[inds[stop_dst_ii]], $
           FOR_ESPEC_DB=(dbString EQ 'eSpec DB') OR (dbString EQ 'ion DB'), $
           DBSTRUCT=*pdbStruct, $
           DBTIMES=N_ELEMENTS(pdbTimes) GT 0 ? *pdbTimes : !NULL, $
           ;; DBTIMES=*pdbTimes, $
           RESTRICT_W_THESEINDS=good_i, $
           OUT_INDS_LIST=inds_list, $
           UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
           INDS_ORBS_LIST=inds_orbs_list, $
           TRANGES_ORBS_LIST=tranges_orbs_list, $
           TSPANS_ORBS_LIST=tspans_orbs_list, $
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

     PRINTF,lun,"Saving FAST " + dbString + " nonstorm/storm indices for today: " + todaysFile
     SAVE,ns_i,mp_i,rp_i,s_dst_i,ns_dst_i,mp_dst_i,rp_dst_i, $
          n_s,n_ns,n_mp,n_rp, $
          ns_t1,ns_t2,mp_t1,mp_t2,rp_t1,rp_t2, $
          FILENAME=todaysFile

  ENDELSE

END