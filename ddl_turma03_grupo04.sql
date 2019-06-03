CREATE TABLE Cliente (
    cpf CHAR(11) NOT NULL PRIMARY KEY,
    email VARCHAR(100),
    endereco VARCHAR(100),
    data_nascimento DATE,
    sexo CHAR(1),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Telefone (
    cpf_cli CHAR(11),
    tel_number VARCHAR(20),
    PRIMARY KEY(cpf_cli, tel_number),
    FOREIGN KEY(cpf_cli) REFERENCES Cliente(cpf) ON DELETE CASCADE
);