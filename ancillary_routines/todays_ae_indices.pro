;2016/01/01
FUNCTION TODAYS_AE_INDICES, $
   DESPUN_ALFDB=despun_AlfDB, $
   FOR_ALFVENDB=for_AlfvenDB, $
   FOR_FASTLOC=for_fastLoc, $
   FOR_ESPECDB=for_eSpecDB, $
   FOR_IONDB=for_ionDB, $
   FOR_OMNIDB=for_OMNIDB, $
   AE_STR=AE_str, $
   AECUTOFF=AECutoff, $
   SMOOTH_AE=smooth_AE, $
   SUFFIX=suffix, $
   LOAD_MOST_RECENT=most_recent

  COMPILE_OPT idl2

  IF N_ELEMENTS(suffix) EQ 0 THEN suffix = ''

  smoothStr            = ''
  IF KEYWORD_SET(smooth_AE) THEN BEGIN
     smoothStr         = '--smAE'
  ENDIF

  CASE 1 OF
     KEYWORD_SET(for_AlfvenDB): BEGIN
        dbNavn         = 'alfDB' + $
                         (KEYWORD_SET(despun_AlfDB) ? '--despun' : '')
     END
     KEYWORD_SET(for_fastLoc): BEGIN
        dbNavn         = 'fastLoc'
     END
     KEYWORD_SET(for_OMNI): BEGIN
        dbNavn         = 'OMNI'
     END
     KEYWORD_SET(for_eSpecDB): BEGIN
        dbNavn         = 'eSpecDB'
     END
     KEYWORD_SET(for_ionDB): BEGIN
        dbNavn         = 'ionDB'
     END
  ENDCASE

  indDir           = '/SPENCEdata/Research/database/temps/'

  mostRecent_bash  = indDir + 'mostRecent_' + dbNavn + '_' + AE_str + '_inds.txt'
  IF KEYWORD_SET(most_recent) THEN BEGIN
     SPAWN,'cat ' + mostRecent_bash,todaysFile
  ENDIF ELSE BEGIN
     filePref      = 'todays_' + AE_str + '_' $
                     + dbNavn + '_inds--AECutoff_' + $
                     STRCOMPRESS(AEcutoff,/REMOVE_ALL) + "nT"

     hoyDia        = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
     todaysFile    = indDir+filePref+smoothStr+suffix'--'+hoyDia+'.sav'
     SPAWN,'echo "' + todaysFile + '" >>' + mostRecent_bash
  ENDELSE

  RETURN,todaysFile

END