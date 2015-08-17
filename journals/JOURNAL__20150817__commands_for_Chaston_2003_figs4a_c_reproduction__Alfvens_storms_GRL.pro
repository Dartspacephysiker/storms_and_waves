;2015/08/17
;These plots have to be reproduced because we now have burst data, son.

PRO JOURNAL__20150817__commands_for_Chaston_2003_figs4a_c_reproduction__Alfvens_storms_GRL

  date='20150817'
  dbDate = '20150811'

  dirs='all_IMF'
  ;; dirs=['duskward', 'dawnward']

  plotDir="/SPENCEdata/Research/Cusp/storms_Alfvens/plots/20150817__Chaston_2003_fig4a__Alfvens_storms_GRL/"
  plotSuff="Dartdb_" + dbDate 
  ;; plotDir="LaBelle_Bin_mtg--02042015/Chaston_2003_fig4a-d/"

  plotLabelFormat='(D0.2)'

  ;;hemisphere?
  hemi="North"
  ;; hemi="South"

  ;;different delay?
  ;delay=!NULL
  delay=1020

  ;maskMin
  mskm=3

  ;delete postscript?
  del_PS = 1

  ;charERange?
  charERange=[4.0,4e3]

  ;altRange?
  altitudeRange=[0.0,5000.0]

 ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi,/orbplots, $
                                        /orbcontribplot,/orbtotplot,/orbfreqplot, $
                                        /neventperorbplot, /logneventperorb, $
                                        ;; neventperorbrange=[0.01,10.0], $
                                        neventperorbrange=[-2.0,1.11394334], $
                                        nEventsRange=[0,3000], orbFreqRange=[0.0, 0.8], orbcontribrange=[1,200], $
                                        /WHOLECAP,/midnight,DELAY=delay,/noplotintegral,DEL_PS = del_PS, $
                                        CHARERANGE=charERange, ALTITUDERANGE=altitudeRange,LABELFORMAT=plotLabelFormat

  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
  ;;                                       /eplots,efluxplottype="Max",customerange=[-1,1.5],/logefplot,/nonegeflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
                                        /eplots,efluxplottype="Max",eplotrange=[-1,2],/logefplot,/abseflux,/WHOLECAP,/midnight, $
                                        DELAY=delay,/noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange, ALTITUDERANGE=altitudeRange, $
                                        /logavgplot,LABELFORMAT=plotLabelFormat ;,/medianplot
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
                                        /pplots,pplotrange=[-1.7,1.698977],/logpfplot,/nonegpflux,/WHOLECAP,/midnight, $
                                        DELAY=delay,/noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange, ALTITUDERANGE=altitudeRange, $
                                        /logavgplot,LABELFORMAT=plotLabelFormat ;, /medianplot
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
  ;;                                       /pplots,pplotrange=[0.05,10],/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
  ;;                                       /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange, ALTITUDERANGE=altitudeRange
  
  ;Better (for showing features) plotrange
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
  ;;                                       /pplots,pplotrange=[-1.3,1.0],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
  ;;                                       /noplotintegral,DEL_PS = del_PS
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
  ;;                                       /pplots,/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
  ;;                                       /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange, ALTITUDERANGE=altitudeRange

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, HEMI=hemi, $
                                        /chareplot,charetype="lossCone",/logCharEPlot, $ ;chareplotrange=[0,4e3],
                                        /WHOLECAP,/midnight,DELAY=delay, $
                                        /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange, ALTITUDERANGE=altitudeRange, $
                                        /logavgplot,LABELFORMAT=plotLabelFormat ;,/medianplot

END