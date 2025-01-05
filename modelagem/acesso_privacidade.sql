-- 1. ADM
-- Criar o usuário administrador
CREATE USER admin WITH PASSWORD 'admin_password';

-- Conceder permissões de superusuário ao administrador
ALTER USER admin WITH SUPERUSER;

-- 2. MOD
-- Criar o usuário moderador
CREATE USER moderador WITH PASSWORD 'moderador_password';

-- Conceder permissões de SELECT, INSERT, UPDATE e DELETE nas tabelas de comentários, grupos e conquistas
GRANT SELECT, INSERT, UPDATE, DELETE ON COMENTARIO TO moderador;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPO TO moderador;
GRANT SELECT, INSERT, UPDATE, DELETE ON CONQUISTA TO moderador;

-- 3. USER
-- Criar o usuário comum
CREATE USER usuario_comum WITH PASSWORD 'usuario_comum_password';

-- Conceder permissões de SELECT, INSERT e UPDATE nas tabelas que o usuário pode interagir
GRANT SELECT, INSERT, UPDATE ON PERFIL TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIBLIOTECA TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON DESEJO TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON AMIGOS TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON COMENTARIO TO usuario_comum;
GRANT SELECT, INSERT, UPDATE ON CONQUISTA TO usuario_comum;
GRANT SELECT, INSERT, UPDATE ON GRUPO TO usuario_comum;
GRANT SELECT, INSERT, UPDATE ON PARTICIPAR TO usuario_comum;

-- O usuário comum não deve ter permissão para deletar dados
REVOKE DELETE ON PERFIL, CONQUISTA, GRUPO, PARTICIPAR FROM usuario_comum;

-- 4. 
-- Criar o usuário leitor
CREATE USER leitor WITH PASSWORD 'leitor_password';

-- Conceder permissões de SELECT nas tabelas relevantes
GRANT SELECT ON PERFIL TO leitor;
GRANT SELECT ON BIBLIOTECA TO leitor;
GRANT SELECT ON DESEJO TO leitor;
GRANT SELECT ON AMIGOS TO leitor;
GRANT SELECT ON COMENTARIO TO leitor;
GRANT SELECT ON CONQUISTA TO leitor;
GRANT SELECT ON GRUPO TO leitor;
GRANT SELECT ON PARTICIPAR TO leitor;

-- 5. 
-- Permitir que os usuários se conectem ao banco de dados
GRANT CONNECT ON DATABASE "ProjetoBD" TO admin, moderador, usuario_comum, leitor;
GRANT USAGE ON SCHEMA public TO admin, moderador, usuario_comum, leitor;

-- 6. 
-- Adicionando FUNCOES, REGRAS e TRIGGERS
-- Função para permitir operações apenas no próprio perfil
CREATE OR REPLACE FUNCTION fn_perfil_access_control()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o usuário é o dono do perfil
    IF NEW.cp_id_perfil != current_setting('my.user_id')::INT  THEN
        RAISE EXCEPTION 'Você só pode modificar o seu próprio perfil!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para garantir que os usuários só modifiquem suas próprias conquistas
CREATE OR REPLACE FUNCTION fn_conquista_access_control()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o perfil está tentando modificar uma conquista que não pertence a ele
    IF NEW.ce_id_perfil != current_setting('my.user_id'):: INT THEN
        RAISE EXCEPTION 'Você só pode modificar suas próprias conquistas!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se o usuário está alterando os seus próprios dados na tabela BIBLIOTECA
CREATE OR REPLACE FUNCTION verificar_own_data_biblioteca() RETURNS trigger AS $$
BEGIN
    -- Verifica se o cp_id_perfil na tabela BIBLIOTECA corresponde ao cp_id_perfil do usuário
    IF NEW.ce_id_perfil != current_setting('my.user_id')::INT THEN
        RAISE EXCEPTION 'Você não tem permissão para alterar dados de outros usuários.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se o usuário está alterando os seus próprios dados na tabela DESEJO
