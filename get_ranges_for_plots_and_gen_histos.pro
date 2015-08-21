PRO GET_RANGES_FOR_PLOTS_AND_GEN_HISTOS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i,CDB_STORM_I=cdb_storm_i,CDB_IND_LIST=cdb_ind_list, $
                                        MINMAXDAT=minMaxDat, NALFSTORMS=nAlfStorms,NSTORMS=nStorms, $
                                        CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterStorm=tAfterStorm,tBeforeStorm=tBeforeStorm, $
                                        nEventHists=nEventHists, $
                                        avg_type_maxInd=avg_type_maxInd, $
                                        NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                     tot_plot_i_pos_list=tot_plot_i_pos_list,tot_cdb_t_pos_list=tot_cdb_t_pos_list,tot_cdb_y_pos_list=tot_cdb_y_pos_list, $
                                     tot_plot_i_neg_list=tot_plot_i_neg_list,tot_cdb_t_neg_list=tot_cdb_t_neg_list,tot_cdb_y_neg_list=tot_cdb_y_neg_list, $
                                     tot_plot_i_list=tot_plot_i_list,tot_cdb_t_list=tot_cdb_t_list,tot_cdb_y_list=tot_cdb_y_list, $
                                        nEvHist_pos=nEvHist_pos,nEvHist_neg=nEvHist_neg,ALL_NEVHIST=all_nEvHist,tBin=tBin, $
                                        MIN_NEVBINSIZE=min_NEVBINSIZE,NEVTOT=nEvTot

  FOR i=0,nStorms-1 DO BEGIN
     
     tempInds=cgsetintersection(good_i,[cdb_storm_i(i,0):cdb_storm_i(i,1):1])
     minMaxDat(i,1)=MAX(maximus.(maxInd)(tempInds),MIN=tempMin)
     minMaxDat(i,0)=tempMin

     IF neg_and_pos_separ THEN BEGIN
        
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        
        IF plot_i[0] EQ -1 THEN BEGIN
           PRINT,'No Alfven events for storm #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
           print,FORMAT='("Storm ",I0,":",TR5,A0)',i,tStamps(i) ;show me where!
           nAlfStorms--
           print,'nAlfStorms is now ' + STRCOMPRESS(nAlfStorms,/REMOVE_ALL) + '...'
        END

        plot_i_list = LIST(cgsetintersection(plot_i,cdb_ind_list[0])) ;pos and neg
        plot_i_list.add,cgsetintersection(plot_i,cdb_ind_list[1])
        
        ;; get relevant time range
        cdb_t=LIST( (DOUBLE(cdbTime(plot_i_list[0]))-DOUBLE(centerTime(i)))/3600. )
        cdb_t.add,( (DOUBLE(cdbTime(plot_i_list[1]))-DOUBLE(centerTime(i)))/3600. )
        
        ;; get corresponding data
        cdb_y=LIST(maximus.(maxInd)(plot_i_list[0]))
        cdb_y.add,ABS(maximus.(maxInd)(plot_i_list[1]))
        
        nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)
        
        IF i EQ 0 THEN BEGIN
           tot_plot_i_pos_list=LIST(plot_i_list[0])
           tot_cdb_t_pos_list=LIST((cdb_t[0]))
           tot_cdb_y_pos_list=LIST(cdb_y[0])
           
           tot_plot_i_neg_list=LIST(plot_i_list[1])
           tot_cdb_t_neg_list=LIST((cdb_t[1]))
           tot_cdb_y_neg_list=LIST(cdb_y[1])
           
        ENDIF ELSE BEGIN
           tot_plot_i_pos_list.add,plot_i_list[0]
           tot_cdb_t_pos_list.add,(cdb_t[0])
           tot_cdb_y_neg_list.add,cdb_y[0]
           
           tot_plot_i_neg_list.add,plot_i_list[1]
           tot_cdb_t_neg_list.add,(cdb_t[1])
           tot_cdb_y_neg_list.add,cdb_y[1]
           
        ENDELSE 
        
        IF (plot_i_list[0])(0) GT -1 AND N_ELEMENTS(plot_i_list[0]) GT 1 THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch

              IF N_ELEMENTS(nEvHist_pos) EQ 0 THEN BEGIN
                 nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
                                       ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                       MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                       BINSIZE=min_NEVBINSIZE)
                 nEvTot[0]=N_ELEMENTS(plot_i_list[0])
              ENDIF ELSE BEGIN
                 nEvHist_pos=histogram((cdb_t[0]),LOCATIONS=tBin, $
                                       ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                       MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                       BINSIZE=min_NEVBINSIZE, $
                                       INPUT=nEvHist_pos)
                 nEvTot[0]+=N_ELEMENTS(plot_i_list[0])
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
        IF (plot_i_list[1])(0) GT -1 AND (N_ELEMENTS(plot_i_list[1]) GT 1) THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
              IF N_ELEMENTS(nEvHist_neg) EQ 0 THEN BEGIN
                 nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
                                       ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                       MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                       BINSIZE=min_NEVBINSIZE)
                 nEvTot[1]=N_ELEMENTS(plot_i_list[1])
              ENDIF ELSE BEGIN
                 nEvHist_neg=histogram((cdb_t[1]),LOCATIONS=tBin, $
                                       ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                       MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                       BINSIZE=min_NEVBINSIZE, $
                                       INPUT=nEvHist_neg)
                 nEvTot[1]+=N_ELEMENTS(plot_i_list[1])
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
     ENDIF ELSE BEGIN
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        

        IF plot_i[0] EQ -1 THEN BEGIN
           PRINT,'No Alfven events for storm #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
           print,FORMAT='("Storm ",I0,":",TR5,A0)',i,tStamps(i) ;show me where!
           nAlfStorms--
           print,'nAlfStorms is now ' + STRCOMPRESS(nStorms,/REMOVE_ALL) + '...'
        END

        ;; get relevant time range
        cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(centerTime(i)))/3600.
        
        ;; get corresponding data
        cdb_y=maximus.(maxInd)(plot_i)
        
        IF i EQ 0 THEN BEGIN
           nEvTot=N_ELEMENTS(plot_i)
           
           tot_plot_i_list=LIST(plot_i)
           tot_cdb_t_list=LIST(cdb_t)
           
           tot_cdb_y_list=LIST(cdb_y)
           nEvTotList=LIST(nEvTot)
        ENDIF ELSE BEGIN
           nEvTot+=N_ELEMENTS(plot_i)
           
           tot_plot_i_list.add,plot_i
           tot_cdb_t_list.add,cdb_t
           
           tot_cdb_y_list.add,cdb_y
           nEvTotList.add,nEvTot
        ENDELSE 
        
        
        IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
           
           IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
              
              IF i EQ 0 THEN BEGIN
                 all_nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                   MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                   BINSIZE=min_NEVBINSIZE)
              ENDIF ELSE BEGIN
                 all_nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                   MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                   BINSIZE=min_NEVBINSIZE, $
                                   INPUT=all_nEvHist)
              ENDELSE
           ENDIF                ;end nEventHists
        ENDIF
        
     ENDELSE
     
  ENDFOR

  PRINT,'Number of storms with Alfven events: ' + STRCOMPRESS(nAlfStorms,/REMOVE_ALL)

END