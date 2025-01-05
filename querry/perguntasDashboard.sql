-- 1. 
-- Usuários que possuem bibliotecas em uma determinada categoria
SELECT p.nome
FROM PERFIL p
JOIN BIBLIOTECA b ON p.cp_id_perfil = b.ce_id_perfil
JOIN CATEGORIA c ON b.ce_id_categoria = c.cp_id_categoria
WHERE c.nome = 'Categoria 45'; 

-- 2.
-- Desejos com preço acima de um valor específico em uma categoria
SELECT d.nome
FROM DESEJO d
JOIN CATEGORIA c ON d.ce_id_categoria = c.cp_id_categoria
WHERE d.preço > 50 AND c.nome = 'Categoria 45'; 

-- 3.
-- Tempo total jogado com amigos por um usuário específico
SELECT SUM(a.tempo_jogado_juntos) AS tempo_total_jogado
FROM AMIGOS a
JOIN tem t ON a.cp_id_amigo = t.ce_id_amigo
WHERE t.ce_id_perfil = 30; 

-- 4.
-- Encontrar os nomes dos grupos que um determinado usuário participa e o nome do autor do grupo:
SELECT g.nome AS nome_grupo, p_autor.nome AS nome_autor
FROM GRUPO g
JOIN participar part ON g.cp_id_grupo = part.ce_id_grupo
JOIN PERFIL p_participante ON part.ce_id_perfil = p_participante.cp_id_perfil
JOIN PERFIL p_autor ON g.ce_id_perfil_autor = p_autor.cp_id_perfil
WHERE p_participante.cp_id_perfil = 10; o

-- 5. 
-- Quais os nomes dos usuários que têm amigos com tempo de jogo maior que 100 horas? 
SELECT nome
FROM PERFIL
WHERE cp_id_perfil IN (SELECT ce_id_perfil FROM AMIGOS WHERE tempo_jogado_juntos > 100);

-- 6.
-- Qual o nome dos usuários e a quantidade de amigos que cada um possui?
SELECT p.nome, COUNT(a.cp_id_amigo) AS quantidade_amigos
FROM PERFIL p
LEFT JOIN AMIGOS a ON p.cp_id_perfil = a.ce_id_perfil
GROUP BY p.nome;

-- 7.
-- Encontrar Usuários com Desejos em uma Categoria Específica
SELECT p.nome AS nome_usuario, c.descrição AS descrição_categoria
FROM PERFIL p
JOIN DESEJO d ON p.cp_id_perfil = d.ce_id_perfil
JOIN CATEGORIA c ON d.ce_id_categoria = c.cp_id_categoria
WHERE c.nome = 'Categoria 20'
GROUP BY p.nome, c.descrição;

-- 8.
-- Encontrando amigos em comum que compartilham desejos.
SELECT p1.nome AS usuario1, p2.nome AS usuario2, d.nome AS jogo_em_comum
FROM PERFIL p1
JOIN AMIGOS a1 ON p1.cp_id_perfil = a1.ce_id_perfil
JOIN PERFIL p2 ON a1.cp_id_amigo = p2.cp_id_perfil
JOIN DESEJO d ON d.ce_id_perfil = p1.cp_id_perfil -- Desejo de p1
WHERE EXISTS ( -- Verifica se p2 também deseja o mesmo jogo
    SELECT 1
    FROM DESEJO d2
    WHERE d2.ce_id_perfil = p2.cp_id_perfil AND d2.nome = d.nome
) AND p1.cp_id_perfil < p2.cp_id_perfil; -- Evita duplicatas

-- 9.
-- Encontrar grupos com mais de um membro que compartilham pelo menos uma categoria de desejo.
SELECT g.nome AS nome_grupo, c.nome AS nome_categoria
FROM GRUPO g
JOIN participar p1 ON g.cp_id_grupo = p1.ce_id_grupo
JOIN participar p2 ON g.cp_id_grupo = p2.ce_id_grupo AND p1.ce_id_perfil < p2.ce_id_perfil -- Garante que sejam membros diferentes
JOIN DESEJO d1 ON p1.ce_id_perfil = d1.ce_id_perfil
JOIN DESEJO d2 ON p2.ce_id_perfil = d2.ce_id_perfil
JOIN CATEGORIA c ON d1.ce_id_categoria = c.cp_id_categoria AND d2.ce_id_categoria = c.cp_id_categoria
GROUP BY g.nome, c.nome
HAVING COUNT(DISTINCT p1.ce_id_perfil) > 1; -- Garante que o grupo tenha mais de um membro que compartilha a categoria

-- 10.
-- Tempo total jogado com amigos que compartilham pelo menos um desejo. 
SELECT p1.nome, SUM(a1.tempo_jogado_juntos) AS tempo_total_com_amigos_em_comum
FROM PERFIL p1
JOIN AMIGOS a1 ON p1.cp_id_perfil = a1.ce_id_perfil
WHERE EXISTS (
    SELECT 1
    FROM PERFIL p2
    JOIN AMIGOS a2 ON p2.cp_id_perfil = a2.ce_id_perfil
    JOIN DESEJO d ON d.ce_id_perfil = p1.cp_id_perfil -- Desejo de p1
    WHERE a2.cp_id_amigo = p1.cp_id_perfil
      AND EXISTS (
        SELECT 1
        FROM DESEJO d2
        WHERE d2.ce_id_perfil = p2.cp_id_perfil AND d2.nome = d.nome
      )
)
GROUP BY p1.nome;