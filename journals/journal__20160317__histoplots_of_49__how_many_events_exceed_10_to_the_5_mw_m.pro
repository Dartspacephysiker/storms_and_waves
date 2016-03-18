;2016/03/17
;Got these from pausing
;JOURNAL__20160315__HISTOPLOTS_OF_49_PFLUXEST_DURING_STORMPHASES__MULTIPLIED_BY_WIDTH_X__APPROPRIATE_BFIELD_RATIO
; at the plot line, and totaling normalized histos above 10^5 and above 10^4
PRO JOURNAL__20160317__HISTOPLOTS_OF_49__HOW_MANY_EVENTS_EXCEED_10_TO_THE_5_MW_M

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;N pFlux measurements above 10^4 mW/m
  total(y[32:-1])*100.   
  ;;28.057522  --DAYSIDE

  total(y[32:-1])*100.
  ;;36.512486  --NIGHTSIDE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;N pFlux measurements above 10^5 mW/m
  total(y[42:-1])*100.
  ;;3.8819113  --DAYSIDE

  total(y[42:-1])*100.
  ;;7.6340580  --NIGHTSIDE

END