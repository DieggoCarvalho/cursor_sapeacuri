DECLARE
	/* IMO_TIPO_PROTOCOLO */
	@ITP_DESCRICAO VARCHAR(50), @ITP_DIAS INT

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/
SELECT
/* IMO_TIPO_PROTOCOLO */
td.ds_tipo_documento ITP_DESCRICAO,
td.nr_prazo_prenotacao ITP_DIAS
FROM
PALMEIRAS_RI..tipo_documento td
WHERE
td.is_ativo = 1
ORDER BY
td.id
--UPPER(n.ds_natureza) ITP_DESCRICAO,
--*
--FROM
--PALMEIRAS_RI..natureza n
--WHERE n.is_ativo = 1
--ORDER BY
--n.id
/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@ITP_DESCRICAO, @ITP_DIAS
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1061
/*==========================================================================================*/
	/* IMO_QUALIDADE */
    INSERT INTO IMOVEIS..IMO_TIPO_PROTOCOLO
	(ITP_DESCRICAO, ITP_DIAS, ENT_CODIGO)
	VALUES
	(@ITP_DESCRICAO, @ITP_DIAS, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	   @ITP_DESCRICAO, @ITP_DIAS
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

	    
 