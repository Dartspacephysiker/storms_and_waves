;;This routine, called from a few of the storm plotting procedures, creates 
;; the following important variables:
;;
;; alf_epoch_t        : an NEPOCHSx2 array of UTC times
;;  alf_epoch_t[*,0]  : start time of the given Alfven epoch
;;  alf_epoch_t[*,1]  : stop time of the given Alfven epoch
;;
;; alf_epoch_i        : an NEPOCHSx2 array of UTC times
;;  alf_epoch_i[*,0]  : start index into the AlfvenDBStr for the given Alfven epoch
;;  alf_epoch_t[*,1]  : stop index into the AlfvenDBStr for the given Alfven epoch
;;
;; include_i          : Indices of the epochs for which we have data. All others discarded from
;;                       variables alf_centerTime, alf_tStamps, nAlfEpochs, alf_epoch_t, 
;;                       and alf_epoch_i
PRO GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                      CENTERTIME=centerTime, $
                                      DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                      NALFEPOCHS=nAlfEpochs,ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                      ALF_CENTERTIME=alf_centerTime,ALF_TSTAMPS=alf_tStamps, $
                                      RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                      MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                      DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                      BOTH_HEMIS=both_hemis, $
                                      NORTH=north, $
                                      SOUTH=south, $
                                      HEMI=hemi, $
                                      DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr

  include     = MAKE_ARRAY(nEpochs,2,/BYTE,VALUE=0)
  alf_epoch_t = MAKE_ARRAY(nEpochs,2,/DOUBLE)
  alf_epoch_i = MAKE_ARRAY(nEpochs,2,/L64)

  good_i=GET_CHASTON_IND(maximus,"OMNI",-1, $
                         BOTH_HEMIS=both_hemis, $
                         NORTH=north, $
                         SOUTH=south, $
                         HEMI=hemi, $ ;/BOTH_HEMIS, $
                         ALTITUDERANGE=N_ELEMENTS(restrict_altRange) EQ 1 ? [1000,5000] : (N_ELEMENTS(restrict_altRange) GT 1 ? restrict_altRange : !NULL), $
                         CHARERANGE=N_ELEMENTS(restrict_charERange) EQ 1 ? [4,4000] : (N_ELEMENTS(restrict_charERange) GT 1 ? restrict_charERange : !NULL), $ 
                         ;; CHARERANGE=(restrict_charERange) ? [300,4000] : !NULL, $
                         ;; CHARERANGE=(restrict_charERange) ? [4,300] : !NULL, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                         DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside,/PRINT_PARAM_SUMMARY)
  
  PRINT,FORMAT='("i",T4,"centerTime",T25,"tempClosest (hours)",T48,"Num events in range")'
  FOR i=0,nEpochs-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop[i,j]-cdbTime[good_i]),tempClosest_ii)
        alf_epoch_i[i,j]=good_i[tempClosest_ii]
        alf_epoch_t[i,j]=cdbTime[good_i[tempClosest_ii]]

        ;; PRINT,FORMAT='(I0,T4,I0,T8,A0,T43,F0.2,)',i,j,tStamps[i],tempClosest/3600.,
     ENDFOR
     plot_i=cgsetintersection(good_i,indgen(alf_epoch_i[i,1]-alf_epoch_i[i,0]+1)+alf_epoch_i[i,0])
     include[i] = (tempClosest/3600. LE tBeforeEpoch AND tempClosest/3600. LE tAfterEpoch)
     PRINT,FORMAT='(I0,T4,A0,T25,F0.2,T48,I0)',i,tStamps[i],tempClosest/3600., $
           include[i] ? N_ELEMENTS(plot_i) : 0



  ENDFOR

  include_i       = WHERE(include)
  nAlfEpochs      = N_ELEMENTS(include_i)
  alf_epoch_i     = alf_epoch_i[include_i,*]
  alf_epoch_t     = alf_epoch_t[include_i,*]
  alf_tStamps     = tStamps[include_i]
  alf_centerTime  = centerTime[include_i]

  IF saveFile THEN saveStr+=',nEpochs,centerTime,tStamps,epochString,dbFile,tBeforeEpoch,tAfterEpoch,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list'


END