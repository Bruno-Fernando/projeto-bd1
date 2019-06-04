CREATE TABLE Cliente(
    cpf CHAR(11) NOT NULL PRIMARY KEY,
    email VARCHAR(100),
    endereco VARCHER(100),
    data_nascimento DATE,
    sexo CHAR(1),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Telefone(
    cpf_cli CHAR(11),
    tel_number VARCHAR(20),
    PRIMARY KEY(cpf_cli, tel_number),
    FOREIGN KEY(cpf_cli) REFERENCES Cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE Avaliacao(
    id NUMBER NOT NULL PRIMARY KEY,
    nota CHAR(3),
    data DATE,
    comentario VARCHAR(500)
);

CREATE TABLE Funcionario(
    cpf CHAR(11) NOT NULL PRIMARY KEY,
    data_nascimento DATE,
    nome VARCHAR(50) NOT NULL,
    salario NUMBER(9,2),
    funcao VARCHAR(50)
);

CREATE TABLE Quarto(
    numero NUMBER NOT NULL PRIMARY KEY, 
    valor_diaria NUMERIC(9,2),
    tipo VARCHAR(20),
    vista VARCHAR(20)
);

CREATE TABLE Equipamento(
    numero_quarto NUMBER,
    equipamento VARCHAR(20),
    PRIMARY KEY(numero_quarto, equipamento),
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE CASCADE
);

CREATE TABLE Produto(
    id NUMBER NOT NULL PRIMARY KEY,
    tipo VARCHAR(50),
    nome VARCHAR(50) NOT NULL,
    valor NUMBER(9,2) NOT NULL,
    descricao VARCHAR(200)
);

CREATE TABLE Dependente(
    cpf CHAR(11) NOT NULL PRIMARY KEY,
    data_nascimento DATE,
    nome VARCHAR(50) NOT NULL,
    FOREIGN KEY(cpf_dependente) REFERENCES Dependente(cpf) ON DELETE CASCADE
);