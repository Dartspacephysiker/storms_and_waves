;2017/12/01
PRO FUNK,newell__espec,name,ilats,mlts,plotDir

  noSpot = WHERE((newell__espec.diffuse EQ 1 OR $
                 newell__espec.diffuse EQ 2) AND $
                ( newell__espec.mlt  GE mlts[0]) AND $
                ( newell__espec.mlt  LE mlts[1]) AND $
                ( newell__espec.ilat GE ilats[0]) AND $
                ( newell__espec.ilat LE ilats[1]))
                
  ilatStrs = STRING(FORMAT='(F0.2)',ilats)
  mltStrs  = STRING(FORMAT='(F0.2)',mlts )

  CGHISTOPLOT,newell__espec.jee[noSpot], $
              TITLE=STRING(FORMAT='(A0,A0,",",A0,A0,A0,",",A0,A0)', $
                           'DIFFUSE JEE ([', $
                           ilatStrs[0],ilatStrs[1], $
                           '] ILAT; [', $
                           mltStrs[0],mltStrs[1], $
                           '] MLT)'), $
              OUTPUT=plotDir+name+'_diffJee_histo__' + ilatStrs[0] + $
              '_' + ilatStrs[1] + '_ILAT__' + mltStrs[0] + '_' + $
              mltStrs[1] + '_MLT.png'

  CGHISTOPLOT,ALOG10(newell__espec.jee[noSpot]), $
              TITLE=STRING(FORMAT='(A0,A0,",",A0,A0,A0,",",A0,A0)', $
                           'DIFFUSE JEE ([', $
                           ilatStrs[0],ilatStrs[1], $
                           '] ILAT; [', $
                           mltStrs[0],mltStrs[1], $
                           '] MLT)'), $
              OUTPUT=plotDir+name+'diffJee_histo__' + ilatStrs[0] + $
              '_' + ilatStrs[1] + '_ILAT__' + mltStrs[0] + '_' + $
              mltStrs[1] + '_MLT.png', $
              MININPUT=-3.5,MAXINPUT=1.2

  noOrbs = (newell__espec.orbit[noSpot])[UNIQ(newell__espec.orbit[noSpot])]
  nNo = N_ELEMENTS(noOrbs)

  nNo = N_ELEMENTS(noOrbs)
  print,name+" Orbs"

  FOR k=0,nNo-1 DO BEGIN
     ;; PRINT,noOrbs[k]
     this_ii = WHERE(newell__eSpec.orbit[noSpot] EQ noOrbs[k],nTmp)
     tmpI    = noSpot[this_ii]
     PRINT,FORMAT='(I3,T5,I5,T12,I5,T20,G0.3,T30,G0.3,T40,G0.3)', $
           k, $
           noOrbs[k], $
           nTmp, $
           MEAN(newell__eSpec.jee[tmpI]), $
           MEDIAN(newell__espec.jee[tmpI]), $
           STDDEV(newell__espec.jee[tmpI])
  ENDFOR
END

PRO JOURNAL__20171201__CHECK_SOME_SPOTS_WITH_HUGE_FLUXES

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__newell_espec.pro

  plotDir = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/plots/20171201/'

  ;; large spot between 60,62 ILAT and 11.5,12 MLT

  name = 'bigSpot'
  ilats = [60.0,60.5]
  mlts  = [11.5,11.75]

  funk,newell__espec,name,ilats,mlts,plotDir

  ;; not spot between 60,62 ILAT and 10.5,11 MLT
  ;; Badness: orbit 12296
  ;; Maybe bad : 12307
  name = 'NoSpot'
  ilats = [60.0,60.5]
  mlts  = [11.25,11.5]

  funk,newell__espec,name,ilats,mlts,plotDir


END
