PRO SORT_BRETTS_DB,stormStruct

  si=sort(stormstruct.year)
  stormStruct_sorted={IS_LARGESTORM:stormstruct.is_largestorm(si), $
               STORM:stormstruct.storm(si), $
               TIME:stormstruct.time(si), $
               TSTAMP:stormstruct.tstamp(si), $
               YEAR:stormstruct.year(si), $
               MONTH:stormstruct.month(si), $
               DAY:stormstruct.day(si), $
               HOUR:stormstruct.hour(si), $
               MINUTE:stormstruct.minute(si), $
               DST:stormstruct.dst(si), $
               DROP_IN_DST:stormstruct.drop_in_dst(si)}

  stormStruct=stormStruct_sorted

  PRINT,"Finished sorting Brett's DB by year!"

END