-- 1.
-- Esta materialized view lista, para cada usuário, os jogos desejados por seus amigos. 

CREATE MATERIALIZED VIEW mv_jogos_desejados_por_amigos AS
SELECT p.nome AS nome_usuario, a.ce_id_amigo as id_amigo, d.nome AS nome_jogo_desejado
FROM PERFIL p
JOIN AMIGOS a ON p.cp_id_perfil = a.ce_id_perfil
JOIN DESEJO d ON a.ce_id_amigo = d.ce_id_perfil;

-- 2.
-- Resumo das Bibliotecas com Informações de Categoria e Usuário
CREATE MATERIALIZED VIEW mv_resumo_bibliotecas AS
SELECT
    b.cp_id_biblioteca,
    b.nome AS nome_biblioteca,
    b.tempo_uso,
    c.nome AS nome_categoria,
    p.nome AS nome_usuario,
    p.apelido AS apelido_usuario,
    p.email AS email_usuario
FROM
    BIBLIOTECA b
JOIN
    CATEGORIA c ON b.ce_id_categoria = c.cp_id_categoria
JOIN
    PERFIL p ON b.ce_id_perfil = p.cp_id_perfil;