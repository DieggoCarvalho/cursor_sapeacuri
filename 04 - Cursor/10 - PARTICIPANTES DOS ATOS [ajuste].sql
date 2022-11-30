DECLARE
	/* IMO_ATOS_PARTICIPANTES */
	@ATO_CODIGO INT, @PAR_CODIGO INT, @IAP_PARTICIPA CHAR(1)

	

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/
SELECT DISTINCT
/* IMO_ATOS_PARTICIPANTES */
--(Select ATO_CODIGO from IMOVEIS..IMO_ATOS where ATO_CODIGO_OLD = ato.id AND ENT_CODIGO = 1076) ATO_CODIGO,
--(Select PAR_CODIGO from IMOVEIS..IMO_PARTICIPANTES where PAR_CODIGO_OLD = par.id AND ENT_CODIGO = 1076) PAR_CODIGO,
'S' IAP_PARTICIPA
FROM
SAPEACU_RI..ato_prenotado_parte par
left join SAPEACU_RI..qualidade q on par.fk_id_qualidade = q.id
left join SAPEACU_RI..ato_prenotado ato on ato.id = par.fk_id_ato_prenotado
left join SAPEACU_RI..prenotado pre on pre.id = ato.fk_id_prenotado

/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@ATO_CODIGO, @PAR_CODIGO, @IAP_PARTICIPA
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	/* IMO_QUALIDADE */
    INSERT INTO IMOVEIS..IMO_ATOS_PARTICIPANTES
	(ATO_CODIGO, PAR_CODIGO, IAP_PARTICIPA, ENT_CODIGO)
	VALUES
	(@ATO_CODIGO, @PAR_CODIGO, @IAP_PARTICIPA, @ENTIDADE)
	 
      FETCH NEXT FROM CURSO_PADRAO INTO
	   @ATO_CODIGO, @PAR_CODIGO, @IAP_PARTICIPA
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

	    
 