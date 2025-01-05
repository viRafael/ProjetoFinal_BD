-- BETREE
-- Índices para chaves estrangeiras
CREATE INDEX idx_biblioteca_ce_id_categoria ON BIBLIOTECA (ce_id_categoria);
CREATE INDEX idx_biblioteca_ce_id_perfil ON BIBLIOTECA (ce_id_perfil);

CREATE INDEX idx_desejo_ce_id_categoria ON DESEJO (ce_id_categoria);
CREATE INDEX idx_desejo_ce_id_perfil ON DESEJO (ce_id_perfil);

CREATE INDEX idx_amigos_ce_id_perfil ON AMIGOS (ce_id_perfil);

CREATE INDEX idx_comentario_ce_id_perfil ON COMENTARIO (ce_id_perfil);

CREATE INDEX idx_conquista_ce_id_perfil ON CONQUISTA (ce_id_perfil);

CREATE INDEX idx_grupo_ce_id_perfil_autor ON GRUPO (ce_id_perfil_autor);

CREATE INDEX idx_tem_ce_id_amigo ON tem (ce_id_amigo);
CREATE INDEX idx_tem_ce_id_perfil ON tem (ce_id_perfil);

CREATE INDEX idx_participar_ce_id_grupo ON participar (ce_id_grupo);
CREATE INDEX idx_participar_ce_id_perfil ON participar (ce_id_perfil);

-- Índices adicionais com base em possíveis consultas frequentes (exemplos)

-- Se você frequentemente busca perfis por nome ou apelido:
CREATE INDEX idx_perfil_nome ON PERFIL (nome);
CREATE INDEX idx_perfil_apelido ON PERFIL (apelido);

-- Se você frequentemente busca desejos por nome:
CREATE INDEX idx_desejo_nome ON DESEJO (nome);

-- Se você frequentemente busca categorias por nome:
CREATE INDEX idx_categoria_nome ON CATEGORIA (nome);

-- Exemplo de índice composto (se você frequentemente busca desejos por categoria E perfil):
CREATE INDEX idx_desejo_categoria_perfil ON DESEJO (ce_id_categoria, ce_id_perfil);

-- Se você frequentemente busca amigos por data de início:
CREATE INDEX idx_amigos_dt_inicio ON AMIGOS (dt_inicio);


-- COM HASH
CREATE INDEX idx_amigos_ce_id_perfil_hash ON AMIGOS USING HASH (ce_id_perfil);
CREATE INDEX idx_perfil_nome_hash ON PERFIL USING HASH (nome);