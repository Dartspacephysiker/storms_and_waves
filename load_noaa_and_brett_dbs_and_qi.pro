;;2015/10/16 
;;Time to streamline my life
PRO LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  DBDIR = '/home/spencerh/Research/Cusp/database/sw_omnidata/'
  DB_Brett = 'large_and_small_storms--1985-2011--Anderson.sav'
  DB_NOAA = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

  inds_file = 'large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav'

  IF N_ELEMENTS(stormStruct) EQ 0 THEN BEGIN
     PRINT,"Restoring " + DB_Brett + "..."
     IF FILE_TEST(DBDir+DB_Brett) THEN RESTORE,DBDir+DB_Brett
     IF stormStruct EQ !NULL THEN BEGIN
        PRINT,"Couldn't load Brett's stormStruct!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a stormStruct loaded! Not loading " + DB_Brett
  ENDELSE

  IF N_ELEMENTS(SSC1) EQ 0 OR N_ELEMENTS(SSC2) EQ 0 THEN BEGIN
     PRINT,"Restoring " + DB_NOAA + "..."
     IF FILE_TEST(DBDir+DB_NOAA) THEN RESTORE,DBDir+DB_NOAA
     IF SSC1 EQ !NULL OR SSC2 EQ !NULL THEN BEGIN
        PRINT,"Couldn't load NOAA storm sudden commencement DB 1/2!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"NOAA storm sudden commencement DBs already loaded! Not loading " + DB_NOAA
  ENDELSE

  IF N_ELEMENTS(qi) EQ 0 THEN BEGIN
     PRINT,"Restoring " + Inds_File + "..."
     IF FILE_TEST(DBDir+Inds_File) THEN RESTORE,DBDir+Inds_File
     IF qi EQ !NULL THEN BEGIN
        PRINT,"Couldn't load indices for four storm quadrants!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"qi (four-storm-quadrant indices) already loaded! Not loading " + Inds_File
  ENDELSE

  RESTORE,DBDIR+inds_file

END