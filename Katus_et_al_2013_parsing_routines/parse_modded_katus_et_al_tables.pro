;2017/11/30
PRO ADD_EARLY_AND_LATE_MP_AND_RP_TO_KATUS_STRUCT,katus

  mpHalf = (katus.mp.utc   + katus.peak.utc)/2.D
  rpHalf = (katus.peak.utc + katus.rp.utc  )/2.D

  mpHalf = {utc    : mpHalf     , $
            string : T2S(mpHalf)}
  rpHalf = {utc    : rpHalf     , $
            string : T2S(rpHalf)}
  
  mp     = CREATE_STRUCT('utc'   ,katus.mp.utc   , $
                         'string',katus.mp.string, $
                         'len'   ,katus.mp.len   , $
                         'half'  ,mpHalf         , $
                         'stats' ,katus.mp.stats )
  rp     = CREATE_STRUCT('utc'   ,katus.rp.utc   , $
                         'string',katus.rp.string, $
                         'len'   ,katus.rp.len   , $
                         'half'  ,rpHalf         , $
                         'stats' ,katus.rp.stats )

  katus = CREATE_STRUCT('date'  ,katus.date  , $
                        'dstmin',katus.dstmin, $
                        'init'  ,katus.init  , $
                        'mp'    ,mp          , $
                        'peak'  ,katus.peak  , $
                        'rp'    ,rp          )



END

