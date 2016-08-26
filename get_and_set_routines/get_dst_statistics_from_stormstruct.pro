;;08/26/16
FUNCTION GET_DST_STATISTICS_FROM_STORMSTRUCT,stormStruct, $
   storm_i, $
   ;; BPD__DSTMIN_MEAN=BPDMinMean, $
   BPD__DSTMIN_OUTLIERS=BPDMinOutliers, $
   ;; BPD__DSTDROP_MEAN=BPDDropMean, $
   BPD__DSTDROP_OUTLIERS=BPDDropOutliers
  ;; RESTRICT_WITH_THESE_I=restrict_i

  COMPILE_OPT IDL2

  IF N_ELEMENTS(storm_i) GE 5 THEN BEGIN
     include_BPD = 1 
  ENDIF ELSE BEGIN
     include_BPD = 0
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DstMin statistics
  IF include_BPD THEN BEGIN
     DstMinBPD       = CREATEBOXPLOTDATA(stormStruct.Dst[storm_i], $
                                         CI_VALUES=ci_minVals, $
                                         MEAN_VALUES=BPDMinMean, $
                                         OUTLIER_VALUES=BPDMinOutliers)
  ENDIF ELSE BEGIN
     DstMinBPD       = MAKE_ARRAY(1,5,VALUE=0)
     ;; BPDMinMean      = 0
     ci_minVals      = MAKE_ARRAY(2,VALUE=0)
     BPDMinOutliers  = 0
  ENDELSE

  DstMinMom       = MOMENT(stormStruct.Dst[storm_i])

  ;; Dstmin          = {BPD     : {data     : DstMinBPD, $
  ;;                               meanVals : BPDMinMean, $
  ;;                               outliers : BPDMinOutliers}, $
  ;;                    moments : DstMinMom, $
  ;;                    name    : "Dst minimum (nT)"}
  Dstmin          = {BPD     : DstMinBPD, $
                     ci_BPD  : ci_minVals, $
                     mom     : DstMinMom, $
                     badBPD  : ~include_BPD, $
                     name    : "Dst minimum (nT)"}


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DstDrop statistics
  IF include_BPD THEN BEGIN
     DstDropBPD      = CREATEBOXPLOTDATA(stormStruct.drop_in_Dst[storm_i], $
                                         CI_VALUES=ci_dropVals, $
                                         MEAN_VALUES=BPDDropMean, $
                                         OUTLIER_VALUES=BPDDropOutliers)
  ENDIF ELSE BEGIN
     DstDropBPD       = MAKE_ARRAY(1,5,VALUE=0)
     ;; BPDDropMean      = 0
     ci_DropVals      = MAKE_ARRAY(2,VALUE=0)
     BPDDropOutliers  = 0
  ENDELSE
  DstDropMom      = MOMENT(stormStruct.drop_in_Dst[storm_i])

  ;; DstDrop          = {BPD     : {data    : DstDropBPD, $
  ;;                               meanVals : BPDDropMean, $
  ;;                               outliers : BPDDropOutliers}, $
  ;;                     moments : DstMinMom, $
  ;;                     name    : "Dst drop (nT)"}
  DstDrop          = {BPD     : DstDropBPD, $
                     ci_BPD  : ci_dropVals, $
                      mom     : DstDropMom, $
                      badBPD  : ~include_BPD, $
                      name    : "Dst drop (nT)"}

  RETURN,LIST(Dstmin,DstDrop)

END
