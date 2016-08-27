;;08/26/16
FUNCTION GET_DST_STATISTICS_FROM_STORMSTRUCT_V2,stormStruct, $
   storm_i, $
   BPD__DSTMIN_OUTLIERS=BPDMinOutliers, $
   BPD__DSTDROP_OUTLIERS=BPDDropOutliers, $
   BPD__DSTMIN_SUSPECTED_OUTLIERS=BPDMinSusOutliers, $
   BPD__DSTDROP_SUSPECTED_OUTLIERS=BPDDropSusOutliers

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
                                         OUTLIER_VALUES=BPDMinOutliers, $
                                         SUSPECTED_OUTLIER_VALUES=BPDMinSusOutliers)
  ENDIF ELSE BEGIN
     DstMinBPD       = MAKE_ARRAY(1,5,VALUE=0)
     ;; BPDMinMean      = 0
     ci_minVals      = MAKE_ARRAY(2,VALUE=0)
     BPDMinMean      = 0
     BPDMinOutliers  = 0
  ENDELSE

  DstMinMom       = MOMENT(stormStruct.Dst[storm_i])

  tmpExtra        =  {ci_values   : ci_minVals, $
                      mean_values : BPDMinMean}

  CASE 1 OF
     (N_ELEMENTS(BPDMinOutliers) GT 0) AND $
        (N_ELEMENTS(BPDMinSusOutliers) GT 0): BEGIN
        tmpExtra    = CREATE_STRUCT(tmpExtra, $
                                  "OUTLIER_VALUES",BPDMinOutliers, $
                                  "SUSPECTED_OUTLIER_VALUES",BPDMinSusOutliers)
                                  
     END
     (N_ELEMENTS(BPDMinOutliers) GT 0): BEGIN
        tmpExtra   = CREATE_STRUCT(tmpExtra, $
                                  "OUTLIER_VALUES",BPDMinOutliers)

     END
     (N_ELEMENTS(BPDMinSusOutliers) GT 0): BEGIN
        tmpExtra   = CREATE_STRUCT(tmpExtra, $
                                  "SUSPECTED_OUTLIER_VALUES",BPDMinSusOutliers)
     END
     ELSE: 
  ENDCASE

  tmpBPD          = {data    : DstMinBPD, $
                     bad     : ~include_BPD, $
                     extras  : tmpExtra}

  Dstmin          = {BPD     : tmpBPD, $
                     mom     : DstMinMom, $
                     name    : "Dst minimum (nT)"}


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DstDrop statistics
  IF include_BPD THEN BEGIN
     DstDropBPD      = CREATEBOXPLOTDATA(stormStruct.drop_in_Dst[storm_i], $
                                         CI_VALUES=ci_dropVals, $
                                         MEAN_VALUES=BPDDropMean, $
                                         OUTLIER_VALUES=BPDDropOutliers, $
                                         SUSPECTED_OUTLIER_VALUES=BPDDropSusOutliers)
  ENDIF ELSE BEGIN
     DstDropBPD       = MAKE_ARRAY(1,5,VALUE=0)
     ci_DropVals      = MAKE_ARRAY(2,VALUE=0)
     BPDDropMean      = 0
     BPDDropOutliers  = 0
  ENDELSE
  DstDropMom      = MOMENT(stormStruct.drop_in_Dst[storm_i])

  tmpExtra        =  {ci_values   : ci_DropVals, $
                      mean_values : BPDDropMean}

  CASE 1 OF
     (N_ELEMENTS(BPDDropOutliers) GT 0) AND $
        (N_ELEMENTS(BPDDropSusOutliers) GT 0): BEGIN
        tmpExtra    = CREATE_STRUCT(tmpExtra, $
                                  "OUTLIER_VALUES",BPDDropOutliers, $
                                  "SUSPECTED_OUTLIER_VALUES",BPDDropSusOutliers)
                                  
     END
     (N_ELEMENTS(BPDDropOutliers) GT 0): BEGIN
        tmpExtra   = CREATE_STRUCT(tmpExtra, $
                                  "OUTLIER_VALUES",BPDDropOutliers)

     END
     (N_ELEMENTS(BPDDropSusOutliers) GT 0): BEGIN
        tmpExtra   = CREATE_STRUCT(tmpExtra, $
                                  "SUSPECTED_OUTLIER_VALUES",BPDDropSusOutliers)
     END
     ELSE: 
  ENDCASE

  tmpBPD          = {data    : DstDropBPD, $
                     bad     : ~include_BPD, $
                     extras  : tmpExtra}


  DstDrop          = {BPD     : tmpBPD, $
                      mom     : DstDropMom, $
                      name    : "Dst drop (nT)"}

  RETURN,LIST(Dstmin,DstDrop)

END
