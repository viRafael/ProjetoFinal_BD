-- 1. Tabela PERFIL (já implementado na resposta anterior)
ALTER TABLE PERFIL ALTER COLUMN apelido TYPE VARCHAR(20); -- Garante a alteração

DO $$
DECLARE
    i integer := 1;
BEGIN
    WHILE i <= 100 LOOP
        INSERT INTO PERFIL (nome, apelido, email, numero_telefone)
        VALUES (
            'Usuario ' || i,
            'Apelido' || i,
            'usuario' || i || '@exemplo.com',
            floor(random() * 900000000) + 100000000
        );
        i := i + 1;
    END LOOP;
END $$;

-- 2. Tabela CATEGORIA
DO $$
DECLARE
    i integer := 1;
BEGIN
    WHILE i <= 50 LOOP -- Menos categorias, para não gerar muitos relacionamentos desnecessários
        INSERT INTO CATEGORIA (nome, descrição)
        VALUES (
            'Categoria ' || i,
            'Descrição da Categoria ' || i
        );
        i := i + 1;
    END LOOP;
END $$;

-- 3. Tabela BIBLIOTECA
DO $$
DECLARE
    i integer := 1;
    perfil_id INTEGER;
    categoria_id INTEGER;
BEGIN
    WHILE i <= 100 LOOP
        SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        SELECT cp_id_categoria INTO categoria_id FROM CATEGORIA ORDER BY RANDOM() LIMIT 1;
        INSERT INTO BIBLIOTECA (nome, tempo_uso, ce_id_categoria, ce_id_perfil)
        VALUES (
            'Biblioteca ' || i,
            floor(random() * 240) + 60, -- Tempo de uso entre 60 e 300
            categoria_id,
            perfil_id
        );
        i := i + 1;
    END LOOP;
END $$;

-- 4. Tabela DESEJO (similar a BIBLIOTECA)
DO $$
DECLARE
    i integer := 1;
    perfil_id INTEGER;
    categoria_id INTEGER;
BEGIN
    WHILE i <= 100 LOOP
        SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        SELECT cp_id_categoria INTO categoria_id FROM CATEGORIA ORDER BY RANDOM() LIMIT 1;
        INSERT INTO DESEJO (nome, descrição, preço, ce_id_categoria, ce_id_perfil)
        VALUES (
            'Desejo ' || i,
            'Descrição do Desejo ' || i,
            floor(random() * 300) + 50, -- Preço entre 50 e 350
            categoria_id,
            perfil_id
        );
        i := i + 1;
    END LOOP;
END $$;

-- 5. Tabela AMIGOS (relaciona emails existentes em PERFIL)
DO $$
DECLARE
    i integer := 1;
    perfil1_id INTEGER;
    perfil2_id INTEGER;
BEGIN
    WHILE i <= 50 LOOP -- Gera 50 pares de amizades (100 registros na tabela AMIGOS)
        SELECT cp_id_perfil INTO perfil1_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        SELECT cp_id_perfil INTO perfil2_id FROM PERFIL WHERE cp_id_perfil != perfil1_id ORDER BY RANDOM() LIMIT 1;

        -- Insere a amizade do ponto de vista do perfil1
        INSERT INTO AMIGOS (dt_inicio, tempo_jogado_juntos, ce_id_perfil)
        VALUES 
            ('2023-01-01', 
            floor(random() * 501) + 100, -- Intervalo entre 100 e 600 (inclusive)
            perfil1_id
        );

        
        i := i + 1;
    END LOOP;
END $$;

-- 6. Tabela COMENTARIO
DO $$
DECLARE
    i integer := 1;
    perfil_id INTEGER;
BEGIN
    WHILE i <= 100 LOOP
        SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        INSERT INTO COMENTARIO (titulo, conteudo, ce_id_perfil)
        VALUES (
            'Comentário ' || i,
            'Conteúdo do Comentário ' || i,
            perfil_id
        );
        i := i + 1;
    END LOOP;
END $$;

-- 7. Tabela CONQUISTA
DO $$
DECLARE
    i integer := 1;
    perfil_id INTEGER;
BEGIN
    WHILE i <= 100 LOOP
        SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        INSERT INTO CONQUISTA (nome, descrição, ce_id_perfil)
        VALUES (
            'Conquista ' || i,
            'Descrição da Conquista ' || i,
            perfil_id
        );
        i := i + 1;
    END LOOP;
END $$;

-- 8. Tabela GRUPO
DO $$
DECLARE
    i integer := 1;
    perfil_id INTEGER;
BEGIN
    WHILE i <= 50 LOOP
        SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
        INSERT INTO GRUPO (nome, descrição, ce_id_perfil_autor)
        VALUES (
            'Grupo ' || i,
            'Descrição do Grupo ' || i,
            perfil_id
        );
        i := i + 1;
    END LOOP;
END $$;

-- 9. Tabela tem (relacionamento entre AMIGOS e PERFIL)
DO $$
DECLARE
  i integer := 1;
  amigo_id INTEGER;
  perfil_id INTEGER;
BEGIN
  WHILE i <= 100 LOOP
    SELECT cp_id_amigo INTO amigo_id FROM AMIGOS ORDER BY RANDOM() LIMIT 1;
    SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
    INSERT INTO tem (ce_id_amigo, ce_id_perfil) VALUES (amigo_id, perfil_id);
    i := i + 1;
  END LOOP;
END $$;


-- 10. Tabela participar (relacionamento entre GRUPO e PERFIL)
DO $$
DECLARE
  i integer := 1;
  grupo_id INTEGER;
  perfil_id INTEGER;
BEGIN
  WHILE i <= 100 LOOP
    SELECT cp_id_grupo INTO grupo_id FROM GRUPO ORDER BY RANDOM() LIMIT 1;
    SELECT cp_id_perfil INTO perfil_id FROM PERFIL ORDER BY RANDOM() LIMIT 1;
    INSERT INTO participar (ce_id_grupo, ce_id_perfil) VALUES (grupo_id, perfil_id);
    i := i + 1;
  END LOOP;
END $$;