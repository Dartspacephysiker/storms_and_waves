PRO SORT_BRETTS_DB,stormStruct

  ;; jd_st = JULDAY(stormstruct.month, stormstruct.day, stormstruct.year, stormstruct.hour, stormstruct.minute)
  si=sort(stormstruct.julday)

  stormStruct={IS_LARGESTORM:stormstruct.is_largestorm(si), $
               STORM:stormstruct.storm(si), $
               TIME:stormstruct.time(si), $
               JULDAY:stormstruct.julday(si), $
               TSTAMP:stormstruct.tstamp(si), $
               YEAR:stormstruct.year(si), $
               MONTH:stormstruct.month(si), $
               DAY:stormstruct.day(si), $
               HOUR:stormstruct.hour(si), $
               MINUTE:stormstruct.minute(si), $
               DST:stormstruct.dst(si), $
               DROP_IN_DST:stormstruct.drop_in_dst(si)}

  PRINT,"Finished sorting Brett's DB!"

END