# Aula 13 - 30/10/2026
## Restrições de integridade: 
- É a manutenção e garantia de consistência e precisão dos dados, usando-as para atingir a integridade.

- Tipos:
  - Declarativa: Na forma declarativa, as restrições de integridade são parametrizadas durante a criação das estruturas das tabelas, fazendo uso de chaves primárias (PK), impedindo valores não nulos, utilizando tipos e domínios de dados e aplicando regras de    integridade referencial.
  - Procedural: Na forma procedural (também chamadas de restrições semânticas), é possível fazer uso de recursos como gatilhos (triggers), procedimentos armazenados (stored procedures), bem como de afirmações (assertion). Usada com auxílio das regras de negócio passadas pelos clientes.
 
- As cinco principais restrições de Integridade são:
● Integridade de Domínio;
● Integridade Referencial;
● Integridade de Vazio;
● Integridade de Chave;
● Integridade Definida pelo Usuário.

  ● Integridade de Domínio: As restrições de domínio especificam que, dentro de cada tupla, o valor de cada atributo Y deve ser um valor indivisível do domínio dom(Y), ou seja, se um atributo tiver que receber valores dentro de um intervalo pré-estabelecido para um domínio, ele só receberá valores dentro deste intervalo, caso contrário uma mensagem de erro aparecerá para o usuário para que ele possa ajustar os dados antes da entrada no banco de dados.
    - Valores inseridos em uma coluna devem sempre obedecer à definição dos valores que são permitidos para essa coluna – os valores do domínio.
    - Fatores
		● Tipo de Dado do campo;
		● Representação interna do tipo de dado;
		● Presença ou não do dado;
		● Intervalos de valores no domínio;
		● Conjunto de valores discretos.

 ● Integridade Referencial: A restrição de Integridade Referencial assegura que valores de uma coluna em um tabela são válidos baseados nos valores em uma outra tabela relacionada.
    - Se um registro for excluído em uma tabela, então os registros relacionados em outras tabelas que o referenciam talvez precisem ser excluídos. Caso contrário ocorrerá erro. O mesmo se dá com atualização de registros
    - CASCADE: Se um registro for excluído em uma tabela (operações DELETE e TRUNCATE), então os registros relacionados em outras tabelas que o referenciam talvez precisem ser excluídos. Caso contrário ocorrerá erro. O mesmo se dá com a atualização de registros (operação UPDATE). 
	-  on delete cascade;
    -  on update cascade.

● Integridade de Vazio: Este tipo de integridade informa se a coluna é obrigatória ou opcional, ou seja, se é possível não inserir um valor na coluna. Uma coluna de chave primária, por exemplo, sempre deve ter dados inseridos, e nunca pode estar vazia para nenhum registro.

● Integridade de Chave: Os valores inseridos na coluna de chave primária (PK) devem ser sempre únicos, não admitindo-se repetições nesses valores. Desta forma, as tuplas (registros) serão sempre distintas. Os valores de chave primária também não podem ser nulos.

● Integridade Definida pelo Usuário: A integridade definida pelo usuário permite definir regras comerciais que não se encaixam em outras categorias de integridade. Todas as categorias de integridade oferecem suporte à integridade definida pelo usuário.
  - Esta integridade se refere a regras de negócio específicas que são definidas pelo usuário do banco de dados. Por exemplo, pode-se definir que uma coluna aceitará um conjunto restrito de valores.

# Aula 12 - 23/10/2026
- Novo banco: [Link do banco](https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/EMPRESA_2026.sql)

## Trigger 
 - Regras que especificam ações que são automaticamente disparadas por certos eventos.
 - Executado automaticamente quando um usuário realiza uma operação de modificação de dados.
 - Disparados apenas por eventos com INSERT, UPDATE ou DELETE

   ### Modo de uso:
   - AFTER: O código presente no trigger é executado após todas as ações na tabela terem sido completas
   - INSTEAD OF: O código presente no trigger é executado no lugar de operação que causou seu disparo
  
