;;This pro is called after GET_EPOCH_T_AND_INDS_FOR_ALFVENDB, and can return the following
;; important lists, elements of which are all arrays of indices:
;;
;; tot_plot_i_{pos_,neg_,}list      : A list of arrays of indices into the Alfven DBStruct for
;;                                     Alfven events that pass screening 
;; tot_alf_{y,t}_{pos,_neg_,}list   : A list of arrays of {data, UTC time} values for Alfven
;;                                      events that pass screening
PRO GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                                      ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                      MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                      LOG_DBQUANTITY=log_dbquantity, $
                                      CENTERTIME=alf_centerTime,TSTAMPS=alf_tStamps,tAfterEpoch=tAfterEpoch,tBeforeEpoch=tBeforeEpoch, $
                                      NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                      ONLY_POS=only_pos, $
                                      ONLY_NEG=only_neg, $
                                      TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                      TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                      TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                      NEVTOT=nEvTot, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr, $
                                      LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  
  ;; Get ranges for plots
  minMaxDat=MAKE_ARRAY(nEpochs,2,/DOUBLE)
  
  alf_ind_list = LIST(WHERE(maximus.(maxInd) GT 0))
  alf_ind_list.add,WHERE(maximus.(maxInd) LT 0)
  IF KEYWORD_SET(log_dbquantity) THEN BEGIN
     PRINTF,lun,'Logging all Alfven DB values for maxInd = ' + STRCOMPRESS(maxInd,/REMOVE_ALL) + '...'

     log_i = WHERE(maximus.(maxInd) NE 0.0 AND FINITE(maximus.(maxInd)))
     good_i = CGSETINTERSECTION(good_i,log_i)
  ENDIF
  
  IF KEYWORD_SET(only_pos) THEN BEGIN
     good_i = CGSETINTERSECTION(good_i,WHERE(maximus.(maxInd) GT 0.0 AND FINITE(maximus.(maxInd))))
  ENDIF

  IF neg_and_pos_separ OR ( log_DBQuantity AND (alf_ind_list[1,0] NE -1)) THEN BEGIN
     PRINT,'Got some negs here...'
     WAIT,1
  ENDIF
  
  FOR i=0,nAlfEpochs-1 DO BEGIN
     
     tempInds=cgsetintersection(good_i,[alf_epoch_i(i,0):alf_epoch_i(i,1):1])
     minMaxDat(i,1)=MAX(maximus.(maxInd)(tempInds),MIN=tempMin)
     minMaxDat(i,0)=tempMin

     IF neg_and_pos_separ THEN BEGIN
        
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(alf_epoch_i(i,1)-alf_epoch_i(i,0)+1)+alf_epoch_i(i,0))
        
        IF plot_i[0] EQ -1 THEN BEGIN
           PRINT,'No Alfven events for epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
           print,FORMAT='("Epoch ",I0,":",TR5,A0)',i,alf_tStamps[i] ;show me where!
           nAlfEpochs--
           print,'nAlfEpochs is now ' + STRCOMPRESS(nAlfEpochs,/REMOVE_ALL) + '...'
        ENDIF ELSE BEGIN
           
           plot_i_list = LIST(cgsetintersection(plot_i,alf_ind_list[0])) ;pos and neg
           plot_i_list.add,cgsetintersection(plot_i,alf_ind_list[1])
           
           ;; get relevant time range
           alf_t=LIST( (DOUBLE(cdbTime(plot_i_list[0]))-DOUBLE(alf_centerTime[i]))/3600. )
           alf_t.add,( (DOUBLE(cdbTime(plot_i_list[1]))-DOUBLE(alf_centerTime[i]))/3600. )
           
           ;; get corresponding data
           alf_y=LIST(maximus.(maxInd)(plot_i_list[0]))
           alf_y.add,ABS(maximus.(maxInd)(plot_i_list[1]))
           IF KEYWORD_SET(log_dbquantity) THEN BEGIN
              alf_y[0] = ALOG10(alf_y[0])
              alf_y[1] = ALOG10(alf_y[1])
           ENDIF

           nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)
           
           IF i EQ 0 THEN BEGIN
              tot_plot_i_pos_list=LIST(plot_i_list[0])
              tot_alf_t_pos_list=LIST((alf_t[0]))
              tot_alf_y_pos_list=LIST(alf_y[0])
              
              tot_plot_i_neg_list=LIST(plot_i_list[1])
              tot_alf_t_neg_list=LIST((alf_t[1]))
              tot_alf_y_neg_list=LIST(alf_y[1])
              
           ENDIF ELSE BEGIN
              tot_plot_i_pos_list.add,plot_i_list[0]
              tot_alf_t_pos_list.add,(alf_t[0])
              tot_alf_y_neg_list.add,alf_y[0]
              
              tot_plot_i_neg_list.add,plot_i_list[1]
              tot_alf_t_neg_list.add,(alf_t[1])
              tot_alf_y_neg_list.add,alf_y[1]
              
           ENDELSE 
        ENDELSE
     ENDIF ELSE BEGIN
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(alf_epoch_i[i,1]-alf_epoch_i[i,0]+1)+alf_epoch_i[i,0])
        
        IF plot_i[0] EQ -1 THEN BEGIN
           PRINT,'No Alfven events for epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
           print,FORMAT='("Epoch ",I0,":",TR5,A0)',i,alf_tStamps[i] ;show me where!
           nAlfEpochs--
           print,'nAlfEpochs is now ' + STRCOMPRESS(nAlfEpochs,/REMOVE_ALL) + '...'
        ENDIF ELSE BEGIN
           
           ;; get relevant time range
           alf_t=(DOUBLE(cdbTime[plot_i])-DOUBLE(alf_centerTime[i]))/3600.
           
           ;; get corresponding data
           alf_y=maximus.(maxInd)(plot_i)
           IF KEYWORD_SET(log_dbquantity) THEN BEGIN
              alf_y = ALOG10(alf_y)
           ENDIF

           IF i EQ 0 THEN BEGIN
              nEvTot=N_ELEMENTS(plot_i)
              
              tot_plot_i_list=LIST(plot_i)
              tot_alf_t_list=LIST(alf_t)
              
              tot_alf_y_list=LIST(alf_y)
              nEvTotList=LIST(nEvTot)
           ENDIF ELSE BEGIN
              nEvTot+=N_ELEMENTS(plot_i)
              
              tot_plot_i_list.add,plot_i
              tot_alf_t_list.add,alf_t
              
              tot_alf_y_list.add,alf_y
              nEvTotList.add,nEvTot
           ENDELSE 
           
        ENDELSE
     ENDELSE
     
  ENDFOR
  
  PRINT,'Number of epochs with Alfven events: ' + STRCOMPRESS(nAlfEpochs,/REMOVE_ALL)

  IF KEYWORD_SET(saveFile) THEN BEGIN
     saveStr = saveStr + 'tot_alf_t_list,tot_alf_y_list,maxind,good_i,minmaxdat,nalfepochs,alf_centertime,alf_tstamps,tbeforeepoch,tafterepoch,alf_epoch_i,alf_ind_list'
  ENDIF

END