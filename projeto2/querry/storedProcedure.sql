-- 1.
-- Adiciona um jogo ao acervo de um perfil. Caso o jogo já exista no acervo do perfil, retorna uma mensagem informando.
CREATE OR REPLACE PROCEDURE adicionar_jogo_ao_acervo(
    p_id_perfil INT,
    p_id_jogo INT,
    p_tipo_acervo VARCHAR(10),
    p_id_conquista INT DEFAULT NULL -- Conquista é opcional
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se o jogo já está no acervo do perfil
    IF EXISTS (
        SELECT 1
        FROM ACERVO
        WHERE ce_id_perfil = p_id_perfil AND ce_id_jogo = p_id_jogo
    ) THEN
        RAISE NOTICE 'O jogo já está no acervo deste perfil.';
    ELSE
        -- Insere o jogo no acervo
        INSERT INTO ACERVO (ce_id_perfil, ce_id_jogo, tipo, ce_id_conquista)
        VALUES (p_id_perfil, p_id_jogo, p_tipo_acervo, p_id_conquista);
        RAISE NOTICE 'Jogo adicionado ao acervo com sucesso.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro ao adicionar jogo ao acervo: %', SQLERRM;
END;
$$;

-- 2.
-- Crie um procedimento armazenado que adicione um novo grupo. 
CREATE OR REPLACE PROCEDURE adicionar_grupo(
    p_nome VARCHAR(40),
    p_descricao VARCHAR(120)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO GRUPO (nome, descrição, numero_participantes)
    VALUES (p_nome, p_descricao, 0);
COMMIT;
END;
$$;