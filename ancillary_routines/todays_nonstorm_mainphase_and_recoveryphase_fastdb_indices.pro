;2016/01/01
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES,DO_DESPUN=do_despun, $
   DSTCUTOFF=dstCutoff


  indDir               = '/SPENCEdata/Research/Cusp/database/temps/'
  filePref             = 'todays_nonstorm_mainphase_and_recoveryphase_fastdb_inds--dstCutoff_' + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT" + $
                         (KEYWORD_SET(do_despun) ? '--despun' : '')
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+hoyDia+'.sav'

  RETURN,todaysFile

END