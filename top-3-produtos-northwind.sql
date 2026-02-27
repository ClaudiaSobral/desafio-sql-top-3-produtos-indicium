select
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
