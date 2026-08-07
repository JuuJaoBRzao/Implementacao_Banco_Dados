# Aula 2 - 07/08/2026
- Praticamos os comandos básicos de sql:
```sql
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
drop table Editora;

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

INSERT INTO editora(nome, cidade, site, ano_fundacao)
VALUES ("Companhia das Letras", "São Paulo", "www.cdl.br", 1986), 
	   ("Penguin", "Londres", "www.pg.ldn", 1935);
       
INSERT INTO Livro(titulo, ISBN,  ano_publicacao, fk_id_autor, fk_id_editora)
VALUES ("Dom Casmurro", "9874689", 1910, 1, 1),
	   ("1984", "7799654", 1949, 2, 2);
       
TRUNCATE livro;
       
DELETE FROM autor
WHERE autor_id_autor = 3;

UPDATE autor
SET autor.nacionalidade = "Brasileiro"
WHERE Autor.id = 2;

SELECT l.titulo, l.ano_publicacao
FROM livro AS l
WHERE l.titulo LIKE "%Dom%";

SELECT *
FROM livro AS l
JOIN autor AS a ON l.fk_id_autor = a.id_autor;

SELECT l.titulo AS "Título", 
	   l.ano_publicacao AS "Ano de publicação", 
	   A.nome AS "Autor", 
	   A.nacionalidade AS "Nacionalidade", 
       CONCAT(A.nome, "/", A.nacionalidade) AS "Autor/Nacionalidade",
       e.nome AS "Editora"
FROM Livro AS l
JOIN Autor AS a ON l.fk_id_autor = A.id
JOIN Editora AS e ON l.fk_id_editora = e.id_editora;

-- Recuperado as informações
SELECT * FROM autor;
SELECT * FROM livro;

SHOW TABLES;
```

# Aula 1 - 31/07/2026

* Revisão: 
  - Reverse Engineering:
  - Forward Engineering:

  - Modelo Entidade Relacionamento Conceitual:
    - Relaciona entidades com seus respectivos atributos.
    - Usado para eliminar possíveis duplicidade no banco.
    - Toda entidade necessita de uma chave primária (Ex: CPF).
    - Não demonstra fisicamente como esse banco realmente será estruturado, apenas um conceito.
    - Atributo multilavorado = (0/1...N).

    - Exemplo Tabela Entidade Relacionamento:
    <img width="502" height="216" alt="image" src="https://github.com/user-attachments/assets/62cc4b11-57a6-4f68-bd5f-5fe0f87f0706" />

    - Exemplo Tabela Física:
      ```sql
        /* Lógico_1: */

      CREATE TABLE Funcionario (
        CPF CHAR(14) PRIMARY KEY,
        Nome VARCHAR(100),
        Salario DECIMAL(10,2),
        DataNasc DATE,
        CEP CHAR(9),
        Rua VARCHAR(255),
        Numero INT,
        Complemento VARCHAR(255)
      );
      ```
      ///////////////////////////

      - Tabelas completas:
        <img width="982" height="485" alt="image" src="https://github.com/user-attachments/assets/fdb9f60f-90ee-4969-ba11-153f60f79e20" />
        <img width="632" height="563" alt="image" src="https://github.com/user-attachments/assets/3361a74a-4def-4523-8f75-fa82474496d5" />
        
        OBS: se tem duplicidade, geralmente vai ser um atributo.

         site: brmodeloweb.com (extensão .jar)
