PRO  ADD_TSTAMP_TO_NOAA_SSC_DBS,ssc

  jd_ssc = JULDAY(ssc.month, ssc.day, ssc.year, ssc.hour, ssc.minute)
  ts_ssc = TIMESTAMP(YEAR=ssc.year, MONTH=ssc.month, DAY=ssc.day, HOUR=ssc.hour, MINUTE=ssc.minute)

  si=sort(jd_ssc)

  ssc={FILENAME:ssc.filename, $
       JULDAY:jd_ssc(si), $
       TSTAMP:ts_ssc(si), $
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
  
  PRINT,"Added timestamps and Julian day to NOAA SSC database!"

END