```sql
CREATE OR ALTER TRIGGER trg_after_insert_dpt
ON DEPARTAMENTO
AFTER INSERT
AS
BEGIN
	DECLARE @nome VARCHAR(40);
	SELECT @nome = I.Dnome
	FROM inserted AS I;

	PRINT 'Foi inserido um novo departamento: ' + @nome;
END;
GO

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES(88,'Expedição')
GO;

CREATE TRIGGER trg_insetadof_delete_dpt
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'NÃO DELETEI o registro';
END

DELETE 
FROM DEPARTAMENTO
WHERE Dnumero = 88

ALTER TABLE DEPARTAMENTO
DISABLE TRIGGER trg_insetadof_delete_dpt;

EXEC sp_helptrigger DEPARTAMENTO;
GO;
DROP TRIGGER trg_after_insert_dpt;

--TRIGGER para nçao permitir nomes duplicados em DEPARTAMENTO
CREATE TRIGGER trg_insteadof_insert_dpt
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @nome VARCHAR(40), @numero INT;
	--Atribuir a variavel @nome o valor que esta no insert
	SELECT @nome = I.Dnome, @numero = Dnumero FROM inserted AS I
	IF EXISTS(SELECT 1 FROM DEPARTAMENTO WHERE DNome = @nome)
		RAISERROR('Já existe um departamento com esse nome', 16, 1)
	ELSE
		INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
		SELECT I.Dnumero, I.Dnome, I.Cpf_gerente, I.Data_inicio_gerente
		FROM inserted AS I
END
GO;

DROP TRIGGER trg_insteadof_insert_dpt

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES (100, 'Vendas')
GO;

CREATE OR ALTER TRIGGER trg_insteadof_insert_dpt
ON DEPARTAMENTO
AFTER INSERT 
AS
BEGIN
	DECLARE @nome VARCHAR(40), @numero INT;

	SELECT @nome = I.Dnome, @numero = Dnumero 
	FROM inserted AS I

	SELECT * FROM DEPARTAMENTO;

	IF ((SELECT COUNT (Dnome) FROM DEPARTAMENTO WHERE Dnome = @nome) > 1)
	BEGIN	
		ROLLBACK TRANSACTION;
		RAISERROR ('Já existe um departamento com esse nome', 16, 1)
	END
END
GO;

--Função UPDATE()
--Verificar se um nome ja foi alterado
CREATE TRIGGER trg_for_update_nome
ON DEPARTAMENTO
FOR UPDATE -- FOR = AFTER
AS
BEGIN
	DECLARE @nome_antigo VARCHAR(40),
			@nome_novo VARCHAR(40);
	SELECT @nome_antigo = D.Dnome FROM deleted AS D;
	SELECT @nome_novo = I.Dnome FROM inserted AS I; 
	IF UPDATE(Dnome)
	BEGIN
		PRINT 'O nome era: ' + @nome_antigo;
		PRINT 'O novo nome é: ' + @nome_novo;
	END
	ELSE
		PRINT 'O nome não foi alterado';
END

UPDATE DEPARTAMENTO
SET Dnome = 'Tecnologia'
WHERE Dnome = 'TI';

UPDATE DEPARTAMENTO
SET Dnumero = 9
WHERE Dnome = 'Estoque';

SELECT * FROM DEPARTAMENTO
GO;
DROP TRIGGER trg_for_update_nome


CREATE TABLE LOG_FUNCIONARIO(
	log_id INT IDENTITY(100,1) PRIMARY KEY,
	cpf CHAR(11),
	operacao VARCHAR(10),
	data_hora DATETIME DEFAULT GETDATE()
)

-- TRIGGER de log de insert
CREATE TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO
FOR UPDATE
AS 
BEGIN
	INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
	SELECT I.Cpf, 'INSERT'
	FROM inserted AS I
END
GO

CREATE TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO
FOR UPDATE
AS 
BEGIN
	INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
	SELECT D.Cpf, 'DELETE'
	FROM deleted AS D
END

INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, dnr)
VALUES ('Juca', 'Da Silva', '4568790', '2015-06-08', 'Rua Sete', 'M', 1100, 0, '2026-10-23', 10);

SELECT * FROM FUNCIONARIO ORDER BY Pnome;
SELECT * FROM LOG_FUNCIONARIO;

UPDATE FUNCIONARIO
SET Salario = 100
WHERE Cpf = '4568790';

DELETE FROM FUNCIONARIO
WHERE Cpf = '4568790';

CREATE TRIGGER trg_for_IDU_funcionario
ON FUNCIONARIO
FOR INSERT, DELETE, UPDATE
AS 
BEGIN
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS((SELECT * FROM deleted))
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT I.Cpf, 'UPDATE'
			FROM inserted AS I
		ELSE	
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT I.Cpf, 'INSERT'
			FROM inserted AS I
		END
		ELSE
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT D.Cpf, 'DELETE'
			FROM deleted AS D
END
GO

-- VIEW
CREATE VIEW vw_rh_funcionario_dpt
AS
SELECT 
	CONCAT(Pnome, ' ', Minicial, '. ', Unome) AS 'Nome',
	DATEDIFF(YEAR, Datanasc, GETDATE()) AS 'Idade',
	Endereco AS 'Endereço',
	Data_Admissao AS 'Admissão',
	D.Dnome AS 'Departamento'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;

SELECT * FROM vw_rh_funcionario_dpt
WHERE DEPARTAMENTO = 'Matriz';
```
<img width="867" height="453" alt="image" src="https://github.com/user-attachments/assets/755a2059-e039-45bd-93b5-db1850fd5ea7" />