PRO PARSE_MODDED_KATUS_ET_AL_TABLES

  COMPILE_OPT IDL2,STRICTARRSUBS

  dir = '/SPENCEdata/Research/database/storm_data/processed/katus_et_al_2013__normalized_storm_phases/'
  intenseFil = '2012JA017915R_AUXtable1_mod.txt'
  moderatFil = '2012JA017915R_AUXtable2_mod.txt'

  outFil     = 'katus_IDL_structs.sav'
  tmpltFil   = 'katus_modded_table_idl_ASCII_tmplt.sav'

  process_storms_we_dont_have = 1

  ;; Do we have the ASCII template?
  haveTmplt  = 0
  IF FILE_TEST(dir+tmpltFil) THEN BEGIN
     RESTORE,dir+tmpltFil
     haveTmplt = N_ELEMENTS(tmplt) GT 0
  ENDIF

  IF ~haveTmplt THEN BEGIN
     tmplt   = ASCII_TEMPLATE(dir+intenseFil)
     PRINT,"Saving ASCII template to " + tmpltFil + ' ...'
     SAVE,tmplt,FILENAME=dir+tmpltFil
  ENDIF


  CASE 1 OF
     KEYWORD_SET(process_storms_we_dont_have): BEGIN

        missingFil    = 'katus_storms_not_covered_by_electron_DB__after_orbit_24634.txt'
        missingOutFil = 'katus_noHave_after_FASTorb24634.sav'
        startLine     = 30
        IF ~FILE_TEST(dir+missingFil) THEN STOP

        katus = READ_ASCII(dir+missingFil,TEMPLATE=tmplt,DATA_START=startLine)

        katusTmp = {date   : {utc    : S2T(katus.date)                , $
                                 string : katus.date     }               , $
                       DstMin : katus.DstMin                             , $ 
                       init   : {utc    : S2T(katus.init)                , $
                                 string : katus.init                     , $
                                 len    : katus.ipLen                    , $
                                 stats  : {mean   : MEAN  (katus.ipLen)  , $
                                           median : MEDIAN(katus.ipLen)  , $
                                           mode   : MODE  (katus.ipLen)  , $
                                           stddev : STDDEV(katus.ipLen)}}, $
                       mp     : {utc    : S2T(katus.mp  )                , $
                                 string : katus.mp                       , $
                                 len    : katus.mpLen                    , $
                                 stats  : {mean   : MEAN  (katus.mpLen)  , $
                                           median : MEDIAN(katus.mpLen)  , $
                                           mode   : MODE  (katus.mpLen)  , $
                                           stddev : STDDEV(katus.mpLen)}}, $
                       peak   : {utc    : S2T(katus.peak)                , $
                                 string : katus.peak     }               , $
                       rp     : {utc    : S2T(katus.rp  )                , $
                                 string : katus.rp                       , $
                                 len    : katus.rpLen                    , $
                                 stats  : {mean   : MEAN  (katus.rpLen)  , $
                                           median : MEDIAN(katus.rpLen)  , $
                                           mode   : MODE  (katus.rpLen)  , $
                                           stddev : STDDEV(katus.rpLen)}}}

        katus = TEMPORARY(katusTmp)

        PRINT,"Saving missing storm struct to " + missingOutFil + ' ...'
        SAVE,katus,FILENAME=dir+missingOutFil

     END
     ELSE: BEGIN

        IF ~(FILE_TEST(dir+intenseFil) AND FILE_TEST(dir+moderatFil)) THEN STOP

        katusInt = READ_ASCII(dir+intenseFil,TEMPLATE=tmplt)
        katusMod = READ_ASCII(dir+moderatFil,TEMPLATE=tmplt)


        katusIntTmp = {date   : {utc    : S2T(katusInt.date)                , $
                                 string : katusInt.date     }               , $
                       DstMin : katusInt.DstMin                             , $ 
                       init   : {utc    : S2T(katusInt.init)                , $
                                 string : katusInt.init                     , $
                                 len    : katusInt.ipLen                    , $
                                 stats  : {mean   : MEAN  (katusInt.ipLen)  , $
                                           median : MEDIAN(katusInt.ipLen)  , $
                                           mode   : MODE  (katusInt.ipLen)  , $
                                           stddev : STDDEV(katusInt.ipLen)}}, $
                       mp     : {utc    : S2T(katusInt.mp  )                , $
                                 string : katusInt.mp                       , $
                                 len    : katusInt.mpLen                    , $
                                 stats  : {mean   : MEAN  (katusInt.mpLen)  , $
                                           median : MEDIAN(katusInt.mpLen)  , $
                                           mode   : MODE  (katusInt.mpLen)  , $
                                           stddev : STDDEV(katusInt.mpLen)}}, $
                       peak   : {utc    : S2T(katusInt.peak)                , $
                                 string : katusInt.peak     }               , $
                       rp     : {utc    : S2T(katusInt.rp  )                , $
                                 string : katusInt.rp                       , $
                                 len    : katusInt.rpLen                    , $
                                 stats  : {mean   : MEAN  (katusInt.rpLen)  , $
                                           median : MEDIAN(katusInt.rpLen)  , $
                                           mode   : MODE  (katusInt.rpLen)  , $
                                           stddev : STDDEV(katusInt.rpLen)}}}

        katusModTmp = {date   : {utc    : S2T(katusMod.date)                , $
                                 string : katusMod.date     }               , $
                       DstMin : katusMod.DstMin                             , $ 
                       init   : {utc    : S2T(katusMod.init)                , $
                                 string : katusMod.init                     , $
                                 len    : katusMod.ipLen                    , $
                                 stats  : {mean   : MEAN  (katusMod.ipLen)  , $
                                           median : MEDIAN(katusMod.ipLen)  , $
                                           mode   : MODE  (katusMod.ipLen)  , $
                                           stddev : STDDEV(katusMod.ipLen)}}, $
                       mp     : {utc    : S2T(katusMod.mp  )                , $
                                 string : katusMod.mp                       , $
                                 len    : katusMod.mpLen                    , $
                                 stats  : {mean   : MEAN  (katusMod.mpLen)  , $
                                           median : MEDIAN(katusMod.mpLen)  , $
                                           mode   : MODE  (katusMod.mpLen)  , $
                                           stddev : STDDEV(katusMod.mpLen)}}, $
                       peak   : {utc    : S2T(katusMod.peak)                , $
                                 string : katusMod.peak     }               , $
                       rp     : {utc    : S2T(katusMod.rp  )                , $
                                 string : katusMod.rp                       , $
                                 len    : katusMod.rpLen                    , $
                                 stats  : {mean   : MEAN  (katusMod.rpLen)  , $
                                           median : MEDIAN(katusMod.rpLen)  , $
                                           mode   : MODE  (katusMod.rpLen)  , $
                                           stddev : STDDEV(katusMod.rpLen)}}}

        katusInt = TEMPORARY(katusIntTmp)
        katusMod = TEMPORARY(katusModTmp)

        tmpDates = [katusInt.date.utc,katusMod.date.utc]
        sort_i   = SORT(tmpDates)

        katusCom = {date   : {utc    : ([katusInt.date.utc   ,katusMod.date.utc   ])[sort_i]    , $
                              string : ([katusInt.date.string,katusMod.date.string])[sort_i]}   , $
                    DstMin :              ([katusInt.DstMin  ,katusMod.DstMin     ])[sort_i]    , $ 
                    init   : {utc    : ([katusInt.init.utc   ,katusMod.init.utc   ])[sort_i]    , $
                              string : ([katusInt.init.string,katusMod.init.string])[sort_i]    , $
                              len    : ([katusInt.init.len   ,katusMod.init.len   ])[sort_i]    , $
                              stats  : {mean   : MEAN  ([katusInt.init.len,katusMod.init.len])  , $
                                        median : MEDIAN([katusInt.init.len,katusMod.init.len])  , $
                                        mode   : MODE  ([katusInt.init.len,katusMod.init.len])  , $
                                        stddev : STDDEV([katusInt.init.len,katusMod.init.len])}}, $
                    mp     : {utc    : ([katusInt.mp.utc   ,katusMod.mp.utc   ])[sort_i]        , $
                              string : ([katusInt.mp.string,katusMod.mp.string])[sort_i]        , $
                              len    : ([katusInt.mp.len   ,katusMod.mp.len   ])[sort_i]        , $
                              stats  : {mean   : MEAN  ([katusInt.mp.len,katusMod.mp.len])      , $
                                        median : MEDIAN([katusInt.mp.len,katusMod.mp.len])      , $
                                        mode   : MODE  ([katusInt.mp.len,katusMod.mp.len])      , $
                                        stddev : STDDEV([katusInt.mp.len,katusMod.mp.len])}}    , $
                    peak   : {utc    : ([katusInt.peak.utc   ,katusMod.peak.utc   ])[sort_i]    , $
                              string : ([katusInt.peak.string,katusMod.peak.string])[sort_i]}       , $
                    rp     : {utc    : ([katusInt.rp.utc   ,katusMod.rp.utc   ])[sort_i]    , $
                              string : ([katusInt.rp.string,katusMod.rp.string])[sort_i]    , $
                              len    : ([katusInt.rp.len   ,katusMod.rp.len   ])[sort_i]    , $
                              stats  : {mean   : MEAN  ([katusInt.rp.len,katusMod.rp.len])  , $
                                        median : MEDIAN([katusInt.rp.len,katusMod.rp.len])  , $
                                        mode   : MODE  ([katusInt.rp.len,katusMod.rp.len])  , $
                                        stddev : STDDEV([katusInt.rp.len,katusMod.rp.len])}}}

        ADD_EARLY_AND_LATE_MP_AND_RP_TO_KATUS_STRUCT,katusInt
        ADD_EARLY_AND_LATE_MP_AND_RP_TO_KATUS_STRUCT,katusMod
        ADD_EARLY_AND_LATE_MP_AND_RP_TO_KATUS_STRUCT,katusCom

        PRINT,"Saving intense and moderate structs to " + outFil + ' ...'
        SAVE,katusInt,katusMod,katusCom,FILENAME=dir+outFil

     END
  ENDCASE

  STOP

END
