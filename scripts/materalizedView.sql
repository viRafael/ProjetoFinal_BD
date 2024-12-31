-- 1.
-- Esta materialized view lista, para cada usuário, os jogos desejados por seus amigos. 

CREATE MATERIALIZED VIEW mv_jogos_desejados_por_amigos AS
SELECT p.nome AS nome_usuario, a.ce_id_amigo as id_amigo, d.nome AS nome_jogo_desejado
FROM PERFIL p
JOIN AMIGOS a ON p.cp_id_perfil = a.ce_id_perfil
JOIN DESEJO d ON a.ce_id_amigo = d.ce_id_perfil;

