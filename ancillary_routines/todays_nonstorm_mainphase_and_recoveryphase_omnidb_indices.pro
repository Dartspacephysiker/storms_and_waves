;2016/08/19
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES, $
   DSTCUTOFF=dstCutoff


  indDir               = '/SPENCEdata/Research/database/temps/'
  filePref             = 'todays_nonstorm_mainphase_and_recoveryphase_OMNIdb_inds--' + $
                         'dstCutoff_' + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT"
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+hoyDia+'.sav'

  RETURN,todaysFile

END