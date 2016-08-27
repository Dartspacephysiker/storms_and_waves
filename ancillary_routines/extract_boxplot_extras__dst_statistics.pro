;;08/27/16
PRO EXTRACT_BOXPLOT_EXTRAS__DST_STATISTICS,BPD, $
   CI_VALUES=ci_values, $
   MEAN_VALUES=mean_values, $
   OUTLIER_VALUES=outlier_values, $
   SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
   EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
   EXCLUDE_CI_VALUES=exclude_ci_values, $              
   EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $         
   EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values
  

  COMPILE_OPT IDL2

  nBoxPlots = N_ELEMENTS(BPD.data[0,*])

  badCount  = 0

  SWITCH SIZE(BPD.extras,/TYPE) OF
     0: BEGIN
        PRINT,"I have no extras. Quit asking for the impossible."
     END
     8: 
     11: BEGIN
        IF N_ELEMENTS(BPD.extras) GT nBoxPlots THEN BEGIN
           ;; PRINT,'Apparently this is an array. No thanks'
           PRINT,'Apparently there are more extras than BP data. No thanks'
        ENDIF ELSE BEGIN
           ci_values      = !NULL

           mean_values    = !NULL

           outlier_values = !NULL

           suspected_outlier_values = !NULL
           
           FOR k=0,nBoxPlots-1 DO BEGIN

              ;;Skip the baddies
              IF BPD.bad[k] THEN BEGIN
                 badCount++
                 CONTINUE
              ENDIF

              bpNum       = k-badCount

              ciVals      = TAG_EXIST(BPD.extras[k],"CI_VALUES"                ) AND $
                            ~KEYWORD_SET(exclude_ci_values)                ? $
                            BPD.extras[k].ci_values                : !NULL

              meanVals    = TAG_EXIST(BPD.extras[k],"MEAN_VALUES"              ) AND $
                            ~KEYWORD_SET(exclude_mean_values)              ? $
                            BPD.extras[k].mean_values              : !NULL

              outVals     = TAG_EXIST(BPD.extras[k],"OUTLIER_VALUES"           ) AND $
                            ~KEYWORD_SET(exclude_outlier_values)           ? $
                            BPD.extras[k].outlier_values           : !NULL

              susOutVals  = TAG_EXIST(BPD.extras[k],"SUSPECTED_OUTLIER_VALUES" ) AND $
                            ~KEYWORD_SET(exclude_suspected_outlier_values) ? $
                            BPD.extras[k].suspected_outlier_values : !NULL
              
              IF N_ELEMENTS(ciVals)     GT 0 THEN BEGIN
                 IF N_ELEMENTS(ciVals) GT 1 THEN STOP
                 ci_values                = [ci_values,ciVals]
              ENDIF
              IF N_ELEMENTS(meanVals)   GT 0 THEN BEGIN
                 IF N_ELEMENTS(meanVals) GT 1 THEN STOP
                 mean_values              = [mean_values,meanVals]
              ENDIF
              IF N_ELEMENTS(outVals)    GT 0 THEN BEGIN
                 CASE N_ELEMENTS(outVals) OF
                    1: BEGIN
                       outVals            = [bpNum,outVals]
                    END
                    ELSE: BEGIN
                       outVals[0,*]       = bpNum
                    END
                 ENDCASE

                 outlier_values           = [[outlier_values],[outVals]]
              ENDIF
              IF N_ELEMENTS(susOutVals) GT 0 THEN BEGIN
                 CASE N_ELEMENTS(susOutVals) OF
                    1: BEGIN
                       susOutVals         = [bpNum,susOutVals]
                    END
                    ELSE: BEGIN
                       susOutVals[0,*]    = bpNum
                    END
                 ENDCASE

                 suspected_outlier_values = [[suspected_outlier_values],[susOutVals]]
              ENDIF
           ENDFOR

        ENDELSE
     END
  ENDSWITCH

END
