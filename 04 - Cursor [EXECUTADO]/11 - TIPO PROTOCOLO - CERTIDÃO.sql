DECLARE                                                
	/* IMO_TIPO_PROTOCOLO */
	@ITP_DESCRICAO VARCHAR(50),
	/* IMO_NATUREZA */
	@NAT_NOME VARCHAR(50), @NAT_CODIGO_OLD INT, @NAT_LIVRO_2 CHAR(1),
	@NAT_LIVRO_3 CHAR(1), @NAT_LIVRO_CERT CHAR(1), @NAT_ATIVO CHAR(1), @NAT_LINRO INT, @PRO_TIPO CHAR(1)

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/
SELECT
/* IMO_TIPO_PROTOCOLO */
cer.ds_tipo_certidao ITP_DESCRICAO,
/* IMO_NATUREZA */
cer.ds_tipo_certidao NAT_NOME,
cer.id NAT_CODIGO_OLD,
Case
	When cer.ie_livro = 'L2' Then 'S'
	Else NULL
End NAT_LIVRO_2,
Case
	When cer.ie_livro = 'L3' Then 'S'
	Else NULL
End NAT_LIVRO_3,
'S' NAT_LIVRO_CERT,
Case
	When cer.is_ativo = 1 Then 'S'
	Else 'N'
End NAT_ATIVO,
Case
	When cer.ie_livro = 'L2' Then 2
	When cer.ie_livro = 'L3' Then 3
	Else NULL
End NAT_LINRO,
'C' PRO_TIPO
FROM
PALMEIRAS_RI..tipo_certidao cer
WHERE
cer.is_ativo = 1
ORDER BY
cer.id
/*==========================================================================================*/

OPEN CURSO_PADRAO
	FETCH NEXT FROM CURSO_PADRAO INTO

	/* IMO_TIPO_PROTOCOLO */
	@ITP_DESCRICAO,
	/* IMO_NATUREZA */
	@NAT_NOME, @NAT_CODIGO_OLD, @NAT_LIVRO_2,
	@NAT_LIVRO_3, @NAT_LIVRO_CERT, @NAT_ATIVO, @NAT_LINRO, @PRO_TIPO

WHILE @@FETCH_STATUS = 0
BEGIN
/*==============================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1061
/*==============================*/

	/* IMO_TIPO_PROTOCOLO */
	INSERT INTO IMOVEIS..IMO_TIPO_PROTOCOLO
	(ITP_DESCRICAO, ENT_CODIGO)
	VALUES 
	(@ITP_DESCRICAO, @ENTIDADE)

	/* IMO_NATUREZA */
	INSERT INTO IMOVEIS..IMO_NATUREZA
	(NAT_NOME, NAT_CODIGO_OLD, NAT_LIVRO_2, NAT_LIVRO_3, NAT_LIVRO_CERT, NAT_ATIVO, NAT_LINRO, PRO_TIPO, ENT_CODIGO)
	VALUES 
	(@NAT_NOME, @NAT_CODIGO_OLD, @NAT_LIVRO_2,
	@NAT_LIVRO_3, @NAT_LIVRO_CERT, @NAT_ATIVO, @NAT_LINRO, @PRO_TIPO, @ENTIDADE)


	FETCH NEXT FROM CURSO_PADRAO INTO
	/* IMO_TIPO_PROTOCOLO */
	@ITP_DESCRICAO,
	/* IMO_NATUREZA */
	@NAT_NOME, @NAT_CODIGO_OLD, @NAT_LIVRO_2,
	@NAT_LIVRO_3, @NAT_LIVRO_CERT, @NAT_ATIVO, @NAT_LINRO, @PRO_TIPO
/*==========================================================================================*/

END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO