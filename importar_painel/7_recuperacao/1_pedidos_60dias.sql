SELECT h.*,
       it.GRUPO            AS IT_GRUPO,
       it.CODIGO           AS IT_CODIGO,
       it.DESCRICAO        AS IT_DESCRICAO,
       it.QTD              AS IT_QTD,
       it.VALUNIT          AS IT_VALUNIT,
       it.DESCONTO         AS IT_DESCONTO,
       it.CUSTO_COMPRA     AS IT_CUSTO_COMPRA,
       it.TABITEM          AS IT_TABITEM,
       it.LUCRA            AS IT_LUCRA,
       it.VALFRT           AS IT_VALFRT,
       it.VALUNIT_REBATE   AS IT_VALUNIT_REBATE,
       it.VALUNIT_CASHBACK AS IT_VALUNIT_CASHBACK,
       it.VALOR_TX_MP      AS IT_VALOR_TX_MP,
       it.NITEMPED         AS IT_NITEMPED,
       it.KIT              AS IT_KIT,
       it.STTSEPAR         AS IT_STTSEPAR,
       it.VALUNIT_NF       AS IT_VALUNIT_NF,
       it.ICMS             AS IT_ICMS,
       CAST(2 AS INTEGER) AS SQL_VERSAO
  FROM (
SELECT p.STATUS                                            AS STATUS,
       p.FILIAL                                            AS FILIAL,
       COALESCE(cl.CLI_VINCULADO, 0)                       AS REPRESENTANTE,
       p.PEDIDO                                            AS PEDIDO,
       p.VENDEDOR                                          AS VENDEDOR,
       ve.NOME                                             AS NOME_VEND,
       p.DTFATURA                                          AS DT_FATURA,
       p.CODCLIENTE                                        AS COD_CLIENTE,
       p.NOME                                              AS NOME,
       p.VALOR                                             AS VALOR_TOTAL,
       p.VALOR_NF + p.VALOR_FRT                            AS VALOR_NF_FRT,
       p.NOTAFISCAL                                        AS NOTA_FISCAL,
       p.CONHECIMENTO                                      AS CONHECIM,
       p.VALDESCNF                                         AS DESC_NF,
       p.FORMA_PAG                                         AS FORMA_PAG,
       CASE WHEN p.VALOR > 0 THEN CAST(
            (p.VALOR - p.CUSTO
             - CASE WHEN p.VALFRETE_EFETIVO > 0
                    THEN p.VALFRETE_EFETIVO - p.VALOR_FRT ELSE 0 END)
            * 100 / p.VALOR AS NUMERIC(15,2))
            ELSE 0 END                                     AS PC_LUCRAT,
       CASE WHEN p.VALOR
                 - CASE WHEN p.VALFRETE_EFETIVO > 0
                        THEN p.VALFRETE_EFETIVO - p.VALOR_FRT ELSE 0 END > 0 THEN CAST(
            (p.VALOR - p.CUSTO
             - CASE WHEN p.VALFRETE_EFETIVO > 0
                    THEN p.VALFRETE_EFETIVO - p.VALOR_FRT ELSE 0 END)
            * 100 /
            (p.VALOR - CASE WHEN p.VALFRETE_EFETIVO > 0
                            THEN p.VALFRETE_EFETIVO - p.VALOR_FRT ELSE 0 END) AS NUMERIC(15,2))
            ELSE 0 END                                     AS MARGEM_PC,
       tr.NOME                                             AS NOME_TRANSP,
       fp.DESCRICAO                                        AS FORMA_PAGAMENTO,
       p.DTCONFIRMA                                        AS DT_CONFIRMA,
       p.USCONFIRMA                                        AS US_CONFIRMA,
       cl.FANTASIA                                         AS FANTASIA,
       p.ECOMMERCE                                         AS E_COMMERCE,
       p.MARKETPLACE                                       AS MARKET_PLACE,
       p.CGC                                               AS CNPJ_CPF,
       p.UF                                                AS UF,
       p.TRANSPORTADORA                                    AS TRANSP,
       p.DATAEMISSAO                                       AS DT_EMISSAO_NF,
       p.ENTREGA_FUTURA                                    AS ENTREGA_FUTURA,
       p.DATAEXPED                                         AS DT_EXPEDICAO,
       p.VALFRETE_EFETIVO                                  AS FRETE_EFETIVO,
       p.VALOR_FRT                                         AS FRETE_COBRADO,
       p.DESCONTO                                          AS DESCONTO,
       p.ENCARGOS + p.OUTROSENCARGOS                       AS ENCARGOS,
       p.CUSTO                                             AS CUSTO,
       p.CUSTO_TABELA                                      AS CUSTO_TAB,
       p.TABELA                                            AS TABELA,
       p.VALOR_NF                                          AS VALOR_NF,
       p.HRFATURA                                          AS HORA_FATURA,
       p.USUARIO                                           AS USUARIO,
       p.USSEPARA                                          AS US_SEPARA,
       p.DATASEPARA                                        AS DATA_SEPARA,
       p.USLIBERA                                          AS US_LIBERA,
       p.DATALIBERA                                        AS DATA_LIBERA,
       p.US_1ACONFIRM                                      AS US_1A_CONFIRMACAO,
       p.DTHR_1ACONFIRM                                    AS DTHR_1A_CONFIRMACAO,
       p.USEXPED                                           AS US_EXPED,
       p.ENDERECO                                          AS ENDERECO,
       p.ENDERECO_NUMERO                                   AS END_NO,
       p.ENDERECO_COMPLEMENTO                              AS COMPLEMENTO,
       p.BAIRRO                                            AS BAIRRO,
       p.CEP                                               AS CEP,
       mu.DESCRICAO                                        AS CIDADE,
       p.SEUPEDIDO                                         AS PED_CLIENTE,
       (SELECT SUM(i.QTD) FROM PEDITENS i
         WHERE i.FILIAL = p.FILIAL AND i.PEDIDO = p.PEDIDO) AS SOMA_QTD_ITENS,
       COALESCE(
         (SELECT DATEDIFF(DAY FROM MAX(a.DTFATURA) TO p.DTFATURA)
            FROM PEDIDOS a
           WHERE a.FILIAL     = p.FILIAL
             AND a.CODCLIENTE = p.CODCLIENTE
             AND a.PEDIDO     < p.PEDIDO
             AND a.STATUS IN ('25','30','99')
             AND COALESCE(a.VENDEDOR, 0) <> 99),
         CASE WHEN EXISTS (SELECT 1 FROM PEDIDOS b
                            WHERE b.CODCLIENTE = p.CODCLIENTE
                              AND b.PEDIDO     < p.PEDIDO
                              AND b.STATUS IN ('25','30','99')
                              AND COALESCE(b.VENDEDOR, 0) <> 99)
              THEN 0 ELSE 999999 END)                      AS DIAS_ULTPED,
       CAST('N' AS CHAR(1))                                AS PED_AUT,
       p.ESPECIAL                                          AS ESPECIAL,
       CAST(SUBSTRING((SELECT LIST(o.ID_OS, ', ') FROM OS o
              WHERE o.FILIAL = p.FILIAL
                AND (o.PEDIDO = p.PEDIDO OR o.PEDIDO_SERV = p.PEDIDO)) FROM 1 FOR 255)
            AS VARCHAR(255))                               AS OS,
       CASE WHEN (SELECT COUNT(*) FROM PEDITENS i
                   WHERE i.FILIAL = p.FILIAL AND i.PEDIDO = p.PEDIDO) > 0
             AND NOT EXISTS (SELECT 1 FROM PEDITENS i
                      LEFT JOIN CADAESTO e ON e.FILIAL = i.FILIAL
                                          AND e.GRUPO  = i.GRUPO
                                          AND e.CODIGO = i.CODIGO
                             WHERE i.FILIAL = p.FILIAL AND i.PEDIDO = p.PEDIDO
                               AND COALESCE(e.TIPO, '') <> 'SERV')
            THEN 'S' ELSE 'N' END                          AS SO_SERVICO,
       COALESCE((SELECT SUM(r.VALOR) FROM CONTARECEBIDO r
                  WHERE r.FILIAL = p.FILIAL AND r.PEDIDO = p.PEDIDO
                    AND r.TIPOPAG = 'CR'
                    AND r.RECEBER = 'N'
                    AND r.STATUS <> 'C'), 0)               AS CR_USADO,
       (SELECT MIN(c.DESCRICAO) FROM CLIENTES_X_CNAE x
           JOIN CNAE c ON c.ID = x.CNAE
          WHERE x.CODCLIENTE = p.CODCLIENTE
            AND x.PRIMARIA   = 'S')                        AS ATIVIDADE,
       p.PARCELAS_CARTAO                                   AS PARCELAS_CARTAO,
       p.MEDIA_DIAS                                        AS MEDIA_DIAS,
       (SELECT COUNT(*) FROM CONTARECEBIDO r
         WHERE r.FILIAL = p.FILIAL AND r.PEDIDO = p.PEDIDO
           AND r.TIPOPAG = 'CA'
           AND r.RECEBER = 'N'
           AND r.STATUS <> 'C'
           AND r.VALOR > 0)                                AS PARCELAS_CARTAO_REAL
  FROM PEDIDOS p
  LEFT JOIN CLIENTES        cl ON cl.CODCLIENTE = p.CODCLIENTE
  LEFT JOIN VENDEDORES      ve ON ve.CODVEND    = p.VENDEDOR
  LEFT JOIN TRANSPORTADORAS tr ON tr.CODTRANSP  = p.TRANSPORTADORA
  LEFT JOIN FORMA_PAGAMENTO fp ON fp.CODIGO     = p.FORMA_PAG
  LEFT JOIN MUNICIPIOS      mu ON mu.CODIGO     = p.CODMUNIC
 WHERE p.DTFATURA >= CURRENT_DATE - 60
    OR (p.STATUS NOT IN ('25','30','99','CA','CB','CO') AND p.DIA >= CURRENT_DATE - 90)
       ) h
  LEFT JOIN PEDITENS it ON it.FILIAL = h.FILIAL AND it.PEDIDO = h.PEDIDO
 ORDER BY h.PEDIDO DESC, it.NITEMPED
