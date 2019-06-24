-- Questão 2
create view lista_cliente_qtdProd as
select c.cpf from venda v inner join produto p on p.id = v.id_produto
inner join quarto q on q.numero = v.numero_quarto
inner join hospeda h on h.NUMERO_QUARTO = q.numero
inner join cliente c on c.cpf = h.CPF_CLIENTE
where v.data <= h.DIA_CHECK_OUT and v.data >= h.DIA_CHECK_IN
group by c.cpf
order by sum(v.QUANTIDADE)

-- Questão 7
select f.cpf from FUNCIONARIO f inner join
MANUTENCAO m on m.CPF_FUNCIONARIO = f.cpf
group by cpf
having count(*)>2

--Questão 12
select q.numero , e.equipamento from quarto q left join
equipamento e on e.numero_quarto = q.numero


--Questão 16
create or replace procedure atualizaPrecosProdutosByTipo(
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
  
