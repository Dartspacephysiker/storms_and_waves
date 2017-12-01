;2017/12/01
;; Ze list of orbs is located in [.../storm_data/processed/katus_...]/FAST_orbits_for_katus_storms_after_FAST_orbit_24634.txt
PRO GET_ORBS_FOR_MISSING_KATUS_STORMS

  COMPILE_OPT IDL2,STRICTARRSUBS

  dir           = '/SPENCEdata/Research/database/storm_data/processed/katus_et_al_2013__normalized_storm_phases/'
  missingOutFil = 'katus_noHave_after_FASTorb24634.sav'
  delta_t       = 10

  RESTORE,dir+missingOutFil

  N             = N_ELEMENTS(katus.init.utc)
  tidArr        = [[katus.init.utc],[katus.rp.utc]]
  tidStrArr     = [[katus.init.string],[katus.rp.string]]

  FOR k=0,N-1 DO BEGIN
     PRINT,FORMAT='(I3,T5,A0,T30,A0)',k,tidStrArr[k,0],tidStrArr[k,1]
     PRINT,FORMAT='(T5,A0,T30,A0)',T2S(tidArr[k,0]),T2S(tidArr[k,1])
     IF ~(STRMATCH(T2S(tidArr[k,0]),tidStrArr[k,0]) AND STRMATCH(T2S(tidArr[k,1]),tidStrArr[k,1])) THEN STOP
  ENDFOR
  
  ;; Good; if we're here, we're semi-safe
  ;; Now the orbs

  orbArr = !NULL
  FOR k=0,N-1 DO BEGIN
     PRINT,FORMAT='(I3,T5,A0,T30,A0)',k,tidStrArr[k,0],tidStrArr[k,1]

     GET_ALT_MLT_ILAT_FROM_FAST_EPHEM,!NULL,REFORM(tidArr[k,*]), $
                                      /NOT_TIMEARR, $
                                      NOT_TARR__DELTA_T=delta_t, $
                                      OUT_ALT=alt, $
                                      OUT_MLT=mlt, $
                                      OUT_ILAT=ilat, $
                                      OUT_ORBIT=orbit, $
                                      OUT_MAPRATIO=mapRatio, $
                                      OUT_NEVENTS=nEvents, $
                                      LOGLUN=logLun

     

     orbArr = [orbArr,orbit[UNIQ(orbit,SORT(orbit))]]

  ENDFOR

  STOP

  ;; Last orbit is 51315 on CDAWeb as well as sprg.ssl.berkeley.edu/htbin/fastcgi/sumplotsNetscape/recentplot.pl

  orbArr = orbArr[WHERE(orbArr LE 51315)]

  FOR k=0,N_ELEMENTS(orbArr)-1 DO PRINT,orbArr[k]

  
END
