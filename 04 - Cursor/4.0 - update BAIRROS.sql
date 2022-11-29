select distinct
UPPER(nm_bairro)
from 
SAPEACU_RI..historico_matricula
where nm_bairro <> ''


begin transaction
update SAPEACU_RI..historico_matricula
set nm_bairro = 'ZONA RURAL'
where nm_bairro IN ('SONA RURAL', 'ZZONA RURAL', ' ZONA RURAL', 'ZONA RUARL', 'ZONA URAL', 'ZUNA RURAL', 'ZONA RUAL', 'ZOLA RURAL', 'ZONA RUARA', 'RURAL') 
commit

begin transaction
update SAPEACU_RI..historico_matricula
set nm_bairro = 'CENTRO'
where nm_bairro IN ('CCENTRO', 'CENTRRO') 
commit

begin transaction
update SAPEACU_RI..historico_matricula
set nm_bairro = 'ZONA URBANA'
where nm_bairro IN ('URBANO', 'ZONA URBANO') 
commit

begin transaction
update SAPEACU_RI..historico_matricula
set nm_bairro = 'LOTEAMENTO PARQUE DAS LARANJEIRAS'
where nm_bairro IN ('LOTEAMENTO PARQUE DAS \LARANJEIRAS') 
commit

begin transaction
update SAPEACU_RI..historico_matricula
set nm_bairro = 'ÁGUA BRANCA'
where nm_bairro IN ('AGUA BRANCA') 
commit
