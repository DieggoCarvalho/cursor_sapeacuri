DECLARE
	/* IMO_ATOS */
	@PRO_CODIGO INT, @ATO_NATUREZA CHAR(1), @NAT_CODIGO INT, @IMO_CODIGO INT, @DAJ_CODIGO INT, @IMO_DOI CHAR(1), @ATO_LIVRO INT,
	@ATO_CODIGO_OLD INT,
	/* IMO_IMOVEIS */
	@IMO_SEQUENCIA_LIVRO2 INT,
	/* IMO_PROTOCOLO */
	@PRO_OBSERVACAO VARCHAR(MAX)

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/

SELECT
/* IMO_ATOS */
(SELECT PRO_CODIGO from IMOVEIS..IMO_PROTOCOLO where PRO_CODIGO_OLD = pre.id and ENT_CODIGO = 1061) PRO_CODIGO,
ato.ie_tipo_servico ATO_NATUREZA,
(Select NAT_CODIGO from IMOVEIS..IMO_NATUREZA where NAT_CODIGO_OLD = n.id and ENT_CODIGO = 1061 and PRO_TIPO = ato.ie_tipo_servico) NAT_CODIGO,
(Select IMO_CODIGO from IMOVEIS..IMO_IMOVEIS where IMO_CODIGO_OLD = ato.fk_id_matricula and ENT_CODIGO = 1061) IMO_CODIGO,
(Select DAJ_CODIGO from IMOVEIS..PRO_DAJE where  DAJ_CODIGO_OLD = ato.fk_id_daje and ENT_CODIGO = 1061) DAJ_CODIGO,
Case
	When ato.is_doi = 0 Then 'N'
	When ato.is_doi = 1 Then 'S'
	Else NULL
End As IMO_DOI,
Case
	When ato.ie_livro = 'L2' Then 2
	When ato.ie_livro = 'L3' Then 3
	Else NULL
End as ATO_LIVRO,
ato.id ATO_CODIGO_OLD,
/* IMO_IMOVEIS */
ato.nr_sequencia IMO_SEQUENCIA_LIVRO2,
/* IMO_PROTOCOLO */
Case
	When mov.tx_observacao <> '' Then mov.tx_observacao
	Else NULL
End as PRO_OBSERVACAO
FROM
PALMEIRAS_RI..ato_prenotado ato
left join PALMEIRAS_RI..prenotado pre on pre.id = ato.fk_id_prenotado
left join PALMEIRAS_RI..natureza n on n.id = ato.fk_id_natureza
left join PALMEIRAS_RI..matricula_registro mat on ato.fk_id_matricula = mat.id
left join PALMEIRAS_RI..movimentacao_prenotado mov on pre.fk_id_movimentacao_prenotado_ultima = mov.id

/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	/* IMO_ATOS */
	@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @IMO_DOI, @ATO_LIVRO,
	@ATO_CODIGO_OLD,
	/* IMO_IMOVEIS */
	@IMO_SEQUENCIA_LIVRO2,
	/* IMO_PROTOCOLO */
	@PRO_OBSERVACAO
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1061
/*==========================================================================================*/
	/* IMO_ATOS */
	INSERT INTO IMOVEIS..IMO_ATOS
	  (PRO_CODIGO, ATO_NATUREZA, NAT_CODIGO, IMO_CODIGO, DAJ_CODIGO, IMO_DOI, ATO_LIVRO,
	  ATO_CODIGO_OLD, ENT_CODIGO)
	  VALUES
	  (@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @IMO_DOI, @ATO_LIVRO,
	  @ATO_CODIGO_OLD, @ENTIDADE);

	DECLARE @LAST_ID AS INT
      SET @LAST_ID = SCOPE_IDENTITY()

	/* IMO_PROTOCOLOS_X_DAJES */
	INSERT INTO IMOVEIS..IMO_PROTOCOLOS_X_DAJES
	(DAJ_CODIGO, PRO_CODIGO, ATO_CODIGO)
	VALUES
	(@DAJ_CODIGO, @PRO_CODIGO, @LAST_ID);

	/* IMO_IMOVEIS */
	UPDATE IMOVEIS..IMO_IMOVEIS
	SET IMO_SEQUENCIA_LIVRO2 = @IMO_SEQUENCIA_LIVRO2
	WHERE IMO_CODIGO = @IMO_CODIGO AND ENT_CODIGO = @ENTIDADE

	/* IMO_PROTOCOLO */
	UPDATE IMOVEIS..IMO_PROTOCOLO
	SET PRO_OBSERVACAO = @PRO_OBSERVACAO
	WHERE PRO_CODIGO = @PRO_CODIGO AND ENT_CODIGO = @ENTIDADE

       FETCH NEXT FROM CURSO_PADRAO INTO
	   /* IMO_ATOS */
	@PRO_CODIGO, @ATO_NATUREZA, @NAT_CODIGO, @IMO_CODIGO, @DAJ_CODIGO, @IMO_DOI, @ATO_LIVRO,
	@ATO_CODIGO_OLD,
	/* IMO_IMOVEIS */
	@IMO_SEQUENCIA_LIVRO2,
	/* IMO_PROTOCOLO */
	@PRO_OBSERVACAO
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

--(Select NAT_CODIGO from IMOVEIS..IMO_NATUREZA where NAT_NOME = UPPER(n.ds_natureza ) and ENT_CODIGO = 1061) NAT_CODIGO,

	    
 