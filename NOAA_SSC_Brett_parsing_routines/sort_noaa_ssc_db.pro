;;Obsoleted 2015/08/14. This is now done in read_sudden_commencement_dbs when
;;add_tstamp_to_noaa_ssc_dbs is called at the bottom of the pro.
PRO  SORT_NOAA_SSC_DB,ssc,jd

  jd_ssc = JULDAY(ssc.month, ssc.day, ssc.year, ssc.hour, ssc.minute)

  si=sort(jd_ssc)

  jd=jd_ssc(si)

  ssc_sorted={FILENAME:ssc.filename, $
              YEAR:ssc.year(si), $
              MONTH:ssc.month(si), $
              DAY:ssc.day(si), $
              HOUR:ssc.hour(si), $
              MINUTE:ssc.minute(si), $
              A:ssc.A(si), $
              B:ssc.B(si), $
              C:ssc.C(si), $
              SI:ssc.si(si), $
              CODE_OBS1:ssc.code_obs1(si), $
              CODE_OBS2:ssc.code_obs2(si), $
              CODE_OBS3:ssc.code_obs3(si), $
              CODE_OBS4:ssc.code_obs4(si), $
              CODE_OBS5:ssc.code_obs5(si), $
              AVG_DUR:ssc.avg_dur(si), $
              AVG_AMPLITUDE:ssc.avg_amplitude(si)}
  ssc=ssc_sorted

  PRINT,"Finished sorting NOAA SSC database!"

END