# Aula 11 - 09/10/2026

## Transaction 

- Uma transação é um conjunto de operações que são tratadas como uma única unidade de trabalho (inserções, atualizações...)
- Uma transação precisa ser completamente concluída ou revertida para garantir que o banco de dados permaneça em um estado constante
- Principal objetivo da transação é garantir a integridade e consistência dos dados, mesmo diante de falhas, como erros no sistema ou interrupções inesperadas

## ACID 

- Atomicidade: garante que uma transação é tratada como uma única unidade, o que significa que ela deve ser completamente concluída ou totalmente desfeita. Se uma parte falhar, todo o resto também falha.
- Isolamento: garante que as transações sejam executadas de forma isolada, sem que as operações de uma transação afetem as operações de outra. O nível de isolamento pode variar, afetando a visibilidade das mudanças feitas por transações concorrentes.
- Consistência: garante que uma transação leve o banco de dados de um estado válido para outro estado válido, respeitando todas as regras definidas.
- Durabilidade: garante que, uma vez que uma transação é confirmada (committed), ela permanecerá no banco de dados, mesmo que ocorra uma falha no sistema. Os dados serão persistidos no armazenamento

- BEGIN TRANSACTION: Inicia uma nova transação
- COMMIT TRANSACTION: Confirma a transação, aplicando permanentemente todas as operações feitas no banco de dados
- ROLLBACK TRANSACTION: Desfaz todas as operações realizadas desde o início da transação
- SAVEPOINT: Define um ponto dentro de uma transação para permitir um rollback parcial, até esse ponto

