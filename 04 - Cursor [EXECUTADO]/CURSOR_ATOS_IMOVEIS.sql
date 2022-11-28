DECLARE
	/* IMO_ATOS */
	@PRO_CODIGO INT, @ATO_NATUREZA CHAR(1), @NAT_CODIGO INT, @IMO_CODIGO INT, @ATO_STATUS INT,
	@ENT_CODIGO INT, @IMO_DOI CHAR(1), @ATO_LIVRO INT, @DAJ_CODIGO INT,
	/* IMO_PROTOCOLO */
	@ITP_CODIGO INT

DECLARE CURSOR_IMOVEIS CURSOR FOR
/*==========================================================================================*/
SELECT
P.PRO_PROTOCOLO,
P.PRO_CODIGO AS PRO_CODIGO,
P.PRO_TIPO AS ATO_NATUREZA,
P.NAT_CODIGO AS NAT_CODIGO,
P.IMO_CODIGO AS IMO_CODIGO,
Case
	When P.PRO_STATUS = 2 Then 3
	When P.PRO_STATUS = 5 Then 3
	Else P.PRO_STATUS
End As ATO_STATUS ,
P.ENT_CODIGO AS ENT_CODIGO,
N.NAT_DOI AS IMO_DOI,
Case 
 When P.IFL_LIVRO IS NULL And P.IFL_CODIGO_LIV_3 IS NOT NULL Then 3
 Else P.IFL_LIVRO
End AS ATO_LIVRO,
D.DAJ_CODIGO AS DAJ_CODIGO,
(Select distinct ITP_CODIGO from IMO_TIPO_PROTOCOLO inner join IMO_NATUREZA on IMO_TIPO_PROTOCOLO.ITP_DESCRICAO = IMO_NATUREZA.NAT_NOME
where IMO_TIPO_PROTOCOLO.ENT_CODIGO = 8 and IMO_NATUREZA.NAT_CODIGO = P.NAT_CODIGO) ITP_CODIGO
FROM
IMO_PROTOCOLO P
inner join IMO_NATUREZA N ON P.NAT_CODIGO = N.NAT_CODIGO
inner join IMO_PROTOCOLOS_X_DAJES D ON P.PRO_CODIGO = D.PRO_CODIGO
WHERE
P.ENT_CODIGO = 8
AND P.NAT_CODIGO is not null
AND P.PRO_PROTOCOLO <> 5482 --= 5129

/*==========================================================================================*/
OPEN CURSOR_IMOVEIS

	FETCH NEXT FROM CURSOR_IMOVEIS INTO
      /* IMO_ATOS */
	@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @ATO_STATUS,
	@ENT_CODIGO, @IMO_DOI, @ATO_LIVRO, @DAJ_CODIGO,
	/* IMO_PROTOCOLO */
	@ITP_CODIGO

 WHILE @@FETCH_STATUS = 0

 BEGIN
	/* IMO_ATOS */
      INSERT INTO IMO_ATOS
	  (PRO_CODIGO, ATO_NATUREZA, NAT_CODIGO, IMO_CODIGO, ATO_STATUS,
	  ENT_CODIGO, IMO_DOI, ATO_LIVRO, DAJ_CODIGO)
	  VALUES
	  (@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @ATO_STATUS,
		@ENT_CODIGO, @IMO_DOI, @ATO_LIVRO, @DAJ_CODIGO);

	  DECLARE @LAST_ID AS INT
      SET @LAST_ID = SCOPE_IDENTITY()
	  PRINT @LAST_ID

	/* IMO_REGISTRO_GERAL */
	   UPDATE IMO_REGISTRO_GERAL
	   SET ATO_CODIGO = @LAST_ID
	   WHERE PRO_CODIGO = @PRO_CODIGO AND ENT_CODIGO = @ENT_CODIGO AND IMO_CODIGO = @IMO_CODIGO

	/* IMO_PROTOCOLO */
	   UPDATE IMO_PROTOCOLO
	   SET ITP_CODIGO = @ITP_CODIGO
	   WHERE PRO_CODIGO = @PRO_CODIGO AND ENT_CODIGO = @ENT_CODIGO AND IMO_CODIGO = @IMO_CODIGO 
		
		FETCH NEXT FROM CURSOR_IMOVEIS INTO
		/* IMO_ATOS */
		@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @ATO_STATUS,
		@ENT_CODIGO, @IMO_DOI, @ATO_LIVRO, @DAJ_CODIGO,
		/* IMO_PROTOCOLO */
		@ITP_CODIGO
END

CLOSE CURSOR_IMOVEIS
DEALLOCATE CURSOR_IMOVEIS 