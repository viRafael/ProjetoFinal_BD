-- =========== Querrys basicas ==========
-- 1. 
-- Quais os nomes dos perfis e os nomes dos jogos que eles têm em seu acervo, listando também o tipo do acervo?
SELECT p.nome AS nome_perfil, j.nome AS nome_jogo, a.tipo AS tipo_acervo
FROM PERFIL p
JOIN ACERVO a ON p.cp_id_perfil = a.ce_id_perfil
JOIN JOGOS j ON a.ce_id_jogo = j.cp_id_jogo;

-- 2. 
-- Qual o preço médio dos jogos em cada categoria?
SELECT c.nome AS nome_categoria, AVG(j.preco) AS preco_medio
FROM JOGOS j
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria
GROUP BY c.nome;

-- 3.
--  Quais os nomes dos jogos e os nomes das categorias a que pertencem, listando apenas os jogos que custam mais de 50 reais?
SELECT j.nome AS nome_jogo, c.nome AS nome_categoria
FROM JOGOS j
JOIN CATEGORIA c ON j.ce_id_categoria = c.cp_id_categoria
WHERE j.preco > 50;

-- =========== Querrys intermediarias ==========
-- 4. 
-- Quantos amigos cada perfil tem?
SELECT p.nome AS nome_perfil, COUNT(a.cp_id_amigo) AS numero_de_amigos
FROM PERFIL p
LEFT JOIN AMIGOS a ON p.cp_id_perfil = a.ce_id_perfil
GROUP BY p.nome
ORDER BY numero_de_amigos DESC; -- Ordena para mostrar quem tem mais amigos primeiro

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
SELECT p1.nome AS perfil1, p2.nome AS perfil2, p3.nome AS amigo_comum
FROM PERFIL p1
JOIN amigos_perfil ap1 ON p1.cp_id_perfil = ap1.ce_id_perfil
JOIN AMIGOS a ON ap1.ce_id_amigo = a.cp_id_amigo
JOIN PERFIL p3 ON a.ce_id_perfil = p3.cp_id_perfil -- Amigo comum
JOIN amigos_perfil ap2 ON p2.cp_id_perfil = ap2.ce_id_perfil
WHERE ap1.ce_id_amigo = ap2.ce_id_amigo -- Condição chave: mesmo amigo
AND p1.cp_id_perfil < p2.cp_id_perfil; -- Evita duplicatas (ex: (A, B) e (B, A))

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