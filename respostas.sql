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
