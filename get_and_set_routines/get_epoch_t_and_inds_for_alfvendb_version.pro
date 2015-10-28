PRO GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime, $
                                      NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                      CENTERTIME=centerTime, $
                                      DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                      NALFEPOCHS=nAlfEpochs,ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                      RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                      MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                      DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                      DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                      SAVEFILE=saveFile,SAVESTR=saveStr

  nAlfEpochs = nEpochs
  alf_epoch_t=MAKE_ARRAY(nEpochs,2,/DOUBLE)
  alf_epoch_i=MAKE_ARRAY(nEpochs,2,/L64)
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS, $
                         ALTITUDERANGE=(restrict_altRange) ? [1000,5000] : !NULL, $
                         CHARERANGE=(restrict_charERange) ? [4,4000] : !NULL, $
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

        tempClosest1  = MIN(ABS(datStartStop[i,0]-cdbTime[good_i]),tempClosest_ii1)
        tempClosest1  = datStartStop[i,0]-cdbTime[good_i[tempClosest_ii1]]
        temp_epoch_i1 = good_i[tempClosest_ii1]
        temp_epoch_t1 = cdbTime[good_i[tempClosest_ii1]]

        tempClosest2  = MIN(ABS(datStartStop[i,1]-cdbTime[good_i]),tempClosest_ii2)
        tempClosest2  = datStartStop[i,1]-cdbTime[good_i[tempClosest_ii2]]
        temp_epoch_i2 = good_i[tempClosest_ii2]
        temp_epoch_t2 = cdbTime[good_i[tempClosest_ii2]]

        ;; PRINT,FORMAT='(I0,T4,I0,T8,A0,T43,F0.2,)',i,j,tStamps[i],tempClosest/3600.,
     
     ;;keep 'im?
     tempInclude = (tempClosest1/3600. LT tBeforeEpoch OR tempClosest2/3600. LT tAfterEpoch)
     IF tempInclude THEN BEGIN
        plot_i=cgsetintersection(good_i,indgen(alf_epoch_i[i,1]-alf_epoch_i[i,0]+1)+alf_epoch_i[i,0])
        PRINT,FORMAT='(I0,T4,A0,T25,F0.2,T48,I0)', $
              i, $
              tStamps[i], $
              MIN(ABS([tempClosest1-centerTime[i],tempClosest2-centerTime[i]]))/3600., $
              N_ELEMENTS(plot_i)
        alf_epoch_i[i,0]= temp_epoch_i1
        alf_epoch_t[i,0]= temp_epoch_t1
        alf_epoch_i[i,1]= temp_epoch_i2
        alf_epoch_t[i,1]= temp_epoch_t2
     ENDIF ELSE BEGIN
        PRINT,'No Alfven events for epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + '!!!' 
        print,FORMAT='("Epoch ",I0,":",TR5,A0)',i,tStamps[i] ;show me where!
        nAlfEpochs--
     ENDELSE

  ENDFOR
  
  alf_epoch_t = alf_epoch_t[0:nAlfEpochs-1,*]
  alf_epoch_i = alf_epoch_i[0:nAlfEpochs-1,*]

  IF saveFile THEN saveStr+=',nEpochs,centerTime,tStamps,epochString,dbFile,tBeforeEpoch,tAfterEpoch,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list'


END