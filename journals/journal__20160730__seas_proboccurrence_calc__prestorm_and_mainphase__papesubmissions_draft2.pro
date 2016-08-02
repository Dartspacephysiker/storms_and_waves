;2016/07/30 This is for the second rev to this paper. Gotta show Referee #1 wassup.
PRO JOURNAL__20160730__SEAS_PROBOCCURRENCE_CALC__PRESTORM_AND_MAINPHASE__PAPESUBMISSIONS_DRAFT2

  COMPILE_OPT idl2

  lun                  = -1

  ranges               = [ $
                         [-60,0], $
                         [0,2.5], $
                         [2.5,5.0], $
                         [5.0,7.5], $
                         [7.5,10.0], $
                         [0,10.0], $
                         [10,20], $
                         [20,30], $
                         [30,40], $
                         [40,60]] 

  nightFL              = [200990.0000, $
                          6515.00000, $ 
                          8402.50000, $ 
                          11567.50000, $
                          9337.50000, $ 
                          35822.50000, $
                          37082.50000, $
                          35877.50000, $
                          38640.00000, $
                          63452.50000]



  nightWidth           = [717.45504, $
                          52.52148, $ 
                          199.70900, $
                          206.46876, $
                          148.61523, $
                          607.31446, $
                          556.22264, $
                          292.38479, $
                          192.86330, $
                          316.34567]

  dayFL                = [138495.00000, $
                          6620.00000, $  
                          6337.50000, $  
                          8305.00000, $  
                          6000.00000, $  
                          27262.50000, $ 
                          24962.50000, $ 
                          25102.50000, $ 
                          20600.00000, $ 
                          43147.50000]

  dayWidth             = [2397.80847, $
                          475.50392, $ 
                          609.26365, $ 
                          692.28119, $ 
                          542.77146, $ 
                          2319.82022, $
                          1226.52147, $
                          696.87889, $ 
                          526.59761, $ 
                          858.25190] 

  nightProb            = nightWidth/nightFL
  dayProb              = dayWidth/dayFL

  nRanges              = N_ELEMENTS(ranges[0,*])

  PRINTF,lun,FORMAT='("Range",T20,T20,"Prob occ",T40,"Prob occ. (pre-storm frac)")'


  FOR m=0,1 DO BEGIN

     CASE m OF
        0: BEGIN
           sideString  = 'Dayside'
           probOcc     = dayProb
        END
        1: BEGIN
           sideString  = 'Nightside'
           probOcc     = nightProb
        END
     ENDCASE

     preStorm          = probOcc[0]

     PRINT,''
     PRINT,"****************************************"
     PRINT,sideString
     PRINT,"****************************************"
     FOR k=0,nRanges-1 DO BEGIN
        lb             = ranges[0,k]
        ub             = ranges[1,k]
        val            = probOcc[k]

        PRINTF,lun,FORMAT='(F-0.2,"–",F-0.2,T20,F-0.5,T40,F-0.5)',lb,ub,val,val/preStorm
     ENDFOR
  ENDFOR

  STOP

END