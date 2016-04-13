;;2016/04/13 Now we can calculate probOccurrence à la Chaston et al. [2007]
PRO TILE_STORMPHASE_PLOTS_FROM_TEMPFILES,tempFiles, $
                                         TEMPDIR=tempDir, $
                                         COMBINE_STORMPHASE_PLOTS=combine_stormphase_plots, $
                                         SAVE_COMBINED_WINDOW=save_combined_window, $
                                         COMBINED_TO_BUFFER=combined_to_buffer, $
                                         QUANTS_TO_PLOT=quants_to_plot, $
                                         NEW_LIMITS=new_limits, $
                                         NO_COLORBAR=no_colorbar

                                         

  COMPILE_OPT idl2

  IF N_ELEMENTS(combine_stormphase_plots) EQ 0 THEN combine_stormphase_plots = 1
  IF N_ELEMENTS(save_combined_window)     EQ 0 THEN save_combined_window     = 1
  IF N_ELEMENTS(combined_to_buffer)       EQ 0 THEN combined_to_buffer       = 1


  IF ~KEYWORD_SET(tempDir)                     THEN tempDir  = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  IF ~KEYWORD_SET(no_colorbar)                 THEN no_colorbar = [1,0,1]
  
  IF ~KEYWORD_SET(tempFiles) THEN BEGIN
     PRINT,'No tempfiles provided! Out ...'
     RETURN
  ENDIF


  SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

  outTempFiles           = tempDir + tempFiles

  FOR i=0,2 DO BEGIN
     PLOT_2DHISTO_FILE,outTempFiles[i], $
                       QUANTS_TO_PLOT=quants_to_plot, $
                       /MIDNIGHT, $
                       NEW_LIMITS=new_limits, $
                       NO_COLORBAR=no_colorbar[i], $
                       QUANTS_WITH_NEW_LIMITS=quants_with_new_limits, $
                       PLOTDIR=plotDir

  ENDFOR
  IF KEYWORD_SET(combine_stormphase_plots) THEN BEGIN

     IF KEYWORD_SET(eps_output) THEN fileSuff = '.ps' ELSE fileSuff = '.png'

     PRINT,"Combining stormphase plots..."

     plotFileArr = !NULL

     FOR i=0,2 DO BEGIN

        RESTORE,outTempFiles[i]

        ;;Just do what's told you, son
        IF KEYWORD_SET(quants_to_plot) THEN dataInds = quants_to_plot ELSE dataInds = [0:-2+KEYWORD_SET(nPlots)]
        plotFileArr = [[plotFileArr],[plotDir + paramStr+'--'+dataNameArr[dataInds] + fileSuff]]

     ENDFOR


     IF ~KEYWORD_SET(save_combined_name) THEN BEGIN
        IF KEYWORD_SET(logAvgPlot) THEN BEGIN
           statType = 'log_avg'
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(medianPlot) THEN BEGIN
              statType = 'median'
           ENDIF ELSE BEGIN
              statType = 'avg'
           ENDELSE
        ENDELSE

        save_combined_name = paramStr + '--' + dataNameArr[dataInds] + $
                             '--combined_phases' + fileSuff
        ;; save_combined_name = GET_TODAY_STRING() + '--' + dataNameArr[0:-3+KEYWORD_SET(nPlots)] + $
        ;;                      (KEYWORD_SET(plotSuffix) ? plotSuffix : '') + $
        ;;                      '--' + statType + '--combined_phases' + fileSuff
     ENDIF

     FOR i=0,N_ELEMENTS(plotFileArr[*,0])-1 DO BEGIN

        PRINT,"Saving to " + save_combined_name[i] + "..."
        TILE_STORMPHASE_PLOTS,plotFileArr[i,*],niceStrings, $
                              OUT_IMGARR=out_imgArr, $
                              OUT_TITLEOBJS=out_titleObjs, $
                              COMBINED_TO_BUFFER=combined_to_buffer, $
                              SAVE_COMBINED_WINDOW=save_combined_window, $
                              SAVE_COMBINED_NAME=save_combined_name[i], $
                              PLOTDIR=plotDir, $
                              /DELETE_PLOTS_WHEN_FINISHED
     ENDFOR
  ENDIF


END