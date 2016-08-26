PRO SORT_BRETTS_DB,stormStruct,jd

  COMPILE_OPT idl2

  storm_i     = SORT(stormstruct.julday)
  jd          = stormstruct.julday[storm_i]

  stormStruct = {IS_LARGESTORM:stormstruct.is_largestorm[storm_i], $
                 STORM:stormstruct.storm[storm_i], $
                 TIME:stormstruct.time[storm_i], $
                 JULDAY:stormstruct.julday[storm_i], $
                 TSTAMP:stormstruct.tstamp[storm_i], $
                 YEAR:stormstruct.year[storm_i], $
                 MONTH:stormstruct.month[storm_i], $
                 DAY:stormstruct.day[storm_i], $
                 HOUR:stormstruct.hour[storm_i], $
                 MINUTE:stormstruct.minute[storm_i], $
                 DST:stormstruct.dst[storm_i], $
                 DROP_IN_DST:stormstruct.drop_in_dst[storm_i]}

  PRINT,"Finished sorting Brett's DB!"

END