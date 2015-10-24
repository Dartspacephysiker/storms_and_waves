PRO PLOT_STORM_ALFVENDB_QUANTITY,maxInd,mTags,LOOPIDX=loopIdx,NEVRANGE=nEvRange, LOG_DBQUANTITY=log_DBQuantity, $
                                 NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                 PLOT_I_POS=plot_i_pos,ALF_T_POS=alf_t_pos,ALF_Y_POS=alf_y_pos, $
                                 PLOT_I_NEG=plot_i_neg,ALF_T_NEG=alf_t_neg,ALF_Y_NEG=alf_y_neg, $
                                 POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                                 PLOT_I_ALL=plot_i,ALF_T_ALL=alf_t,ALF_Y_ALL=alf_y, $
                                 PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
                                 YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
                                 OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg

  @stormplot_defaults.pro

  IF N_ELEMENTS(loopIdx) EQ 0 THEN loopIdx = 0

  IF KEYWORD_SET(neg_and_pos_separ) THEN BEGIN
     
     IF (plot_i_pos)[0] GT -1 AND N_ELEMENTS(plot_i_pos) GT 1 THEN BEGIN
        
        out_maxPlotPos=plot((alf_t_pos), $
                            (alf_y_pos), $
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
                            OVERPLOT=(loopIdx EQ 0) ? 0: 1, $
                            LAYOUT=pos_layout, $
                            SYM_TRANSPARENCY=defSymTransp)
        
        
     ENDIF
     
     IF (plot_i_neg)[0] GT -1 AND (N_ELEMENTS(plot_i_neg) GT 1) THEN BEGIN
        
        out_maxPlotNeg=plot((alf_t_neg), $
                            (alf_y_neg), $
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
     IF plot_i[0] GT -1 AND (N_ELEMENTS(plot_i) GT 1) THEN BEGIN
        
        maxPlot=plot(alf_t, $
                     alf_y, $
                     ;; (log_DBquantity) ? ALOG10(alf_y) : alf_y, $
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
                     OVERPLOT=(loopIdx EQ 0) ? 0: 1, $
                     SYM_TRANSPARENCY=defSymTransp)
        
        out_maxPlotAll = maxPlot
        
     ENDIF
     
  ENDELSE                       ;end ~neg_and_pos_separ
  


END