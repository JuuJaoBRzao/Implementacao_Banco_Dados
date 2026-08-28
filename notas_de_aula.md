# Aula 5 - 28/08/2026
- Terminando a lista de comandos dos slides:

```sql
use EMPRESA;

-- UNION
SELECT P.Projlocal AS 'Local'
FROM PROJETO AS P

UNION

SELECT L.Dlocal AS 'Local'
FROM LOCALIZACAO_DEP AS L;

-- EXCEPT
SELECT F.Cpf, F.Pnome
FROM FUNCIONARIO AS F

EXCEPT

SELECT D.Cpf_gerente, F.Pnome
FROM DEPARTAMENTO AS D

JOIN FUNCIONARIO AS F
ON D.Cpf_gerente = F.Cpf

-- INTERSECT
SELECT Cpf
FROM FUNCIONARIO

INTERSECT

SELECT Cpf_supervisor
FROM FUNCIONARIO

-- GROUP BY
SELECT COUNT(F.Cpf) AS 'Qtd_Cpf', F.Sexo
FROM FUNCIONARIO AS F
GROUP BY F.Sexo;

-- ///
SELECT COUNT(F.Cpf) AS 'Qtd_Cpf', D.Dnome
FROM FUNCIONARIO AS F

JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

GROUP BY D.Dnome;

-- ///
SELECT SUM(F.Salario) AS 'Soma Salario', D.Dnome
FROM FUNCIONARIO AS F

JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

GROUP BY D.Dnome;

-- ///
SELECT AVG(T.Horas) AS 'M Hrs', P.Projnome
FROM TRABALHA_EM AS T

JOIN PROJETO AS P
ON T.Pnr = P.Projnumero

GROUP BY P.Projnome

-- ///
SELECT MAX(F.Salario) AS 'Salario', D.Dnome
FROM FUNCIONARIO AS F

JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

GROUP BY D.Dnome

-- HAVING
SELECT COUNT(F.Cpf) AS 'Func', D.Dnome
FROM FUNCIONARIO AS F

JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

GROUP BY D.Dnome
HAVING COUNT(F.Cpf) > 3;

-- ///
SELECT SUM(T.Horas) AS 'Min Hrs', P.Projnome
FROM TRABALHA_EM AS T

JOIN PROJETO AS P
ON T.Pnr = P.Projnumero

GROUP BY P.Projnome
HAVING SUM(T.Horas) >= 50;

-- EXISTS
SELECT *
FROM DEPARTAMENTO AS D
WHERE EXISTS (
	SELECT 1
	FROM PROJETO, DEPARTAMENTO
	WHERE PROJETO.Dnum = DEPARTAMENTO.Dnumero
);

-- ANY
SELECT F.Salario
FROM FUNCIONARIO AS F

JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

WHERE D.Dnome = 'Administração';

--///
SELECT Pnome, Salario
FROM FUNCIONARIO
WHERE Salario <> ANY (
	SELECT F.Salario
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.DnumerO
	WHERE D.Dnome = 'Administração'
)
```
- Mais alguns comandos:

```sql
--DECLARE
DECLARE --@nome VARCHAR(100),
		@idade INT,
		--@salario DECIMAL(10,2),
		@data DATE;
SET @nome = 'Herysson R. Figueiredo';
SET @idade = 38;
SET @salario = 2400.00;
SET @data = GETDATE();
PRINT 'OLÁ PUTÃO, TEU NOME É: ' + @nome 
	+ ', Idade: ' + CAST(@idade AS VARCHAR(10));
SELECT
	@nome AS 'Nome',
	@idade AS 'Idade',
	@salario AS 'Grana',
	@data AS 'Data de hoje';

-- ///
DECLARE @nomeDpt VARCHAR(20);

SELECT @nomeDpt = Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4

PRINT 'Departamento' + @nomeDpt;

--- /// 
DECLARE @salario DECIMAL(10,2),
		@novo_salario DECIMAL(10,2),
		@nome VARCHAR(100);
SET @nome = 'Jennifer';
SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;
SET @novo_salario = @salario * 1.1;
PRINT 'Salario: ' + CAST(@salario AS VARCHAR(10))
PRINT 'Novo Salario: ' + CAST(@novo_salario AS VARCHAR(10))

-- ///
DECLARE @dataJennifer DATE

SELECT @dataJennifer = Datanasc
FROM FUNCIONARIO
WHERE Pnome = 'Jennifer'

PRINT DATEDIFF(YEAR, @dataJennifer, GETDATE());
```

