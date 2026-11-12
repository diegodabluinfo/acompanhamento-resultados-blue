SELECT r.FILIAL            AS FILIAL,
       r.TITULO            AS TITULO,
       r.ID                AS ID,
       r.NFISCAL           AS NFISCAL,
       r.EMISSAO           AS EMISSAO,
       r.CODCLIENTE        AS CODCLIENTE,
       r.CGC               AS CGC,
       CAST(r.PEDIDO AS VARCHAR(12)) AS PEDIDO,
       r.VENCIMENTO        AS VENCIMENTO,
       r.VENC_ORIG         AS VENC_ORIG,
       r.VALOR             AS VALOR,
       r.JUROS             AS JUROS,
       r.DESCONTOS         AS DESCONTOS,
       r.RECEBIDO          AS RECEBIDO,
       r.VALOR_ABATIMENTO  AS VALOR_ABATIMENTO,
       r.VALOR_VENDA       AS VALOR_VENDA,
       r.QUITADO           AS QUITADO,
       r.DATAQUITACAO      AS DATAQUITACAO,
       r.DIGITACAO         AS DIGITACAO,
       r.USCANCELA         AS USCANCELA,
       r.DTCANCELA         AS DTCANCELA,
       r.STATUS            AS STATUS,
       r.PROTESTO          AS PROTESTO,
       r.CARTEIRA          AS CARTEIRA,
       r.BANCO             AS BANCO,
       r.NOSSONR           AS NOSSONR,
       r.ENVIO             AS ENVIO,
       r.HISTORICO         AS HISTORICO,
       r.CONTA             AS CONTA,
       r.CCTITULO          AS CCTITULO,
       r.USUARIO           AS USUARIO,
       r.BOLETOANTECIPADO  AS BOLETOANTECIPADO,
       r.ECOMMERCE         AS ECOMMERCE,
       CAST(2 AS INTEGER) AS SQL_VERSAO
  FROM CONTARECEBER r
 WHERE COALESCE(r.QUITADO, 'N') NOT IN ('S', 'C')
    OR r.EMISSAO      >= CURRENT_DATE - 60
    OR r.DATAQUITACAO >= CURRENT_DATE - 60
    OR r.DTCANCELA    >= CURRENT_DATE - 60
    OR r.DIGITACAO    >= CURRENT_DATE - 60
 ORDER BY r.FILIAL, r.TITULO, r.ID
