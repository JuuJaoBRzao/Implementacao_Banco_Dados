-- Criando meu banco
CREATE DATABASE biblioteca;

-- Colocando o banco criado em uso
USE biblioteca;

CREATE TABLE Autor (
	id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(151) NOT NULL,
    nacionalidade VARCHAR(100) NOT NULL,
    ano_nascimento YEAR
);

CREATE TABLE Editora(
	id_Editora INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cidade VARCHAR(50),
    site VARCHAR(100),
    ano_fundacao YEAR
);

CREATE TABLE Livro (
	ISBN CHAR(13) PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao YEAR,
    fk_id_autor INT,
    fk_id_editora INT,
    FOREIGN KEY (fk_id_autor) REFERENCES autor(id_autor),
    FOREIGN KEY (fk_id_editora) REFERENCES editora(id_editora)
    
    -- FOREIGN KEY (fk_id_Autor) REFERENCES Autor(id)
);

-- Remover as tabelas
drop table Livro;
drop table Autor;

-- Adicionar FK via alteração
ALTER TABLE Livro
ADD CONSTRAINT  fk_Autor -- nome da restrição
FOREIGN KEY (fk_id_Autor) REFERENCES Autor(id);

-- Adicionando uma nova coluna
ALTER TABLE Livro
ADD genero VARCHAR(100);

-- Remover uma coluna
ALTER TABLE Livro
DROP COLUMN genero;

-- Modificar tipo de uma coluna
ALTER TABLE Autor
MODIFY COLUMN nacionalidade CHAR(2);

-- Alterando nome de uma coluna
ALTER TABLE Livro
CHANGE id ISBN VARCHAR(20);

-- Inserir
INSERT INTO Autor (nome, nacionalidade, ano_nascimento) 
VALUES ("Machado de Assis", "Brasileiro", 1939);

INSERT INTO Autor
VALUES (NULL, "George Orwell", "Britânico", 1903); 

-- Recuperado as informações
SELECT * FROM autor;

SHOW TABLES;
