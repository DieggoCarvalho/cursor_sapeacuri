
-- tava fazendo update em cg_daje para retirar ''

BEGIN TRANSACTION
UPDATE SAPEACU_GERAL..cg_daje
SET vl_ato = NULL
WHERE vl_ato = ''
UPDATE SAPEACU_GERAL..cg_daje
SET vl_fmmpba = NULL
WHERE vl_fmmpba = ''
COMMIT
