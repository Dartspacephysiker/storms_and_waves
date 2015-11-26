PRO PLOT_STORM_ALFVENDB_AVGS,maximus,TBIN=tBin, LOG_DBQUANTITY=log_DBQuantity, $
                             AVGS_POS=avgs_pos,AVGS_NEG=avgs_neg,AVGS=avgs,SAFE_I=safe_i, $
                             ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                             POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
                             PLOTTITLE=plotTitle,XRANGE=xRange,MINDAT=minDat,MAXDAT=maxDat, $
                             YTITLE_MAXIND=yTitle_maxInd,YRANGE_MAXIND=yRange_maxInd, $
                             OUT_MAXPLOTALL=out_maxPlotAll, OUT_MAXPLOTPOS=out_maxPlotPos, OUT_MAXPLOTNEG=out_maxPlotNeg, $
                             OUT_TBINS=out_tBins,OUT_BKGRND_MAXIND=out_bkgrnd_maxInd
  
  @stormplot_defaults.pro

  nBins=N_ELEMENTS(tBin)
  IF neg_and_pos_separ THEN BEGIN
     
     ;;combine all plot_i        
     IF N_ELEMENTS(out_maxPlotPos) GT 0 THEN BEGIN
        out_maxPlotPos=plot(tBin[safe_i]+0.5*min_nEvBinsize, $
                            (log_DBQuantity) ? 10^Avgs_pos[safe_i] : Avgs_pos[safe_i], $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags[maxInd]), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [minDat[0],maxDat[0]], $
                            LINESTYLE='--', $
                            COLOR='MAROON', $
                            SYMBOL='d', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            LAYOUT=pos_layout, $
                            /CURRENT,/OVERPLOT, $
                            SYM_SIZE=1.5, $
                            SYM_COLOR='MAROON') ;, $
        
     ENDIF

     IF N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN
        out_maxPlotNeg=plot(tBin[safe_i]+0.5*min_nEvBinsize, $
                            (log_DBQuantity) ? 10^Avgs_neg[safe_i] : Avgs_neg[safe_i], $
                            TITLE=plotTitle, $
                            XTITLE=defXTitle, $
                            YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                                    yTitle_maxInd : $
                                    mTags[maxInd]), $
                            XRANGE=xRange, $
                            YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                            yRange_maxInd : [minDat[1],maxDat[1]], $
                            LINESTYLE='-:', $
                            COLOR='DARK GREEN', $
                            SYMBOL='d', $
                            XTICKFONT_SIZE=max_xtickfont_size, $
                            XTICKFONT_STYLE=max_xtickfont_style, $
                            LAYOUT=neg_layout, $
                            /CURRENT,/OVERPLOT, $
                            SYM_SIZE=1.5, $
                            SYM_COLOR='DARK GREEN') ;, $
        
     ENDIF
     
  ENDIF ELSE BEGIN
     
     avgPlot=plot(tBin[safe_i]+0.5*min_nEvBinsize, $
                  (log_DBQuantity) ? 10^Avgs[safe_i] : Avgs[safe_i], $
                  ;; Avgs[safe_i], $
                  NAME='Stormtime Alfvén activity', $
                  TITLE=plotTitle, $
                  XTITLE=defXTitle, $
                  YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                          yTitle_maxInd : $
                          mTags[maxInd]), $
                  XRANGE=xRange, $
                  YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                  yRange_maxInd : [minDat,maxDat], $
                  YLOG=(log_DBQuantity) ? 1 : 0, $
                  AXIS_STYLE=2, $
                  LINESTYLE='--', $
                  COLOR='MAROON', $
                  THICK=2.0, $
                  SYMBOL='d', $
                  SYM_SIZE=2.5, $
                  SYM_COLOR='MAROON', $ ;, $
                  XTICKFONT_SIZE=max_xtickfont_size, $
                  XTICKFONT_STYLE=max_xtickfont_style, $
                  YTICKFONT_SIZE=max_ytickfont_size, $
                  YTICKFONT_STYLE=max_ytickfont_style, $
                  /CURRENT,/OVERPLOT, $
                  MARGIN=KEYWORD_SET(bkgrnd_maxInd) ? plotMargin_max : !NULL)
     
     out_maxPlotAll = avgPlot
  ENDELSE

END