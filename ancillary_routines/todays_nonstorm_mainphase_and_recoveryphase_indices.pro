;2016/01/01
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_INDICES, $
   DESPUN_ALFDB=despun_AlfDB, $
   FOR_ALFVENDB=for_AlfvenDB, $
   FOR_FASTLOC=for_fastLoc, $
   FOR_ESPECDB=for_eSpecDB, $
   UPGOING_ESPEC=upgoing_eSpec, $
   FOR_IONDB=for_ionDB, $
   DOWNGOING_ION=downgoing_ion, $
   FOR_SWAYDB=for_sWayDB, $
   FOR_OMNIDB=for_OMNIDB, $
   FASTLOC_FOR_ESPEC=for_eSpec_DBs, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   DSTCUTOFF=dstCutoff, $
   SMOOTH_DST=smooth_dst, $
   USE_MOSTRECENT_DST_FILES=most_recent, $
   USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
   SUFFIX=suffix


  COMPILE_OPT IDL2,STRICTARRSUBS

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
     KEYWORD_SET(for_sWayDB): BEGIN
        dbNavn         = 'sWayDB'
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

  katusfPref       = ''
  katusStr         = ''
  dstCutoffFPref   = '--dstCutoff_' + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT" + smoothStr
  IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN
     katusfPref    = STRING(FORMAT='(A0,I1,"_")',"katus",use_katus_storm_phases)
     katusStr      = STRING(FORMAT='(A0,I1," ")',"Katus",use_katus_storm_phases)
     dstCutofffPref= ''
  ENDIF
  mostRecent_bash  = indDir + 'mostRecent_'+katusfPref+dbNavn + dstCutoffFPref + suffix + '_ns_mp_rp_inds.txt'

  IF KEYWORD_SET(most_recent) THEN BEGIN
     IF FILE_TEST(mostRecent_bash) THEN BEGIN
        SPAWN,'cat ' + mostRecent_bash,todaysFile
        makeNew    = 0
     ENDIF ELSE BEGIN
        PRINT,"Couldn't get most recent " + katusStr + dbNavn + " ns_mp_rp file! Making new ..."
        makeNew    = 1
     ENDELSE
  ENDIF ELSE makeNew = 1

  IF makeNew THEN BEGIN
     filePref      = 'todays_nonstorm_mainphase_and_recoveryphase_' $
                     + katusfPref $
                     + dbNavn + '_inds'

     hoyDia        = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
     todaysFile    = indDir+filePref+dstCutoffFPref+suffix + '--'+hoyDia+'.sav'
     SPAWN,'echo "' + todaysFile + '" >' + mostRecent_bash
  ENDIF

  RETURN,todaysFile

END
