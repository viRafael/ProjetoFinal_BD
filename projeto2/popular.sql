-- Primeiro vamos rodar o codigo abaixo, salvamos como o resultado em .csv 
-- Depois, convertemos o arquivo para .json
-- Populamos o MongoDB com as com esse arquivo, usamos o 'import data'

SELECT 
    p.cp_id_perfil, 
    p.nome AS perfil_nome,
    p.apelido, 
    p.email, 
    p.numero_telefone,
    -- Agrupando as conquistas em um array JSON
    COALESCE(JSON_AGG(
        DISTINCT JSONB_BUILD_OBJECT(
            'conquista_id', c.cp_id_conquista,
            'nome', c.nome,
            'descricao', c.descrição
        )
    ), '[]') AS conquistas,
    -- Agrupando o acervo em um array JSON com informações do jogo
    COALESCE(JSON_AGG(
        DISTINCT JSONB_BUILD_OBJECT(
            'acervo_id', a.cp_id_acervo,
            'tipo', a.tipo,
            'jogo', JSONB_BUILD_OBJECT(
                'jogo_id', j.cp_id_jogo,
                'nome', j.nome,
                'preco', j.preco,
                'data_lancamento', j.data_lancamento,
                'categoria', JSONB_BUILD_OBJECT(
                    'categoria_id', cat.cp_id_categoria,
                    'nome', cat.nome,
                    'descricao', cat.descrição
                )
            )
        )
    ), '[]') AS acervo,
    -- Agrupando os amigos em um array JSON
    COALESCE(JSON_AGG(
        DISTINCT JSONB_BUILD_OBJECT(
            'amigo_id', am.cp_id_amigo,
            'amigo_nome', am.ce_nome_perfil
        )
    ), '[]') AS amigos,
    -- Agrupando as informações do grupo em um array JSON
    COALESCE(JSON_AGG(
        DISTINCT JSONB_BUILD_OBJECT(
            'grupo_id', g.cp_id_grupo,
            'grupo_nome', g.nome,
            'grupo_descricao', g.descrição,
            'numero_participantes', g.numero_participantes
        )
    ), '[]') AS grupos,
    -- Agrupando o tempo jogado com amigos em um array JSON
    COALESCE(JSON_AGG(
        DISTINCT JSONB_BUILD_OBJECT(
            'tempo_jogado_juntos', ap.tempo_jogado_juntos,
            'data_inicio', ap.dt_inicio
        )
    ), '[]') AS tempo_jogado_amigos
FROM 
    PERFIL p
LEFT JOIN 
    ACERVO a ON p.cp_id_perfil = a.ce_id_perfil
LEFT JOIN 
    JOGOS j ON a.ce_id_jogo = j.cp_id_jogo
LEFT JOIN 
    CONQUISTA c ON a.ce_id_conquista = c.cp_id_conquista
LEFT JOIN 
    CATEGORIA cat ON j.ce_id_categoria = cat.cp_id_categoria
LEFT JOIN 
    AMIGOS am ON p.cp_id_perfil = am.ce_id_perfil
LEFT JOIN 
    amigos_perfil ap ON am.cp_id_amigo = ap.ce_id_amigo
LEFT JOIN 
    grupo_perfil gp ON p.cp_id_perfil = gp.ce_id_perfil
LEFT JOIN 
    GRUPO g ON gp.ce_id_grupo = g.cp_id_grupo
GROUP BY 
    p.cp_id_perfil, p.nome, p.apelido, p.email, p.numero_telefone;