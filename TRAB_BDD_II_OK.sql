-- 1.VIEW
CREATE VIEW vw_COLABORADORES AS 
SELECT first_name | | last_name AS NOME,job_title as CARGO, b.NOME_GERENTE

FROM aula.employees a,
    (SELECT first_name | |last_name  AS NOME_GERENTE, employee_id from aula.employees) b
    WHERE a.manager_id = b.employee_id;

SELECT * FROM vw_COLABORADORES; 

-- *******************************************

-- 2.FUNÇÃO
CREATE OR REPLACE FUNCTION aula.fn_Buscar_ClienteContato(ID_CLIE NUMBER)
RETURN VARCHAR2 IS
cliente_dados VARCHAR2(200);
BEGIN
  SELECT CU.name ||' - '|| CO.FIRST_NAME || ' ' || CO.LAST_NAME || ' / ' || CO.EMAIL
  INTO cliente_dados
  FROM AULA.CUSTOMERS CU
  INNER JOIN AULA.CONTACTS CO
  ON CO.CUSTOMER_ID = CU.CUSTOMER_ID
  WHERE CU.CUSTOMER_ID = ID_CLIE;
  RETURN cliente_dados;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Cliente não encontrado';
END;
/
SELECT fn_Buscar_ClienteContato(21) FROM dual;

-- ******************************************* 

-- 3. RELATÓRIO / PROCEDURE

-- ETAPA 1 - RELATÓRIO
CREATE TABLE aula.RELATORIO (
    idRelatorio NUMBER PRIMARY KEY,
    dataHoraCarga TIMESTAMP,
    idPedido NUMBER ,
    dadosCliente VARCHAR2(200),
    nomeVendedor VARCHAR2(100),
    quantidadeTotalProdutos NUMBER,
    valorTotalPedido NUMBER(10,2)
);
SELECT * FROM aula.RELATORIO;

-- ETAPA 2 - PROCEDURE 
CREATE OR REPLACE PROCEDURE AULA.pr_Carga_Relatorio (
in_idRelatorio in int,
in_IDPEDIDO in INT,
in_NOMEVENDEDOR in aula.RELATORIO.NOMEVENDEDOR%TYPE,
in_QTDTOTPROD in INT,
in_VALORTOTPEDIDO in INT,
in_id_func_client in int
)
IS 
    v_DADOSCLIENTE VARCHAR2(200);
    data_agr DATE;
        
BEGIN
    v_DADOSCLIENTE := fn_Buscar_ClienteContato(in_id_func_client);
    SELECT SYSDATE INTO data_agr FROM DUAL;
    INSERT INTO AULA.RELATORIO (IDRELATORIO,DATAHORACARGA, IDPEDIDO,DADOSCLIENTE, NOMEVENDEDOR,QUANTIDADETOTALPRODUTOS,VALORTOTALPEDIDO) 
    VALUES (in_idRelatorio,data_agr,in_IDPEDIDO,v_DADOSCLIENTE,in_NOMEVENDEDOR,in_QTDTOTPROD,in_VALORTOTPEDIDO);
  COMMIT;
END pr_Carga_Relatorio;


BEGIN
AULA.pr_Carga_Relatorio(14,27,'Ademir',300,100,20);
END;

BEGIN
AULA.pr_Carga_Relatorio(29,28,'Ademir',550,110,21);
END;

BEGIN
AULA.pr_Carga_Relatorio(30,25,'Carlos',500,100,23);
END;

-- *******************************************

-- 4. ReposicaoEstoque / TRIGGER

-- ETAPA 1 - ReposicaoEstoque
CREATE TABLE aula.ReposicaoEstoque (
    idProduto NUMBER PRIMARY KEY,
    quantidadeVendida NUMBER,
    quantidadeEmEstoque NUMBER,
    percentualVendido NUMBER(5,2)
);


-- ETAPA 2 - TRIGGER

CREATE OR REPLACE TRIGGER trg_After_Insert_Relatorio
AFTER INSERT ON aula.RELATORIO
FOR EACH ROW
DECLARE
    v_preco_produto NUMBER;
BEGIN    
    INSERT INTO aula.ReposicaoEstoque (
        idProduto,
        quantidadeVendida,
        quantidadeEmEstoque,
        percentualVendido
    )
    VALUES (
        :NEW.idRelatorio,
        :NEW.quantidadeTotalProdutos /:NEW.valorTotalPedido, 
        :NEW.quantidadeTotalProdutos - (:NEW.quantidadeTotalProdutos / :NEW.valorTotalPedido),
        (:NEW.quantidadeTotalProdutos / :NEW.valorTotalPedido) / :NEW.quantidadeTotalProdutos * 100
    );
END;
/ 

SELECT * FROM aula.RELATORIO;
SELECT * FROM aula.ReposicaoEstoque;


-- INSERT INTO de testes
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (3,to_date('01/10/2023', 'dd/mm/yyyy'),7,'JoseAlmeida','JuliaOleda',700,70);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (2,to_date('01/10/2023', 'dd/mm/yyyy'),6,'KlausOlmedo','LeyaSky',550,110);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (44,to_date('01/10/2023', 'dd/mm/yyyy'),43,'LukeSky','AnakinVader',260,130);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (4,to_date('01/10/2023', 'dd/mm/yyyy'),8,'KlausOlmedo','LeyaSky',60,10);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (7,to_date('01/10/2023', 'dd/mm/yyyy'),3,'JhonnyStorm','FreyJaya',400,100);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (11,to_date('01/10/2023', 'dd/mm/yyyy'),11,'SteveBlow','JurisMano',300,100);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (10,to_date('01/10/2023', 'dd/mm/yyyy'),10,'KlausOlmedo','LeyaSky',3000,1000);
    
INSERT INTO aula.RELATORIO (idRelatorio, dataHoraCarga, idPedido, dadosCliente, nomeVendedor, quantidadeTotalProdutos, valorTotalPedido)
    VALUES (13,to_date('01/10/2023', 'dd/mm/yyyy'),19,'LayOlin','LayaChain',3000,1000);   
