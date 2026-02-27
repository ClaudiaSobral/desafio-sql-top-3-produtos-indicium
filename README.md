# desafio-sql-top-3-produtos-indicium
Repositório criado como parte do curso preparatório para Lighthouse, onde o participante deveria utilizar SQL para achar as 3 categorias que mais vendem em uma empresa


## Objetivo
Achar através de query em PostgreSQL as três categorias de produtos que mais faturam dentro de uma empresa, a ficcional ["Northwind Traders"](https://dbdocs.io/akweiwonder3/Northwind-Database).

Projeto realizado com a base de dados clássica Northwind, amplamente utilizada para fins educacionais e prática de SQL.

Tabelas envolvidas:

order_details

products

categories

## Estratégia de Análise

A consulta foi construída em múltiplas etapas:

Agregação das vendas por produto

Cálculo do total considerando:

Preço unitário

Quantidade vendida

Desconto aplicado

Associação do produto à sua categoria

Soma do total por categoria

Ordenação decrescente

Limitação para as 3 categorias com maior valor total

## 📈 Resultado

|nome_categoria|total_categoria|
|--------------|---------------|
|Beverages|272967.95|
|Dairy Products|239732.23|
|Meat/Poultry|173313.40|


A consulta retorna:

Nome da categoria

Total acumulado de vendas

Ordenado da maior para a menor

Limitado às 3 categorias mais relevantes

## ✏️ Query
```select
	categorias.category_name as nome_categoria,
	sum(ranking_produtos.total) as total_categoria
from
	(select 
		sum((round((cast(((preco_unidades - desconto) * quantidade) as decimal)), 2))) as total,
		tabela_pedidos.nome,
		tabela_pedidos.id_produto,
		produtos2.category_id as id_categoria
	from
		(select
			produtos.product_name as nome,
			pedidos.product_id as id_produto,
			pedidos.unit_price as preco_unidades,
			sum(pedidos.quantity) as quantidade,
			sum(pedidos.discount) as desconto
		from public.order_details as pedidos
		inner join public.products as produtos
			on pedidos.product_id = produtos.product_id
		group by id_produto, nome, preco_unidades
		order by id_produto) as tabela_pedidos
	join public.products as produtos2
		on tabela_pedidos.id_produto = produtos2.product_id 
	group by tabela_pedidos.nome, tabela_pedidos.id_produto, id_categoria 
	order by total desc) as ranking_produtos
join public.categories as categorias
	on ranking_produtos.id_categoria = categorias.category_id
group by nome_categoria
order by total_categoria desc
limit 3
```

## 🛠️ Competências Demonstradas

Uso de JOIN

Subqueries aninhadas

Agregações com SUM

Manipulação de tipos com CAST

Arredondamento com ROUND

Agrupamento com GROUP BY

Ordenação com ORDER BY

Limitação de resultados com LIMIT

Estruturação de consultas complexas

## 🚀 Possíveis Melhorias

Simplificação da query para ganho de performance e legibilidade
