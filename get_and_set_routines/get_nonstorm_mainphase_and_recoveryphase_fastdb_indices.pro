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
   GET_SWAY_I_NOT_ALFDB_I=get_sWay_i_not_alfDB_i, $
   NONSTORM_I=ns_i, $
   MAINPHASE_I=mp_i, $
   RECOVERYPHASE_I=rp_i, $
   INITIALPHASE_I=init_i, $
   ;; DSTCUTOFF=dstCutoff, $
   ;; SMOOTH_DST=smooth_dst, $
   USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
   USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
   STORM_DST_I=s_dst_i, $
   NONSTORM_DST_I=ns_dst_i, $
   MAINPHASE_DST_I=mp_dst_i, $
   RECOVERYPHASE_DST_I=rp_dst_i, $
   INITIALPHASE_DST_I=init_dst_i, $
   N_STORM=n_s, $
   N_NONSTORM=n_ns, $
   N_MAINPHASE=n_mp, $
   N_RECOVERYPHASE=n_rp, $
   N_INITIALPHASE=n_init, $
   N_EARLYMAINPHASE=n_earlyMP, $
   N_EARLYRECOVERYPHASE=n_earlyRP, $
   N_LATEMAINPHASE=n_lateMP, $
   N_LATERECOVERYPHASE=n_lateRP, $
   NONSTORM_T1=ns_t1, $
   INITIALPHASE_T1=init_t1, $
   MAINPHASE_T1=mp_t1, $
   RECOVERYPHASE_T1=rp_t1, $
   EARLYMAINPHASE_T1=earlyMP_t1, $
   EARLYRECOVERYPHASE_T1=earlyRP_t1, $
   LATEMAINPHASE_T1=lateMP_t1, $
   LATERECOVERYPHASE_T1=lateRP_t1, $
   NONSTORM_T2=ns_t2, $
   INITIALPHASE_T2=init_t2, $
   MAINPHASE_T2=mp_t2, $
   RECOVERYPHASE_T2=rp_t2, $
   EARLYMAINPHASE_T2=earlyMP_t2, $
   EARLYRECOVERYPHASE_T2=earlyRP_t2, $
   LATEMAINPHASE_T2=lateMP_t2, $
   LATERECOVERYPHASE_T2=lateRP_t2, $
   GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun

  CASE 1 OF
     KEYWORD_SET(get_eSpecdb_i_not_alfDB_i): BEGIN
        @common__newell_espec.pro

        other_guys = alfDB_plot_struct.load_dILAT OR alfDB_plot_struct.load_dAngle OR alfDB_plot_struct.load_dx

        LOAD_NEWELL_ESPEC_DB, $
           UPGOING=alfDB_plot_struct.eSpec__upgoing, $
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
        pDBStruct   = PTR_NEW(TEMPORARY(NEWELL__eSpec))

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_ESPECDB, $
                      UPGOING_ESPEC=alfDB_plot_struct.eSpec__upgoing, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files, $
                      USE_KATUS_STORM_PHASES=alfDB_plot_struct.storm_opt.use_katus_storm_phases)
     END
     KEYWORD_SET(get_sWay_i_not_alfDB_i): BEGIN
        @common__strangeway_bands.pro

        other_guys = alfDB_plot_struct.load_dILAT OR alfDB_plot_struct.load_dAngle OR alfDB_plot_struct.load_dx

        LOAD_STRANGEWAY_BANDS_PFLUX_DB,leMaitre,times, $
                                   DBDir=DBDir, $
                                   DBFile=DBFile, $
                                   USE_8HZ_DB=alfDB_plot_struct.sWay_use_8Hz_DB, $
                                   ;; DB_TFILE=DB_tFile, $
                                   CORRECT_FLUXES=correct_fluxes, $
                                   DO_NOT_MAP_PFLUX=do_not_map_pflux, $
                                   DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
                                   DO_NOT_MAP_ANYTHING=no_mapping, $
                                   COORDINATE_SYSTEM=coordinate_system, $
                                   USE_LNG=use_lng, $
                                   USE_AACGM_COORDS=use_AACGM, $
                                   USE_GEI_COORDS=use_GEI, $
                                   USE_GEO_COORDS=use_GEO, $
                                   USE_MAG_COORDS=use_MAG, $
                                   USE_SDT_COORDS=use_SDT, $
                                   USING_HEAVIES=using_heavies, $
                                   FORCE_LOAD=force_load, $
                                   JUST_TIME=just_time, $
                                   LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
                                   LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
                                   LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
                                   CHECK_DB=check_DB, $
                                   QUIET=quiet, $
                                   CLEAR_MEMORY=clear_memory, $
                                   NO_MEMORY_LOAD=noMem, $
                                   LUN=lun


        dbString    = 'sWay DB'
        pDBStruct   = PTR_NEW(TEMPORARY(SWAY__DB))

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_SWAYDB, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files, $
                      USE_KATUS_STORM_PHASES=alfDB_plot_struct.storm_opt.use_katus_storm_phases)
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
        pDBStruct   = PTR_NEW(TEMPORARY(NEWELL_I__ion))

        todaysFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES( $
                      /FOR_IONDB, $
                      DOWNGOING_ION=alfDB_plot_struct.ion__downgoing, $
                      SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                      INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                      DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                      DSTCUTOFF=alfDB_plot_struct.storm_opt.dstCutoff, $
                      SMOOTH_DST=alfDB_plot_struct.storm_opt.smooth_Dst, $
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files, $
                      USE_KATUS_STORM_PHASES=alfDB_plot_struct.storm_opt.use_katus_storm_phases)
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

        pDBStruct   = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc)
        pDBTimes    = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times  : FASTLOC__times)

        good_i      = FASTLOC_CLEANER(*pDBStruct, $
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
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files, $
                      USE_KATUS_STORM_PHASES=alfDB_plot_struct.storm_opt.use_katus_storm_phases)
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

        pDBStruct   = PTR_NEW(TEMPORARY(MAXIMUS__maximus))
        pDBTimes    = PTR_NEW(TEMPORARY(MAXIMUS__times))
        dbString    = 'Alfven DB'

        good_i      = ALFVEN_DB_CLEANER( $
                      *pDBStruct, $
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
                      USE_MOSTRECENT_DST_FILES=alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files, $
                      USE_KATUS_STORM_PHASES=alfDB_plot_struct.storm_opt.use_katus_storm_phases)

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
     USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
     STORM_DST_I=s_dst_i, $
     NONSTORM_DST_I=ns_dst_i, $
     MAINPHASE_DST_I=mp_dst_i, $
     RECOVERYPHASE_DST_I=rp_dst_i, $
     INITIALPHASE_DST_I=init_dst_i, $
     EARLYMAINPHASE_DST_I=earlyMP_dst_i, $
     EARLYRECOVERYPHASE_DST_I=earlyRP_dst_i, $
     LATEMAINPHASE_DST_I=lateMP_dst_i, $
     LATERECOVERYPHASE_DST_I=lateRP_dst_i, $
     N_STORM=n_s, $
     N_NONSTORM=n_ns, $
     N_MAINPHASE=n_mp, $
     N_RECOVERYPHASE=n_rp, $
     N_INITIALPHASE=n_init, $
     N_EARLYMAINPHASE=n_earlyMP, $
     N_EARLYRECOVERYPHASE=n_earlyRP, $
     N_LATEMAINPHASE=n_lateMP, $
     N_LATERECOVERYPHASE=n_lateRP, $
     LUN=lun

  IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

     CASE katus_storm_phases OF
        1: BEGIN
           dst_i_list=LIST(init_dst_i,mp_dst_i,rp_dst_i)
           strings=["initial","mainphase","recoveryphase"]
        END
        2: BEGIN
           dst_i_list=LIST(init_dst_i,earlyMP_dst_i,lateMP_dst_i,earlyRP_dst_i,lateRP_dst_i)
           strings=["initial","earlyMP","lateMP",'earlyRP','lateRP']
        END
     ENDCASE

  ENDIF ELSE BEGIN

     dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
     strings=["nonstorm","mainphase","recoveryphase"]

  ENDELSE
  
  IF FILE_TEST(todaysFile) AND KEYWORD_SET(alfDB_plot_struct.storm_opt.use_mostRecent_Dst_files) THEN BEGIN
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
           FOR_SWAY_DB=(dbString EQ 'sWay DB'), $
           DBSTRUCT=*pDBStruct, $
           DBTIMES=N_ELEMENTS(pDBTimes) GT 0 ? *pDBTimes : !NULL, $
           ;; DBTIMES=*pDBTimes, $
           RESTRICT_W_THESEINDS=good_i, $
           OUT_INDS_LIST=inds_list, $
           UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
           INDS_ORBS_LIST=inds_orbs_list, $
           TRANGES_ORBS_LIST=tranges_orbs_list, $
           TSPANS_ORBS_LIST=tspans_orbs_list, $
           PRINT_DATA_AVAILABILITY=0,VERBOSE=0,/LIST_TO_ARR
        
        IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

           CASE use_katus_storm_phases OF
              1: BEGIN

                 CASE i OF
                    0: BEGIN
                       init_i   = inds_list
                       init_t1  = dst.time[inds[start_dst_ii]]
                       init_t2  = dst.time[inds[stop_dst_ii]]

                    END
                    1: BEGIN
                       mp_i     = inds_list 
                       mp_t1    = dst.time[inds[start_dst_ii]]
                       mp_t2    = dst.time[inds[stop_dst_ii]]
                    END
                    2: BEGIN
                       rp_i     = inds_list
                       rp_t1    = dst.time[inds[start_dst_ii]]
                       rp_t2    = dst.time[inds[stop_dst_ii]]
                    END
                 ENDCASE

              END
              2: BEGIN

                 CASE i OF
                    0: BEGIN
                       init_i      = inds_list
                       init_t1     = dst.time[inds[start_dst_ii]]
                       init_t2     = dst.time[inds[stop_dst_ii]]

                    END
                    1: BEGIN
                       earlyMP_i  = inds_list 
                       earlyMP_t1 = dst.time[inds[start_dst_ii]]
                       earlyMP_t2 = dst.time[inds[stop_dst_ii]]
                    END
                    2: BEGIN
                       lateMP_i   = inds_list 
                       lateMP_t1  = dst.time[inds[start_dst_ii]]
                       lateMP_t2  = dst.time[inds[stop_dst_ii]]
                    END
                    1: BEGIN
                       earlyRP_i  = inds_list 
                       earlyRP_t1 = dst.time[inds[start_dst_ii]]
                       earlyRP_t2 = dst.time[inds[stop_dst_ii]]
                    END
                    2: BEGIN
                       lateRP_i   = inds_list 
                       lateRP_t1  = dst.time[inds[start_dst_ii]]
                       lateRP_t2  = dst.time[inds[stop_dst_ii]]
                    END
                 ENDCASE

              END
           ENDCASE

        ENDIF ELSE BEGIN

           CASE i OF
              0: BEGIN
                 ns_i   = inds_list
                 ns_t1  = dst.time[inds[start_dst_ii]]
                 ns_t2  = dst.time[inds[stop_dst_ii]]
              END
              1: BEGIN
                 mp_i   = inds_list 
                 mp_t1  = dst.time[inds[start_dst_ii]]
                 mp_t2  = dst.time[inds[stop_dst_ii]]
              END
              2: BEGIN
                 rp_i   = inds_list
                 rp_t1  = dst.time[inds[start_dst_ii]]
                 rp_t2  = dst.time[inds[stop_dst_ii]]
              END
           ENDCASE

        ENDELSE

     ENDFOR

     PRINTF,lun,"Saving FAST " + dbString + " nonstorm/storm indices for today: " + todaysFile

     IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

        CASE use_katus_storm_phases OF
           1: BEGIN

              SAVE,ns_i,init_i,mp_i,rp_i,ns_dst_i,s_dst_i,init_dst_i,mp_dst_i,rp_dst_i, $
                   n_ns,n_s,n_init,n_mp,n_rp, $
                   ns_t1,ns_t2,init_t1,init_t2,mp_t1,mp_t2,rp_t1,rp_t2, $
                   FILENAME=todaysFile

           END
           2: BEGIN

              SAVE,ns_i, $
                   init_i, $
                   earlyMP_i,lateMP_i, $
                   earlyRP_i,lateRP_i, $
                   ns_dst_i,s_dst_i, $
                   init_dst_i, $
                   earlyMP_dst_i,lateMP_dst_i, $
                   earlyRP_dst_i,lateRP_dst_i, $
                   n_ns,n_s, $
                   n_init, $
                   n_earlyMP,n_lateMP, $
                   n_earlyRP,n_lateRP, $
                   ns_t1,ns_t2, $
                   init_t1,init_t2, $
                   earlyMP_t1,earlyMP_t2,lateMP_t1,lateMP_t2, $
                   earlyRP_t1,earlyRP_t2, $
                   FILENAME=todaysFile

           END
        ENDCASE

     ENDIF ELSE BEGIN

        SAVE,ns_i,mp_i,rp_i,s_dst_i,ns_dst_i,mp_dst_i,rp_dst_i, $
             n_s,n_ns,n_mp,n_rp, $
             ns_t1,ns_t2,mp_t1,mp_t2,rp_t1,rp_t2, $
             FILENAME=todaysFile

     ENDELSE

  ENDELSE

  CASE 1 OF
     KEYWORD_SET(get_eSpecdb_i_not_alfDB_i): BEGIN
        NEWELL__eSpec        = TEMPORARY(*pDBStruct)
     END
     KEYWORD_SET(get_iondb_i_not_alfDB_i): BEGIN
        NEWELL_I__ion        = TEMPORARY(*pDBStruct)
     END
     KEYWORD_SET(get_sWay_i_not_alfDB_i): BEGIN
        SWAY__DB             = TEMPORARY(*pDBStruct)
     END
     KEYWORD_SET(get_time_i_not_alfDB_I): BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           FL_eSpec__fastLoc = TEMPORARY(*pDBStruct)
           FASTLOC_E__times  = TEMPORARY(*pDBTimes)
        ENDIF ELSE BEGIN
           FL__fastLoc       = TEMPORARY(*pDBStruct)
           FASTLOC__times    = TEMPORARY(*pDBTimes)
        ENDELSE        
     END
     ELSE: BEGIN
        MAXIMUS__maximus     = TEMPORARY(*pDBStruct)
        MAXIMUS__times       = TEMPORARY(*pDBTimes) 
     END
  ENDCASE

  HEAP_FREE,pDBStruct,/PTR
  IF N_ELEMENTS(pDBTimes) GT 0 THEN HEAP_FREE,pDBTimes,/PTR
  HEAP_GC

END
