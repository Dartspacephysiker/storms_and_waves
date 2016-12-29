;2016/01/01
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES, $
   DESPUN_ALFDB=despun_AlfDB, $
   FOR_ALFVENDB=for_AlfvenDB, $
   FOR_FASTLOC=for_fastLoc, $
   FOR_ESPECDB=for_eSpecDB, $
   UPGOING_ESPEC=upgoing_eSpec, $
   FOR_IONDB=for_ionDB, $
   DOWNGOING_ION=downgoing_ion, $
   FOR_OMNIDB=for_OMNIDB, $
   FASTLOC_FOR_ESPEC=for_eSpec_DBs, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   DSTCUTOFF=dstCutoff, $
   SMOOTH_DST=smooth_dst, $
   USE_MOSTRECENT_DST_FILES=most_recent, $
   SUFFIX=suffix


  COMPILE_OPT idl2

  IF N_ELEMENTS(suffix) EQ 0 THEN suffix = ''

  smoothStr            = ''
  IF KEYWORD_SET(smooth_dst) THEN BEGIN
     IF smooth_dst EQ 1 THEN BEGIN
        smoothStr      = '--smDst'
     ENDIF ELSE BEGIN
        smoothStr      = '--smDst_'+STRCOMPRESS(smooth_dst,/REMOVE_ALL)+'hr'
     ENDELSE   
  ENDIF

  CASE 1 OF
     KEYWORD_SET(for_AlfvenDB): BEGIN
        dbNavn         = 'alfDB' + $
                         (KEYWORD_SET(despun_AlfDB) ? '--despun' : '')
     END
     KEYWORD_SET(for_fastLoc): BEGIN
        dbNavn         = 'fastLoc'
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           dbNavn += '--for_eSpec'
        ENDIF
     END
     KEYWORD_SET(for_OMNIDB): BEGIN
        dbNavn         = 'OMNI'

        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           dbNavn += '--for_eSpec'
        ENDIF
     END
     KEYWORD_SET(for_eSpecDB): BEGIN
        dbNavn         = (KEYWORD_SET(upgoing_eSpec) ? 'up_' : '') + $
                         'eSpecDB'
     END
     KEYWORD_SET(for_ionDB): BEGIN
        dbNavn         = (KEYWORD_SET(downgoing_ion) ? 'down_' : '') + $
                         'ionDB'
     END
  ENDCASE

  CASE 1 OF
     KEYWORD_SET(disregard_sample_t): BEGIN
        dbNavn += '--disregard_sample_t'
     END
     (KEYWORD_SET(include_32Hz) AND $
     (KEYWORD_SET(for_AlfvenDB) OR KEYWORD_SET(for_fastLoc))): BEGIN
        dbNavn += '--inc_32Hz'
     END
     KEYWORD_SET(sample_t_restriction): BEGIN
        dbNavn += 'sampT_restr_' + STRCOMPRESS(sample_t_restriction,/REMOVE_ALL)
     END
     ELSE:
  ENDCASE

  indDir           = '/SPENCEdata/Research/database/temps/'

  mostRecent_bash  = indDir + 'mostRecent_'+dbNavn + '--' + 'dstCutoff_' + $
                     STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT" + smoothStr + suffix + '_ns_mp_rp_inds.txt'

  IF KEYWORD_SET(most_recent) THEN BEGIN
     IF FILE_TEST(mostRecent_bash) THEN BEGIN
        SPAWN,'cat ' + mostRecent_bash,todaysFile
        makeNew    = 0
     ENDIF ELSE BEGIN
        PRINT,"Couldn't get most recent " + dbNavn + " ns_mp_rp file! Making new ..."
        makeNew    = 1
     ENDELSE
  ENDIF ELSE makeNew = 1

  IF makeNew THEN BEGIN
     filePref      = 'todays_nonstorm_mainphase_and_recoveryphase_' $
                     + dbNavn + '_inds--dstCutoff_' + $
                     STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT"

     hoyDia        = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
     todaysFile    = indDir+filePref+smoothStr+suffix + '--'+hoyDia+'.sav'
     SPAWN,'echo "' + todaysFile + '" >' + mostRecent_bash
  ENDIF

  RETURN,todaysFile

END