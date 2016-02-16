;2016/02/17
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTLOC_INDICES, $
   STORMSTRING=stormString, $
   DSTCUTOFF=DstCutoff

  indDir               = '/SPENCEdata/Research/Cusp/database/temps/'
  filePref             = 'todays_' + stormString + '_fastLoc_inds--Dstcutoff_' + STRCOMPRESS(DstCutoff,/REMOVE_ALL) + '--'
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+hoyDia+'.sav'

  RETURN,todaysFile

END