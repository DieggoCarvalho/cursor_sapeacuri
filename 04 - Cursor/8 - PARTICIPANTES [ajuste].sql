DECLARE
	/* IMO_PARTICIPANTES */
	@QUA_CODIGO INT, @PES_COD INT, @PRO_CODIGO INT, @PRO_PROTOCOLO INT, @PES_COD_REPRESENTANTE INT, @PES_COD_PROCURADOR INT, @PRA_DOI numeric(10,2),
	@PAR_TIP_ENVOLVIMENTO INT, @IMO_CODIGO INT, @PAR_CODIGO_OLD INT
	

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/

SELECT DISTINCT
/* IMO_PARTICIPANTES */
--(Select QUA_CODIGO from IMOVEIS..IMO_QUALIDADE where QUA_QUALIDADE = q.nm_qualidade and ENT_CODIGO = 1076) QUA_CODIGO,
--(SELECT PES_COD from IMOVEIS..GER_PESSOA where PES_COD_OLD = par.fk_id_pessoa and ENT_CODIGO = 1076) PES_COD,
--(SELECT PRO_CODIGO from IMOVEIS..IMO_PROTOCOLO where PRO_CODIGO_OLD = pre.id and ENT_CODIGO = 1076) PRO_CODIGO,
--(SELECT PRO_PROTOCOLO from IMOVEIS..IMO_PROTOCOLO where PRO_CODIGO_OLD = pre.id and ENT_CODIGO = 1076) PRO_PROTOCOLO,
--(SELECT PES_COD from IMOVEIS..GER_PESSOA where PES_COD_OLD = par.fk_id_pessoa_representante and ENT_CODIGO = 1076) PES_COD_REPRESENTANTE,
--(SELECT PES_COD from IMOVEIS..GER_PESSOA where PES_NOME = par.nm_procurador and PES_CPF_CNPJ = par.tx_documento_procurador and ENT_CODIGO = 1076) PES_COD_PROCURADOR,
nullif(par.vl_porcentagem, '') PRA_DOI,
nullif(par.cod_tipo_envolvimento, '') PAR_TIP_ENVOLVIMENTO,
--(Select IMO_CODIGO from IMOVEIS..IMO_IMOVEIS where IMO_CODIGO_OLD = ato.fk_id_matricula and ENT_CODIGO = 1076) IMO_CODIGO,
par.id PAR_CODIGO_OLD
FROM
SAPEACU_RI..ato_prenotado_parte par
left join SAPEACU_RI..qualidade q on par.fk_id_qualidade = q.id
left join SAPEACU_RI..ato_prenotado ato on ato.id = par.fk_id_ato_prenotado
left join SAPEACU_RI..prenotado pre on pre.id = ato.fk_id_prenotado

/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	/* IMO_PARTICIPANTES */
	@QUA_CODIGO, @PES_COD, @PRO_CODIGO, @PRO_PROTOCOLO, @PES_COD_REPRESENTANTE, @PES_COD_PROCURADOR, @PRA_DOI,
	@PAR_TIP_ENVOLVIMENTO, @IMO_CODIGO, @PAR_CODIGO_OLD
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	/* IMO_QUALIDADE */
    INSERT INTO IMOVEIS..IMO_PARTICIPANTES
	(QUA_CODIGO, PES_COD, PRO_CODIGO, PRO_PROTOCOLO, PES_COD_REPRESENTANTE, PES_COD_PROCURADOR, PRA_DOI,
	PAR_TIP_ENVOLVIMENTO, IMO_CODIGO, PAR_CODIGO_OLD, ENT_CODIGO)
	VALUES
	(@QUA_CODIGO, @PES_COD, @PRO_CODIGO, @PRO_PROTOCOLO, @PES_COD_REPRESENTANTE, @PES_COD_PROCURADOR, @PRA_DOI,
	@PAR_TIP_ENVOLVIMENTO, @IMO_CODIGO, @PAR_CODIGO_OLD, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	   @QUA_CODIGO, @PES_COD, @PRO_CODIGO, @PRO_PROTOCOLO, @PES_COD_REPRESENTANTE, @PES_COD_PROCURADOR, @PRA_DOI,
	@PAR_TIP_ENVOLVIMENTO, @IMO_CODIGO, @PAR_CODIGO_OLD

END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

	    
 