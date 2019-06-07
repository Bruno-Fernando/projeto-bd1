CREATE TABLE Cliente(
    cpf CHAR(11) PRIMARY KEY,
    email VARCHAR(100),
    endereco VARCHAR(100),
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
    id NUMBER PRIMARY KEY,
    cpf_cliente CHAR(11) UNIQUE,
    nota INT,
    data DATE,
    comentario VARCHAR(500),
    FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf) ON DELETE CASCADE,
    CHECK (nota between 0 and 100)
);

CREATE TABLE Funcionario(
    cpf CHAR(11) PRIMARY KEY,
    data_nascimento DATE,
    nome VARCHAR(50) NOT NULL,
    salario NUMBER,
    funcao VARCHAR(50),
    CHECK (salario >= 0)
);

CREATE TABLE Quarto(
    numero INT PRIMARY KEY, 
    valor_diaria NUMBER,
    tipo VARCHAR(20),
    vista VARCHAR(20)
);

CREATE TABLE Equipamento(
    numero_quarto INT,
    equipamento VARCHAR(20),
    PRIMARY KEY(numero_quarto, equipamento),
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE SET NULL
);

CREATE TABLE Produto(
    id INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    valor NUMBER NOT NULL,
    descricao VARCHAR(200)
);

CREATE TABLE Dependente(
    cpf_dependente CHAR(11),
    cpf_cliente CHAR(11),
    data_nascimento DATE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    PRIMARY KEY(cpf_dependente, cpf_cliente),
    FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE Quarto_Vende_Produto(
    numero_quarto INT,
    id_produto INT,
    data DATE NOT NULL,
    quantidade INT,
    PRIMARY KEY(numero_quarto, id_produto),
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE CASCADE, 
    FOREIGN KEY(id_produto) REFERENCES Produto(id) ON DELETE CASCADE    
);

CREATE TABLE Funcionario_Mantem_Quarto(
    cpf_funcionario CHAR(11), 
    numero_quarto INT,
    data DATE NOT NULL,
    tipo CHAR(20),
    observacao CHAR(100),
    PRIMARY KEY(cpf_funcionario, numero_quarto),
    FOREIGN KEY(cpf_funcionario) REFERENCES Funcionario(cpf) ON DELETE CASCADE, 
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE CASCADE       
);

CREATE TABLE Cliente_Reserva_Quarto(
    cpf_cliente CHAR(11),
    numero_quarto INT,
    dia_checkin DATE NOT NULL,
    dia_checkout DATE NOT NULL,
    PRIMARY KEY(cpf_cliente, numero_quarto),
    FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf) ON DELETE CASCADE, 
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE CASCADE       
);

CREATE TABLE Quarto_Hospeda_Cliente(
    numero_quarto INT,
    cpf_cliente CHAR(11),
    dia_checkin DATE NOT NULL,
    dia_checkout DATE NOT NULL,
    PRIMARY KEY(numero_quarto, cpf_cliente),
    FOREIGN KEY(numero_quarto) REFERENCES Quarto(numero) ON DELETE CASCADE,
    FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf) ON DELETE CASCADE          
);
