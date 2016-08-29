;;08/29/16
FUNCTION GET_STORMRATIO_STATISTICS_FROM_STORMRATIOSTRUCT,stormRatStruct, $
   ;; BPD__STORMRAT_OUTLIERS=BPDsRatOutliers, $
   ;; BPD__STORMRAT_SUSPECTED_OUTLIERS=BPDsRatSusOutliers, $
   ADD_TO_STRUCT=add_to_struct

  COMPILE_OPT IDL2

  ;; IF N_ELEMENTS(storm_i) GE 5 THEN BEGIN
  IF stormRatStruct.nIntervals GE 5 THEN BEGIN
     include_BPD      = 1 
  ENDIF ELSE BEGIN
     include_BPD      = 0
  ENDELSE

  ;; nLoop            = 3 ;Quiescent, Main, Recovery
  nRat                = N_ELEMENTS(stormRatStruct.nsRatio)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;StormRatio statistics
  IF include_BPD THEN BEGIN
     ;; stormRatBPD      = CREATEBOXPLOTDATA(TRANSPOSE([[stormRatStruct.nsRatio], $
     ;;                                                 [stormRatStruct.mpRatio],$
     ;;                                                 [stormRatStruct.rpRatio]]), $
     ;;                                      CI_VALUES=ci_ratVals, $
     ;;                                      MEAN_VALUES=BPDsRatMean, $
     ;;                                      OUTLIER_VALUES=BPDsRatOutliers, $
     ;;                                      SUSPECTED_OUTLIER_VALUES=BPDsRatSusOutliers)
     stormRatBPD      = CREATEBOXPLOTDATA(TRANSPOSE([[stormRatStruct.mpRatio],$
                                                     [stormRatStruct.rpRatio], $
                                                     [stormRatStruct.nsRatio]]), $
                                          CI_VALUES=ci_ratVals, $
                                          MEAN_VALUES=BPDsRatMean, $
                                          OUTLIER_VALUES=BPDsRatOutliers, $
                                          SUSPECTED_OUTLIER_VALUES=BPDsRatSusOutliers)
  ENDIF ELSE BEGIN
     stormRatBPD      = MAKE_ARRAY(3,5,VALUE=0)
     ;; BPDsRatMean   = 0
     ci_ratVals       = MAKE_ARRAY(3,VALUE=0)
     BPDsRatMean      = [0,0,0]
     BPDsRatOutliers  = [0,0,0]
  ENDELSE

  tmpExtra            =  {ci_values   : ci_ratVals, $
                          mean_values : BPDsRatMean}

  CASE 1 OF
     (N_ELEMENTS(BPDsRatOutliers) GT 0) AND $
        (N_ELEMENTS(BPDsRatSusOutliers) GT 0): BEGIN
        tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                      "OUTLIER_VALUES",BPDsRatOutliers, $
                                      "SUSPECTED_OUTLIER_VALUES",BPDsRatSusOutliers)
        
     END
     (N_ELEMENTS(BPDsRatOutliers) GT 0): BEGIN
        tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                      "OUTLIER_VALUES",BPDsRatOutliers)

     END
     (N_ELEMENTS(BPDsRatSusOutliers) GT 0): BEGIN
        tmpExtra      = CREATE_STRUCT(tmpExtra, $
                                      "SUSPECTED_OUTLIER_VALUES",BPDsRatSusOutliers)
     END
     ELSE: 
  ENDCASE
  ;; FOR k=0,nLoop-1 DO BEGIN

  stormRatMoms        = REFORM([MOMENT(stormRatStruct.nsRatio), $
                                MOMENT(stormRatStruct.mpRatio), $
                                MOMENT(stormRatStruct.rpRatio)],4,3)

  tmpBPD              = {data    : stormRatBPD, $
                         bad     : ~include_BPD, $
                         extras  : tmpExtra}

  ;; ENDFOR

  stormRatStats       = {BPD     : tmpBPD, $
                         mom     : stormRatMoms, $
                         ;; name    : "Storm Ratios"}
                         name    : ['Quiescent','Main','Recovery']}



  IF KEYWORD_SET(add_to_struct) THEN BEGIN
     stormRatStruct = CREATE_STRUCT(stormRatStruct,"stats",stormRatStats)
  ENDIF

  RETURN,stormRatStats

END