```sql
CREATE DATABASE CAIXA;

USE CAIXA;

--Criação da nossa tabela
CREATE TABLE conta(
	id INT PRIMARY KEY,
	Nome VARCHAR(50),
	Saldo MONEY
);

INSERT INTO CONTA
VALUES (10, 'Maria', 500),
	   (20, 'João', 1500),
	   (30, 'Paulo', 30000),
	   (40, 'Maria', 50000);
GO;

-- Primeira transação	
BEGIN TRAN;
DECLARE @erro INT = 0;

INSERT INTO CONTA
VALUES (50, 'Pedro', 50);
SET @erro = @erro+ @@ERROR

INSERT INTO CONTA
VALUES (10, 'Judas', 666);
SET @erro = @erro+ @@ERROR
SELECT * FROM CONTA;

IF @erro <> 0
BEGIN
	PRINT 'Transação revertida;'
	ROLLBACK TRAN;
END 
ELSE
BEGIN
	PRINT 'Transação realizada com sucesso!'
	COMMIT TRAN;
END

SELECT * FROM CONTA
GO;

BEGIN TRAN;
UPDATE conta
SET Saldo = Saldo + 10000
WHERE Nome = 'Maria';

IF @@ROWCOUNT <> 1
BEGIN
	SELECT * FROM conta;
	ROLLBACK TRAN;
END
ELSE
	COMMIT TRAN;
GO;

-- Transferir dinheiro de uma pessoa para outra

CREATE OR ALTER PROCEDURE sp_pix
    (@id_origem INT, @id_destino INT, @Valor MONEY)
AS
BEGIN
    BEGIN TRANSACTION;

    DECLARE @Saldo MONEY;

    SELECT @Saldo = Saldo
    FROM conta
    WHERE id = @id_origem;

    IF (@Saldo < @Valor OR @Valor <= 0)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Erro no pix';
    END
    ELSE
    BEGIN
        UPDATE conta
        SET Saldo = Saldo - @Valor
        WHERE id = @id_origem;

        UPDATE conta
        SET Saldo = Saldo + @Valor
        WHERE id = @id_destino;

        COMMIT TRANSACTION;
        PRINT 'Pix realizado';
    END

    SELECT * FROM conta;
END;
GO

EXEC sp_pix 10, 20, 500;

-- Save point
BEGIN TRAN;
INSERT INTO conta
VALUES (50, 'Pedro', 50)

-- Save POINT
SAVE TRAN pedroOK
INSERT INTO conta
VALUES (10, 'Juca', -200);

IF @@ERROR <> 0
BEGIN
    ROLLBACK TRAN pedroOK
    COMMIT TRAN;
    PRINT 'Voltamos para o save point';
END
ELSE
    COMMIT TRAN;
GO

-- TRY CATCH
BEGIN TRY
   PRINT 'Olá TRY CATCH!'
   SELECT 1/0; -- erro;
   PRINT 'Não CHEGUEI AQUI!'
END TRY
BEGIN CATCH
    PRINT 'DEU ERRO!'
    PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();               
END CATCH

-- TRANSACTION + TRY CATCH
BEGIN TRAN;
    BEGIN TRY
        INSERT INTO conta
        VALUES (60, 'Mateus', 15)
        SELECT * FROM conta

        INSERT INTO conta
        VALUES (10, 'Juca', -200);

        COMMIT TRAN;
        SELECT * FROM conta
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        PRINT 'DEU ERRO!'
        PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();    
    END CATCH
SELECT * FROM conta;
GO

-- Inserir um novo usuário no banco (não permita nomes duplicados)
DELETE 
FROM conta
WHERE id= '40';

GO
CREATE OR ALTER PROCEDURE sp_Inserir
    (@id INT, @Nome VARCHAR(50), @Saldo MONEY)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM conta WHERE Nome = @Nome)
        BEGIN
            INSERT INTO conta (id, Nome, Saldo)
            VALUES (@id, @Nome, @Saldo);

            COMMIT TRANSACTION;
            PRINT 'Usuário inserido com sucesso!';
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Erro: já existe um usuário com esse nome.';
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT 'Número do erro: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Mensagem de erro: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
EXEC sp_Inserir 100, 'Bruno', 10000;
SELECT * FROM conta;
```

