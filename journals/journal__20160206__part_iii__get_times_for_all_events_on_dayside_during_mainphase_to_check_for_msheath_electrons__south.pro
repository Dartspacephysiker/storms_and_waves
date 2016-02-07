;2016/02/06 Chris' idea is that we should be able to test whether or not these are m-sheath electrons
PRO JOURNAL__20160206__PART_III__GET_TIMES_FOR_ALL_EVENTS_ON_DAYSIDE_DURING_MAINPHASE_TO_CHECK_FOR_MSHEATH_ELECTRONS__SOUTH

  inds_filename                 = 'journal__20160206__inds_for_all_events_on_dayside_during_mainphase_to_check_for_msheath_electrons__south.sav'

  minI                          = -80
  maxI                          = -60
  minM                          = 7.5
  maxM                          = 16.5

  hemi                          = 'SOUTH'

  LOAD_DST_AE_DBS,dst,ae

  earliest_UTC = str_to_time('1996-10-06/16:26:02.417')
  latest_UTC = str_to_time('2000-10-06/00:08:45.188')

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
     DSTCUTOFF=DstCutoff, $
     STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp, $
     EARLIEST_UTC=earliest_UTC,LATEST_UTC=latest_UTC, $
     LUN=lun
  
  dst_i_list=LIST(ns_dst_i,mp_dst_i,rp_dst_i)
  suff = STRING(FORMAT='("--Dstcutoff_",I0)',dstCutoff)
  strings=["nonstorm"+suff,"mainphase"+suff,"recoveryphase"+suff]
  niceStrings=["Non-storm","Main phase","Recovery phase"]


  i                          = 1         ;Main phase

  inds=dst_i_list[i]
  
  GET_STREAKS,inds,START_I=start_dst_ii,STOP_I=stop_dst_ii,SINGLE_I=single_dst_ii
  t1_arr = dst.time[inds[start_dst_ii]]
  t2_arr = dst.time[inds[stop_dst_ii]]
  
  good_i = GET_CHASTON_IND(maximus,satellite,lun, $
                           HEMI=hemi, $
                           DBTIMES=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb, $
                           ORBRANGE=orbRange,  $
                           ALTITUDERANGE=altitudeRange,  $
                           CHARERANGE=charERange, $
                           POYNTRANGE=poyntRange, $
                           MINMLT=minM, $
                           MAXMLT=maxM, $
                           BINM=binM, $
                           MINILAT=minI, $
                           MAXILAT=maxI, $
                           BINILAT=binI, $
                           DO_LSHELL=do_lshell, $
                           MINLSHELL=minL, $
                           MAXLSHELL=maxL, $
                           BINLSHELL=binL, $
                           HWMAUROVAL=HwMAurOval, $
                           HWMKPIND=HwMKpInd)
  
  GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
     T1_ARR=t1_arr, $
     T2_ARR=t2_arr, $
     DBSTRUCT=maximus, $
     DBTIMES=cdbTime, $
     RESTRICT_W_THESEINDS=good_i, $
     OUT_INDS_LIST=plot_i,  $
     UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
     INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
     PRINT_DATA_AVAILABILITY=print_data_availability, $
     LIST_TO_ARR=1,$
     SAVE_INDS_TO_FILENAME=inds_filename, $
     VERBOSE=verbose, DEBUG=debug, LUN=lun

END
