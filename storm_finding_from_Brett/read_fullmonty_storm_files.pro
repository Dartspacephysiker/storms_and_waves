;2016/08/26 Updated version of READ_STORM_FILES
;Still gotta give mad props to Brett for making this so very, very easy
PRO READ_FULLMONTY_STORM_FILES

  COMPILE_OPT idl2

  stormDir       = '/SPENCEdata/Research/database/storm_data/'

  ASCIItmpFile   = 'brettReader--hammers_edits--ASCII_tmplt.sav'
  largeStormFile = 'large_storms--1957-2011.txt'
  smallStormFile = 'small_storms--1957-2011.txt'
  
  stormOutFile   = 'large_and_small_storms--1957-2011--Anderson.sav'
  
  IF FILE_TEST(stormDir+ASCIItmpFile) THEN BEGIN
     RESTORE,stormDir+ASCIItmpFile
  ENDIF ELSE BEGIN
     stormTemplate = ASCII_TEMPLATE(stormDir+largeStormFile)
     SAVE,stormTemplate,FILENAME=stormDir+ASCIItmpFile
  ENDELSE

  ;; (OLD) Template for the storm files that Brett provided (great guy)
  ;; fieldtypes      = [3,3,3,3,3,3,4,4]
  ;; fieldnames      = ["STORM","YEAR", "MONTH", "DAY", "HOUR", "MINUTE", "DST", "DROP_IN_DST"]
  ;; fieldlocations  = [0,9,22,33,45,57,64,76]
  ;; fieldgroups     = [0,1,2,3,4,5,6,7]
  ;; stormTemplate   = {version:1.0,$
  ;;                    datastart:2,$
  ;;                    delimiter:' ',$
  ;;                    missingvalue:!values.f_nan,$
  ;;                    commentsymbol:';',$
  ;;                    fieldcount:[8],$
  ;;                    fieldtypes:fieldtypes,$
  ;;                    fieldnames:fieldnames,$
  ;;                    fieldlocations:fieldlocations,$
  ;;                    fieldgroups:fieldgroups}

  stormDat      = READ_ASCII(stormDir+largeStormFile,TEMPLATE=stormTemplate)

  largeStormDat = {is_largeStorm:MAKE_ARRAY(n_elements(stormDat.storm),VALUE=1), $
                   storm:stormDat.storm, $
                   year:stormDat.year, $
                   month:stormDat.month, $
                   day:stormDat.day, $
                   hour:stormDat.hour, $
                   minute:stormDat.minute, $
                   dst:stormDat.dst, $
                   drop_in_dst:stormDat.drop_in_dst}

  stormDat = READ_ASCII(stormDir+smallStormFile,TEMPLATE=stormTemplate)
  smallStormDat = {is_largeStorm:MAKE_ARRAY(n_elements(stormDat.storm),VALUE=0), $
                   storm:stormDat.storm, $
                   year:stormDat.year, $
                   month:stormDat.month, $
                   day:stormDat.day, $
                   hour:stormDat.hour, $
                   minute:stormDat.minute, $
                   dst:stormDat.dst, $
                   drop_in_dst:stormDat.drop_in_dst}

  ;;times?
  jultime = (JULDAY([largeStormDat.month,smallStormDat.month], $
                    [largeStormDat.day,smallStormDat.day], $
                    [largeStormDat.year,smallStormDat.year], $
                    [largeStormDat.hour,smallStormDat.hour], $
                    [largeStormDat.minute,smallStormDat.minute], $
                    0) - JulDay(1,1,1970,0,0,0) ) * 24. * 60 * 60

  stormStruct = {stormStruct, $
                 is_largeStorm:[largeStormDat.is_largeStorm,smallStormDat.is_largeStorm], $
                 storm:[largeStormDat.storm,smallStormDat.storm], $
                 time:julTime, $
                 julday:JULDAY([largeStormDat.month,smallStormDat.month], $
                               [largeStormDat.day,smallStormDat.day], $
                               [largeStormDat.year,smallStormDat.year], $
                               [largeStormDat.hour,smallStormDat.hour], $
                               [largeStormDat.minute,smallStormDat.minute], $
                               0), $
                 tStamp:TIMESTAMP(YEAR = [largeStormDat.year,smallStormDat.year], $
                                  MONTH = [largeStormDat.month,smallStormDat.month], $
                                  DAY = [largeStormDat.day,smallStormDat.day], $
                                  HOUR = [largeStormDat.hour,smallStormDat.hour], $
                                  MINUTE = [largeStormDat.minute,smallStormDat.minute], $
                                  SECOND = 0), $
                 year:[largeStormDat.year,smallStormDat.year], $
                 month:[largeStormDat.month,smallStormDat.month], $
                 day:[largeStormDat.day,smallStormDat.day], $
                 hour:[largeStormDat.hour,smallStormDat.hour], $
                 minute:[largeStormDat.minute,smallStormDat.minute], $
                 dst:[largeStormDat.dst,smallStormDat.dst], $
                 drop_in_dst:[largeStormDat.drop_in_dst,smallStormDat.drop_in_dst]}

  SORT_BRETTS_DB,stormStruct

  SAVE,stormStruct,FILENAME=stormDir+stormOutFile


END