# Aula 7 - 11/09/2026
```sql
--FUNCTION

CREATE FUNCTION fn_dobro (@Numero INT)
RETURNS INT
AS
BEGIN
	RETURN @Numero * 2;
END;
GO

SELECT dbo.fn_dobro(250) AS Resultado;

SELECT 
	Pnome,
	Unome,
	F.Salario,
	CAST(dbo.fn_dobro(F.Salario) AS DECIMAL (10,2)) AS 'Dobro'
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Maria';

--////
DECLARE @menor_salario DECIMAL(10,2);

SELECT @menor_salario = MIN(Salario)
FROM FUNCIONARIO;

SELECT 
	Pnome,
	Unome,
	F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario > dbo.fn_dobro(@menor_salario);

--////
CREATE FUNCTION fn_idade (@dataNascimento DATE)
RETURNS INT
AS 
BEGIN
	DECLARE @idade INT

	SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE());

	IF DATEADD(YEAR, @idade, @dataNascimento) > CAST(GETDATE() AS DATE)
	BEGIN
		SET @idade = @idade -1;
	END;

	RETURN @idade;
END;
GO

SELECT Pnome,
	   Unome,
	   F.Salario,
	   dbo.fn_idade(F.Datanasc) AS idade
FROM FUNCIONARIO AS F;

--////
CREATE FUNCTION fn_TipoDepartamento (@Departamento VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT F.*
	FROM FUNCIONARIO AS F

	LEFT JOIN DEPARTAMENTO AS D
	ON D.Dnumero = F.Dnr

	WHERE D.Dnome = @Departamento
);
GO

SELECT *
FROM dbo.fn_TipoDepartamento('Administração');

--////
CREATE FUNCTION fn_salarioAnual()
RETURNS @SalAno TABLE
(
	nome_comp VARCHAR(100),
	salario DECIMAL(10,2),
	salario_anual DECIMAL(10,2)
)
AS 
BEGIN
	INSERT INTO @SalAno
	SELECT
		CONCAT(F.Pnome, ' ', F.Minicial, ' ', F.Unome),
		F.Salario,
		F.Salario * 13 + (F.Salario * 0.3)
	FROM FUNCIONARIO AS F;

	RETURN;
END
GO

SELECT * FROM dbo.fn_salarioAnual();

CREATE PROCEDURE sp_exibe_meu_nome
AS
BEGIN
	PRINT 'Guilherme Gonsalves';
END
GO;

EXEC sp_exibe_meu_nome;

--////
CREATE PROCEDURE sp_aumento(@porcentagem DECIMAL(3,1))
AS
BEGIN
	UPDATE FUNCIONARIO
	SET Salario = Salario * (1+(@porcentagem)/100)
END
GO
EXEC dbo.sp_aumento @porcentagem = 5;

SELECT * FROM FUNCIONARIO;

EXEC sp_help funcionario;

--////
CREATE PROCEDURE sp_funcionarios
WITH ENCRYPTION
AS
SELECT * FROM FUNCIONARIO;
GO
EXEC sp_help sp_funcionarios;

--////
CREATE PROCEDURE sp_dptLocalidade(@Departamento VARCHAR(50), @Localidade VARCHAR(100))
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM DEPARTAMENTO
		WHERE Dnome = @Departamento
		)
	BEGIN
		PRINT 'O departamento ja existe'
	END
	
	ELSE
	BEGIN
		DECLARE @id_dpt INT, @id_loc INT;
		SELECT @id_dpt = MAX(Dnumero)
		FROM DEPARTAMENTO

		INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
		VALUES (@id_dpt + 1, @Localidade)

		INSERT INTO LOCALIZACAO_DEP(Dnumero, Dlocal)
		VALUES (@id_dpt + 1, @Localidade)

		PRINT @Depatamento + 'inserido com sucesso';
		PRINT @Localidade + 'inserido com sucesso';
	END
END
GO

EXEC sp_dptLocalidade 'Compras', 'Santa Maria';
```

