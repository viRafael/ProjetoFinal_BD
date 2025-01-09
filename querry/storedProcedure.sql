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
-- Adiciona uma relação de amizade entre dois perfis. Verifica se a amizade já existe e se os perfis existem.
CREATE OR REPLACE PROCEDURE adicionar_amigo(
    p_id_perfil1 INT,
    p_id_perfil2 INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se os perfis existem
    IF NOT EXISTS (SELECT 1 FROM PERFIL WHERE cp_id_perfil = p_id_perfil1) THEN
        RAISE EXCEPTION 'Perfil com ID % não encontrado.', p_id_perfil1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM PERFIL WHERE cp_id_perfil = p_id_perfil2) THEN
        RAISE EXCEPTION 'Perfil com ID % não encontrado.', p_id_perfil2;
    END IF;

    -- Verifica se a amizade já existe (em ambas as direções)
    IF EXISTS (
        SELECT 1
        FROM AMIGOS a1
        JOIN AMIGOS a2 ON a1.ce_id_perfil = p_id_perfil1 AND a2.ce_id_perfil = p_id_perfil2
    ) THEN
        RAISE NOTICE 'A amizade entre os perfis % e % já existe.', p_id_perfil1, p_id_perfil2;
    ELSE
        -- Adiciona a amizade (em ambas as direções para ser bidirecional)
        INSERT INTO AMIGOS (ce_id_perfil, ce_nome_perfil)
          SELECT p.cp_id_perfil, p.nome
          FROM PERFIL p
          WHERE p.cp_id_perfil = p_id_perfil1;
        INSERT INTO AMIGOS (ce_id_perfil, ce_nome_perfil)
          SELECT p.cp_id_perfil, p.nome
          FROM PERFIL p
          WHERE p.cp_id_perfil = p_id_perfil2;

        RAISE NOTICE 'Amizade entre os perfis % e % adicionada com sucesso.', p_id_perfil1, p_id_perfil2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro ao adicionar amizade: %', SQLERRM;
END;
$$;