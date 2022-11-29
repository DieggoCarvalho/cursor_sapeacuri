DECLARE 
	@BAI_BAIRRO VARCHAR(MAX)

DECLARE CURSOR_PESSOA CURSOR FOR
/*==========================================*/
select distinct
UPPER(nm_bairro) BAI_BAIRRO
from 
SAPEACU_RI..historico_matricula
where nm_bairro <> ''
/*==========================================*/
OPEN CURSOR_PESSOA
 FETCH NEXT FROM CURSOR_PESSOA INTO
	@BAI_BAIRRO
 WHILE @@FETCH_STATUS = 0
 BEGIN
 /*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	INSERT INTO IMOVEIS..IMO_BAIRRO (BAI_BAIRRO, ENT_CODIGO)
	VALUES(@BAIRRO, @ENTIDADE)

       FETCH NEXT FROM CURSOR_PESSOA INTO
	@BAI_BAIRRO
 
END
CLOSE CURSOR_PESSOA
DEALLOCATE CURSOR_PESSOA 