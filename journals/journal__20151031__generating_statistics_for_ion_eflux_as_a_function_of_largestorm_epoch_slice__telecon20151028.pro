;2015/10/31 Halloween in Utah!
;The save file mentioned here was produced with the following command:
;save,tot_alf_t_list,tot_alf_y_list,maxind,good_i,minmaxdat,nalfepochs,nepochs,alf_centertime,alf_tstamps,tbeforeepoch,tafterepoch,alf_epoch_i,alf_ind_list,FILENAME='chare_data_for_72_largestorms_no_NOAA.sav'
;2015/11/10
; I am almost certain that I was actually using ion energy flux and not characteristic ion 
; energy, a conclusion I reached by checking out the ranges of the data
PRO JOURNAL__20151031__GENERATING_STATISTICS_FOR_ION_EFLUX_AS_A_FUNCTION_OF_LARGESTORM_EPOCH_SLICE__TELECON20151028

  date            = '20151103'
  dataName        = 'ion_energy_flux'
  unlog           = 0
  normalize_hists = 1
  histBinsize     = 0.25
  newLine         = '!C'

  ;data in        
  inFile          = 'ion_eflux_data_for_72_largestorms_no_NOAA.sav'
  restore,inFile
  nSlices         = N_ELEMENTS(histTBins)
  tot_alf_t       = LIST_TO_1DARRAY(tot_alf_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
  tot_alf_y       = LIST_TO_1DARRAY(tot_alf_y_list,/WARN,/SKIP_NEG1_ELEMENTS)

  ;data out
  genFile         = 'journal__20151031__generating_statistics_for_ion_eflux_as_a_function_of_largestorm_epoch_slice__telecon20151028.pro'
  outstats        = date + '--ion_eflux__moment_data_for_72_largestorms--no_NOAA_SSC.sav'
  SET_PLOT_DIR,plotDir,/FOR_STORMS,/VERBOSE,/ADD_TODAY
  sPP             = plotDir + dataName + '--72_largestorms--no_NOAA_SSC'   ;savePlotPrefix


  ;plot array/window setup
  nWindows   = 5
  windowArr  = MAKE_ARRAY(nWindows,/OBJ)
  plotArr    = MAKE_ARRAY(nSlices,/OBJ)
  plotLayout = [3,2]
  firstmarg  = [0.1,0.1,0.1,0.1]
  marg       = [0.01,0.01,0.1,0.01]
  nPPerWind  = plotLayout[0]*plotLayout[1]

  ;plot details
  ;; xTitle     = 'Characteristic Ion Energy (eV)'
  xTitle     = 'Ion Energy Flux (units?)'
  yTitle     = "Count"
  ;; xRange     = [histTBins[0],histTBins[-1]]
  xRange     = [-6,0]
  ;; yRange     = [MIN(tot_alf_y),MAX(tot_alf_y)]
  yRange     = [0,1000]
  pHP        = MAKE_HISTOPLOT_PARAM_STRUCT(NAME=dataName, $
                                           XTITLE=xTitle, $
                                           YTITLE=yTitle, $
                                           XRANGE=xRange, $
                                           YRANGE=yRange, $
                                           HISTBINSIZE=histBinsize, $
                                           XP_ARE_LOGGED=~unlog) ;, $
                                           ;; MARGIN=margin, $
                                           ;; LAYOUT=layout)
  ;;declare the slice structure array
  ssa = !NULL

  ;;First, all of the text output
  PRINT,FORMAT='("Low (hr)",T10,"High (hr)",T20,"N",T30,"Mean",T40,"Std. dev.",T50,"Skewness",T60,"Kurtosis")'
  FOR i=0,nSlices-2 DO BEGIN
     temp_ii   = WHERE(tot_alf_t GE histTBins[i] AND tot_alf_t LT histTBins[i+1])
     tempData  = tot_alf_y[temp_ii]
     IF KEYWORD_SET(unlog) THEN BEGIN
        tempData                 = 10^(tempData)
     ENDIF
     tempStats = MOMENT(tempData)

     tempESlice = MAKE_EPOCHSLICE_STRUCT(DATANAME=dataName, $
                                         EPOCHSTART=histTBins[i], $
                                         EPOCHEND=histTBins[i+1], $
                                         YDATA=tempData, $
                                         IS_LOGGED_YDATA=~unlog, $
                                         /DO_HIST, $
                                         HISTMIN=pHP.xRange[0], $
                                         HISTMAX=pHP.xRange[1], $
                                         HISTBINSIZE=histBinsize, $
                                         TDATA=tot_alf_t[temp_ii], $
                                         MOMENTSTRUCT=MAKE_MOMENT_STRUCT(tempData), $
                                         GENERATING_FILE=genFile)

     ssa = [ssa,tempESlice]

  PRINT,FORMAT='(I0,T10,I0,T20,I0,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4)', $
        tempESlice.eStart, $
        tempESlice.eEnd, $
        N_ELEMENTS(temp_ii), $
        tempESlice.moments.(0), $
        SQRT(tempESlice.moments.(1)), $
        tempESlice.moments.(2), $
        tempESlice.moments.(3)

  ENDFOR

  ;;Now the windows
  FOR i=0,nSlices-2 DO BEGIN
     ;set up a new window, if need be
     IF (i MOD nPPerWind) EQ 0 THEN BEGIN
        wInd            = FLOOR(i/FLOAT(nWindows))
        t1              = histTbins[i]
        t2              = histTbins[i+nPPerWind]
        wTitle          = STRING(FORMAT='("Storm epoch hours ",F0.2," through ",F0.2)',t1,t2)
        saveName        = STRING(FORMAT='(A0,"--epoch_",I0,"_through_",I0,".png")',sPP,t1,t2)

        windowArr[wInd] = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])
        
     ENDIF

     ;get which panel this is
     layout_i    = (i MOD nPPerWind)+1
     
     ;the indata
     x           = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
     y           = ssa[i].yHistStr.hist[0] 

     integral    = TOTAL(y)
     IF KEYWORD_SET(normalize_hists) THEN BEGIN
        y        = y / integral
        pHP.yRange = [0,0.3]
        pHP.yTitle = 'Relative Freq.'
     ENDIF 

     ;; IF layout_i EQ 1 THEN BEGIN
        title       = STRING(FORMAT='("Storm epoch hours ",I0," through ",I0)',ssa[i].eStart,ssa[i].eEnd)
        xTitle      = layout_i GT plotLayout[0] ? pHP.xTitle : !NULL
        yTitle      = pHP.yTitle
        ;; yMajorTicks = 3
        ;; yTickName   = REPLICATE(' ',yMajorTicks)
        margin      = firstMarg
     ;; ENDIF ELSE BEGIN
     ;;    title       = STRING(FORMAT='(I0," through ",I0)',ssa[i].eStart,ssa[i].eEnd)
     ;;    xTitle      = !NULL
     ;;    yTitle      = !NULL
     ;;    yMajorTicks = !NULL
     ;;    yTickName   = !NULL
     ;;    margin      = marg
     ;; ENDELSE
     
     plotArr[i]  = plot(x,y, $
                        TITLE=title, $
                        XTITLE=xTitle, $
                        YTITLE=yTitle, $
                        XRANGE=pHP.xRange, $
                        YRANGE=pHP.yRange, $
                        ;; YTICKS=yMajorTicks, $
                        ;; YTICKNAME=yTickName, $
                        /HISTOGRAM, $
                        LAYOUT=[plotLayout,layout_i], $
                        MARGIN=margin, $
                        /CURRENT)

     ;;For the integral
     intString   = STRING(FORMAT='("Integral  : ",I0)',integral)
     ;; textStr     = intString+ newLine + $
     ;;               'Mean      : ' + ssa[i].moments.(0) + newLine + $
     ;;               'Std. dev. : ' + ssa[i].moments.(1) + newLine + $
     ;;               'Skewness  : ' + ssa[i].moments.(2) + newLine + $
     ;;               'Kurtosis  : ' + ssa[i].moments.(3) + newLine

     textStr     = STRING(FORMAT='(A0,A0,A0,E0.2,A0,A0,E0.2,A0,A0,E0.2,A0,A0,E0.2,A0)', $
                          intString,newLine, $
                          'Mean      : ', ssa[i].moments.(0), newLine, $
                          'Std. dev. : ', ssa[i].moments.(1), newLine, $
                          'Skewness  : ', ssa[i].moments.(2), newLine, $
                          'Kurtosis  : ', ssa[i].moments.(3), newLine)
     

     int_x       = ( ( (layout_i - 1) MOD plotLayout[0] )) * 1/FLOAT(plotLayout[0]) + 0.05
     int_y       = 1 - 1/FLOAT(plotLayout[1]*2) - ( ( (layout_i - 1) / plotLayout[0] )) * 1/FLOAT(plotLayout[1]) + 1/FLOAT(plotLayout[1]*8)
     intText     = text(int_x,int_y,$
                        textStr, $
                        FONT_NAME='Courier', $
                        /NORMAL, $
                        TARGET=plotArr[i])
     

     IF (i GT 0) AND ( ( (i + 1) MOD nPPerWind ) EQ 0 ) THEN BEGIN
        windowArr[wInd].save,saveName,RESOLUTION=300
     ENDIF

  ENDFOR

END