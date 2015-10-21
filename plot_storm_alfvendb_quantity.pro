PRO PLOT_STORM_ALFVENDB_QUANTITY,NEVRANGE=nEvRange, LOG_DBQUANTITY=log_DBQuantity, $
                                 TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list,TOT_ALF_T_POS_LIST=tot_alf_t_pos_list,TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                 TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list,TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list,TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                 POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                                 TOT_PLOT_I_LIST=tot_plot_i_list,TOT_ALF_T_LIST=tot_alf_t_list,TOT_ALF_Y_LIST=tot_alf_y_list, $
                                 PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
                                 YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
                                 OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg

  @stormplot_defaults.pro

  IF neg_and_pos_separ THEN BEGIN
     
     IF (tot_plot_i_pos_list[i])[0] GT -1 AND N_ELEMENTS(tot_plot_i_pos_list[i]) GT 1 THEN BEGIN
        
        out_maxPlotPos=plot((tot_alf_t_pos_list[i]), $
                            (tot_alf_y_pos_list[i]), $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags[maxInd]), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [(minDat[0]),(maxDat[0])], $
                            YLOG=(log_DBQuantity) ? 1 : 0, $
                            LINESTYLE=' ', $
                            SYMBOL='+', $
                            SYM_COLOR='r', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            YTICKFONT_SIZE=max_ytickfont_size, $
                            YTICKFONT_STYLE=max_ytickfont_style, $
                            ;; XTICKFONT_SIZE=max_xtickfont_size, $
                            ;; XTICKFONT_STYLE=max_xtickfont_style, $
                            /CURRENT, $
                            OVERPLOT=(i EQ 0) ? 0: 1, $
                            LAYOUT=pos_layout, $
                            SYM_TRANSPARENCY=defSymTransp)
        
        
     ENDIF
     
     IF (tot_plot_i_neg_list[i])[0] GT -1 AND (N_ELEMENTS(tot_plot_i_neg_list[i]) GT 1) THEN BEGIN
        
        out_maxPlotNeg=plot((tot_alf_t_neg_list[i]), $
                            (tot_alf_y_neg_list[i]), $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags[maxInd]), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [(minDat[1]),(maxDat[1])], $
                            YLOG=(log_DBQuantity) ? 1 : 0, $
                            LINESTYLE=' ', $
                            SYMBOL='+', $
                            SYM_COLOR='SEA GREEN', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            YTICKFONT_SIZE=max_ytickfont_size, $
                            YTICKFONT_STYLE=max_ytickfont_style, $
                            /CURRENT, $
                            OVERPLOT=1, $
                            LAYOUT=neg_layout, $
                            SYM_TRANSPARENCY=defSymTransp)
        
     ENDIF
     
  ENDIF ELSE BEGIN
     IF tot_plot_i_list[i,0] GT -1 AND (N_ELEMENTS(tot_plot_i_list[i]) GT 1) THEN BEGIN
        
        maxPlot=plot(tot_alf_t_list[i], $
                     tot_alf_y_list[i], $
                     ;; (log_DBquantity) ? ALOG10(tot_alf_y_list[i]) : tot_alf_y_list[i], $
                     XTITLE=defXTitle, $
                     YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                             yTitle_maxInd : $
                             mTags[maxInd]), $
                     XRANGE=xRange, $
                     YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                     yRange_maxInd : [minDat,maxDat], $
                     YLOG=(log_DBQuantity) ? 1 : 0, $
                     LINESTYLE=' ', $
                     SYMBOL='+', $
                     SYM_COLOR='r', $
                     XTICKFONT_SIZE=max_xtickfont_size, $
                     XTICKFONT_STYLE=max_xtickfont_style, $
                     YTICKFONT_SIZE=max_ytickfont_size, $
                     YTICKFONT_STYLE=max_ytickfont_style, $
                     MARGIN=KEYWORD_SET(bkgrnd_maxInd) ? plotMargin_max : !NULL, $
                     /CURRENT, $
                     OVERPLOT=(i EQ 0) ? 0: 1, $
                     SYM_TRANSPARENCY=defSymTransp)
        
        out_maxPlotAll = maxPlot
        
     ENDIF
     
  ENDELSE                       ;end ~neg_and_pos_separ
  


END