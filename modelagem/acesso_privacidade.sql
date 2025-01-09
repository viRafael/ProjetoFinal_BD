-- 1. ADM
-- Criar o usuário administrador
CREATE USER admin WITH PASSWORD 'admin_password';

-- Conceder permissões de superusuário ao administrador
ALTER USER admin WITH SUPERUSER;

-- 2. MOD
-- Criar o usuário moderador
CREATE USER moderador WITH PASSWORD 'moderador_password';

-- Conceder permissões de SELECT, INSERT, UPDATE e DELETE nas seguintes tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPO TO moderador;
GRANT SELECT, INSERT, UPDATE, DELETE ON CONQUISTA TO moderador;
GRANT SELECT, INSERT, UPDATE, DELETE ON JOGOS TO moderador;
GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA TO moderador;

-- 3. USER
-- Criar o usuário comum
CREATE USER usuario_comum WITH PASSWORD 'usuario_comum_password';

-- Conceder permissões de SELECT, INSERT e UPDATE nas tabelas que o usuário pode interagir
GRANT SELECT, INSERT, UPDATE, DELETE ON PERFIL TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON ACERVO TO usuario_comum;
GRANT SELECT ON JOGOS TO usuario_comum; 
GRANT SELECT ON AMIGOS TO usuario_comum;
GRANT SELECT ON CONQUISTA TO usuario_comum;
GRANT SELECT, INSERT, UPDATE ON GRUPO TO usuario_comum;
GRANT SELECT ON grupo_perfil TO usuario_comum; 
GRANT SELECT ON amigos_perfil TO usuario_comum; 
GRANT SELECT ON CATEGORIA TO usuario_comum;

-- O usuário comum não deve ter permissão para deletar dados
REVOKE DELETE ON CONQUISTA, JOGOS, CATEGORIA, AMIGOS, grupo_perfil, amigos_perfil  FROM usuario_comum;

-- 4. 
-- Criar o usuário leitor
CREATE USER leitor WITH PASSWORD 'leitor_password';

-- Conceder permissões de SELECT nas tabelas relevantes
GRANT SELECT ON PERFIL TO leitor;
GRANT SELECT ON JOGOS TO leitor; 
GRANT SELECT ON ACERVO TO leitor;
GRANT SELECT ON AMIGOS TO leitor;
GRANT SELECT ON CONQUISTA TO leitor;
GRANT SELECT ON GRUPO TO leitor;
GRANT SELECT ON grupo_perfil TO leitor; 
GRANT SELECT ON amigos_perfil TO leitor; 
GRANT SELECT ON CATEGORIA TO leitor;

-- 5. 
-- Permitir que os usuários se conectem ao banco de dados
GRANT USAGE ON SCHEMA public TO public;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO public;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO public;