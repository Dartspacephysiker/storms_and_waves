;2015/08/20
;We need some stats on how many quantities in maximus do various things—yes, incredibly vague.

PRO JOURNAL__20150820__generate_stats_on_some_thresholds_for_Alfvens_storms_GRL
  
  DBFile ='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav' 
  DB_tFile = '/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav' 
  RESTORE,DBFile
  RESTORE,DB_tFile

  good_i=get_chaston_ind(maximus,'OMNI',-1,/BOTH_HEMIS,CDBTIME=cdbTime)

  histos_and_lims_for_maximus_quantity,maximus,7

  ;ESA_J/MAG_J ratio
  ratio = ABS(maximus.esa_current(good_i)/maximus.mag_current(good_i))
  ratMin=min(ratio,max=ratMax)
  print,'ESA_J/MAG_J Min: ',ratMin
  print,'ESA_J/MAG_J Max: ',ratMax
  cghistoplot,alog10(ratio)

END