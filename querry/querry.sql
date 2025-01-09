-- =========== Querrys basicas ==========
-- 1. 
-- Qual é o nome e e-mail de todos os perfis cadastrados?
SELECT nome, email 
FROM PERFIL;

-- 2. 
-- Quais são os jogos disponíveis e seus respectivos preços?
SELECT nome, preco 
FROM JOGOS;


-- 3.
-- Quais são as conquistas cadastradas no sistema?
SELECT nome 
FROM CONQUISTA;

-- =========== Querrys intermediarias ==========
-- 4. 
-- Qual é o nome dos jogos e a categoria a qual eles pertencem?
SELECT j.nome AS nome_jogo, c.nome AS categoria_jogo
FROM JOGOS j
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria;

-- 5. 
-- Qual é o nome dos jogos e a categoria a qual eles pertencem?
SELECT j.nome AS nome_jogo, c.nome AS categoria_jogo
FROM JOGOS j
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria;

-- 6.
-- Quantas conquistas estão associadas a cada perfil?
SELECT p.nome, COUNT(a.ce_id_conquista) AS total_conquistas
FROM PERFIL p
JOIN ACERVO a ON p.cp_id_perfil = a.ce_id_perfil
GROUP BY p.nome;

-- 7.
-- Quais perfis têm amigos em comum? (Exemplo: perfis com o mesmo amigo)
SELECT p1.nome AS perfil1, p2.nome AS perfil2, a.ce_nome_perfil AS amigo_comum
FROM AMIGOS a
JOIN PERFIL p1 ON p1.cp_id_perfil = a.ce_id_perfil
JOIN PERFIL p2 ON p2.nome = a.ce_nome_perfil
WHERE p1.cp_id_perfil != p2.cp_id_perfil;

-- =========== Querrys avançadas ==========
-- 8.
-- Quais perfis possuem jogos de determinadas categorias e também conquistaram conquistas?
SELECT p.nome, j.nome AS jogo, c.nome AS categoria, co.nome AS conquista
FROM PERFIL p
JOIN ACERVO a ON p.cp_id_perfil = a.ce_id_perfil
JOIN JOGOS j ON a.ce_id_jogo = j.cp_id_jogo
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria
JOIN CONQUISTA co ON a.ce_id_conquista = co.cp_id_conquista
WHERE c.nome = 'Ação'; -- Categoria de exemplo

-- 9.
-- Quais perfis jogaram juntos mais tempo? (Baseado no tempo total jogado)
SELECT p1.nome AS perfil1, p2.nome AS perfil2, SUM(ap.tempo_jogado_juntos) AS tempo_total
FROM amigos_perfil ap
JOIN PERFIL p1 ON ap.ce_id_perfil = p1.cp_id_perfil
JOIN PERFIL p2 ON ap.ce_id_amigo = p2.cp_id_perfil
GROUP BY p1.nome, p2.nome
ORDER BY tempo_total DESC
LIMIT 5; -- Top 5 perfis com mais tempo jogado juntos

-- 10.
-- Quais perfis pertencem aos mesmos grupos e têm o mesmo amigo?
SELECT p1.nome AS perfil1, p2.nome AS perfil2, g.nome AS grupo, a.ce_nome_perfil AS amigo_comum
FROM grupo_perfil gp
JOIN PERFIL p1 ON gp.ce_id_perfil = p1.cp_id_perfil
JOIN grupo_perfil gp2 ON gp.ce_id_grupo = gp2.ce_id_grupo
JOIN PERFIL p2 ON gp2.ce_id_perfil = p2.cp_id_perfil
JOIN AMIGOS a ON p1.cp_id_perfil = a.ce_id_perfil
WHERE p1.cp_id_perfil != p2.cp_id_perfil
AND a.ce_id_perfil = p2.cp_id_perfil;