;+
;2015/08/31 13:32 at Dartmouth
;A hand-selected period of about two minutes which should have three big Alfven events in it as FAST was outbound in the Northern Hemi.
; ;; NOTE! We do not smooth the E field in our plots!!
; 
; ;; 2015/09/01 
; ;; By appearances, these data are sampled at 128 Hz
;    (Try, e.g., get_data,'EFIELD',data=efield
;    print,efield.x(160001:170001)-efield.x(160000:170000).
;    Same goes for 'MagZ'. )           
;    Also, note that all points in our interval of interest, between tStart and tEnd, are sampled at 128 Hz. So smooth em!
;-
PRO JOURNAL__20150831__five_panel_from_scratch_w_help_from_as5__Alfvens_storms_GRL,TSTARTSTR=tStartStr,TENDSTR=tEndStr

  @startup

  ;;We always prefer pretty colors—you know that
  DEVICE,decomposed=0
  loadct2,43

  ;;These are from gen_fa_k0_dcf_gifps.pro. Maybe helpful?
  !p.charsize = 1.3
  xgifsize = 700
  ygifsize = 900
  tplot_options,'xmargin',[12,12] ; left and right x-margins, in chars

  ;; tStartStr='1998-09-25/02:48:00'
  ;; tEndStr='1998-09-25/02:49:00'
  IF ~KEYWORD_SET(tStartStr) THEN tStartStr='1998-09-25/02:46:30'
  IF ~KEYWORD_SET(tEndStr) THEN tEndStr='1998-09-25/02:48:25'
  tStart=STR_TO_TIME(tStartStr)
  tEnd=STR_TO_TIME(tEndStr)

  ;; orbs=8277
  ;; tStart='1998-09-25/02:46:30'
  ;; tEnd='1998-09-25/02:48:25'

  if not keyword_set(energy_electrons) then energy_electrons=[0.,30000.] ;use 0.0 for lower bound since the sc_pot is used to set this
  if not keyword_set(energy_ions) then energy_ions=[0.,500.]             ;use 0.0 for lower bound since the sc_pot is used to set this
  
  ;; If no data exists, return to main
  t=0
  dat = get_fa_ees(t,/st)
  if dat.valid eq 0 then begin
     print,' ERROR: No FAST electron survey data -- get_fa_ees(t,/st) returned invalid data'
     return
  endif
  
  
  
  ;; Electron current - line plot
  
  if keyword_set(burst) then begin
     get_2dt_ts,'j_2d_b','fa_eeb',t1=t1,t2=t2,name='Je',energy=energy_electrons
  endif else begin
     get_2dt_ts,'j_2d_b','fa_ees',t1=t1,t2=t2,name='Je',energy=energy_electrons
  endelse
  
  ;;remove spurious crap
  get_data,'Je',data=tmpj
  
  keep=where(finite(tmpj.y) NE 0)
  tmpj.x=tmpj.x(keep)
  tmpj.y=tmpj.y(keep)
  
  keep=where(abs(tmpj.y) GT 0.0)
  tx=tmpj.x(keep)
  ty=tmpj.y(keep)
  
  ;;get timescale monotonic
  
  time_order=sort(tx)
  tx=tx(time_order)
  ty=ty(time_order)
  
  
  ;;throw away the first 10  points since they are often corrupted
  if not keyword_set(burst) then begin
     store_data,'Je',data={x:tx(10:n_elements(tx)-1),y:ty(10:n_elements(tx)-1)}
  endif else begin
     store_data,'Je',data={x:tx,y:ty}
  endelse
  
  ;;eliminate data from latitudes below the Holzworth/Meng auroral oval 
  get_data,'Je',data=je
  get_fa_orbit,/time_array,je.x
  get_data,'MLT',data=mlt
  get_data,'ILAT',data=ilat
  keep=where(abs(ilat.y) GT auroral_zone(mlt.y,7,/lat)/(!DPI)*180.)
  
  store_data,'Je',data={x:je.x(keep),y:je.y(keep)}

  ;;Use the electron data to define the time ranges for this orbit	
  
  get_data,'Je',data=je
  part_res_je=make_array(n_elements(Je.x),/double)
  for j=1,n_elements(Je.x)-1 do begin
     part_res_je(j)=abs(Je.x(j)-Je.x(j-1))
  endfor
  part_res_Je(0)=part_res_Je(1)
  gap=where(part_res_je GT 10.0)
  if gap(0) NE -1 then begin
     separate_start=[0,where(part_res_je GT 10.0)]
     separate_stop=[where(part_res_je GT 10.0),n_elements(Je.x)-1]
  endif else begin
     separate_start=[0]
     separate_stop=[n_elements(Je.x)-1]
  endelse
	
  ;;remove esa burp when switched on
  if not keyword_set(burst) then begin
     turn_on=where(part_res_je GT 300.0)
     if turn_on(0) NE -1 then begin
        turn_on_separate=make_array(n_elements(turn_on),/double)
        for j=0,n_elements(turn_on)-1 do turn_on_separate(j)=where(separate_start EQ turn_on(j))
        separate_start(turn_on_separate+1)=separate_start(turn_on_separate+1)+5
     endif
  endif
  ;;identify time indices for each interval
  
  count=0.0
  for j=0,n_elements(separate_start)-1 do begin
     if (separate_stop(j)-separate_start(j)) GT 10 then begin
        count=count+1
        if count EQ 1.0 then begin
           time_range_indices=transpose([separate_start(j)+1,separate_stop(j)-1])
        endif else begin
           time_range_indices=[time_range_indices,transpose([separate_start(j),separate_stop(j)-1])]
        endelse
     endif
  endfor
  
  ;;identify interval times
  
  time_ranges=je.x(time_range_indices)
  number_of_intervals=n_elements(time_ranges(*,0))
  
  print,'number_of_intervals',number_of_intervals
  
  ;;loop over each time interval
  ji_tot=make_array(number_of_intervals,/double)
  ji_up_tot=make_array(number_of_intervals,/double)
  jee_tot=make_array(number_of_intervals,/double)
  Ji_tot_alf=make_array(number_of_intervals,/double)
  Ji_up_tot_alf=make_array(number_of_intervals,/double)
  Jee_tot_alf=make_array(number_of_intervals,/double)
  
  
  ;;get despun mag data if keyword set
  if keyword_set(ucla_mag_despin) then ucla_mag_despin
  
  
  ;;begin looping each interval
  jjj=0
     t1=time_ranges(jjj,0)
     t2=time_ranges(jjj,1)
     print,'time_range: ',time_to_str(time_ranges(jjj,0))+' through '+time_to_str(time_ranges(jjj,1))
     
     je_tmp_time=je.x(time_range_indices(jjj,0):time_range_indices(jjj,1))
     je_tmp_data=je.y(time_range_indices(jjj,0):time_range_indices(jjj,1))
     
     store_data,'Je_tmp',data={x:je_tmp_time,y:je_tmp_data}
     
     ;;get fields quantities
     data_valid=1.0
     dat=get_fa_fields('MagDC',t,/start)
     if dat.valid eq 0 then begin
        print,' ERROR: No FAST mag data-get_fa_fields returned invalid data'
        data_valid=0.0
     endif else begin
        if not keyword_set(ucla_mag_despin) then field=get_fa_fields('MagDC',time_ranges(jjj,0),time_ranges(jjj,1),/store)
        dat=get_fa_fields('V5-V8_S',t,/start)
        if dat.valid eq 0 then begin
           print,' ERROR: No FAST V5-V8 data-get_fa_fields returned invalid data'
           data_valid=0.0
        endif else begin
           spacecraft_potential=get_fa_fields('V8_S',time_ranges(jjj,0),time_ranges(jjj,1))
           efieldV58=get_fa_fields('V5-V8_S',time_ranges(jjj,0),time_ranges(jjj,1))
           efieldV1214=get_fa_fields('V1-V2_S',time_ranges(jjj,0),time_ranges(jjj,1))
           if efieldV1214.valid eq 0 then begin
              print,'No V1-V2 data - trying V1-V4'
              efieldV1214=get_fa_fields('V1-V4_S',time_ranges(jjj,0),time_ranges(jjj,1))
              if efieldV1214.valid eq 0 then begin
                 print,' ERROR: No FAST fields data - get_fa_fields returned invalid data'
                 data_valid=0.0
              endif 
           endif 
        endelse
     endelse	
     
     
     if data_valid NE 0.0 then begin
        
        ;;get E field and B field on same time scale
        
        
        FA_FIELDS_COMBINE,efieldV1214,efieldV58,result=efields_combine,/talk

        ;; efields_combine=combinets({x:efieldV1214.time,y:efieldV1214.comp1},{x:efieldV58.time,y:efieldV58.comp1})
        
        ;;get magnitude of electric and magnetic field
        
        ;; efield={x:efieldV1214.time,y:sqrt(efields_combine.comp1^2+efields_combine.comp2^2)}
        efield={x:efieldV1214.time,y:sqrt(efieldV1214.comp1^2+efields_combine^2)}
        if not keyword_set(ucla_mag_despin) then begin
           get_data,'MagDCcomp1',data=magx
           get_data,'MagDCcomp2',data=magy
           get_data,'MagDCcomp3',data=magz
        endif else begin
           get_data,'dB_fac_v',data=db_fac
           mintime=min(abs(time_ranges(jjj,0)-db_fac.x),ind1)
           mintime=min(abs(time_ranges(jjj,1)-db_fac.x),ind2)
           
           magx={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,0)}
           magy={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,2)}
           magz={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,1)}
        endelse
        
        store_data,'MagZ',data=magz
        ;;magz.y=smooth(magz.y,40)
        store_data,'Magz_smooth',data={x:magz.x,y:magz.y}
        if keyword_set(filterfreq) then begin
           
           magz=filter(magz,filterfreq,'magfilt','l')
           ;;remove end effects of the filter by cutting off the first/last 2s
           sf=magz.x(1)-magz.x(0)
           np=n_elements(magz.x)
           padding=round(2.0/sf)
           magz={x:magz.x(padding:np-padding),y:magz.y(padding:np-padding)}
           store_data,'MagZ',data=magz
        endif
        
        
        ;;get mag and efield data on same time scale
        magz={time:magz.x,comp1:magz.y,ncomp:1}
        efield={time:efield.x,comp1:efield.y}
        FA_FIELDS_COMBINE,magz,efield,result=fields,/interp,delt_t=50.,/talk

        ;; fields={time:magz.time,comp1:magz.comp1,comp2:fields,ncomp:2} ;we just want efields, not magfields too
        fields={x:magz.time,y:fields}
        store_data,'EFIELD',data=fields
        store_data,'V1214',data={x:efieldV1214.time,y:efieldV1214.comp1}
        store_data,'V58',data={x:efieldV58.time,y:efieldV58.comp1}

        magz={x:magz.time,y:magz.comp1}

        ;;get the prootn cyc frequency for smoothing the e field data later
        proton_cyc_freq=1.6e-19*sqrt(magx.y^2+magy.y^2+magz.y^2)*1.0e-9/1.67e-27/(2.*!DPI) ; in Hz

        tDiff=shift(magz.x,-1)-magz.x
        smooth_int=ceil((1./proton_cyc_freq)/(shift(magz.x,-1)-magz.x))

        i_128Hz=where(tDiff LT 0.01 AND tDiff GT 0.006,n128Hz,COMPLEMENT=i_not128Hz,NCOMPLEMENT=nNot128Hz)
        i_Interval=where(magz.x GE tStart and magz.x LE tEnd)
        i_128Int=cgsetintersection(i_128Hz,i_Interval)
        i_not128Int=cgsetintersection(i_not128Hz,i_Interval)
     
        ;; NOTE! We do not smooth the E field in our plots!!
        ;;get elec field amplitude
        ;;smooth to below proton gyro freq.

        ;; smooth_int=ceil((1./proton_cyc_freq(intervalfields(indjmax)))/current_intervals(j,26))
        ;; ; NOTE! current_intervals(j,26) is the fields sample period, calculated with
        ;; ; magz.x(intervalfields(indjmax)+1)-magz.x(intervalfields(indjmax))  


        ;; if smooth_int GT 1.0 and smooth_int LE n_elements(intervalfields)/4.0 then efield_smooth=smooth(fields.comp2(intervalfields),smooth_int) else efield_smooth=fields.comp2(intervalfields)
        
        ;;get_orbit data
        get_fa_orbit,je_tmp_time,/time_array,/all
        
        ;;define loss cone angle
        get_data,'ALT',data=alt
        loss_cone_alt=alt.y(0)*1000.0
        lcw=loss_cone_width(loss_cone_alt)*180.0/!DPI
        get_data,'ILAT',data=ilat
        north_south=abs(ilat.y(0))/ilat.y(0)
        
        if north_south EQ -1 then begin
           e_angle=[180.-lcw,180+lcw] ; for Southern Hemis.
           ;;i_angle=[270.0,90.0]	
           ;;elimnate ram from data
           i_angle=[180.0,360.0]
           i_angle_up=[270.0,360.0]
           
        endif else begin
           e_angle=[360.-lcw,lcw] ;	for Northern Hemis.
           ;;i_angle=[90.,270.0]
           ;;eliminate ram from data
           i_angle=[0.0,180.0]
           i_angle_up=[90.0,180.0]
           
        endelse
        
        
        ;;get fields mode
        
        fields_mode=get_fa_fields('DataHdr_1032',time_ranges(jjj,0),time_ranges(jjj,1))
        
        
        
        ;;get the spacecraft potential per spin
        
        spin_period=4.946       ; seconds
        
        ;;get_sample_rate
        
        v8={x:spacecraft_potential.time,y:spacecraft_potential.comp1}
        
        v8_dt=abs(v8.x-shift(v8.x,-1))
        v8_dt(0)=v8_dt(1)
        v8_dt(n_elements(v8.x)-1)=v8_dt(n_elements(v8.x)-2)
        
        ;;get maxima within a 1 spin window
        
        j_range=where(v8.x LT v8.x(n_elements(v8.x)-1)-spin_period)
        index_max=max(j_range)
        print,index_max
        pot=make_array(n_elements(v8.x),/double)
        for j=0L,index_max do begin
           ;;spin_range=where(v8.x GE v8.x(j) and v8.x LE v8.x(j)+spin_period)
           spin_range=j+findgen(ceil(spin_period/V8_dt(j)))
           pot(j)=max(abs(v8.y(spin_range)),ind)
           sign=v8.y(spin_range(ind))/abs(v8.y(spin_range(ind)))
           pot(j)=sign*pot(j)
           ;;print,j,pot(j)
        endfor
        pot(index_max+1:n_elements(v8.x)-1)=pot(j_range(index_max))
        sc_pot={x:v8.x,y:pot}
        store_data,'S_Pot',data=sc_pot ;note this is actualy the negative of the sp. potential this corrected in the file output
        
        if keyword_set(burst) then begin
           
           get_2dt_ts,'je_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe_tot',energy=energy_electrons
           get_2dt_ts,'je_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe',angle=e_angle,energy=energy_electrons
           get_2dt_ts,'j_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je',energy=energy_electrons
           get_2dt_ts,'j_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je_lc',energy=energy_electrons,angle=e_angle
           
           
           get_2dt_ts,'je_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi',energy=energy_ions
           get_2dt_ts,'j_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji',energy=energy_ions
           get_2dt_ts,'je_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi_up',energy=energy_ions,angle=i_angle
           get_2dt_ts,'j_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji_up',energy=energy_ions,angle=i_angle
           
        endif else begin
           
           get_2dt_ts_pot,'je_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe_tot',energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'je_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe',angle=e_angle,energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je',energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je_lc',energy=energy_electrons,angle=e_angle,sc_pot=sc_pot
           
           
           get_2dt_ts_pot,'je_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
           get_2dt_ts_pot,'je_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
           
           
           
           if keyword_set(heavy) then begin
              
              get_2dt_pot,'je_2d','fa_tsp_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEp_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'je_2d','fa_tso_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEo_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'je_2d','fa_tsh_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEh_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              
              get_2dt_pot,'j_2d','fa_tsp_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jp_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'j_2d','fa_tso_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jo_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'j_2d','fa_tsh_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jh_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              
           endif
           
        endelse
        
        get_data,'Je',data=tmp
        get_data,'Ji',data=tmpi
        ;;remove crap
        keep1=where(finite(tmp.y) NE 0 and finite(tmpi.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        keep2=where(abs(tmp.y) GT 0.0 and abs(tmpi.y) GT 0.0)
        je_tmp_time=tmp.x(keep2)
        je_tmp_data=tmp.y(keep2)
        store_data,'Je',data={x:je_tmp_time,y:je_tmp_data}
        
        get_data,'JEe',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jee_tmp_time=tmp.x(keep2)
        jee_tmp_data=tmp.y(keep2)
        store_data,'JEe',data={x:jee_tmp_time,y:jee_tmp_data}
        
        get_data,'JEe_tot',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jee_tot_tmp_time=tmp.x(keep2)
        jee_tot_tmp_data=tmp.y(keep2)
        store_data,'JEe_tot',data={x:jee_tot_tmp_time,y:jee_tot_tmp_data}
        
        get_data,'Je_lc',data=tmp
        ;;remove_crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        je_lc_tmp_time=tmp.x(keep2)
        je_lc_tmp_data=tmp.y(keep2)
        store_data,'Je_lc',data={x:je_lc_tmp_time,y:je_lc_tmp_data}
        
        
        
        get_data,'Ji',data=tmp
        ;;remove crap	
        ;;keep1=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep2=where(abs(tmp.y) GT 0.0)
        ji_tmp_time=tmp.x(keep2)
        ji_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
        store_data,'Ji',data={x:ji_tmp_time,y:ji_tmp_data}
        
        get_data,'JEi',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jEi_tmp_time=tmp.x(keep2)
        jEi_tmp_data=tmp.y(keep2)
        store_data,'JEi',data={x:jEi_tmp_time,y:jEi_tmp_data}
        
        get_data,'JEi_up',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jEi_up_tmp_time=tmp.x(keep2)
        jEi_up_tmp_data=tmp.y(keep2)
        store_data,'JEi_up',data={x:jEi_up_tmp_time,y:jEi_up_tmp_data}
        
        get_data,'Ji_up',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        ji_up_tmp_time=tmp.x(keep2)
        ji_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
        store_data,'Ji_up',data={x:ji_up_tmp_time,y:ji_up_tmp_data}
        
        
        if keyword_set(heavy) then begin
           
           get_data,'JEp_up',data=tmp
           ;;remove crap
           keep1=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           keep2=where(abs(tmp.y) GT 0.0)
           jEp_up_tmp_time=tmp.x(keep2)
           jEp_up_tmp_data=tmp.y(keep2)
           store_data,'JEp_up',data={x:jEp_up_tmp_time,y:jEp_up_tmp_data}
           
           get_data,'Jp_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jp_up_tmp_time=tmp.x(keep2)
           jp_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jp_up',data={x:jp_up_tmp_time,y:jp_up_tmp_data}
           
           
           get_data,'JEo_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jEo_up_tmp_time=tmp.x(keep2)
           jEo_up_tmp_data=tmp.y(keep2)
           store_data,'JEo_up',data={x:jEo_up_tmp_time,y:jEo_up_tmp_data}
           
           get_data,'Jo_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jo_up_tmp_time=tmp.x(keep2)
           jo_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jo_up',data={x:jo_up_tmp_time,y:jo_up_tmp_data}
           
           
           get_data,'JEh_up',data=tmp
           ;;remove crap
           keep1=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           keep2=where(abs(tmp.y) GT 0.0)
           jEh_up_tmp_time=tmp.x(keep2)
           jEh_up_tmp_data=tmp.y(keep2)
           store_data,'JEh_up',data={x:jEh_up_tmp_time,y:jEh_up_tmp_data}
           
           get_data,'Jh_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jh_up_tmp_time=tmp.x(keep2)
           jh_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jh_up',data={x:jh_up_tmp_time,y:jh_up_tmp_data}
           
        endif
        ;;get ion end electron characteristic energies
        
        chare=(jee_tmp_data/je_lc_tmp_data)*6.242*1.0e11
        chare_tot=(jee_tot_tmp_data/je_tmp_data)*6.242*1.0e11
        charei=(JEi_up_tmp_data/ji_up_tmp_data)*6.242*1.0e11
        store_data,'CharE',data={x:jee_tmp_time,y:chare}
        store_data,'CharE_tot',data={x:jee_tot_tmp_time,y:chare_tot}
        store_data,'CharEi',data={x:jei_up_tmp_time,y:charei}
        
        ;;get orbit number for filenames	
        get_data,'ORBIT',data=tmp
        orbit=tmp.y(0)
        orbit_num=strcompress(string(tmp.y(0)),/remove_all)
        
        ;;Scale electron energy flux to 100km, pos flux earthward
        get_data,'ILAT',data=tmp
        sgn_flx = tmp.y/abs(tmp.y)
        get_data,'B_model',data=tmp1
        get_data,'BFOOT',data=tmp2
        mag1 = (tmp1.y(*,0)*tmp1.y(*,0)+tmp1.y(*,1)*tmp1.y(*,1)+tmp1.y(*,2)*tmp1.y(*,2))^0.5
        mag2 = (tmp2.y(*,0)*tmp2.y(*,0)+tmp2.y(*,1)*tmp2.y(*,1)+tmp2.y(*,2)*tmp2.y(*,2))^0.5
        ratio = (mag2/mag1)
        jee_ionos_tmp_data = sgn_flx*jee_tmp_data*ratio
        store_data,'JEei',data={x:jee_tmp_time,y:jee_ionos_tmp_data}
        
        jee_tot_ionos_tmp_data=sgn_flx*jee_tot_tmp_data*ratio
        store_data,'JEei_tot',data={x:jee_tot_tmp_time,y:jee_tot_ionos_tmp_data}
        
        get_data,'fa_vel',data=vel
        speed=sqrt(vel.y(*,0)^2+vel.y(*,1)^2+vel.y(*,2)^2)*1000.0
        
        ;;get position of each mag point
        
        ;;samplingperiod=magz.x(300)-magz.x(299)
        ;;position=make_array(n_elements(magz.x),/double)
        ;;position=speed(300)*samplingperiod*findgen(n_elements(magz.x))
        ;;speed_mag_point=speed(300)

        old_pos=0.
        position=make_array(n_elements(magz.x),/double)
        speed_mag_point=make_array(n_elements(magz.x),/double)
        for j=0L,n_elements(magz.x)-2 do begin
           speed_point_ind=min(abs(vel.x-magz.x(j)),ind)
           ;;print,ind
           speed_mag_point(j)=speed(ind)
           samplingperiod=magz.x(j+1)-magz.x(j)
           ;;position=make_array(n_elements(magz.x),/double)
           position(j)=old_pos+speed_mag_point(j)*samplingperiod
           old_pos=position(j)
        endfor
          
        ;Get current
        deltaBX=deriv(position,magz.y)
        jtemp=abs(1.0e-3*(deltaBx)/1.26e-6)
        sign_jtemp=abs(deltaBx)/deltaBx
        if sign_jtemp(n_elements(jtemp)-1)*sign_jtemp(n_elements(jtemp)-2) NE -1 then sign_jtemp(n_elements(jtemp)-1)=-1*sign_jtemp(n_elements(jtemp)-1)
        jtemp=sign_jtemp*jtemp
        store_data,'jtemp',data={x:magz.x,y:jtemp}

        ;;terminate the intervals before the last point

        ;;MagZ options
        ylim,'MagZ',400,1200,0 
        options,'MagZ','ytitle','B!DAxial!N (nT)'
        options,'MagZ','x_no_interp',1
        options,'MagZ','y_no_interp',1
        options,'MagZ','panel_size',2

        ;EFIELD options
        ylim,'EFIELD',0,0,1 ;autoscale
        options,'EFIELD','ytitle','E!Dsp_plane!N (mV/m)'
        options,'MagZ','x_no_interp',1
        options,'MagZ','y_no_interp',1
        options,'MagZ','panel_size',2

        ;;JEei
        ylim,'JEei',.001,100,1
	options,'JEei','ytitle','e- >s/c pot (eV!C!Cergs/cm!U2!N-s)'
	options,'JEei','tplot_routine','pmplot'


        ;; window,0,xsize=600,ysize=800
        ;; tplot,['Je','CharE','JEei','Ji','JEi','MagZ'] ,var_label=['ALT','MLT','ILAT'],trange=[time_ranges(jjj,0),time_ranges(jjj,1)]
        ;; tplot,['Je','CharE','JEei','Ji','JEi','MagZ'] ,var_label=['ALT','MLT','ILAT'],trange=[tStart,tEnd]
        
     endif


  ;; STOP      ;see wassup
   
  ;;;;;;;;;;;;
  ;;ELECTRONS
  ;;;;;;;;;;;;

  make_array_struc,'fa_ees_sp' ;speed things up a bit; see fast_ef_summary.pro
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Electron spectrogram - survey data, remove retrace, downgoing electrons
  get_en_spec,"array_struc",units='eflux',name='el_0',angle=[330,30],retrace=1
  options,'el_0','spec',1	
  zlim,'el_0',1e6,2e9,1
  ylim,'el_0',3,40000,1
  options,'el_0','ytitle','e- 0!Uo!N-30!Uo!N!C!CEnergy (eV)'
  options,'el_0','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'el_0','x_no_interp',1
  options,'el_0','y_no_interp',1
  options,'el_0','panel_size',2
  options,'el_0','yticks',3     ; set y-axis labels
  options,'el_0','ytickname',['10!A1!N','10!A2!N','10!A3!N','10!A4!N'] 
  options,'el_0','ytickv',[10,100,1000,10000] ; set y-axis labels

  get_en_spec,"array_struc",units='eflux',name='el_90',angle=[60,120],retrace=1
  options,'el_90','spec',1	
  zlim,'el_90',1e6,1e9,1
  ylim,'el_90',3,40000,1
  options,'el_90','ytitle','e- 60!Uo!N-120!Uo!N!C!CEnergy (eV)'
  options,'el_90','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'el_90','x_no_interp',1
  options,'el_90','y_no_interp',1
  options,'el_90','panel_size',2
  
  get_en_spec,"array_struc",units='eflux',name='el_180',angle=[150,180],retrace=1
  options,'el_180','spec',1	
  zlim,'el_180',1e6,1e9,1
  ylim,'el_180',3,40000,1
  options,'el_180','ytitle','e- 150!Uo!N-180!Uo!N!C!CEnergy (eV)'
  options,'el_180','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'el_180','x_no_interp',1
  options,'el_180','y_no_interp',1
  options,'el_180','panel_size',2

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Electron differential energy flux - angle spectrograms
  ;;pitch-angle spectrograms, low energy
  get_pa_spec,"array_struc",units='eflux',name='el_low',energy=[100,1000],retrace=1,/shift90
  options,'el_low','spec',1	
  zlim,'el_low',1e6,1e9,1
  ylim,'el_low',-100,280,0
  options,'el_low','ytitle','e- .1-1 keV!C!C Pitch Angle'
  options,'el_low','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'el_low','x_no_interp',1
  options,'el_low','y_no_interp',1
  options,'el_low','panel_size',2

  ;;pitch-angle spectrograms, low energy
  get_pa_spec,"array_struc",units='eflux',name='el_high',energy=[1000,40000],retrace=1,/shift90
  options,'el_high','spec',1	
  zlim,'el_high',1e6,1e9,1
  ylim,'el_high',-100,280,0
  options,'el_high','ytitle','e- >1 keV!C!C Pitch Angle'
  options,'el_high','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'el_high','x_no_interp',1
  options,'el_high','y_no_interp',1
  options,'el_high','panel_size',2

  ;;;;;;
  ;;IONS
  ;;;;;;

  make_array_struc,'fa_ies_sp'
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Ion differential energy flux - energy spectrograms
  get_en_spec,"array_struc",units='eflux',name='ion_0',angle=[330,30],retrace=1
  options,'ion_0','spec',1	
  zlim,'ion_0',1e4,1e8,1
  ylim,'ion_0',3,40000,1
  options,'ion_0','ytitle','ions 0!Uo!N-30!Uo!N!C!CEnergy (eV)'
  options,'ion_0','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'ion_0','x_no_interp',1
  options,'ion_0','y_no_interp',1
  options,'ion_0','panel_size',2
  
  get_en_spec,"array_struc",units='eflux',name='ion_90',angle=[40,140],retrace=1
  options,'ion_90','spec',1	
  zlim,'ion_90',1e4,1e8,1
  ylim,'ion_90',3,40000,1
  options,'ion_90','ytitle','ions 40!Uo!N-140!Uo!N!C!CEnergy (eV)'
  options,'ion_90','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'ion_90','x_no_interp',1
  options,'ion_90','y_no_interp',1
  options,'ion_90','panel_size',2
  
  get_en_spec,"array_struc",units='eflux',name='ion_180',angle=[150,210],retrace=1
  options,'ion_180','spec',1	
  zlim,'ion_180',1e4,1e8,1
  ylim,'ion_180',3,40000,1
  options,'ion_180','ytitle','ions 150!Uo!N-180!Uo!N!C!CEnergy (eV)'
  options,'ion_180','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'ion_180','x_no_interp',1
  options,'ion_180','y_no_interp',1
  options,'ion_180','panel_size',2
  
  ;; Ion differential energy flux - angle spectrograms
  get_pa_spec,"array_struc",units='eflux',name='ion_low',energy=[50,1000],retrace=1,/shift90
  options,'ion_low','spec',1	
  zlim,'ion_low',1e4,1e8,1
  ylim,'ion_low',-100,280,0
  options,'ion_low','ytitle','ions .05-1 keV!C!C Pitch Angle'
  options,'ion_low','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'ion_low','x_no_interp',1
  options,'ion_low','y_no_interp',1
  options,'ion_low','panel_size',2
  
  get_pa_spec,"array_struc",units='eflux',name='ion_high',energy=[1000,40000],retrace=1,/shift90
  options,'ion_high','spec',1	
  zlim,'ion_high',1e4,1e8,1
  ylim,'ion_high',-100,280,0
  options,'ion_high','ytitle','ions >1 keV!C!C Pitch Angle'
  options,'ion_high','ztitle','eV/cm!U2!N-s-sr-eV'
  options,'ion_high','x_no_interp',1
  options,'ion_high','y_no_interp',1
  options,'ion_high','panel_size',2
  
  ;; Ion energy flux - line plot
  ;; get_2dt,'je_2d',"array_struc",name='JEi',energy=[0,30000] ;don't re-get the data! Already have it, man...
  ylim,'JEi',1.e-5,1,1
  options,'JEi','ytitle','i+ >s/c pot (eV!C!Cergs/cm!U2!N-s)'
  options,'JEi','tplot_routine','pmplot'
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;get orbit data
  get_data,'ion_0',data=tmp_0
  get_fa_orbit,tmp_0.x,/time_array,/all
  ;; Make L-shell data
  get_data,'ILAT',data=ilat
  lShell={x:ilat.x,y:(cos(ilat.y*!PI/180.))^(-2),yTitle:"L-shell"}
  store_data,'LSHELL',data={x:ilat.x,y:(cos(ilat.y*!PI/180.))^(-2),yTitle:"L-shell"}

  get_data,'ORBIT',data=tmp
  ntmp=n_elements(tmp.y)
  if ntmp gt 5 then begin
     orb=tmp.y(5)
     orbit_num=strcompress(string(orb),/remove_all)
     if ntmp gt 11 and orb ne tmp.y(ntmp-5) then begin
        orbit_num=orbit_num+'-'+strcompress(string(tmp.y(ntmp-5)),/remove_all)
     endif
  endif else begin
     orb=tmp.y(ntmp-1)
     orbit_num=strcompress(string(orb),/remove_all)
  endelse

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; want Je and Ji
  ylim,'Je',1.e7,1.e9,1                          ; set y limits
  options,'Je','ytitle','Electrons!C!C1/(cm!U2!N-s)' ; set y title
  options,'Je','tplot_routine','pmplot'              ; set 2 color plot
  options,'Je','labels',['Downgoing!C Electrons','Upgoing!C Electrons '] ; set color label
  options,'Je','labflag',3                           ; set color label
  options,'Je','labpos',[4.e8,5.e7]                  ; set color label
  options,'Je','panel_size',1                        ; set panel size

  ylim,'Ji',1.e5,1.e8,1                              ; set y limits
  options,'Ji','ytitle','Ions!C!C1/(cm!U2!N-s)'      ; set y title
  options,'Ji','tplot_routine','pmplot'              ; set 2 color plot
  options,'Ji','labels',['Downgoing!C Ions','Upgoing!C Ions '] ; set color label
  options,'Ji','labflag',3                           ; set color label
  options,'Ji','labpos',[2.e7,1.e6]                  ; set color label
  options,'Ji','panel_size',1                        ; set panel size

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; and then the plots
  ;; window,0,xsize=xgifsize,ysize=ygifsize
  ;; tplot,['el_0','el_low','ion_low','Je','Ji'],$
  ;;       var_label=['ALT','ILAT','LSHELL','MLT'], $
  ;;       title='FAST ORBIT '+orbit_num
  
  ;; window,1,xsize=xgifsize,ysize=ygifsize
  ;; tplot,['el_0','el_high','ion_high','Je','Ji'],$
  ;;       var_label=['ALT','ILAT','LSHELL','MLT'], $
  ;;       title='FAST ORBIT '+orbit_num

  options,'alt','ytitle','Alt (km)'

  window,0,xsize=xgifsize,ysize=ygifsize ;electron plots
  tplot,['el_0','el_90','el_180','el_low','el_high','Je','JEei'], $
        var_label=['ALT','ILAT','LSHELL','MLT'], $
        title='FAST ORBIT '+orbit_num + ': Electrons'

  tlimit,tStart,tEnd

  window,1,xsize=xgifsize,ysize=ygifsize ;ion plots
  tplot,['ion_0','ion_90','ion_180','ion_low','ion_high','Ji','JEi'], $
        var_label=['ALT','ILAT','LSHELL','MLT'], $
        title='FAST ORBIT '+orbit_num + ': Ions'
  
  window,2,xsize=xgifsize+300,ysize=ygifsize ;fields plots
  ;; tplot,['MagZ','EFIELD'], $
  tplot,['MagZ','EFIELD','V1214','V58','jtemp'], $
        var_label=['ALT','ILAT','LSHELL','MLT'], $
        title='FAST ORBIT '+orbit_num + ': Fields'
        
  STOP

END