-- Questao 01: Liste o total de clientes em ordem crescente de idade.

SELECT *                
FROM CLIENTE
ORDER BY data_nasc DESC


-- Questao 02: Crie uma view que liste os clientes de forma crescente pelo numero de produtos comprados.

CREATE view lista_cliente_qtdProd AS
SELECT c.cpf FROM VENDA v INNER JOIN PRODUTO p ON p.id = v.id_produto
INNER JOIN QUARTO q ON q.numero = v.numero_quarto
INNER JOIN HOSPEDA h ON h.NUMERO_QUARTO = q.numero
INNER JOIN CLIENTE c ON c.cpf = h.CPF_CLIENTE
WHERE v.data <= h.DIA_CHECK_OUT AND v.data >= h.DIA_CHECK_IN
GROUP BY c.cpf
ORDER BY SUM(v.QUANTIDADE);


-- Questao 03: Crie uma view que liste os produtos do tipo bar ou restaurante que possuem valor entre 
-- R$ 50,00 e R$ 100,00.

CREATE VIEW ProdutosBarOuRestaurante
AS SELECT *
FROM PRODUTO
WHERE tipo IN ('bar', 'restaurante')
AND valor BETWEEN 50 AND 100;


-- Questao 04: Liste todos os funcionários com função de técnico, em ordem crescente pelo nome, e pelo salário.

SELECT f.nome, f.salario 
FROM FUNCIONARIO f 
WHERE f.funcao = 'Técnico' 
ORDER BY f.nome, f.salario;


-- Questao 05: Qual a maior venda que um quarto realizou em dezembro de 2018?

SELECT v.ID_VENDA
FROM VENDA v, PRODUTO p
WHERE v.ID_PRODUTO = p.ID and
      (v.QUANTIDADE * p.VALOR) = (SELECT MAX(v1.QUANTIDADE * p1.VALOR) as VALOR_DA_VENDA
                                 FROM VENDA v1, PRODUTO p1
                                 WHERE v1.ID_PRODUTO = p1.ID
                                 and v1.data between TO_DATE('12-01-2018', 'MM-DD-YYYY') and TO_DATE('12-31-2018', 'MM-DD-YYYY'))
      and v.data between TO_DATE('12-01-2018', 'MM-DD-YYYY') and TO_DATE('12-31-2018', 'MM-DD-YYYY')
      

-- Questao 06: Quais quartos nao possuem equipamento de ar-condicionado ou de frigobar?
-- O atributo equipamento da tabela EQUIPAMENTO possui tamanho maximo de 14 caracteres, enquanto que  
-- a string 'ar-condicionado' possui 15, por isso a consulta procura por 'arcondicionado'

SELECT q.numero
FROM Quarto q
WHERE 'frigobar' NOT IN (SELECT e.equipamento
       FROM EQUIPAMENTO e
       WHERE q.numero = e.numero_quarto) AND
      'arcondicionado' NOT IN (SELECT e.equipamento
       FROM EQUIPAMENTO e
       WHERE q.numero = e.numero_quarto) 
       

-- Questao 07: Quais funcionarios deram manutencao em mais de dois quartos?

SELECT f.cpf FROM FUNCIONARIO f INNER JOIN
MANUTENCAO m ON m.CPF_FUNCIONARIO = f.cpf
GROUP BY cpf
HAVING COUNT(*) > 2;


-- Questao 08: Quais quartos possuem mais de 3 equipamentos iguais?
-- Assumimos que todos os equipamentos tem o padrao: nome_equipamento + numero (ex: 'frigobar 1', 'frigobar 2', etc.)

SELECT numero_quarto,
COUNT(*)
FROM EQUIPAMENTO
WHERE equipamento LIKE "TV%";


-- Questao 09: Quais clientes que possuem nenhum dependente associado?

SELECT * 
FROM CLIENTE c 
WHERE NOT EXISTS(SELECT * FROM DEPENDENTE d WHERE d.cpf_cliente = c.cpf);


-- Questao 10: Qual o cliente consumiu mais produtos do tipo lavadeira?

-- Visao Auxiliar definida localmente com WITH: permite ter, em cada tupla, a informacao do cpf do cliente e a qnt. 
-- de produtos do tipo 'lavadeira' que ele consumiu

WITH auxiliar(cpf, qnt_lavadeira) AS
     (SELECT c.CPF, COUNT(p.ID) as NumeroProdutosTipoLavadeira
     FROM Cliente c, Hospeda h, Quarto q, Venda v, Produto p
     WHERE c.CPF = h.CPF_CLIENTE and h.NUMERO_QUARTO = q.NUMERO and q.NUMERO = v.NUMERO_QUARTO and v.ID_PRODUTO = p.ID
           and p.tipo LIKE '%lavadeira%'
     GROUP BY c.CPF)
