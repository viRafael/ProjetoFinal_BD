SELECT p.nome, COUNT(a.cp_id_amigo) AS quantidade_amigos
FROM PERFIL p
LEFT JOIN AMIGOS a ON p.cp_id_perfil = a.ce_id_perfil
GROUP BY p.nome;

-- SEM INDEX: 320 msec
-- COM BTREE: 119 msec
-- COM HASH: 198 msec