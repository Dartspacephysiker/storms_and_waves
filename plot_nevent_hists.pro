PRO PLOT_STORM_NEVENT_HISTS,TBIN=tBin,TSTAMPS=tStamps, $
                            NEVRANGE=nEvRange, NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                            ALL_NEVHIST=all_nEvHist,NEVHIST_POS=nEvHist_pos,NEVHIST_NEG=nEvHist_neg,NEVTOT=nEvTot, $
                            ALF_IND_LIST=alf_ind_list, $
                            PLOTTITLE=plotTitle, OVERPLOT_HIST=overplot_hist, $
                            POS_LAYOUT=pos_layout,NEG_LAYOUT=neg_layout, $
                            GEOMAGWINDOW=geomagWindow,PLOT_NEV=plot_nEv,PLOT_BKGRND=plot_bkgrnd, $
                            RETURNED_NEV_TBINS_AND_HIST=returned_nev_tbins_and_hist, $
                            SAVEPLOTNAME=savePlotName,SAVEFILE=saveFile,SAVESTR=saveStr
  
  @stormplot_defaults.pro

  IF neg_and_pos_separ THEN BEGIN
     
     IF (alf_ind_list[0])[0] NE -1 THEN BEGIN
        
        cNEvHist_pos= TOTAL(nEvHist_pos, /CUMULATIVE) / nEvTot[0]
        
        IF ~noPlots THEN BEGIN
           histWindow_pos=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                 DIMENSIONS=[1200,800])
           
           plot_nEv_pos=plot(tBin,nEvHist_pos, $
                             ;; /STAIRSTEP, $
                             /HISTOGRAM, $
                             YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                             TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                             tStamps[0] + " - " + $
                             tStamps[-1], $
                             XTITLE=defXTitle, $
                             YTITLE='Number of Alfvén events', $
                             /CURRENT, LAYOUT=pos_layout,COLOR='red')
           
           cdf_nEv_pos=plot(tBin,cNEvHist_pos, $
                            XTITLE=defXTitle, $
                            YTITLE='Cumulative number of Alfvén events', $
                            /CURRENT, LAYOUT=pos_layout, AXIS_STYLE=1,COLOR='r')
           
           
        ENDIF
     ENDIF
     
     IF (alf_ind_list[1])[0] NE -1 THEN BEGIN
        
        cNEvHist_neg= TOTAL(nEvHist_neg, /CUMULATIVE) / nEvTot[1]
        
        IF ~noPlots THEN BEGIN
           histWindow_neg=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                 DIMENSIONS=[1200,800])
           
           plot_nEv_neg=plot(tBin,nEvHist_neg, $
                             ;; /STAIRSTEP, $
                             /HISTOGRAM, $
                             YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                             TITLE='Number of Alfvén events relative to storm epoch for ' + stormString + ' storms, ' + $
                             tStamps[0] + " - " + $
                             tStamps[-1], $
                             XTITLE=defXTitle, $
                             YTITLE='Number of Alfvén events', $
                             /CURRENT,/OVERPLOT, LAYOUT=neg_layout,COLOR='b')
           
           cdf_nEv_neg=plot(tBin,cNEvHist_neg, $
                            XTITLE=defXTitle, $
                            YTITLE='Cumulative number of Alfvén events', $
                            /CURRENT, LAYOUT=neg_layout,/OVERPLOT, AXIS_STYLE=1,COLOR='b')
           
           ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize,min_NEVBINSIZE'
        ENDIF
     ENDIF
     
     IF saveFile THEN saveStr+=',cNEvHist_pos,nEvHist_pos,cNEvHist_neg,nEvHist_neg,tBin,nEvBinsize,min_NEVBINSIZE,tot_plot_i_pos_list,tot_plot_i_neg_list,maxInd'
     
  ENDIF ELSE BEGIN
     
     IF ~noPlots THEN BEGIN
        ;; IF KEYWORD_SET(overplot_hist) THEN BEGIN
        ;;    PRINT,'setting geomagwindow as current...'
        ;;    geomagWindow.setCurrent
        ;; ENDIF ELSE BEGIN
        ;;    histWindow=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
        ;;                   DIMENSIONS=[1200,800])
        ;; ENDELSE
        plot_nEv=plot(tBin,all_nEvHist, $
                      ;; /STAIRSTEP, $
                      /HISTOGRAM, $
                      TITLE=plotTitle, $
                      ;; TITLE='Number of Alfvén events relative to storm epoch for ' + stormString
                      ;; + ' storms, ' + $
                      ;; tStamps[0] + " - " + $
                      ;; tStamps[-1], $
                      YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : defNEvYRange, $
                      NAME='Event histogram', $
                      ;; YRANGE=[MIN(all_nEvHist),MAX(all_nEvHist)], $
                      XRANGE=xRange, $
                      AXIS_STYLE=(KEYWORD_SET(overplot_hist)) ? 0 : 1, $
                      ;; XTITLE=defXTitle, $
                      ;; YTITLE='Number of Alfvén events', $
                      ;; /CURRENT, LAYOUT=[1,1,1]
                      COLOR='red', $
                      MARGIN=plotMargin, $
                      THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                      CURRENT=KEYWORD_SET(overplot_hist))
        
        yaxis = AXIS('Y', LOCATION='right', TARGET=plot_nEv, $
                     TITLE='Number of events', $
                     MAJOR=nMajorTicks, $
                     MINOR=nMinorTicks, $
                     TICKFONT_SIZE=max_ytickfont_size, $
                     TICKFONT_STYLE=max_ytickfont_style, $
                     TICKFORMAT='(I0)', $
                     ;; AXIS_RANGE=[minDat,maxDat], $
                     TEXTPOS=1, $
                     COLOR='red')
        
        IF KEYWORD_SET(bkgrnd_hist) AND ~noPlots THEN BEGIN
           plot_bkgrnd=plot(tBin,bkgrnd_hist, $
                            ;; /STAIRSTEP, $
                            /HISTOGRAM, $
                            YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : [0,7500], $
                            NAME='Background histogram', $
                            XRANGE=xRange, $
                            AXIS_STYLE=0, $
                            COLOR='blue', $
                            MARGIN=plotMargin, $
                            THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                            /CURRENT,TRANSPARENCY=50)
           
           leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                        POSITION=[xRange[1]-10.,((KEYWORD_SET(nEvRange) ? nEvRange : [0,7500])[1])], /DATA, $
                        /AUTO_TEXT_COLOR)
        ENDIF     
        
        ;; xaxis = AXIS('Y', LOCATION='right', TARGET=plot_nEv, $
        ;;              TITLE='Number of events', $
        ;;              MAJOR=nMajorTicks, $
        ;;              MINOR=nMinorTicks, $
        ;;              ;; AXIS_RANGE=[minDat,maxDat], $
        ;;              TEXTPOS=1, $
        ;;              COLOR='red')
        
        
        ;; cdf_nEv=plot(tBin,cAll_NEvHist, $
        ;;              XTITLE=defXTitle, $
        ;;              YTITLE='Cumulative number of Alfvén events', $
        ;;              /CURRENT, LAYOUT=[2,1,2], AXIS_STYLE=1,COLOR='blue')
        
        ;; IF saveFile THEN saveStr+=',cAll_NEvHist,cdf_nEv,plot_nEv,all_nEvHist,tBin,nEvBinsize,min_NEVBINSIZE'
     ENDIF
     
     cAll_NEvHist = TOTAL(all_nEvHist, /CUMULATIVE) / nEvTot
     IF saveFile THEN saveStr+=',cAll_NEvHist,all_nEvHist,tBin,nEvBinsize,min_NEVBINSIZE,tot_plot_i_list,maxInd,nAlfStorms'
     
  ENDELSE
  
  IF KEYWORD_SET(returned_nev_tbins_and_hist) THEN returned_nev_tbins_and_Hist=[[tbin],[all_nEvHist]]

  ;; IF KEYWORD_SET(savePlotName) THEN BEGIN
  ;;    PRINT,"Saving plot to file: " + savePlotName
  ;;    geomagWindow.save,savePlotName,RESOLUTION=defRes
  ;; ENDIF

END