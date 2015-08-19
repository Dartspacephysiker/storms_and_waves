;2015/08/18
;The idea is to generate some stats like the number of intervals, the number of orbits, etc.
PRO JOURNAL__20150818__generate_stats_for_Alfvens_storms_GRL

  dataDir='/SPENCEdata/Research/Cusp/database/'
  DBFile='dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DB_tFile='dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  stormFile='saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--20150817.dat'

  print,'Restoring ' + DBFile + '...'
  restore,dataDir+DBFile
  print,'Restoring ' + DB_tFile + '...'
  restore,dataDir+DB_tFile

  ;restore storm file and get inds
  print,'Restoring ' + stormFile + '...'
  restore,dataDir+'../storms_Alfvens/' + stormFile
  storm_i = tot_plot_i_list[0]
  FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO storm_i = [storm_i,tot_plot_i_list[i]]
  nStormEv = N_ELEMENTS(storm_i)

  ;clean 'er out first, then set current limits
  good_i = get_chaston_ind(maximus,'OMNI',-1,/BOTH_HEMIS) & nGood=N_ELEMENTS(good_i)
  burst_i=cgsetintersection(good_i,WHERE(maximus.burst,COMPLEMENT=survey_i))
  survey_i=cgsetintersection(good_i,survey_i)
  burst_storm_i=cgsetintersection(burst_i,storm_i)
  survey_storm_i=cgsetintersection(survey_i,storm_i)
  ;**************************************************
  ;Burst stats
  PRINT_MIN_MAX_NUNIQ_IN_MAXIMUS,maximus,0,burst_i,'burst orbs',CDBTIME=cdbTime,UNIQ_II=uniq_burst_ii,N=nBurst
  PRINT,FORMAT='("#Burst events/Total events: ",TR1,I0,"/",I0,TR4,"(",F0.2," %)")',nBurst,nGood,DOUBLE(nBurst)/DOUBLE(nGood)*100.

  ;**************************************************
  ;Survey stats
  PRINT_MIN_MAX_NUNIQ_IN_MAXIMUS,maximus,0,survey_i,'survey orbs',CDBTIME=cdbTime,UNIQ_II=uniq_survey_ii,N=nSurvey
  PRINT,FORMAT='("#Survey events/Total events: ",TR1,I0,"/",I0,TR4,"(",F0.2," %)")',nSurvey,nGood,DOUBLE(nSurvey)/DOUBLE(nGood)*100.

  ;**************************************************
  ;Burst STORM stats
  PRINT_MIN_MAX_NUNIQ_IN_MAXIMUS,maximus,0,burst_storm_i,'burst storm orbs',CDBTIME=cdbTime,UNIQ_II=uniq_burst_storm_ii,N=nBurstStorm
  PRINT,FORMAT='("#Burst storm events/Total storm events: ",TR1,I0,"/",I0,TR4,"(",F0.2," %)")',nBurstStorm,nStormEv,DOUBLE(nBurstStorm)/DOUBLE(nStormEv)*100.
  ;**************************************************
  ;Survey STORM stats
  PRINT_MIN_MAX_NUNIQ_IN_MAXIMUS,maximus,0,survey_storm_i,'survey storm orbs',CDBTIME=cdbTime,UNIQ_II=uniq_survey_storm_ii,N=nSurveyStorm
  PRINT,FORMAT='("#Survey events/Total storm events: ",TR1,I0,"/",I0,TR4,"(",F0.2," %)")',nSurveyStorm,nStormEv,DOUBLE(nSurveyStorm)/DOUBLE(nStormEv)*100.

  


END