DECLARE 
	@MUN_MUNICIPIO VARCHAR(MAX)

DECLARE CURSOR_PESSOA CURSOR FOR
/*==========================================*/
select distinct
UPPER(nm_cidade) MUN_MUNICIPIO
from 
SAPEACU_RI..historico_matricula
where nm_cidade <> ''
/*==========================================*/
OPEN CURSOR_PESSOA
 FETCH NEXT FROM CURSOR_PESSOA INTO
	@MUN_MUNICIPIO
 WHILE @@FETCH_STATUS = 0
 BEGIN
 /*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	INSERT INTO IMOVEIS..IMO_MUNICIPIO (MUN_MUNICIPIO, ENT_CODIGO)
	VALUES(@MUN_MUNICIPIO, @ENTIDADE)

       FETCH NEXT FROM CURSOR_PESSOA INTO
	@MUN_MUNICIPIO
 
END
CLOSE CURSOR_PESSOA
DEALLOCATE CURSOR_PESSOA 