# SQLs do BlueSys para a tela "Importar do ERP" do painel

**Pacote 2026-11-12c.** A versão mais nova está sempre no botão **Baixar os SQLs do BlueSys**, dentro da tela Importar do ERP. Se o painel disser "SQL desatualizado", baixe de novo.

Rode no BlueSys/SVInfo, tela **Comandos de pesquisa**: cole o SQL inteiro, **Executa**, depois **GravXls**. Não mude nada dentro do SQL; a janela de datas é automática. Não use o GravaTxt (falha).

| Arquivo | O que traz | Rodadas |
|---|---|---|
| `1_pedidos.sql` | pedidos dos últimos 8 dias (+ abertos) com itens | até 09:50 · 13:15 · 15:40 · 18:30 |
| `2_produtos.sql` | produtos ativos: estoque, preço, promoção | até 09:50 · 13:15 · 15:40 · 18:30 |
| `3_contas_receber.sql` | títulos em aberto + 60 dias | até 09:50 · 18:30 |
| `4_os.sql` | OS abertas + 90 dias, com itens | até 09:50 · 15:40 |
| `5_clientes.sql` | cadastro completo de clientes | 18:30 |

A rodada "até 09:50" é feita logo depois da baixa dos boletos no sistema. Passo a passo completo: `ROTEIRO-equipe.md`.
