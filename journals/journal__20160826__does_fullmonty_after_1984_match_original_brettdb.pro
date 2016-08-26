;2016/08/26
PRO JOURNAL__20160826__DOES_FULLMONTY_AFTER_1984_MATCH_ORIGINAL_BRETTDB

  COMPILE_OPT idl2

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,/FULLMONTY_BRETTDB
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct2

  nFull  = N_ELEMENTS(stormStruct.storm )
  nBull  = N_ELEMENTS(stormStruct2.storm)

  f1985  = WHERE(stormStruct.year  GE 1985,nF1985,NCOMPLEMENT=nFBef1985)
  b1985  = WHERE(stormStruct2.year GE 1985,nB1985,NCOMPLEMENT=nBBef1985)

  fFirst = MIN(f1985)
  bFirst = MIN(b1985)
  
  IF (nFull-nFBef1985) NE nBull THEN BEGIN
     PRINT,"Why doesn't # of storms in each DB match after 1985?"
     STOP
  ENDIF

  tDiff  = stormStruct.time[f1985] - stormStruct2.time[b1985]

  IF (WHERE(ABS(tDiff) GT 0.001))[0] EQ -1 THEN BEGIN
     PRINT,"That is so magical. It is so rare to have things line up."
  ENDIF ELSE BEGIN
     PRINT,"Just like always. There always needs to be a problem to keep some sadist somewhere happy."
  ENDELSE

END