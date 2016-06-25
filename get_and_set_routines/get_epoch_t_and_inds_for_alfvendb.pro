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
PRO GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs, $
                                      TBEFOREEPOCH=tBeforeEpoch, $
                                      TAFTEREPOCH=tAfterEpoch, $
                                      CENTERTIME=centerTime, $
                                      DATSTARTSTOP=datStartStop, $
                                      TSTAMPS=tStamps, $
                                      GOOD_I=good_i, $
                                      NALFEPOCHS=nAlfEpochs, $
                                      ALF_EPOCH_T=alf_epoch_t, $
                                      ALF_EPOCH_I=alf_epoch_i, $
                                      EMPTY_EPOCHS_I=empty_epochs_i, $
                                      ALF_CENTERTIME=alf_centerTime, $
                                      ALF_TSTAMPS=alf_tStamps, $
                                      RESTRICT_ALTRANGE=restrict_altRange, $
                                      RESTRICT_CHARERANGE=restrict_charERange, $
                                      RESTRICT_ORBRANGE=restrict_orbRange, $
                                      RESTRICT_POYNTRANGE=restrict_poyntRange, $
                                      MINMLT=minM, $
                                      MAXMLT=maxM, $
                                      BINM=binM, $
                                      MINILAT=minI, $
                                      MAXILAT=maxI, $
                                      BINI=binI, $
                                      DO_LSHELL=do_lshell, $
                                      MINLSHELL=minL, $
                                      MAXLSHELL=maxL, $
                                      BINL=binL, $
                                      BOTH_HEMIS=both_hemis, $
                                      NORTH=north, $
                                      SOUTH=south, $
                                      HEMI=hemi, $
                                      RESET_GOOD_INDS=reset_good_inds, $
                                      DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr

  include     = MAKE_ARRAY(nEpochs,/BYTE,VALUE=0)
  alf_epoch_t = MAKE_ARRAY(nEpochs,2,/DOUBLE)
  alf_epoch_i = MAKE_ARRAY(nEpochs,2,/L64)
  empty_epochs_i = !NULL

  good_i      = GET_CHASTON_IND(maximus,"OMNI",-1, $
                                DBTIMES=cdbTime, $
                                BOTH_HEMIS=both_hemis, $
                                NORTH=north, $
                                SOUTH=south, $
                                HEMI=hemi, $ ;/BOTH_HEMIS, $
                                ALTITUDERANGE=N_ELEMENTS(restrict_altRange) EQ 1 ? [0000,5000] : (N_ELEMENTS(restrict_altRange) GT 1 ? restrict_altRange : !NULL), $
                                CHARERANGE=N_ELEMENTS(restrict_charERange) EQ 1 ? [4,30000] : (N_ELEMENTS(restrict_charERange) GT 1 ? restrict_charERange : !NULL), $ 
                                ORBRANGE=N_ELEMENTS(restrict_orbRange) EQ 1 ? [500,12670] : (N_ELEMENTS(restrict_orbRange) GT 1 ? restrict_orbRange : !NULL), $
                                POYNTRANGE=N_ELEMENTS(restrict_poyntRange) EQ 1 ? [1,100] : (N_ELEMENTS(restrict_poyntRange) GT 1 ? restrict_poyntRange : !NULL), $ 
                                ;; CHARERANGE=(restrict_charERange) ? [300,4000] : !NULL, $
                                ;; CHARERANGE=(restrict_charERange) ? [4,300] : !NULL, $
                                MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                DAYSIDE=dayside, $
                                NIGHTSIDE=nightside, $
                                RESET_GOOD_INDS=reset_good_inds, $
                                /PRINT_PARAM_SUMMARY)
  
  PRINT,FORMAT='("i",T4,"centerTime",T25,"tempClosest start (hrs)",T50,"tempClosest stop (hrs)",T75,"Num events in range")'
  tempClosest            = MAKE_ARRAY(2,/DOUBLE,VALUE=0)
  tc_ii_Arr              = MAKE_ARRAY(2,/L64,VALUE=0)
  FOR i=0,nEpochs-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest[j]   = MIN(ABS(datStartStop[i,j]-cdbTime[good_i]),tempClosest_ii)
        tc_ii_Arr[j]     = tempClosest_ii

        tempClosest[j]   = cdbTime[good_i[tc_ii_Arr[j]]]-datStartStop[i,j]
        alf_epoch_i[i,j] = good_i[tc_ii_Arr[j]]
        alf_epoch_t[i,j] = cdbTime[good_i[tc_ii_Arr[j]]]

        ;; include[i,j]     = ((tempClosest/3600.0D GE (-tBeforeEpoch) AND tempClosest/3600.0D LE 0) $
        ;;                     OR (tempClosest/3600.0D LE tAfterEpoch AND tempClosest/3600.0D GE 0))
        ;; PRINT,FORMAT='(I0,T4,I0,T8,A0,T43,F0.2,)',i,j,tStamps[i],tempClosest/3600.,
     ENDFOR
     plot_i             = CGSETINTERSECTION(good_i,INDGEN(alf_epoch_i[i,1]-alf_epoch_i[i,0]+1,/L64)+alf_epoch_i[i,0])
     test               = WHERE( ( VALUE_LOCATE(datStartStop[i,*],cdbTime[plot_i]) ) EQ 0,count)
     IF count GT 0 THEN BEGIN
        include[i]      = 1
     ENDIF ELSE BEGIN
        empty_epochs_i  = [empty_epochs_i,i]
     ENDELSE
     ;; include[i] = (tempClosest/3600. LE tBeforeEpoch AND tempClosest/3600. LE tAfterEpoch)
     ;; include[i]         = ((tempClosest/3600.0D GE (-tBeforeEpoch) AND tempClosest/3600.0D LE 0) $
     ;;                       OR (tempClosest/3600.0D LE tAfterEpoch AND tempClosest/3600.0D GE 0))
     PRINT,FORMAT='(I0,T4,A0,T25,F12.2,T50,F12.2,T75,I0)',i,tStamps[i], $
           tempClosest[0]/3600.0D, $
           tempClosest[1]/3600.0D, $
           (include[i] OR include[i]) ? N_ELEMENTS(plot_i) : 0
  ENDFOR

  include_i       = WHERE(include)
  nAlfEpochs      = N_ELEMENTS(include_i)
  alf_epoch_i     = alf_epoch_i[include_i,*]
  alf_epoch_t     = alf_epoch_t[include_i,*]
  alf_tStamps     = tStamps[include_i]
  alf_centerTime  = centerTime[include_i]

  IF saveFile THEN saveStr+=',nEpochs,centerTime,tStamps,epochString,dbFile,tBeforeEpoch,tAfterEpoch,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list'


END