;2016/01/12 I have a hunch that these two quantities are inversely related
PRO JOURNAL__20160112__SCATTERPLOT__19_CHAR_ION_ENERGY_VS_49_PFLUXEST_FOR_SEA_EVENTS

  indFile                    = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/temp/20160112--AlfDB_plot_i_and_epoch_times_for_SEAs.sav'
  
  load_maximus_and_cdbtime,maximus

  restore,indFile

  pFluxEst                   = maximus.pfluxest[tot_plot_i]
  charIE                     = maximus.char_ion_energy[tot_plot_i]

  ;; pFluxEst                   = ALOG10(maximus.pfluxest[tot_plot_i])
  ;; charIE                     = ALOG10(maximus.char_ion_energy[tot_plot_i])

  ;; xRange                     = [-2,2]
  xRange                     = [0,100]
  yRange                     = [0,40]
  ;; yRange                     = [0,1.5]

  ;;linear regression, of form A + Bx
  linReg                     = LINFIT(pFluxEst, charIE, CHISQR=chisqr, COVAR=covar, $
                                      MEASURE_ERRORS=measures, PROB=prob, SIGMA=sigma, $
                                      YFIT=yfit)
  A                          = linReg[0]
  B                          = linReg[1]

  myX                        = INDGEN ((xRange[1]-xRange[0])*40)/40.-xRange[1]
  myY                        = A + B*myX

  ;;A scatterplot?
  sc_plot                    = SCATTERPLOT(pFluxEst,charIE,SYM_TRANSPARENCY=97, $
                                           XTITLE='Log Poynting Flux Estimate', $
                                           YTITLE='Characteristic Ion Energy (eV)', $
                                           ;; XRANGE=[0,80], $
                                           XRANGE=xRange, $
                                           YRANGE=yRange)
  
  regPlot                    = PLOT(myX,myY, /OVERPLOT, $
                                    XRANGE=xRange)

  myText = TEXT(0.5, 0.8,STRING(FORMAT='("y =  ",G0.3," + ",G0.3,"x")',A,B), FONT_COLOR='green', $
   FONT_SIZE=9, FONT_STYLE='italic', /NORMAL, TARGET=sc_plot)

END