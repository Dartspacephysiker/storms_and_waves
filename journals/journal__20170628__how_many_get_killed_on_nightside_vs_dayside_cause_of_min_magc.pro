;2017/06/28
PRO JOURNAL__20170628__HOW_MANY_GET_KILLED_ON_NIGHTSIDE_VS_DAYSIDE_CAUSE_OF_MIN_MAGC

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;;Need good_i from GET_CHASTON_IND to continue from here
  STOP

  day_i = WHERE(dbstruct.mlt GE 6 AND dbStruct.MLT LT 18,COMPLEMENT=night_i)
  dayGood_i = CGSETINTERSECTION(good_i,day_i)
  nightGood_i = CGSETINTERSECTION(good_i,night_i)
  !P.MULTI = [0,1,2,0,0]

  CGHISTOPLOT,dbstruct.mag_current[dayGood_i]
  CGHISTOPLOT,dbstruct.mag_current[nightGood_i]
  CGHISTOPLOT,ABS(dbstruct.mag_current[dayGood_i])
  CGHISTOPLOT,ABS(dbstruct.mag_current[nightGood_i])
  CGHISTOPLOT,ABS(dbstruct.mag_current[dayGood_i]),MAXINPUT=200
  CGHISTOPLOT,ABS(dbstruct.mag_current[nightGood_i]),MAXINPUT=200
  CGHISTOPLOT,ALOG10(ABS(dbstruct.mag_current[nightGood_i]))
  CGHISTOPLOT,ALOG10(ABS(dbstruct.mag_current[dayGood_i]))

  PRINT,"Night % below 10 microA/m^2: ",N_ELEMENTS(WHERE(ABS(dbstruct.mag_current[nightGood_i]) LT 10.))/FLOAT(N_ELEMENTS(nightGood_i))*100.
  PRINT,"Day % below 10 microA/m^2: ",N_ELEMENTS(WHERE(ABS(dbstruct.mag_current[dayGood_i]) LT 10.))/FLOAT(N_ELEMENTS(dayGood_i))*100.

;; Night % below 10 microA/m^2:       24.8612
;; Day % below 10 microA/m^2:       8.71799

  PRINT,"Median night current: ",MEDIAN(ABS(dbstruct.mag_current[nightGood_i]))
  PRINT,"Median day current: ",MEDIAN(ABS(dbstruct.mag_current[dayGood_i]))

END