# Aula 4 - 21/08/2026
- Mais praticas usando o mesmo banco:
```sql
use EMPRESA;

-- IN
SELECT *
FROM FUNCIONARIO 
WHERE Salario IN (25000, 30000);


SELECT F.Pnome, T.Pnr
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE 
	F.Cpf = T.FCpf
	AND F.Pnome != 'Fernando'
	AND T.Pnr IN (
		SELECT Pnr 
		FROM TRABALHA_EM 
		WHERE Fcpf = 
			(SELECT Cpf
			FROM FUNCIONARIO
			WHERE Pnome = 'Fernando')
			)
ORDER BY T.Pnr ASC;


-- BETWEEN
SELECT *
FROM FUNCIONARIO AS F
WHERE 
	F.Dnr = 5
	AND F.Salario BETWEEN 30000 AND 40000;


-- INNER JOIN
SELECT F.PNome, F.UNome, F.Endereco, D.Dnome
FROM FUNCIONARIO AS F

INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

WHERE F.Dnr = 5;


-- Listar os funcionarios que trabalham no desenvolvimento do produto x
SELECT F.Pnome, F.Minicial, F.Unome, T.Horas, P.Projnome
FROM TRABALHA_EM AS T

INNER JOIN PROJETO AS P
ON T.Pnr = P.Projnumero

INNER JOIN FUNCIONARIO AS F
ON T.Fcpf = F.Cpf

WHERE P.Projnome = 'ProdutoX'
ORDER BY T.Horas ASC;


-- Numero do departamento que controla os projetos localizados em Maua
SELECT 
	D.Dnome, 
	P.Projnome, 
	P.Projlocal, 
	D.Cpf_gerente, 
	F.Unome, 
	F.Endereco
FROM DEPARTAMENTO AS D

JOIN PROJETO AS P
ON P.Dnum = D.Dnumero

JOIN FUNCIONARIO AS F
ON F.Cpf = D.Cpf_gerente

WHERE P.Projlocal = 'Mauá';


-- LEFT JOIN
SELECT *
FROM FUNCIONARIO AS F

LEFT JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

SELECT *
FROM DEPARTAMENTO AS D

LEFT JOIN FUNCIONARIO AS F
ON D.Dnumero = F.Dnr

WHERE F.Cpf IS NULL;


-- FULL JOIN
SELECT * 
FROM FUNCIONARIO AS F

FULL JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero

WHERE
	D.Dnumero IS NULL
	OR F.Cpf IS NULL;


-- SELF JOIN
SELECT T1.Pnome, T2.Cpf
FROM FUNCIONARIO AS T1

JOIN FUNCIONARIO AS T2
ON T1.Cpf = T2.Cpf

WHERE T2.Cpf_supervisor IS NOT NULL;

SELECT 
	F.Pnome AS 'Funcionario',
	S.Unome AS 'Supervisor'
FROM FUNCIONARIO AS F

JOIN FUNCIONARIO AS S
ON F.Cpf_supervisor = S.Cpf_supervisor
ORDER BY 'Supervisor';


-- UNION
SELECT 
	F.Pnome AS 'Nome',
	F.Sexo AS 'Sexo',
	F.Datanasc AS 'Data'
FROM FUNCIONARIO AS F

UNION

SELECT 
	D.Nome_dependente AS 'Nome',
	D.Sexo AS 'Sexo',
	D.Datanasc AS 'Data'
FROM DEPENDENTE AS D;
```

# Aula 3 - 14/08/2026
- Banco de dados para atividade: https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/EMPRESA.sql

https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/MICROSOFT.sql

- Práticas SQL usando esse banco:
```sql
-- DISTINCT
SELECT DISTINCT F.Salario
FROM FUNCIONARIO AS F;

SELECT DISTINCT F.Sexo
FROM FUNCIONARIO AS F;

-- WHERE
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Carlos';

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'M' 
AND F.Salario >= 30000;

-- OR
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco LIKE '%São Paulo%'
OR F.Endereco LIKE '%Curitiba%';

-- NOT
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco NOT LIKE '%SP%';

-- ORDER BY
SELECT 
	F.Pnome AS 'Nome',
	F.Unome AS 'Sobrenome',
	F.Salario AS 'Salario',
	(F.Salario + COALESCE(F.Bonus, 0)) * 12 AS 'CustoAnual' 
	-- A função COALESCE no SQL avalia uma lista de valores na 
	-- ordem informada e retorna o primeiro valor não nulo (NOT NULL).
FROM FUNCIONARIO AS F
ORDER BY (F.Salario + COALESCE(F.Bonus,0)) * 12 DESC;

-- NULL
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL

-- TOP - MySQL LIMIT
SELECT TOP 3 *
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC;

-- MIN() MAX()
SELECT 
	MIN(F.Salario) AS 'Menor Salario',
	MAX(F.Salario) AS 'Maior Salario'
FROM FUNCIONARIO AS F;

-- Outro jeito
DECLARE @salario_min DECIMAL(10,2);
SET @salario_min = (SELECT MIN(Salario) FROM FUNCIONARIO);
PRINT @salario_min;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario = @salario_min;

-- COUNT()
SELECT COUNT(F.Cpf) 
FROM FUNCIONARIO AS F;

SELECT COUNT(D.Nome_dependente)
FROM DEPENDENTE AS D;

SELECT
	(SELECT COUNT(F.Cpf) FROM FUNCIONARIO AS F) + 
	(SELECT COUNT(D.Nome_dependente) FROM DEPENDENTE AS D)
	AS 'QtdePessoas';

-- AVG()
SELECT AVG(F.Salario)
FROM FUNCIONARIO AS F

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario < (SELECT AVG(Salario) FROM FUNCIONARIO)
ORDER BY F.Salario ASC;

-- SUM()
SELECT SUM(F.Salario) * 12 AS CustoAnual
FROM FUNCIONARIO AS F;

-- LIKE
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Datanasc LIKE '%72%';
```

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
