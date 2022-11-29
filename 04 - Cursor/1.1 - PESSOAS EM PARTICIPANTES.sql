DECLARE
	/*GER_PESSOA*/ 
	@PES_NOME VARCHAR(200), @PES_DATA_CADASTRO DATETIME, @PES_CPF_CNPJ VARCHAR(14), @PES_DATA_MIGRACAO DATETIME

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/

SELECT DISTINCT
/* GER_PESSOA */
nm_procurador PES_NOME,
GETDATE() PES_DATA_CADASTRO,
tx_documento_procurador PES_CPF_CNPJ,
GETDATE() PES_DATA_MIGRACAO
FROM
SAPEACU_RI..ato_prenotado_parte
WHERE
nm_procurador <> ''

/*==========================================================================================*/


OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	/* GER_PESSOA */
	@PES_NOME, @PES_DATA_CADASTRO, @PES_CPF_CNPJ, @PES_DATA_MIGRACAO

 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/

		 /*GER_PESSOA*/
		  INSERT INTO IMOVEIS..GER_PESSOA
		 (PES_NOME, PES_DATA_CADASTRO, PES_CPF_CNPJ,
		 PES_DATA_MIGRACAO, ENT_CODIGO)
		 VALUES
		 (@PES_NOME, @PES_DATA_CADASTRO, @PES_CPF_CNPJ,
		 @PES_DATA_MIGRACAO, @ENTIDADE)


	 FETCH NEXT FROM CURSO_PADRAO INTO
	/*GER_PESSOA*/
	@PES_NOME, @PES_DATA_CADASTRO, @PES_CPF_CNPJ, @PES_DATA_MIGRACAO

END

CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO
