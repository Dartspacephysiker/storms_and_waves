;2015/12/07
;It's way better to see all plots together, of course
PRO TILE_STORMPHASE_PLOTS,filenames,titles, $
                          OUT_IMGARR=out_imgArr, $
                          OUT_TITLEOBJS=out_titleObjs, $
                          COMBINED_TO_BUFFER=combined_to_buffer, $
                          SAVE_COMBINED_WINDOW=save_combined_window, $
                          SAVE_COMBINED_NAME=save_combined_name, $
                          PLOTDIR=plotDir, $
                          DELETE_PLOTS_WHEN_FINISHED=delete_plots, $
                          LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
                          

  imHDim         = 800
  imVDim         = 640
  xRange         = [300,800]
  yRange         = [20,620]

  IF KEYWORD_SET(combined_to_buffer) THEN BEGIN
     hDim        = 800
     vDim        = 640

     scaleFactor = 1
  ENDIF ELSE BEGIN
     hDim        = 400
     vDim        = 320
     scaleFactor = 0.5
  ENDELSE

  adjHDim     = hDim-300*scaleFactor
  adjVDim     = vDim-40*scaleFactor
  img_loc     = [150*scaleFactor,0]
  ;; xRange      = [150*scaleFactor,650*scaleFactor]
  ;; yRange      = [0,600*scaleFactor]

  imArr       = MAKE_ARRAY(3,/OBJ)
  win         = WINDOW(DIMENSIONS=[adjHDim*3,adjVDim], $
                       BUFFER=combined_to_buffer)
  titleObjs   = MAKE_ARRAY(3,/OBJ)
  
  
  ;; FOR i = 0, N_ELEMENTS(fileNames) - 1 DO BEGIN
  FOR i = 0,2 DO BEGIN
     ;; IF KEYWORD_SET(combined_to_buffer) THEN BEGIN
     ;;    imArr[0]    = IMAGE(filenames[i], $
     ;;                        LAYOUT=[3,1,i+1],$
     ;;                        MARGIN=0, $
     ;;                        /BUFFER, $
     ;;                        IMAGE_DIMENSIONS=[hDim,vDim])
     ;; ENDIF ELSE BEGIN
        imArr[i]    = IMAGE(filenames[i], $
                            LAYOUT=[3,1,i+1],$
                            MARGIN=0, $
                            /CURRENT, $
                            ;; DIMENSIONS=[hDim,vDim], $
                            ;; IMAGE_DIMENSIONS=[adjHDim,adjVDim], $
                            DIMENSIONS=[adjHDim,adjVDim], $
                            IMAGE_DIMENSIONS=[imHDim,imVDim], $
                            IMAGE_LOCATION=img_loc, $
                            XRANGE=xRange, $
                            YRANGE=yRange)
     ;; ENDELSE

     IF KEYWORD_SET(titles) THEN BEGIN
        ;; titleObjs[i] = TEXT(i*hDim + hDim/2., vDim*8./9., titles[i], $
        titleObjs[i] = TEXT(i*adjHDim + adjHDim/2., $
                            500, $;adjVDim*8./9., $
                            titles[i], $
                            ALIGNMENT=0.5, $
                            /DEVICE, $
                            FONT_SIZE=20.*scaleFactor)
     ENDIF
  ENDFOR
  
  IF KEYWORD_SET(save_combined_window) THEN BEGIN
     IF ~KEYWORD_SET(plotDir) THEN plotDir = './'
     IF ~KEYWORD_SET(save_combined_name) THEN save_combined_name = plotDir + 'combined_stormphases.png'

     ;; IF KEYWORD_SET(combined_to_buffer) THEN BEGIN
     ;;    imArr[0].save,plotDir+save_combined_name
     ;;    ENDIF ELSE BEGIN
     win.save,plotDir+save_combined_name
        ;; ENDELSE
  ENDIF

  out_imgArr    = imArr
  out_titleObjs = titleObjs

  IF KEYWORD_SET(delete_plots) THEN BEGIN
     PRINTF,lun,"Deleting plots after tiling..."
     FOR i = 0,2 DO BEGIN
        PRINTF,lun,'Removing ' + filenames[i] + '...'
        SPAWN,'rm ' + filenames[i]
     ENDFOR
  ENDIF

END