DECLARE
	/* IMO_PROTOCOLO */
	@PRO_PROTOCOLO INT, @PRO_DATA_ABERTURA DATETIME, @PRO_DATA_PREVISAO DATETIME, @PES_COD_REPRESENTANTE INT, 
	@PRO_CODIGO_OLD INT, @PRO_OBS VARCHAR(MAX), @ITP_CODIGO INT, @PRO_TIPO CHAR(1), @IMO_CODIGO INT
	

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/
SELECT
/* IMO_PROTOCOLO */
pre.nr_protocolo PRO_PROTOCOLO,
pre.dt_abertura_prenotacao PRO_DATA_ABERTURA,
pre.dt_prazo_prenotacao PRO_DATA_PREVISAO,
--(Select PES_COD from IMOVEIS..GER_PESSOA where PES_COD_OLD = a.fk_id_pessoa and ENT_CODIGO = 1076) PES_COD_REPRESENTANTE,
pre.id PRO_CODIGO_OLD,
pre.tx_observacao PRO_OBS,
--(Select ITP_CODIGO from IMOVEIS..IMO_TIPO_PROTOCOLO where ITP_DESCRICAO = td.ds_tipo_documento and ENT_CODIGO = 1076) ITP_CODIGO,
ato.ie_tipo_servico PRO_TIPO--,
--(Select IMO_CODIGO from IMOVEIS..IMO_IMOVEIS where IMO_CODIGO_OLD = ato.fk_id_matricula and ENT_CODIGO = 1076) IMO_CODIGO
FROM
SAPEACU_RI..prenotado pre
left join SAPEACU_RI..apresentante a on a.id = pre.fk_id_apresentante
left join SAPEACU_RI..ato_prenotado ato on pre.id = ato.fk_id_prenotado
left join SAPEACU_RI..tipo_documento td on pre.fk_id_tipo_documento = td.id
ORDER BY
pre.nr_protocolo
/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@PRO_PROTOCOLO, @PRO_DATA_ABERTURA, @PRO_DATA_PREVISAO, @PES_COD_REPRESENTANTE, 
	@PRO_CODIGO_OLD, @PRO_OBS, @ITP_CODIGO, @PRO_TIPO, @IMO_CODIGO
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	/* IMO_PROTOCOLO */
    INSERT INTO
	IMOVEIS..IMO_PROTOCOLO
	(PRO_PROTOCOLO, PRO_DATA_ABERTURA, PRO_DATA_PREVISAO, PES_COD_REPRESENTANTE, 
	PRO_CODIGO_OLD, PRO_OBS, ITP_CODIGO, PRO_TIPO, IMO_CODIGO, ENT_CODIGO)
	VALUES
	(@PRO_PROTOCOLO, @PRO_DATA_ABERTURA, @PRO_DATA_PREVISAO, @PES_COD_REPRESENTANTE, 
	@PRO_CODIGO_OLD, @PRO_OBS, @ITP_CODIGO, @PRO_TIPO, @IMO_CODIGO, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	   @PRO_PROTOCOLO, @PRO_DATA_ABERTURA, @PRO_DATA_PREVISAO, @PES_COD_REPRESENTANTE, 
	@PRO_CODIGO_OLD, @PRO_OBS, @ITP_CODIGO, @PRO_TIPO, @IMO_CODIGO
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

	    
 