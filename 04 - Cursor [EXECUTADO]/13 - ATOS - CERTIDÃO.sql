DECLARE
	/* IMO_ATOS */
	@PRO_CODIGO INT, @ATO_NATUREZA CHAR(1), @NAT_CODIGO INT, @IMO_CODIGO INT, @DAJ_CODIGO INT, @ATO_LIVRO INT,
	@ATO_CODIGO_OLD INT

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/


SELECT
/* IMO_ATOS */
(SELECT PRO_CODIGO from IMOVEIS..IMO_PROTOCOLO where PRO_CODIGO_OLD = cer.id and ENT_CODIGO = 1061 and PRO_TIPO = 'C') PRO_CODIGO,
'C' ATO_NATUREZA,
(Select NAT_CODIGO from IMOVEIS..IMO_NATUREZA where NAT_CODIGO_OLD = tip.id and ENT_CODIGO = 1061 and PRO_TIPO = 'C') NAT_CODIGO,
(Select IMO_CODIGO from IMOVEIS..IMO_IMOVEIS where IMO_MATRICULA = mat.nr_matricula_registro and ENT_CODIGO = 1061) IMO_CODIGO,
(Select DAJ_CODIGO from IMOVEIS..PRO_DAJE where  DAJ_CODIGO_OLD = cer.fk_id_daje and ENT_CODIGO = 1061) DAJ_CODIGO,
cer.id ATO_CODIGO_OLD,
Case
	When cer.ie_livro = 'L2' Then 2
	Else NULL
End as ATO_LIVRO
FROM
PALMEIRAS_RI..pedido_certidao cer
inner join PALMEIRAS_RI..tipo_certidao tip on cer.fk_id_tipo_certidao = tip.id
left join PALMEIRAS_RI..matricula_registro mat on cer.nr_matricula = mat.nr_matricula_registro
order by
cer.nr_pedido

/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	/* IMO_ATOS */
	@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @ATO_LIVRO,
	@ATO_CODIGO_OLD

 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1061
/*==========================================================================================*/
	/* IMO_ATOS */
	INSERT INTO IMOVEIS..IMO_ATOS
	  (PRO_CODIGO, ATO_NATUREZA, NAT_CODIGO, IMO_CODIGO, DAJ_CODIGO, ATO_LIVRO,
	  ATO_CODIGO_OLD, ENT_CODIGO)
	  VALUES
	  (@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @ATO_LIVRO,
	  @ATO_CODIGO_OLD, @ENTIDADE);

	DECLARE @LAST_ID AS INT
      SET @LAST_ID = SCOPE_IDENTITY()

	/* IMO_PROTOCOLOS_X_DAJES */
	INSERT INTO IMOVEIS..IMO_PROTOCOLOS_X_DAJES
	(DAJ_CODIGO, PRO_CODIGO, ATO_CODIGO)
	VALUES
	(@DAJ_CODIGO, @PRO_CODIGO, @LAST_ID);


       FETCH NEXT FROM CURSO_PADRAO INTO
	   /* IMO_ATOS */
	@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @ATO_LIVRO,
	@ATO_CODIGO_OLD
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 
	    
 