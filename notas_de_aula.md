# Aula 2 - 07/08/2026
- Praticamos os comandos básicos de sql: https://github.com/JuuJaoBRzao/Implementacao_Banco_Dados/blob/main/Exemplos_Aula/Exemplo_1.sql

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
