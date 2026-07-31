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

    - CREATE TABLE Funcionario (
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

