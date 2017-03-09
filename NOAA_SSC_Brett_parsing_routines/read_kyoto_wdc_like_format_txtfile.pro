;;08/23/16
;; Everything after Dec 2011 is provisional right now, so we only keep stuff to Dec 2011

PRO READ_KYOTO_WDC_LIKE_FORMAT_TXTFILE

  COMPILE_OPT IDL2,STRICTARRSUBS

  kyotoDir   = '/SPENCEdata/Research/database/storm_data/'
  kyotoFiles = ['dst_1957-1981.txt', $
                'dst_1982-2006.txt', $
                'dst_2007-2015.txt']

  ;;Outfile?
  finalFile  = 'dst_1957-2011.sav'

  ;; missingVal = !VALUES.F_NAN
  missingVal = 9999
  ;; ASCII_tmplt = ASCII_TEMPLATE(kyotoDir+kyotoFiles[0])

  ;;The ASCII template for data  from the "WDC-like" format on http://wdc.kugi.kyoto-u.ac.jp/index.html
  FIELDTYPES = [7,2,2,7,2, $
                7,7,7,2,2, $
                2,2,2,2,2,2,2,2,2,2, $
                2,2,2,2,2,2,2,2,2,2, $
                2,2,2,2, $
                2]

  FIELDNAMES = ['junkstring','year','month','asterisk','day', $                                               ;First 5 entries
                'RR_indicator','X_for_index','Version','year_toptwo','dst', $                                 ;5 more
                'data1','data2','data3','data4','data5','data6','data7','data8','data9','data10', $           ;The 24 data entries
                'data11','data12','data13','data14','data15','data16','data17','data18','data19','data20', $
                'data21','data22','data23','data24', $
                'mean']         ;daily mean
              
  FIELDLOCATIONS = [0,3,5,7,8, $                     ;First 5 entries    
                    10,12,13,14,16, $                ;5 more             
                    20,24,28,32,36,40,44,48,52,56, $ ;The 24 data entries
                    60,64,68,72,76,80,84,88,92,96, $
                    100,104,108,112, $
                    116]                             ;daily mean


  FIELDGROUPS = [0,1,2,3,4, $
                 5,6,7,8,9, $
                 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33, $
                 34]


  data_template = {version:1.0,$
                   datastart:0,$
                   delimiter:BYTE(0),$
                   missingvalue:missingVal,$
                   commentsymbol:';',$
                   fieldcount:35,$
                   fieldtypes:fieldtypes,$
                   fieldnames:fieldnames,$
                   fieldlocations:fieldlocations,$
                   fieldgroups:fieldgroups}



  nYears                 = 0
  FOR j=0,N_ELEMENTS(kyotoFiles)-1 DO BEGIN

     dat                 = READ_ASCII(kyotoDir+kyotoFiles[j],TEMPLATE=data_template)

     ;;How many?
     nGot                = N_ELEMENTS(dat.year)
     PRINT,'Got ' + STRCOMPRESS(nGot,/REMOVE_ALL) + ' from file' + STRCOMPRESS(j+1,/REMOVE_ALL)

     ;;Now chop it up
     year                = MAKE_ARRAY(nGot,/STRING)
     FOR k=0,nGot-1 DO BEGIN
        year[k]          = STRING(FORMAT='(I02,I02)',dat.year_toptwo[k],dat.year[k])
     ENDFOR
     year                = FIX(year)
     PRINT,'Just picked up ' + STRCOMPRESS(N_ELEMENTS(UNIQ(year)),/REMOVE_ALL) + ' years ...'
     nYears             += N_ELEMENTS(UNIQ(year))
     ;;Make sure no 2012
     ;; Everything after Dec 2011 is provisional right now
     ;; don              = WHERE(dat.version NE 2,a)
     ;; year[don[0]]
     ;; 2012
     this                = WHERE(year EQ 2012)
     IF this[0] NE -1 THEN BEGIN
        PRINT,'Hit 2012 stuff--axing it'
        CASE 1 OF
           this[0] EQ 0: BEGIN
              PRINT,"can't pick up any data from this file. breaking ..."
              BREAK
           END
           ELSE: BEGIN
              nGot       = this[0]-1
              nYears    -= N_ELEMENTS(UNIQ(year))
              year       = year[0:nGot]
              PRINT,'... Make that ' + STRCOMPRESS(N_ELEMENTS(UNIQ(year)),/REMOVE_ALL) + ' years !'
              nYears    += N_ELEMENTS(UNIQ(year))
           END
        ENDCASE
     ENDIF

     nReal               = nGot*24 ;Cause there are 24 entries per day

     realDst             = MAKE_ARRAY(nReal,/INTEGER)
     realYear            = MAKE_ARRAY(nReal,/INTEGER)
     realMonth           = MAKE_ARRAY(nReal,/INTEGER)
     realDay             = MAKE_ARRAY(nReal,/INTEGER)
     realHour            = MAKE_ARRAY(nReal,/INTEGER)
     FOR k=0,nGot-1 DO BEGIN

        ;; tmpi          = [k*24:((k+1)*24-1) < (nGot-1)]
        tmpi             = [k*24:(k+1)*24-1]

        tmpDst           = [dat.data1[k],dat.data2[k],dat.data3[k],dat.data4[k],dat.data5[k], $
                            dat.data6[k],dat.data7[k],dat.data8[k],dat.data9[k],dat.data10[k], $
                            dat.data11[k],dat.data12[k],dat.data13[k],dat.data14[k],dat.data15[k], $
                            dat.data16[k],dat.data17[k],dat.data18[k],dat.data19[k],dat.data20[k], $
                            dat.data21[k],dat.data22[k],dat.data23[k],dat.data24[k]]
        
        realDst[tmpi]    = tmpDst

        realYear[tmpi]   = REPLICATE(year[k],24)
        realMonth[tmpi]  = REPLICATE(dat.month[k],24)
        realDay[tmpi]    = REPLICATE(dat.day[k],24)
        realHour[tmpi]   = INDGEN(24)
     ENDFOR

     julDay              = JULDAY(realMonth,realDay,realYear,realHour)
     ;; utc                 = JULDAY_TO_UTC(julDay)

     CASE 1 OF
        j EQ 0: BEGIN
           PRINT,"Initializing final Dst thing ..."
           dst           = {julDay:julDay, $
                            ;; year:realYear, $
                            ;; month:realMonth, $
                            ;; day:realDay, $
                            val:realDst}

        END
        ELSE: BEGIN
           PRINT,"Tacking data onto final Dst thing ..."
           dst           = {julDay:[dst.julDay,julDay], $
                            ;; year:[dst.year,realYear], $
                            ;; month:[dst.month,realMonth], $
                            ;; day:[dst.day,realDay], $
                            val:[dst.val,realDst]}
        END
     ENDCASE

     ;;clear variables
     year                = 0
     nGot                = 0
     dat                 = !NULL
     julDay              = !NULL
     realDst             = !NULL
     realYear            = !NULL
     realMonth           = !NULL
     realDay             = !NULL
     realHour            = !NULL
  ENDFOR

  bad_i                  = WHERE(dst.val EQ 9999,nBad)
  PRINT,'n Bad Dst vals: ' + STRCOMPRESS(nBad,/REMOVE_ALL)
  PRINT,''
  PRINT,'Got ' + STRCOMPRESS(N_ELEMENTS(dst.val)) + ' entries in total, from ' + $
        STRCOMPRESS(nYears,/REMOVE_ALL) + ' years'

  ;;Now add date string
  ;;In batches, since the required memory is a lot
  sliceSize = 5000
  nDst      = N_ELEMENTS(dst.val)
  nIt       = nDst/sliceSize
  tStamp    = MAKE_ARRAY(nDst,/STRING)
  doy       = MAKE_ARRAY(nDst,/INTEGER)
  PRINT,'Getting timestamps ...'
  FOR k=0,nIt DO BEGIN
     PRINT,'nIterations: ' + STRCOMPRESS(k,/REMOVE_ALL) + '/' + STRCOMPRESS(nIt,/REMOVE_ALL)
     tmpi         = [(k*sliceSize):((k+1)*sliceSize-1) < (nDst - 1)]

     CALDAT,dst.julDay[tmpi],month,day,year,hour,minute

     ;; tStamp[tmpi] = TIMESTAMP(YEAR=year[tmpi], $
     ;;                 MONTH=month[tmpi], $
     ;;                 DAY=day[tmpi], $
     ;;                 HOUR=hour[tmpi])
     tStamp[tmpi] = TIMESTAMP(YEAR=year, $
                     MONTH=month, $
                     DAY=day, $
                     HOUR=hour)

     doy[tmpi]    = dst.julDay[tmpi] - JULDAY(12,31,year-1,0,0,0)

  ENDFOR

  ;;A little test for you to see that things came out OK
  ;; diff = ROUND(((SHIFT(dst.julday,-1)-dst.julday)[0:-2])*24.)
  ;; PRINT,MAX(diff)
  ;; PRINT,MIN(diff)

  dst             = {date:tStamp, $
                     julday:dst.julday, $
                     doy:doy, $
                     dst:dst.val}

  PRINT,'Saving to ' + finalFile + ' ...'
  SAVE,dst,FILENAME=kyotoDir+finalFile
  STOP
END