SELECT a.cpf
FROM auxiliar a
WHERE a.qnt_lavadeira = (SELECT MAX(qnt_lavadeira)
                        FROM auxiliar)

-- Questao 11: Para cada quarto, obter o numero do quarto, valor da diaria e o valor total de produtos vendidos por este mesmo quarto.

SELECT q.numero, q.valor_diaria, SUM(v.quantidade * p.valor)
FROM QUARTO q INNER JOIN VENDA v ON v.numero_quarto = q.numero INNER JOIN PRODUTO p ON v.id_produto = p.id 
GROUP BY q.numero, q.valor_diaria


-- Questao 12: Liste todos os quartos juntamente com os seus respectivos equipamentos associados.

SELECT q.numero , e.equipamento 
FROM QUARTO q LEFT JOIN EQUIPAMENTO e ON e.numero_quarto = q.numero;


-- Questao 13: Modifique a tabela FUNCIONARIO, adicionando uma restrição de integridade que valide se a 
-- coluna CPF está no formato "xxx.xxx.xxx-xx", onde cada “x” é um dígito de 0 a 9.

ALTER TABLE FUNCIONARIO
ADD( CONSTRAINT formato_cpf
CHECK( REGEXP_LIKE(cpf, '^([0-9]{3}).?([0-9]{3}).?([0-9]{3})-?([0-9]{2})$')));


-- Questao 14: Faca um trigger que impeça que um produto seja inserido ou atualizado se seu valor ultrapassar R$ 500,00.

CREATE OR REPLACE TRIGGER trCheckProduto 
AFTER INSERT OR UPDATE ON Produto 
FOR EACH ROW
BEGIN
    IF (:NEW.valor > 500.0) THEN
       RAISE_APPLICATION_ERROR(-20000, 'Valor maior que 500,00');
    END IF;
END;


-- Questao 15: Faça um trigger que so permite reserva de um quarto se ele for do tipo simples e
-- com vista lateral.

CREATE OR REPLACE TRIGGER trCheckReserva 
AFTER INSERT ON Reserva
FOR EACH ROW

DECLARE 
    found INT := 0;
BEGIN
    FOR qto IN (SELECT * FROM Quarto WHERE (TIPO LIKE '%simples%' and VISTA LIKE '%lateral%'))
    LOOP
        IF (:NEW.numero_quarto LIKE qto.numero) THEN 
            found := 1;
        END IF;
    END LOOP;
    IF (FOUND = 0) THEN
        RAISE_APPLICATION_ERROR(-20000, 'So pode reservar quarto tipo simples e vista lateral');
    END IF;
END;


-- Questao 16: Crie uma stored procedure chamada atualizaPrecosProdutosByTipo que deve atualizar os preços de
-- todos os produtos de um tipo informado como parametro da procedure aplicando um desconto ou aumento informado
-- como parametro da procedure, eh obrigatorio o uso de CURSOR. Coloque no script também o codigo de como executar a procedure.

CREATE or replace procedure atualizaPrecosProdutosByTipo(
            prod_tipo in produto.tipo%TYPE,
            desc_valor in produto.valor%TYPE
   
    ) as 
      
   BEGIN 
     
     declare 
    
    cursor att_preco is select * from produto where produto.tipo = prod_tipo;
    res att_preco%rowtype;
    desconto produto.valor%TYPE;
    
    begin
       open att_preco;
       
       loop
       
       fetch att_preco into res;
       exit when att_preco%NOTFOUND;
       desconto := res.valor + (desc_valor*res.valor);
   
       update produto set valor = desconto
        where id = res.id;
        
       END LOOP;
       close att_preco;
       commit;
       
     end;
   
   END;
   
-- para um desconto o numero deve ser negativo , para um aumento o numero deve ser possitivo , exemplo abaixo , desconto de 10 %

begin 
 ATUALIZAPRECOSPRODUTOSBYTIPO('restaurante', -0.1);
end;


-- Questao 17: Crie uma stored procedure chamada getQuartosVagos que deve listar todos os quartos que estão vagos no hotel 
-- no momento de sua execução. Coloque no script também o código de como executar a procedure.

create PROCEDURE getQuartosVagos(c1 OUT SYS_REFCURSOR)
AS
BEGIN
 OPEN c1 FOR
 select * from quarto q where not exists
   (select * from hospeda h, reserva r where (h.numero_quarto = q.numero and TO_DATE('24/06/2019', 
   'DD/MM/YYYY') between h.DIA_CHECK_IN and h.DIA_CHECK_OUT) or (r.numero_quarto = q.numero and 
   TO_DATE('24/06/2019', 'DD/MM/YYYY') between r.DIA_CHECK_IN and r.DIA_CHECK_OUT));

END c1;
