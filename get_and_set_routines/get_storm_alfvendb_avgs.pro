PRO GET_STORM_ALFVENDB_AVGS,maximus,TBIN=tBin, $
                            ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                            TOT_PLOT_I_POS=tot_plot_i_pos,TOT_ALF_T_POS=tot_alf_t_pos, $
                            TOT_PLOT_I_NEG=tot_plot_i_neg,TOT_ALF_T_NEG=tot_alf_t_neg, $
                            AVGS_POS=avgs_pos,AVGS_NEG=avgs_neg,AVGS=avgs,SAFE_I=safe_i, $
                            OUT_TBINS=out_tBins,OUT_BKGRND_MAXIND=out_bkgrnd_maxInd
  @stormplot_defaults.pro

  nBins=N_ELEMENTS(tBin)
  IF neg_and_pos_separ THEN BEGIN
     
     ;;combine all plot_i        
     IF N_ELEMENTS(out_maxPlotPos) GT 0 THEN BEGIN

        Avgs_pos=MAKE_ARRAY(nBins,/DOUBLE)
        avg_data_pos=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_pos))) : ABS(maximus.(maxInd)(tot_plot_i_pos))

        ;;now loop over histogram bins, perform average
        FOR i=0,nBins-1 DO BEGIN
           temp_inds=WHERE(tot_alf_t_pos GE (tBin[0] + i*Min_NEvBinsize) AND tot_alf_t_pos LT (tBin[0]+(i+1)*min_nEvBinsize))
           Avgs_pos[i] = TOTAL(avg_data_pos(temp_inds))/DOUBLE(nEvHist_pos[i])
        ENDFOR

        safe_i=WHERE(FINITE(Avgs_pos) AND Avgs_pos NE 0.)

        out_bkgrnd_maxInd = Avgs_pos[safe_i]
        out_tBins=tBin[safe_i]

     ENDIF

     IF N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN

        Avgs_neg=MAKE_ARRAY(nBins,/DOUBLE)
        avg_data_neg=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_neg))) : ABS(maximus.(maxInd)(tot_plot_i_neg))

        ;;now loop over histogram bins, perform average
        FOR i=0,nBins-1 DO BEGIN
           temp_inds=WHERE(tot_alf_t_neg GE (tBin[0] + i*Min_NEvBinsize) AND tot_alf_t_neg LT (tBin[0]+(i+1)*min_nEvBinsize))
           Avgs_neg[i] = TOTAL(avg_data_neg(temp_inds))/DOUBLE(nEvHist_neg[i])
        ENDFOR

        safe_i=WHERE(FINITE(Avgs_neg) AND Avgs_neg NE 0.)
        ;; IF N_ELEMENTS(out_bkgrnd_maxInd) GT 0 THEN BEGIN
        ;;    out_bkgrnd_maxInd = [out_bkgrnd_maxInd,Avgs_neg]
        ;;    tBin
     ENDIF
     
  ENDIF ELSE BEGIN

     ;;combine all plot_i
     Avgs=MAKE_ARRAY(nBins,/DOUBLE)
     avg_data=log_DBQuantity ? ALOG10(maximus.(maxInd)[tot_plot_i]) : maximus.(maxInd)[tot_plot_i]
     ;;now loop over histogram bins, perform average
     FOR i=0,nBins-1 DO BEGIN
        temp_inds=WHERE(tot_alf_t GE (tBin[0] + i*Min_NEvBinsize) AND tot_alf_t LT (tBin[0]+(i+1)*min_nEvBinsize))
        Avgs[i] = TOTAL(avg_data(temp_inds))/DOUBLE(all_nEvHist[i])
     ENDFOR

     safe_i=(log_DBQuantity) ? WHERE(FINITE(Avgs) AND Avgs GT 0.) : WHERE(FINITE(Avgs))

     out_bkgrnd_maxInd = Avgs[safe_i]
     out_tBins=tBin[safe_i]

  ENDELSE

END