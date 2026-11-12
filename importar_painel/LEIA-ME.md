# SQLs do BlueSys para a tela "Importar do ERP" do painel

**Pacote 2026-11-12b.** A versão mais nova está sempre no botão **Baixar os SQLs do BlueSys**, dentro da própria tela Importar do ERP. Cada SQL carrega uma coluna `SQL_VERSAO`; se alguém importar um arquivo gerado por SQL antigo, a tela avisa e manda baixar o pacote de novo.

Rode no BlueSys/SVInfo, tela **Comandos de pesquisa**: **Executa → GravXls**. O `.xls` gerado (Excel 4.0) entra direto na tela do painel — testado em 12/11 com o export real de `1_pedidos.sql` (1.767 linhas). O GravaTxt falhou no teste (gravou só o cabeçalho); não use. Regras daquela tela:
- um comando por vez; o texto tem de **começar com SELECT** (por isso estes arquivos não têm comentário dentro);
- **não** colocar `;` no final;
- a janela de datas é automática (`CURRENT_DATE - 8` etc.): não precisa editar nada antes de rodar.

| Arquivo | O que traz | Janela | Rodadas |
|---|---|---|---|
| `1_pedidos.sql` | pedido + itens (uma linha por item, prefixo `IT_`), com cancelados | faturados/criados nos últimos **8 dias** + todos os **abertos** dos últimos 90 dias | 09:50 · 13:15 · 15:40 · 18:30 |
| `2_produtos.sql` | produto, estoque, reserva, preço base, custo, faixa, fatores 04/07/08, promoção | BLUE: **ativos** + alterados em 8 dias + com promoção | 09:50 · 13:15 · 15:40 · 18:30 |
| `3_contas_receber.sql` | títulos (33 colunas) | **em aberto** + emitidos/quitados/cancelados nos últimos **60 dias** | 09:50 · 18:30 |
| `4_os.sql` | OS + itens (prefixo `IT_`) | **abertas** (status 1, 2, 3, 4, 6) + movimentadas nos últimos **90 dias** | 09:50 · 15:40 |
| `5_clientes.sql` | cadastro completo (40 colunas) + atividade principal | **completo** (39 mil linhas, ~4 MB — o ERP não tem data de alteração confiável em CLIENTES) | 18:30 |
| `7_recuperacao/1_pedidos_desde_20-10-2026.sql` | igual ao `1_pedidos.sql`, mas desde **20/10/2026** (data fixa) | uma vez só, para fechar o buraco de 29/10 a 03/11 (o sincronizador antigo parou às 12:40 de 03/11) | rodar 1× em 12 ou 13/11 |
| `7_recuperacao/1_pedidos_60dias.sql` | igual ao `1_pedidos.sql`, mas últimos **60 dias** | pega cancelamentos e faturamentos tardios que a janela de 8 dias não vê | sexta às 18:30, no lugar do `1_pedidos.sql` |
| `6_cadastros_ocasional/*.sql` | vendedores, formas de pagamento, tipos, atividades, contatos, tabelas de preço, faixas, fatores, kits, promoções | completo | só quando mudar algo no Vanguarda (vendedor novo, tabela nova, kit novo…) |

Depois de exportar, arraste os arquivos para **Cadastros → Importar do ERP** no painel. O tipo é reconhecido pelo cabeçalho; o nome do arquivo é só para organização.

## Detalhes que valem saber
- `1_pedidos.sql` é o mesmo SELECT do relatório "Pedidos Faturados" já validado contra o ERP (14/09/2026), com os itens juntos. Vêm prontos do ERP: `DIAS_ULTPED`, `CUSTO`, `PC_LUCRAT`, `SOMA_QTD_ITENS`, `SO_SERVICO`, `CR_USADO`, `ATIVIDADE`, `OS`.
- Campos de texto acima de 255 caracteres (OBS, DEFEITO, SERVICO… da OS; ASSINATURA do vendedor) saem cortados em 255 (`SUBSTRING ... FOR 255` + `CAST`), senão o SVInfo exporta o literal `(Memo)`. Só `CAST` não serve: quando o texto passa de 255 o Firebird dá "string right truncation" (aconteceu na OS em 12/11, texto de 302 caracteres).
- Um pedido/OS sem item sai com as colunas `IT_` vazias — o painel entende.
- Produto com mais de uma promoção sai em mais de uma linha — o painel entende.
- Se o SVInfo recusar um SQL com a mensagem genérica "Ocorreu erro na pesquisa", o problema costuma ser o tamanho da janela: reduza `CURRENT_DATE - 90` para `- 30` só para testar.

## Formato do export (conferido em 12/11)
**Número nulo sai como 0** no GravXls. Por isso as colunas de referência que podem ser nulas (PEDIDO e PEDIDO_SERV da OS, OS_GARANTIA, CODCLIENTE da OS, PEDIDO do título, CNAE_PRINCIPAL, VENDEDOR2, TRANSP_PADRAO, CODMUNIC) saem com `CAST(... AS VARCHAR)`: texto nulo sai vazio. O painel também trata 0 como vazio nessas colunas, por segurança.

O GravXls gera Excel 4.0 (um registro por célula, texto em Windows-1252). Datas saem como texto `dd/mm/aaaa`, data-hora `dd/mm/aaaa hh:mm:ss`, hora `hh:mm:ss`; números saem como número (com o `,001` do ERP onde ele existe); códigos com zero à esquerda (`STATUS 10`, `TABELA 05`) saem como texto. O cabeçalho vem com espaço no lugar de `_` (`NOME VEND`) e a tela converte de volta. A tela também aceita CSV (`;` `,` tab ou `|`, UTF-8 ou Windows-1252) se um dia for preciso.
