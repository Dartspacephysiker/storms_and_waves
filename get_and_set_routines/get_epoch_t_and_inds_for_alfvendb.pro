PRO GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                      DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                      ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                      RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                      MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                      DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                      DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr

  alf_epoch_t=MAKE_ARRAY(nEpochs,2,/DOUBLE)
  alf_epoch_i=MAKE_ARRAY(nEpochs,2,/L64)
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS, $
                         ALTITUDERANGE=(restrict_altRange) ? [1000,5000] : !NULL, $
                         CHARERANGE=(restrict_charERange) ? [4,300] : !NULL, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                         DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside,/PRINT_PARAM_SUMMARY)
  
  ;; PRINT,FORMAT='("i",T4,"j",T8,"tempClosest (hours)",T33,"centerTime")'
  ;; FOR i=0,nEpochs-1 DO BEGIN
  ;;    FOR j=0,1 DO BEGIN
  ;;       tempClosest=MIN(ABS(datStartStop[i,j]-cdbTime(good_i)),tempClosest_ii)
  ;;       alf_epoch_i[i,j]=good_i(tempClosest_ii)
  ;;       alf_epoch_t[i,j]=cdbTime(good_i(tempClosest_ii))

  ;;       PRINT,FORMAT='(I0,T4,I0,T8,F0.2,T33,A0)',i,j,tempClosest/3600.,tStamps[i]
  ;;    ENDFOR
  ;; ENDFOR

  PRINT,FORMAT='("i",T4,"centerTime",T25,"tempClosest (hours)",T48,"Num events in range")'
  FOR i=0,nEpochs-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop[i,j]-cdbTime[good_i]),tempClosest_ii)
        alf_epoch_i[i,j]=good_i[tempClosest_ii]
        alf_epoch_t[i,j]=cdbTime[good_i[tempClosest_ii]]

        ;; PRINT,FORMAT='(I0,T4,I0,T8,A0,T43,F0.2,)',i,j,tStamps[i],tempClosest/3600.,
     ENDFOR
     plot_i=cgsetintersection(good_i,indgen(alf_epoch_i[i,1]-alf_epoch_i[i,0]+1)+alf_epoch_i[i,0])
     PRINT,FORMAT='(I0,T4,A0,T25,F0.2,T48,I0)',i,tStamps[i],tempClosest/3600., $
           (tempClosest/3600. GT tBeforeEpoch AND tempClosest/3600. GT tAfterEpoch) ? 0 : N_ELEMENTS(plot_i)

  ENDFOR

  IF saveFile THEN saveStr+=',nEpochs,centerTime,tStamps,epochString,dbFile,tBeforeEpoch,tAfterEpoch,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list'


END