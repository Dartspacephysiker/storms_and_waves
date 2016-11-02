;2016/02/17
FUNCTION TODAYS_AE_FASTLOC_INDICES, $
   AE_STR=AE_str, $
   AECUTOFF=AEcutoff, $
   SMOOTH_AE=smooth_AE

  indDir               = '/SPENCEdata/Research/database/temps/'

  smoothStr            = ''
  IF KEYWORD_SET(smooth_AE) THEN BEGIN
     smoothStr         = '--smAE'
  ENDIF

  CASE KEYWORD_SET(AE_str) OF
     1: BEGIN
        filePref       = 'todays_' + AE_str + '_fastLoc_inds--AEcutoff_' + STRCOMPRESS(AEcutoff,/REMOVE_ALL)
     END
     ELSE: BEGIN
        filePref       = 'todays__fastLoc_inds--AEcutoff_' + STRCOMPRESS(AEcutoff,/REMOVE_ALL)
     END
  ENDCASE

  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+smoothStr+'--'+hoyDia+'.sav'

  RETURN,todaysFile

END