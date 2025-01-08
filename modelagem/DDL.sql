CREATE TABLE PERFIL ( 
    cp_id_perfil SERIAL PRIMARY KEY,  
    nome varchar(20),  
    apelido varchar(20) NOT NULL,  
    email varchar(40) NOT NULL UNIQUE,  
    numero_telefone INT,  
    ce_id_acervo INT -- CHAVE ESTRANGEIRA
); 

CREATE TABLE JOGOS ( 
    cp_id_jogo SERIAL PRIMARY KEY,  
    nome varchar(80) NOT NULL,  
    preco INT,  
    data_lancamento VARCHAR(10),
    ce_id_categoria INT -- CHAVE ESTRANGEIRA  
); 

CREATE TABLE CONQUISTA ( 
    cp_id_conquista SERIAL PRIMARY KEY,  
    nome varchar(60) NOT NULL, 
    descrição varchar(120) 
); 

CREATE TABLE ACERVO ( 
    cp_id_acervo SERIAL PRIMARY KEY, 
    tipo varchar(10),
    ce_id_perfil INT, -- CHAVE ESTRANGEIRA  
    ce_id_jogo INT, -- CHAVE ESTRANGEIRA  
    ce_id_conquista INT -- CHAVE ESTRANGEIRA
);

CREATE TABLE CATEGORIA ( 
    cp_id_categoria SERIAL PRIMARY KEY,  
    nome varchar(120) NOT NULL,  
    descrição varchar(120)  
); 

CREATE TABLE AMIGOS ( 
    cp_id_amigo SERIAL PRIMARY KEY,  
    ce_id_perfil INT, -- CHAVE ESTRANGEIRA
    ce_nome_perfil varchar(20) -- CHAVE ESTRANGEIRA
); 

CREATE TABLE GRUPO ( 
    cp_id_grupo SERIAL PRIMARY KEY,  
    nome varchar(20) NOT NULL,  
    descrição varchar(120),
    numero_participantes INT
);  

CREATE TABLE amigos_perfil ( 
    tempo_jogado_juntos INT,
    dt_inicio varchar(10), 
    ce_id_amigo INT,  -- CHAVE ESTRANGEIRA 
    ce_id_perfil INT  -- CHAVE ESTRANGEIRA 
); 

CREATE TABLE grupo_perfil ( 
    ce_id_grupo INT, -- CHAVE ESTRANGEIRA  
    ce_id_perfil INT -- CHAVE ESTRANGEIRA  
); 

-- ADICIONANDO AS CONTRAINS
-- Adicionando para PERFIL
ALTER TABLE PERFIL
ADD FOREIGN KEY(ce_id_acervo) 
REFERENCES ACERVO (cp_id_acervo);

-- Adicionando para JOGOS
ALTER TABLE JOGOS
ADD FOREIGN KEY(ce_id_categoria) 
REFERENCES CATEGORIA (cp_id_categoria);

-- Adicionando para ACERVO
ALTER TABLE ACERVO
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES PERFIL (cp_id_perfil);

ALTER TABLE ACERVO
ADD FOREIGN KEY(ce_id_conquista) 
REFERENCES CONQUISTA (cp_id_conquista);

ALTER TABLE ACERVO
ADD FOREIGN KEY(ce_id_jogo) 
REFERENCES JOGOS (cp_id_jogo);

-- Adicionando para AMIGOS
ALTER TABLE AMIGOS
ADD FOREIGN KEY(ce_nome_perfil) 
REFERENCES PERFIL (nome);

ALTER TABLE AMIGOS
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES PERFIL (cp_id_perfil);


-- Adicionando para amigos_perfil
ALTER TABLE amigos_perfil
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES PERFIL (cp_id_perfil);

ALTER TABLE amigos_perfil
ADD FOREIGN KEY(ce_id_amigo) 
REFERENCES AMIGOS (cp_id_amigo);

-- Adicionando para grupo_perfil
ALTER TABLE grupo_perfil
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES PERFIL (cp_id_perfil);

ALTER TABLE grupo_perfil
ADD FOREIGN KEY(ce_id_grupo) 
REFERENCES GRUPO (cp_id_grupo);