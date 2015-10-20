PRO GET_ALFSTORM_HISTOS,MAXIMUS=maximus,CDBTIME=cdbTime,MAXIND=maxInd,GOOD_I=good_i, $
                        ALF_STORM_I=alf_storm_i,ALF_IND_LIST=alf_ind_list, $
                        MINMAXDAT=minMaxDat, NALFSTORMS=nAlfStorms,NSTORMS=nStorms, $
                        CENTERTIME=centerTime,TSTAMPS=tStamps,tAfterStorm=tAfterStorm,tBeforeStorm=tBeforeStorm, $
                        NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                        TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                        TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                        TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                        NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,ALL_NEVHIST=all_nEvHist,TBIN=tBin, $
                        CNEVHIST_POS=cNEvHist_pos,NEVHIST_NEG=cNEvHist_neg,ALL_NEVHIST=cAll_nEvHist, $
                        MIN_NEVBINSIZE=min_NEVBINSIZE,NEVTOT=nEvTot


  FOR i=0,nStorms-1 DO BEGIN
     
     IF neg_and_pos_separ THEN BEGIN
        
        nEVTot = MAKE_ARRAY(2,/INTEGER,VALUE=0)
        
        IF tot_plot_i_pos_list[i,0] GT -1 AND N_ELEMENTS(tot_plot_i_pos_list[i]) GT 1 THEN BEGIN
           IF N_ELEMENTS(nEvHist_pos) EQ 0 THEN BEGIN
              nEvHist_pos=histogram(tot_alf_t_pos_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE)
              nEvTot[0]=N_ELEMENTS(tot_plot_i_pos_list[i])
           ENDIF ELSE BEGIN
              nEvHist_pos=histogram(tot_alf_t_pos_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE, $
                                    INPUT=nEvHist_pos)
              nEvTot[0]+=N_ELEMENTS(tot_plot_i_pos_list[i])
           ENDELSE
        ENDIF
        
        IF tot_plot_i_neg_list[i,0] GT -1 AND (N_ELEMENTS(tot_plot_i_neg_list[i]) GT 1) THEN BEGIN
           
           IF N_ELEMENTS(nEvHist_neg) EQ 0 THEN BEGIN
              nEvHist_neg=histogram(tot_alf_t_neg_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE)
              nEvTot[1]=N_ELEMENTS(tot_plot_i_neg_list[i])
           ENDIF ELSE BEGIN
              nEvHist_neg=histogram(tot_alf_t_neg_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE, $
                                    INPUT=nEvHist_neg)
              nEvTot[1]+=N_ELEMENTS(tot_plot_i_neg_list[i])
           ENDELSE
        ENDIF
        
     ENDIF ELSE BEGIN
        
        IF tot_plot_i_list[i,0] GT -1 AND N_ELEMENTS(tot_plot_i_list[i]) GT 1 THEN BEGIN
           ;; IF i EQ 0 THEN BEGIN
           IF N_ELEMENTS(all_nEvHist) EQ 0 THEN BEGIN
              all_nEvHist=histogram(tot_alf_t_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE)
           ENDIF ELSE BEGIN
              all_nEvHist=histogram(tot_alf_t_list[i],LOCATIONS=tBin, $
                                    ;;MAX=tAfterStorm+min_NEVBINSIZE,MIN=-tBeforeStorm 
                                    MAX=tAfterStorm,MIN=-tBeforeStorm, $
                                    BINSIZE=min_NEVBINSIZE, $
                                    INPUT=all_nEvHist)
           ENDELSE
        ENDIF
        
     ENDELSE
     
  ENDFOR

  IF neg_and_pos_separ THEN BEGIN
     cNEvHist_pos= TOTAL(nEvHist_pos, /CUMULATIVE) / nEvTot[0]
     cNEvHist_neg= TOTAL(nEvHist_neg, /CUMULATIVE) / nEvTot[1]
  ENDIF ELSE BEGIN
     cAll_NEvHist = TOTAL(all_nEvHist, /CUMULATIVE) / nEvTot
  ENDELSE

END