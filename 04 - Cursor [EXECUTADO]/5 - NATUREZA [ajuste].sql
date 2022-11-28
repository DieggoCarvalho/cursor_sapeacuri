DECLARE
	/* IMO_NATUREZA */
	@NAT_NOME VARCHAR(50), @PRO_TIPO CHAR(1), @NAT_CODIGO_OLD VARCHAR(15)

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/

SELECT DISTINCT
/* IMO_NATUREZA */
UPPER(n.ds_natureza) NAT_NOME,
ato.ie_tipo_servico PRO_TIPO,
n.id NAT_CODIGO_OLD
FROM
PALMEIRAS_RI..natureza n
left join PALMEIRAS_RI..ato_prenotado ato on ato.fk_id_natureza = n.id
WHERE
UPPER(n.ds_natureza) not in (select NAT_NOME from IMOVEIS..IMO_NATUREZA where ENT_CODIGO = 1061) and n.is_ativo = 1
ORDER BY
n.id

/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@NAT_NOME, @PRO_TIPO, @NAT_CODIGO_OLD
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1061
/*==========================================================================================*/
	/* IMO_NATUREZA */
	INSERT INTO IMOVEIS..IMO_NATUREZA
	(NAT_NOME, NAT_CODIGO_OLD, PRO_TIPO, ENT_CODIGO)
	VALUES
	(@NAT_NOME, @NAT_CODIGO_OLD, @PRO_TIPO, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	   @NAT_NOME, @PRO_TIPO, @NAT_CODIGO_OLD
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO