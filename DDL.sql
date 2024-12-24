-- Criar Tabela PERFIL
CREATE TABLE PERFIL ( 
    cp_id_perfil SERIAL PRIMARY KEY,  
    nome varchar(20),  
    apelido INT NOT NULL,  
    email varchar(40) NOT NULL,  
    numero_telefone INT, -- CHAVE ESTRANGEIRA
    ce_id_comentario INT, -- CHAVE ESTRANGEIRA
    ce_id_conquista INT, -- CHAVE ESTRANGEIRA 
    ce_id_desejo INT -- CHAVE ESTRANGEIRA 
); 

-- Criar Tabela BIBLIOTECA
CREATE TABLE BIBLIOTECA ( 
    cp_id_biblioteca SERIAL PRIMARY KEY,  
    nome varchar(60),  
    tempo_uso INT,  
    ce_categoria INT, -- CHAVE ESTRANGEIRA   
    ce_id_perfil INT -- CHAVE ESTRANGEIRA   
); 

-- Criar Tabela DESEJO
CREATE TABLE DESEJO ( 
    cp_id_desejo SERIAL PRIMARY KEY,  
    nome varchar(60) NOT NULL,  
    descrição varchar(120),  
    preço INT,  
    ce_categoria INT -- CHAVE ESTRANGEIRA   
); 

-- Criar Tabela CATEGORIA
CREATE TABLE CATEGORIA ( 
    cp_id_categoria SERIAL PRIMARY KEY,  
    nome varchar(120),  
    descrição varchar(120),  
    ce_id_desejo INT, -- CHAVE ESTRANGEIRA   
    ce_id_biblioteca INT -- CHAVE ESTRANGEIRA   
); 

-- Criar Tabela AMIGOS
CREATE TABLE AMIGOS ( 
    cp_id_amigo SERIAL PRIMARY KEY,  
    dt_inicio varchar(8), 
    ce_email INT -- CHAVE ESTRANGEIRA
); 

-- Criar Tabela COMENTARIO
CREATE TABLE COMENTARIO ( 
    cp_id_comentario SERIAL PRIMARY KEY,  
    titulo varchar(60),
    conteudo varchar(120),  
    ce_id_perfil INT -- CHAVE ESTRANGEIRA  
); 

-- Criar Tabela CONQUISTA
CREATE TABLE CONQUISTA ( 
    cp_id_conquista SERIAL PRIMARY KEY,  
    nome varchar(60), 
    descrição varchar(120), 
    ce_id_perfil INT -- CHAVE ESTRANGEIRA     
); 

-- Criar Tabela GRUPO
CREATE TABLE GRUPO ( 
    cp_id_grupo SERIAL PRIMARY KEY,  
    nome varchar(20),  
    descrição varchar(120),  
    ce_id_perfil_autor INT -- CHAVE ESTRANGEIRA   
); 

-- Criar Tabela tem
CREATE TABLE tem ( 
    ce_id_amigo INT, -- CHAVE ESTRANGEIRA
    ce_id_perfil INT -- CHAVE ESTRANGEIRA 
); 

-- Criar Tabela participar
CREATE TABLE participar ( 
    ce_id_grupo INT, -- CHAVE ESTRANGEIRA 
    ce_id_perfil INT -- CHAVE ESTRANGEIRA  
); 

-- TO DO: 
-- ADICIONANDO AS CONTRAINS  

-- Adicionando CONSTRAINS para PERFIL
ALTER TABLE PERFIL 
ADD FOREIGN KEY(ce_id_comentario) 
REFERENCES PERFIL (ce_id_comentario);

ALTER TABLE PERFIL 
ADD FOREIGN KEY(ce_id_conquista) 
REFERENCES PERFIL (ce_id_conquista);

ALTER TABLE PERFIL 
ADD FOREIGN KEY(ce_id_desejo) 
REFERENCES PERFIL (ce_id_desejo);

-- Adicionando CONSTRAINS para BIBLIOTECA
ALTER TABLE BIBLIOTECA 
ADD FOREIGN KEY(ce_categoria) 
REFERENCES undefined (ce_categoria);

ALTER TABLE BIBLIOTECA 
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES PERFIL (ce_id_perfil);

-- Adicionando CONSTRAINS para DESEJO
ALTER TABLE DESEJO 
ADD FOREIGN KEY(ce_categoria) 
REFERENCES PERFIL (ce_categoria)

-- Adicionando CONSTRAINS para CATEGORIA
ALTER TABLE CATEGORIA 
ADD FOREIGN KEY(ce_id_desejo) 
REFERENCES PERFIL (ce_id_desejo)

ALTER TABLE CATEGORIA 
ADD FOREIGN KEY(ce_id_biblioteca) 
REFERENCES PERFIL (ce_id_biblioteca)

-- Adicionando CONSTRAINS para AMIGOS
ALTER TABLE AMIGOS 
ADD FOREIGN KEY(ce_email FK) 
REFERENCES PERFIL (ce_email FK)

-- Adicionando CONSTRAINS para COMENTARIO
ALTER TABLE COMENTARIO 
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES undefined (ce_id_perfil)

-- Adicionando CONSTRAINS para CONQUISTA
ALTER TABLE CONQUISTA 
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES undefined (ce_id_perfil)

-- Adicionando CONSTRAINS para GRUPO
ALTER TABLE GRUPO ADD 
FOREIGN KEY(ce_id_perfil_autor) 
REFERENCES undefined (ce_id_perfil_autor)

-- Adicionando CONSTRAINS para tem
ALTER TABLE tem 
ADD FOREIGN KEY(ce_id_amigo) 
REFERENCES undefined (ce_id_amigo)

ALTER TABLE tem 
ADD FOREIGN KEY(ce_id_perfil) 
REFERENCES undefined (ce_id_perfil)