;2015/10/31 Halloween in Utah!
;The save file mentioned here was produced with the following command:
;save,tot_alf_t_list,tot_alf_y_list,maxind,good_i,minmaxdat,nalfepochs,nepochs,alf_centertime,alf_tstamps,tbeforeepoch,tafterepoch,alf_epoch_i,alf_ind_list,FILENAME='chare_data_for_72_largestorms_no_NOAA.sav'

PRO JOURNAL__20151031__GENERATING_STATISTICS_FOR_CHARE_AS_A_FUNCTION_OF_LARGESTORM_EPOCH_SLICE__TELECON20151028

  date            = '20151103'
  dataName        = 'char_ion_energy'
  unlog           = 0
  histBinsize     = 0.25

  ;data in        
  inFile          = 'chare_data_for_72_largestorms_no_NOAA.sav'
  restore,inFile
  nSlices         = N_ELEMENTS(histTBins)
  tot_alf_t       = LIST_TO_1DARRAY(tot_alf_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
  tot_alf_y       = LIST_TO_1DARRAY(tot_alf_y_list,/WARN,/SKIP_NEG1_ELEMENTS)

  ;data out
  genFile         = 'journal__20151031__generating_statistics_for_chare_as_a_function_of_largestorm_epoch_slice__telecon20151028.pro'
  outstats        = date + '--chare_moment_data_for_72_largestorms--no_NOAA_SSC.sav'
  sPP             = date + '--' + dataName + '--72_largestorms--no_NOAA_SSC'   ;savePlotPrefix

  ;plot array/window setup
  nWindows   = 5
  windowArr  = MAKE_ARRAY(nWindows,/OBJ)
  plotLayout = [3,2]
  nPPerWind  = plotLayout[0]*plotLayout[1]

  ;plot details
  xTitle     = 'Characteristic Ion Energy (eV)'
  yTitle     = "Count"
  ;; xRange     = [histTBins[0],histTBins[-1]]
  xRange     = [-6,1]
  ;; yRange     = [MIN(tot_alf_y),MAX(tot_alf_y)]
  yRange     = [0,10000]
  pHP        = MAKE_HISTOPLOT_PARAM_STRUCT(NAME=dataName, $
                                           XTITLE=xTitle, $
                                           YTITLE=yTitle, $
                                           XRANGE=xRange, $
                                           YRANGE=yRange, $
                                           HISTBINSIZE=histBinsize, $
                                           XP_ARE_LOGGED=~unlog)
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
        t2              = histTbins[i+nPerWind-1]
        wTitle          = STRING(FORMAT='("Storm epoch hours ",I0,"–",I0)',t1,t2)
        saveName        = STRING(FORMAT='(A0,"--epoch_",I0,"-",I0,".png")',sPP,t1,t2)

        windowArr[wInd] = WINDOW(TITLE=wTitle,DIMENSIONS=[1200,800])
        
     ENDIF

     
     x      = ssa[i].yHistStr.locs[0] + ssa[i].yHistStr.binsize/2.
     y      = ssa[i].yHistStr.hist[0] 
     title  = STRING(FORMAT='("Storm epoch hours ",I0,"–",I0)',ssa[i].eStart,ssa[i].eEnd)
     
     plot   = plot(x,y, $
                   TITLE=title, $
                   XTITLE=pHP.xTitle, $
                   YTITLE=pHP.yTitle, $
                   XRANGE=pHP.xRange, $
                   YRANGE=pHP.yRange, $
                   /HISTOGRAM, $
                   LAYOUT=[plotLayout,(i MOD nPPerWind)], $
                   /CURRENT)
                   
                 
     IF (i GT 0) AND ( (i + 1) MOD nPPerWind ) THEN BEGIN
        windowArr[wInd].save,saveName,RESOLUTION=300
     ENDIF

  ENDFOR

END