# Aula 6 - 04/09/2026
```sql
-- CAST
GO;
--DECLARE @nome VARCHAR(100),
		@salario DECIMAL(10,2);
SET @nome = 'Jennifer';
SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'O Funcionário(a) ' 
	   + @nome 
	   +' tem um salário de: R$ '
	   + CAST(@salario AS  VARCHAR(10));
GO;

-- CONVERT
--DECLARE @dataNasc DATE;
--DECLARE @nome VARCHAR(100)
SET @nome = 'Jennifer'

SELECT @dataNasc = Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

SELECT CONVERT(VARCHAR(10), @dataNasc, 103) AS DataNascimento;

-- IF/ELSE
--DECLARE @nome VARCHAR(100)
DECLARE @salario DECIMAL(10,2)
DECLARE @salarioMedio DECIMAL(10,2)
SET @nome = 'Jennifer'

SELECT @salarioMedio = AVG(Salario)
FROM FUNCIONARIO;

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE @nome = Pnome;

IF(@salario < @salarioMedio)
	BEGIN
	PRINT 'O funcionário(a) '
	+ @nome
	+ ' ganha um salario de R$ '
	+ CAST(@salario AS VARCHAR(100))
	+ ' e ele esta abaixo da média de R$ '
	+ CAST(@salarioMedio AS VARCHAR(100));
	END
ELSE
	BEGIN
	PRINT 'O funcionário(a) '
	+ @nome
	+ ' ganha um salario de R$ '
	+ CAST(@salario AS VARCHAR(100))
	+ ' e ele esta acima da média de R$ '
	+ CAST(@salarioMedio AS VARCHAR(100));
	END;

-- ////////
DECLARE @anoAtual INT,
		@anoNasc INT,
		--@nome VARCHAR(100),
		--@idade INT;
SET @nome = 'Jennifer';
SET @anoAtual = YEAR(GETDATE());

SELECT @anoNasc = YEAR(Datanasc)
FROM FUNCIONARIO
WHERE @nome = Pnome;
SET @idade =@anoAtual - @anoNasc;

IF(@idade <= 55)
	BEGIN
	PRINT @nome + ' tem ' 
		+ CAST(@idade AS VARCHAR(100))  
		+ 'e está longe da aposentadoria'
	END
ELSE IF(@idade > 55 AND @idade <= 60)
	BEGIN
	PRINT @nome + ' tem ' 
		+ CAST(@idade AS VARCHAR(100))  
		+ 'e está próximo da aposentadoria'
	END
ELSE
	BEGIN
	PRINT @nome + ' tem ' 
		+ CAST(@idade AS VARCHAR(100)) 
		+ 'anos e passou da aposentadoria'
	END;

--////
DECLARE @dataNasc DATE,
		@nome VARCHAR(100),
		@idade INT;
SET @nome = 'Fernando';

SELECT @dataNasc = Datanasc
FROM FUNCIONARIO
WHERE Pnome = @nome

IF(MONTH(GETDATE()) < MONTH(@dataNasc))
	SET @idade = DATEDIFF(YEAR, @dataNasc, GETDATE()) -1
ELSE IF (MONTH(GETDATE()) = MONTH(@dataNasc)) AND DAY(@dataNasc) < DAY(GETDATE())
	SET @idade = DATEDIFF(YEAR, @dataNasc, GETDATE()) - 1
ELSE
	SET @idade = DATEDIFF(YEAR, @dataNasc, GETDATE());
	
PRINT @dataNasc
PRINT @idade

--IIF
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	IIF(F.Salario < 20000, 'Salario baixo', 'Salario alto') AS 'Categoria'
FROM FUNCIONARIO AS F;

-- CASE
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	CASE
		WHEN F.Salario <= 10000 AND F.Salario > 0 THEN 'Baixo'
		WHEN F.Salario > 10000 AND F.Salario <= 30000 THEN 'Medio'
		WHEN F.Salario > 30000 THEN 'Alto'
		ELSE 'ERRO'
	END AS 'Categoria'

FROM FUNCIONARIO AS F;

-- WHILE
DECLARE @contador INT = 0;

WHILE @contador < 10
BEGIN
	SET @contador = @contador + 1
	IF @contador % 2 = 0
		CONTINUE
	PRINT 'Contador' + CAST(@contador AS VARCHAR(3));
END

-- CURSORES
DECLARE @name VARCHAR(50);

DECLARE cursorFuncionario CURSOR FOR
SELECT Pnome FROM FUNCIONARIO;
```

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
