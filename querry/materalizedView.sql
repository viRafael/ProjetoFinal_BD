-- 1.
-- Jogos por Categoria com Número de Jogos e Preço Médio 
CREATE MATERIALIZED VIEW jogos_por_categoria AS
SELECT c.nome AS nome_categoria,
       COUNT(j.cp_id_jogo) AS quantidade_jogos,
       AVG(j.preco) AS preco_medio
FROM JOGOS j
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria
GROUP BY c.nome;

-- 2.
-- Resumo dos Acervo com Informações de Categoria e Usuário
CREATE MATERIALIZED VIEW resumo_acervo AS
SELECT
    p.nome AS nome_perfil,
    p.apelido AS apelido_perfil,
    j.nome AS nome_jogo,
    c.nome AS nome_categoria,
    a.tipo AS tipo_acervo,
    con.nome as nome_conquista,
    con.descrição as descricao_conquista
FROM
    ACERVO a
JOIN
    PERFIL p ON a.ce_id_perfil = p.cp_id_perfil
JOIN
    JOGOS j ON a.ce_id_jogo = j.cp_id_jogo
JOIN
    CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria
LEFT JOIN
    CONQUISTA con ON a.ce_id_conquista = con.cp_id_conquista;

-- Para atualizar a materialized view:
REFRESH MATERIALIZED VIEW jogos_com_mais_conquistas;
REFRESH MATERIALIZED VIEW resumo_acervo;