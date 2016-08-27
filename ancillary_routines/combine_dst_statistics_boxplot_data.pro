;;08/27/16
PRO COMBINE_DST_STATISTICS_BOXPLOT_DATA,final,tmp,NAME=name

  COMPILE_OPT IDL2

  IF N_ELEMENTS(final) EQ 0 THEN BEGIN

     ;; final = tmp

     final = {data   : tmp.data, $
              bad    : tmp.bad, $
              extras : LIST(), $
              name   : KEYWORD_SET(name) ? name : 'Dst stats'}

     final.extras.Add,tmp.extras

  ENDIF ELSE BEGIN

     final = {data   : [final.data,tmp.data], $
              bad    : [final.bad,tmp.bad], $
              extras : final.extras, $
              name   : [final.name,KEYWORD_SET(name) ? name : 'Dst stats']}

     final.extras.Add,tmp.extras

  ENDELSE     

END
