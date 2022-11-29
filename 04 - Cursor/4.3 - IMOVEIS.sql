DECLARE
	/* IMO_IMOVEIS */
	@IMO_LOGRADOURO VARCHAR(200), @IMO_UF CHAR(2), @BAI_CODIGO INT, @IMO_CARACTERISTICAS VARCHAR(MAX), @IMO_AREA_IMOVEL VARCHAR(20),
	@IMO_MATRICULA VARCHAR(10), @IMO_COMPLEMENTO VARCHAR(25), @IMO_NUMERO VARCHAR(15), @IMO_CEP VARCHAR(8),
	@IMO_INSCRICAO_IMOBILIARIA VARCHAR(50), @IMO_DATA DATETIME, @IMO_CODIGO_OLD VARCHAR(15), @MUN_CODIGO INT, 
	@CLA_CODIGO INT, @ITI_CODIGO INT
	

DECLARE CURSO_PADRAO CURSOR FOR
/*==========================================================================================*/

SELECT
/* IMO_IMOVEIS */
nullif(h.nm_logradouro, '') IMO_LOGRADOURO,
nullif(h.sg_uf, '') IMO_UF,
--(Select BAI_CODIGO from IMOVEIS..IMO_BAIRRO where UPPER(h.nm_bairro) = BAI_BAIRRO and ENT_CODIGO = 1076) BAI_CODIGO,
nullif(CAST(h.tx_composicao_imovel AS VARCHAR(8000)), '') IMO_CARACTERISTICAS,
h.vl_area+h.tx_area_complemento IMO_AREA_IMOVEL,
nullif(m.nr_matricula_registro, '') IMO_MATRICULA,
h.tx_complemento IMO_COMPLEMENTO,
h.nr_endereco IMO_NUMERO,
h.tx_cep IMO_CEP,
nullif(h.tx_cadastro, '') IMO_INSCRICAO_IMOBILIARIA,
m.created_date IMO_DATA,
m.id IMO_CODIGO_OLD,
--(Select MUN_CODIGO from IMOVEIS..IMO_MUNICIPIO where UPPER(h.nm_cidade) = MUN_MUNICIPIO and ENT_CODIGO = 1076) MUN_CODIGO,
Case
	When h.nm_bairro = 'ZONA RURAL' then 1
	Else NULL
	End CLA_CODIGO,
Case 
	When h.cd_tp_imovel = 15 then 1030
	When h.cd_tp_imovel = 17 then 2058
	When h.cd_tp_imovel = 31 then 2059
	When h.cd_tp_imovel = 33 then 2060
	When h.cd_tp_imovel = 35 then 2061
	When h.cd_tp_imovel = 65 then 1012
	When h.cd_tp_imovel = 67 then 1011
	When h.cd_tp_imovel = 69 then 1
	When h.cd_tp_imovel = 71 then 2
	When h.cd_tp_imovel = 89 then 2062
	Else NULL
	End ITI_CODIGO
FROM
SAPEACU_RI..ato_praticado a
inner join SAPEACU_RI..matricula_registro m on a.id = m.fk_id_ato_praticado_ultimo
left join SAPEACU_RI..historico_matricula h on a.fk_id_historico_matricula = h.id and m.id = h.fk_id_matricula
--where m.nr_matricula_registro = 965
order by m.nr_matricula_registro
/*==========================================================================================*/
OPEN CURSO_PADRAO
 FETCH NEXT FROM CURSO_PADRAO INTO
	@IMO_LOGRADOURO, @IMO_UF, @BAI_CODIGO, @IMO_CARACTERISTICAS, @IMO_AREA_IMOVEL,
	@IMO_MATRICULA, @IMO_COMPLEMENTO, @IMO_NUMERO, @IMO_CEP,
	@IMO_INSCRICAO_IMOBILIARIA, @IMO_DATA, @IMO_CODIGO_OLD, @MUN_CODIGO, 
	@CLA_CODIGO, @ITI_CODIGO
 WHILE @@FETCH_STATUS = 0
 BEGIN
/*==========================================================================================*/
		DECLARE @ENTIDADE INT
		SET @ENTIDADE = 1076
/*==========================================================================================*/
	/* IMO_IMOVEIS */
    INSERT INTO IMOVEIS..IMO_IMOVEIS
	(IMO_LOGRADOURO, IMO_UF, BAI_CODIGO, IMO_CARACTERISTICAS, IMO_AREA_IMOVEL,
	IMO_MATRICULA, IMO_COMPLEMENTO, IMO_NUMERO, IMO_CEP,
	IMO_INSCRICAO_IMOBILIARIA, IMO_DATA, IMO_CODIGO_OLD, MUN_CODIGO, 
	CLA_CODIGO, ITI_CODIGO, ENT_CODIGO)
	VALUES
	(@IMO_LOGRADOURO, @IMO_UF, @BAI_CODIGO, @IMO_CARACTERISTICAS, @IMO_AREA_IMOVEL,
	@IMO_MATRICULA, @IMO_COMPLEMENTO, @IMO_NUMERO, @IMO_CEP,
	@IMO_INSCRICAO_IMOBILIARIA, @IMO_DATA, @IMO_CODIGO_OLD, @MUN_CODIGO, 
	@CLA_CODIGO, @ITI_CODIGO, @ENTIDADE)
	     
       FETCH NEXT FROM CURSO_PADRAO INTO
	@IMO_LOGRADOURO, @IMO_UF, @BAI_CODIGO, @IMO_CARACTERISTICAS, @IMO_AREA_IMOVEL,
	@IMO_MATRICULA, @IMO_COMPLEMENTO, @IMO_NUMERO, @IMO_CEP,
	@IMO_INSCRICAO_IMOBILIARIA, @IMO_DATA, @IMO_CODIGO_OLD, @MUN_CODIGO, 
	@CLA_CODIGO, @ITI_CODIGO
 
END
CLOSE CURSO_PADRAO
DEALLOCATE CURSO_PADRAO