CREATE OR REPLACE FUNCTION verificar_own_data_desejo() RETURNS trigger AS $$
BEGIN
    -- Verifica se o cp_id_perfil na tabela DESEJO corresponde ao cp_id_perfil do usuário
    IF NEW.ce_id_perfil != current_setting('my.user_id')::INT THEN
        RAISE EXCEPTION 'Você não tem permissão para alterar dados de outros usuários.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se o usuário está alterando os seus próprios dados na tabela AMIGOS
CREATE OR REPLACE FUNCTION verificar_own_data_amigos() RETURNS trigger AS $$
BEGIN
    -- Verifica se o cp_id_perfil na tabela AMIGOS corresponde ao cp_id_perfil do usuário
    IF NEW.ce_id_perfil != current_setting('my.user_id')::INT THEN
        RAISE EXCEPTION 'Você não tem permissão para alterar dados de outros usuários.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para garantir que o usuário só altere ou visualize grupos seus
CREATE OR REPLACE FUNCTION fn_grupo_access_control()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o grupo foi criado pelo usuário
    IF NEW.ce_id_perfil_autor != current_setting('my.user_id')::INT THEN
        RAISE EXCEPTION 'Você não pode modificar grupos que não são de sua autoria!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para garantir que o usuário só possa se associar a grupos válidos
CREATE OR REPLACE FUNCTION fn_participar_access_control()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o usuário já participa do grupo
    IF EXISTS (SELECT 1 FROM participar WHERE ce_id_grupo = NEW.ce_id_grupo AND ce_id_perfil = current_setting('my.user_id')::INT) THEN
        RAISE EXCEPTION 'Você já está participando deste grupo!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se o usuário está alterando os seus próprios dados na tabela COMENTARIO
CREATE OR REPLACE FUNCTION verificar_own_data_comentario() RETURNS trigger AS $$
BEGIN
    -- Verifica se o cp_id_perfil na tabela COMENTARIO corresponde ao cp_id_perfil do usuário
    IF NEW.ce_id_perfil != current_setting('my.user_id')::INT THEN
        RAISE EXCEPTION 'Você não tem permissão para alterar dados de outros usuários.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7.
-- Trigger para a tabela PERFIL
CREATE TRIGGER perfil_access_control_trigger
BEFORE INSERT OR UPDATE OR DELETE ON PERFIL
FOR EACH ROW EXECUTE FUNCTION fn_perfil_access_control();

-- Trigger para a tabela CONQUISTA 
CREATE TRIGGER conquista_access_control_trigger
BEFORE INSERT OR UPDATE OR DELETE ON CONQUISTA
FOR EACH ROW EXECUTE FUNCTION fn_conquista_access_control();

-- Trigger para a tabela GRUPO
CREATE TRIGGER grupo_access_control_trigger
BEFORE INSERT OR UPDATE OR DELETE ON GRUPO
FOR EACH ROW EXECUTE FUNCTION fn_grupo_access_control();

-- Trigger para a tabela PARTICIPAR
CREATE TRIGGER participar_access_control_trigger
BEFORE INSERT ON PARTICIPAR
FOR EACH ROW EXECUTE FUNCTION fn_participar_access_control();

-- Trigger para a tabela BIBLIOTECA
CREATE TRIGGER trigger_biblioteca
BEFORE INSERT OR UPDATE OR DELETE ON BIBLIOTECA
FOR EACH ROW
EXECUTE FUNCTION verificar_own_data_biblioteca();

-- Trigger para a tabela DESEJO
CREATE TRIGGER trigger_desejo
BEFORE INSERT OR UPDATE OR DELETE ON DESEJO
FOR EACH ROW
EXECUTE FUNCTION verificar_own_data_desejo();

-- Trigger para a tabela AMIGOS
CREATE TRIGGER trigger_amigos
BEFORE INSERT OR UPDATE OR DELETE ON AMIGOS
FOR EACH ROW
EXECUTE FUNCTION verificar_own_data_amigos();

-- Trigger para a tabela COMENTARIO
CREATE TRIGGER trigger_comentario
BEFORE INSERT OR UPDATE OR DELETE ON COMENTARIO
FOR EACH ROW
EXECUTE FUNCTION verificar_own_data_comentario();

-- Suponha que o ID do usuário seja 123
SET my.user_id = '100';
