-- 1.
-- Inserir um novo desejo na tabela DESEJO.
CREATE OR REPLACE PROCEDURE inserir_novo_desejo(
    IN p_nome VARCHAR(120),
    IN p_descricao TEXT,
    IN p_preco INT,
    IN p_id_perfil INT,
    IN p_id_categoria INT,
    OUT mensagem VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO DESEJO (nome, descrição, preço, ce_id_perfil, ce_id_categoria)
    VALUES (p_nome, p_descricao, p_preco, p_id_perfil, p_id_categoria);

    mensagem := 'Desejo inserido com sucesso.';

EXCEPTION
    WHEN unique_violation THEN -- Trata violação de chave única
        mensagem := 'Erro: Já existe um desejo com este nome para este perfil.';
    WHEN OTHERS THEN
        mensagem := 'Erro ao inserir o desejo: ' || SQLERRM;
        ROLLBACK;
END;
$$;

DO $$
DECLARE
    msg VARCHAR;
BEGIN
    CALL inserir_novo_desejo('Novo Jogo', 'Descrição do novo jogo.', 75, 1, 2, msg);
    RAISE NOTICE '%', msg;
END $$;

select * from desejo;

-- 2.
-- Retornar o número de desejos para uma determinada categoria.
CREATE OR REPLACE PROCEDURE obter_numero_desejos_por_categoria(
    IN p_id_categoria INT,
    OUT p_numero_desejos INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO p_numero_desejos
    FROM DESEJO
    WHERE ce_id_categoria = p_id_categoria;

    IF p_numero_desejos IS NULL THEN --Trata o caso de não existir desejos para a categoria
      p_numero_desejos = 0;
    END IF;

END;
$$;

DO $$
DECLARE
    num_desejos INT;
BEGIN
    CALL obter_numero_desejos_por_categoria(1, num_desejos);
    RAISE NOTICE 'Número de desejos na categoria 1: %', num_desejos;
END $$;