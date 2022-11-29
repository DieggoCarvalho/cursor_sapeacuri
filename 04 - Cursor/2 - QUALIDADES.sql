DECLARE
	/* IMO_QUALIDADE */
	@QUA_QUALIDADE VARCHAR(50),@QUA_CODIGO_OLD VARCHAR(20)
	

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/
SELECT
/* IMO_QUALIDADE */
q.nm_qualidade QUA_QUALIDADE,
q.id QUA_CODIGO_OLD
FROM
SAPEACU_RI..qualidade q
ORDER BY q.id
/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@QUA_QUALIDADE, @QUA_CODIGO_OLD
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	/* IMO_QUALIDADE */
    INSERT INTO IMOVEIS..IMO_QUALIDADE
	(QUA_QUALIDADE, QUA_CODIGO_OLD, ENT_CODIGO)
	VALUES (@QUA_QUALIDADE, @QUA_CODIGO_OLD, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	   @QUA_QUALIDADE, @QUA_CODIGO_OLD
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO 

	    
 