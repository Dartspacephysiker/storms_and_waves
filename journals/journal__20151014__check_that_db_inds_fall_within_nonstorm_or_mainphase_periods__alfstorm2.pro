;2015/10/14 The idea here is to make sure that we actually have what we think we have—FAST Alfvén events during specified
;storm/nonstorm periods. The checks below demonstrate, for at least the two cases I checked, that we're all right.

PRO JOURNAL__20151014__CHECK_THAT_DB_INDS_FALL_WITHIN_NONSTORM_OR_MAINPHASE_PERIODS__ALFSTORM2


  ;;get both DBs in mem
  load_maximus_and_cdbtime,maximus,cdbtime
  load_dst_ae_dbs,dst,ae

  good_i=alfven_db_cleaner(maximus)

  ;;now get storm index stuff
  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES,NONSTORM_I=ns_i,MAINPHASE_I=mp_i,RECOVERYPHASE_I=rp_i, $
     STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp


  ns_t = maximus.time[ns_i]
  mp_t = maximus.time[mp_i]
  rp_t = maximus.time[rp_i]
  
  ns_dst_t = dst.date[ns_dst_i]
  mp_dst_t = dst.date[mp_dst_i]
  rp_dst_t = dst.date[rp_dst_i]
  

  print,mp_dst_t[150:160]
  ;;  1996-10-03T06:00:00.000
  ;;  1996-10-08T18:00:00.000
  ;;  1996-10-08T19:00:00.000
  ;;  1996-10-08T20:00:00.000
  ;;  1996-10-09T03:00:00.000
  ;;  1996-10-09T04:00:00.000
  ;;  1996-10-09T05:00:00.000
  ;;  1996-10-09T06:00:00.000
  ;;  1996-10-09T07:00:00.000
  ;;  1996-10-09T10:00:00.000
  ;;  1996-10-09T15:00:00.000

  print,mp_t[0:10]
  ;;  1996-10-09/04:30:10.485
  ;;  1996-10-09/04:30:13.094
  ;;  1996-10-09/04:30:13.414
  ;;  1996-10-09/04:30:16.719
  ;;  1996-10-09/04:30:17.039
  ;;  1996-10-09/04:30:17.274
  ;;  1996-10-09/04:30:25.391
  ;;  1996-10-09/04:30:25.969
  ;;  1996-10-09/04:30:26.688
  ;;  1996-10-09/04:30:26.969
  ;;  1996-10-09/04:30:50.836

  ;;Good! Now recovery phase

  print,rp_dst_t[170:180]
  ;;  1996-10-09T22:00:00.000
  ;;  1996-10-09T23:00:00.000
  ;;  1996-10-10T00:00:00.000
  ;;  1996-10-10T01:00:00.000
  ;;  1996-10-10T02:00:00.000
  ;;  1996-10-10T03:00:00.000
  ;;  1996-10-10T04:00:00.000
  ;;  1996-10-10T05:00:00.000
  ;;  1996-10-10T06:00:00.000
  ;;  1996-10-11T20:00:00.000
  ;;  1996-10-11T21:00:00.000

  print,rp_t[0:10]
  ;;  1996-10-09/22:17:57.528
  ;;  1996-10-10/00:35:16.871
  ;;  1996-10-10/00:35:21.262
  ;;  1996-10-10/00:35:21.856
  ;;  1996-10-10/00:35:23.512
  ;;  1996-10-10/00:35:24.520
  ;;  1996-10-10/00:35:25.645
  ;;  1996-10-10/00:35:26.168
  ;;  1996-10-10/00:35:36.020
  ;;  1996-10-10/00:35:39.082
  ;;  1996-10-10/00:35:40.504

END