;2015/08/12
;Now we're going to read in NOAA's storm sudden commencement databases

;They are located here:
;https://catalog.data.gov/dataset/geomagnetic-storm-sudden-commencements/resource/1d48830c-04ae-476d-b81f-76fe1eeed8b3
;or
;ftp://ftp.ngdc.noaa.gov/STP/SOLAR_DATA/SUDDEN_COMMENCEMENTS/

;I originally chanced upon these while reading Borovsky and Denton [2006], "Differences between CME-driven storms and CIR-driven storms",
; where these authors make use of said database.

;Jim wants me to find an automated way to identify storm sudden commencement, but I'd rather rely on the work of others.
;I'll be comparing their lists with the storms identified by Brett Anderson's dst_stormfinder_v2.pro.

;2015/08/14 : Added the whole 'add_tstamp_to_NOAA_SSC_DBs' thing to give Julday and tstamps, and to
;sort the dbs by time

PRO READ_SUDDEN_COMMENCEMENT_DBS

  DBDIR='/SPENCEdata/Research/database/sw_omnidata/'

  ;; Not currently sure what the difference between these two is
  SSC_FILE1 = DBDIR+'storm2_mods.txt'
  SSC_FILE2 = DBDIR+'STORM2_MODS.SSC'

  ;; ssc_tmplt1 = ASCII_TEMPLATE(SSC_FILE1)
  ;; ssc_fmt1 = '(T1,I4,T8,I2,T13,I2,T17,I2,T19,I2,T25,I2,T31,I2,T37,I2,T62,I2,T71,I1,T73,I1,T75,I1,T77,I1,T79,I1,T85,F4.1,T92,F3.0)'

  fieldTypes1=[3,3,3,3,3,$
               3,3,3,3,3,$
               3,3,3,3,4,$
               4]

  fieldNames1=["YEAR", "MONTH", "DAY", "HOUR", "MINUTE", $
               "A", "B", "C", "SI", "CODE_OBS1", $
               "CODE_OBS2", "CODE_OBS3", "CODE_OBS4", "CODE_OBS5", "AVG_DUR", $
               "AVG_AMPLITUDE"]

  fieldLocations1=[1, 8, 13, 17, 20, $
                   25, 31, 37, 62, 71, $
                   73, 75, 77, 79, 85, $
                   92]
  
  fieldGroups1 = [0, 1, 2, 3, 4, $
                  5, 6, 7, 8, 9, 10, $
                  11, 12, 13, 14, $
                  15]

  ssc_tmplt1 = {VERSION:1.00000, $
                DATASTART:6L, $
                DELIMITER:32B, $
                MISSINGVALUE:!Values.F_NAN, $
                COMMENTSYMBOL:'', $
                FIELDCOUNT:16L, $
                FIELDTYPES:fieldTypes1, $
                FIELDNAMES:fieldNames1, $
                FIELDLOCATIONS:fieldLocations1, $
                FIELDGROUPS:fieldGroups1}

  ssc1 = READ_ASCII(SSC_FILE1,TEMPLATE=ssc_tmplt1)
  ssc2 = READ_ASCII(SSC_FILE2,TEMPLATE=ssc_tmplt1)

  ssc1 = CREATE_STRUCT("filename",SSC_FILE1,ssc1)
  ssc2 = CREATE_STRUCT("filename",SSC_FILE2,ssc2)

  add_tstamp_to_noaa_ssc_dbs,ssc1
  add_tstamp_to_noaa_ssc_dbs,ssc2

  save,ssc1,ssc2,filename='SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

END
