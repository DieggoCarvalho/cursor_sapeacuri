BEGIN TRANSACTION
DECLARE @ENTIDADE INT; SET @ENTIDADE = 1076;
INSERT INTO IMO_ESTADO_CIVIL VALUES ('CASADO(A)', @ENTIDADE, 'N'), ('SOLTEIRO(A)', @ENTIDADE, 'N'),  ('DIVORCIADO(A)', @ENTIDADE, 'N'), ('VIÚVO(A)', @ENTIDADE, 'N');
SELECT * FROM IMOVEIS..IMO_ESTADO_CIVIL where ENT_CODIGO = @ENTIDADE
COMMIT

select distinct st_civil
FROM
SAPEACU_GERAL..cg_pessoa

Case 
	When p.st_civil = 'C' Then '2233'
	When p.st_civil = 'S' Then '2234'
	When p.st_civil = 'D' Then '2235'
	When p.st_civil = 'V' Then '2236'
	Else NULL
End IEC_CODIGO,
