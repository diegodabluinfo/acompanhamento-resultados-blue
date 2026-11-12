# Importar do ERP — roteiro da equipe (1 página)

**O que é:** o painel não puxa mais os dados do Vanguarda sozinho. Quatro vezes por dia alguém roda os SQLs no BlueSys, salva os arquivos e arrasta para a tela **Cadastros → Importar do ERP** do painel. Em até 1 minuto o painel se atualiza.

## Horários e arquivos de cada rodada (segunda a sexta; não roda em feriado)

| Rodada | Rode estes SQLs | Para quê |
|---|---|---|
| **09:50** | 1 PEDIDOS · 2 PRODUTOS · 3 CONTAS A RECEBER · 4 OS | a cobrança automática das 10h precisa dos títulos de hoje |
| **12:40** | 1 PEDIDOS · 2 PRODUTOS | orçamentos da tarde com preço e estoque certos |
| **15:40** | 1 PEDIDOS · 2 PRODUTOS · 4 OS | pico da tarde |
| **20:30** | 1 PEDIDOS · 2 PRODUTOS · 3 CONTAS A RECEBER · 5 CLIENTES | fecha o dia: lista do dia, ranking e recepção de amanhã |

Na dúvida, mande os 5 — repetir arquivo não faz mal.

## Passo a passo

1. **No BlueSys**, abra a tela de SQL e rode o arquivo da vez (`1_pedidos.sql`, `2_produtos.sql`, `3_contas_receber.sql`, `4_os.sql`, `5_clientes.sql`). Os SQLs ficam no botão **Baixar os SQLs do BlueSys**, na própria tela Importar do ERP — se o painel disser "SQL desatualizado", baixe o pacote de novo. Não mude nada dentro do SQL.
2. Clique em **GravXls** e salve na pasta `Importar ERP` com o nome do SQL (ex.: `1_pedidos.xls`). Não use o GravaTxt (ele falha).
3. **No painel**, entre em **Cadastros → Importar do ERP** e arraste os arquivos para a área pontilhada (pode arrastar todos de uma vez).
4. **Confira o cartão de cada arquivo:** o tipo reconhecido (Pedidos, Produtos…), o número de linhas e o período. Se aparecer ✖ em vermelho, o arquivo não vai subir — leia o motivo (quase sempre coluna faltando: o SQL foi alterado ou a exportação cortou colunas).
5. Clique em **Enviar N arquivos**. Espere a barra azul terminar e o cartão ficar **"na fila"**.
6. Em até 1 minuto o cartão muda para **ok** (verde) com o resumo: "pedidos: 612 lidas · 612 gravadas". A barra do rodapé do painel passa a mostrar "ERP importado em … às …".

## Se der errado

| O que apareceu | O que fazer |
|---|---|
| **ok com avisos** (amarelo) | Entrou tudo. Leia o aviso: em geral o arquivo veio menor que o esperado e o painel não apagou nada por segurança. Rode o SQL de novo sem filtro mexido. |
| **erro** (vermelho) | Nada daquele arquivo foi gravado. O motivo está em "Resultado". Corrija (normalmente rodar o SQL e exportar de novo) e mande de novo. |
| **falhou** no envio | Caiu a internet no meio. Clique em **Enviar** de novo — o arquivo sobe outra vez do zero. |
| Mandei o arquivo errado | Se ainda estiver "na fila", clique em **cancelar** no cartão. Se já processou, mande o arquivo certo por cima: o painel atualiza, não duplica. |
| Barra do rodapé laranja "Importação atrasada" | A rodada do horário não foi feita. Faça agora. |

**Regra de ouro:** o painel nunca duplica — o mesmo pedido/título/produto mandado duas vezes é só atualizado. Mandar de novo é sempre seguro.

**Quem pode importar:** só quem tem a aba "Importar do ERP" liberada na tela Usuários (pedir ao Diego).
