;2015/10/14
;2016/01/01 If this has already been done once today, then don't do it again
;2016/01/01 Also output t1 and t2 for each phase, if desired
;2016/04/04 Added DO_DESPUN keyword for fear
PRO GET_AE_FASTDB_INDICES, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   GET_TIME_I_NOT_ALFDB_I=get_time_i_not_alfDB_I, $
   GET_ESPECDB_I_NOT_ALFDB_I=get_eSpecdb_i_not_alfDB_i, $
   GET_IONDB_I_NOT_ALFDB_I=get_iondb_i_not_alfDB_i, $
   ;; AECUTOFF=AEcutoff, $
   ;; SMOOTH_AE=smooth_AE, $
   USE_AU=use_au, $
   USE_AL=use_al, $
   USE_AO=use_ao, $
   HIGH_AE_I=high_ae_i, $
   LOW_AE_I=low_ae_i, $
   HIGH_I=high_i, $
   LOW_I=low_i, $
   N_HIGH=n_high, $
   N_LOW=n_low, $
   OUT_NAME=navn, $
   HIGH_AE_T1=high_ae_t1, $
   LOW_AE_T1=low_ae_t1, $
   HIGH_AE_T2=high_ae_t2, $
   LOW_AE_T2=low_ae_t2, $
   GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $
   LUN=lun

  COMPILE_OPT IDL2,STRICTARRSUBS

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun

  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AU): BEGIN
        AE_str = 'AU'
     END
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AO): BEGIN
        AE_str = 'AO'
     END
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AL): BEGIN
        AE_str = 'AL'
     END
     ELSE: BEGIN
        AE_str = 'AE'
     END
  ENDCASE

  CASE 1 OF 
     KEYWORD_SET(get_eSpecdb_i_not_alfDB_i): BEGIN
        @common__newell_espec.pro

        LOAD_NEWELL_ESPEC_DB, $
           FAILCODES=failCode, $
           USE_UNSORTED_FILE=use_unsorted_file, $
           NEWELLDBDIR=NewellDBDir, $
           NEWELLDBFILE=NewellDBFile, $
           FORCE_LOAD_DB=force_load_db, $
           OUT_TIMES=dbTimes, $
           LUN=lun, $
           QUIET=quiet

        dbString    = 'eSpec DB'
        pDBStruct   = PTR_NEW(TEMPORARY(NEWELL__eSpec))

        todaysFile = TODAYS_AE_INDICES( $
                     /FOR_ESPECDB, $
                     UPGOING_ESPEC=alfDB_plot_struct.eSpec__upgoing, $
                     AE_STR=ae_str, $
                     AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
                     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
                     LOAD_MOST_RECENT=most_recent)
     END
     KEYWORD_SET(get_iondb_i_not_alfDB_i): BEGIN
        @common__newell_ion_db.pro

        LOAD_NEWELL_ION_DB, $
           DOWNGOING=alfDB_plot_struct.ion__downgoing, $
           USE_UNSORTED_FILE=use_unsorted_file, $
           NEWELLDBDIR=NewellDBDir, $
           NEWELLDBFILE=NewellDBFile, $
           FORCE_LOAD_DB=force_load_db, $
           OUT_TIMES=dbTimes, $
           LUN=lun, $
           QUIET=quiet

        dbString    = 'ion DB'
        pDBStruct   = PTR_NEW(TEMPORARY(NEWELL_I__ion))

        todaysFile = TODAYS_AE_INDICES( $
                     /FOR_IONDB, $
                     DOWNGOING_ION=alfDB_plot_struct.ion__downgoing, $
                     AE_STR=ae_str, $
                     AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
                     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
                     LOAD_MOST_RECENT=most_recent)
     END
     KEYWORD_SET(get_time_i_not_alfDB_I): BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           @common__fastloc_espec_vars.pro
        ENDIF ELSE BEGIN
           @common__fastloc_vars.pro
        ENDELSE        

        LOAD_FASTLOC_AND_FASTLOC_TIMES, $
           COORDINATE_SYSTEM=MIMC_struct.coordinate_system, $
           USE_AACGM_COORDS=MIMC_struct.use_AACGM, $
           USE_MAG_COORDS=MIMC_struct.use_MAG, $
           FOR_ESPEC_DBS=for_eSpec_DBs, $
           INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
           LUN=lun

        pDBStruct   = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc   )
        pDBTimes    = PTR_NEW(KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times  : FASTLOC__times)

        good_i = FASTLOC_CLEANER(*pDBStruct, $
                                 FOR_ESPEC_DBS=for_eSpec_DBs, $
                                 SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                                 INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                                 DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t)

        dbString = 'fastLoc'
        todaysFile = TODAYS_AE_INDICES( $
                     /FOR_FASTLOC, $
                     FASTLOC_FOR_ESPEC=alfDB_plot_struct.for_eSpec_DBs, $
                     SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                     INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
                     DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                     AE_STR=ae_str, $
                     AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
                     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
                     LOAD_MOST_RECENT=most_recent)
     END
     ELSE: BEGIN

        LOAD_MAXIMUS_AND_CDBTIME, $
           CHASTDB=alfDB_plot_struct.chastDB, $
           DESPUNDB=alfDB_plot_struct.despunDB, $
           COORDINATE_SYSTEM=MIMC_struct.coordinate_system, $
           USE_AACGM=MIMC_struct.use_AACGM, $
           USE_MAG_COORDS=MIMC_struct.use_MAG, $
           LUN=lun

        pDBStruct   = PTR_NEW(TEMPORARY(MAXIMUS__maximus))
        pDBTimes    = PTR_NEW(TEMPORARY(MAXIMUS__times))
        dbString = 'Alfven DB'

        good_i = ALFVEN_DB_CLEANER( $
                 *pDBStruct, $
                 SAMPLE_T_RESTRICTION=alfDB_plot_struct.sample_t_restriction, $
                 INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                 DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t)

        todaysFile = TODAYS_AE_INDICES( $
                     DESPUN_ALFDB=alfDB_plot_struct.despunDB, $
                     /FOR_ALFVENDB, $
                     AE_STR=ae_str, $
                     AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
                     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
                     LOAD_MOST_RECENT=most_recent)
        
     END
  ENDCASE

  GET_LOW_AND_HIGH_AE_PERIODS, $
     ae, $
     AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
     EARLIEST_UTC=IMF_struct.earliest_UTC, $
     LATEST_UTC=IMF_struct.latest_UTC, $
     USE_JULDAY_NOT_UTC=IMF_struct.use_julDay_not_UTC, $
     EARLIEST_JULDAY=IMF_struct.earliest_julDay, $
     LATEST_JULDAY=IMF_struct.latest_julDay, $
     USE_AU=alfDB_plot_struct.ae_opt.use_au, $
     USE_AL=alfDB_plot_struct.ae_opt.use_al, $
     USE_AO=alfDB_plot_struct.ae_opt.use_ao, $
     HIGH_AE_I=high_ae_i, $
     LOW_AE_I=low_ae_i, $
     N_HIGH=n_high, $
     N_LOW=n_low, $
     OUT_NAME=navn, $
     QUIET=quiet, $
     LUN=lun

  ae_i_list = LIST(high_ae_i,low_ae_i)
  strings = ["high_","low_"] + AE_str

  IF FILE_TEST(todaysFile) THEN BEGIN
     PRINTF,lun,"Already have nonstorm and storm " + dbString + " inds! Restoring today's file..."
     RESTORE,todaysFile
  ENDIF ELSE BEGIN
     
     FOR i=0,1 DO BEGIN
        inds=ae_i_list[i]
        help,inds
        GET_STREAKS,inds,START_I=start_ae_ii,STOP_I=stop_ae_ii,SINGLE_I=single_ae_ii
        
        GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
           T1_ARR=ae.time[inds[start_ae_ii]], $
           T2_ARR=ae.time[inds[stop_ae_ii]], $
           DBSTRUCT=*pDBStruct, $
           DBTIMES=N_ELEMENTS(pDBTimes) GT 0 ? *pDBTimes : !NULL, $
           RESTRICT_W_THESEINDS=good_i, $
           OUT_INDS_LIST=inds_list, $
           UNIQ_ORBS_LIST=uniq_orbs_list, $
           UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
           INDS_ORBS_LIST=inds_orbs_list, $
           TRANGES_ORBS_LIST=tranges_orbs_list, $
           TSPANS_ORBS_LIST=tspans_orbs_list, $
           PRINT_DATA_AVAILABILITY=0, $
           VERBOSE=0, $
           /LIST_TO_ARR
        
        IF i EQ 0 THEN BEGIN
           PRINT,"N " + dbString + " inds for high " + AE_str + " retrieved  : " + $
                 STRCOMPRESS(N_ELEMENTS(inds_list),/REMOVE_ALL)
           high_i                  = inds_list
           high_ae_t1              = ae.time[inds[start_ae_ii]]
           high_ae_t2              = ae.time[inds[stop_ae_ii]]
        ENDIF ELSE BEGIN
           IF i EQ 1 THEN BEGIN
           PRINT,"N " + dbString + " inds for low " + AE_str + " retrieved  : " + $
                 STRCOMPRESS(N_ELEMENTS(inds_list),/REMOVE_ALL)
              low_i                = inds_list
              low_ae_t1            = ae.time[inds[start_ae_ii]]
              low_ae_t2            = ae.time[inds[stop_ae_ii]]
           ENDIF
        ENDELSE
        
     ENDFOR

     PRINTF,lun,"Saving FAST " + dbString + " AE/AO/AU/AL indices for today..."
     SAVE,high_i,low_i,high_ae_i,low_ae_i, $
          n_high,n_low, $
          high_ae_t1,high_ae_t2,low_ae_t1,low_ae_t2, $
          FILENAME=todaysFile

  ENDELSE

  CASE 1 OF
     KEYWORD_SET(get_eSpecdb_i_not_alfDB_i): BEGIN
        NEWELL__eSpec = TEMPORARY(*pDBStruct)
     END
     KEYWORD_SET(get_iondb_i_not_alfDB_i): BEGIN
        NEWELL_I_ion = TEMPORARY(*pDBStruct)
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
        MAXIMUS__maximus    = TEMPORARY(*pDBStruct)
        MAXIMUS__times      = TEMPORARY(*pDBTimes) 
     END
  ENDCASE

  HEAP_FREE,pDBStruct,/PTR
  IF N_ELEMENTS(pDBTimes) GT 0 THEN HEAP_FREE,pDBTimes,/PTR
  HEAP_GC


END