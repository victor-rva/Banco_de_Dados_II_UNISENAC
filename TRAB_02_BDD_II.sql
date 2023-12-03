-- 1.
SET SERVEROUTPUT ON;

DECLARE
  v_employee_id aula.employees.employee_id%TYPE;
  v_first_name aula.employees.first_name%TYPE;
  v_last_name aula.employees.last_name%TYPE;
  v_total_orders NUMBER := 0;
  v_min_price NUMBER := NULL;
  v_max_price NUMBER := NULL;
  v_total_price NUMBER := 0;
  v_avg_price NUMBER := 0;

  CURSOR c_salesmen IS
    SELECT e.employee_id,
           e.first_name,
           e.last_name,
           COUNT(DISTINCT o.order_id) AS total_orders,
           MIN(oi.unit_price) AS min_price,
           MAX(oi.unit_price) AS max_price,
           AVG(oi.unit_price) AS avg_price
      FROM aula.employees e
           JOIN aula.orders o ON e.employee_id = o.salesman_id
           LEFT JOIN aula.order_items oi ON o.order_id = oi.order_id
     WHERE o.status = 'Shipped'
     GROUP BY e.employee_id, e.first_name, e.last_name;

BEGIN
  OPEN c_salesmen;

  LOOP
    FETCH c_salesmen INTO v_employee_id, v_first_name, v_last_name, v_total_orders, v_min_price, v_max_price, v_avg_price;

    EXIT WHEN c_salesmen%NOTFOUND;

    -- Exibir resultados
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('| Nome Vendedor: ' || v_first_name || ' ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('|');
    DBMS_OUTPUT.PUT_LINE('| Total de Pedidos : ' || v_total_orders);
    DBMS_OUTPUT.PUT_LINE('| Produto com Menor Preço : ' || NVL(TO_CHAR(v_min_price, '9999.99'), 'N/A'));
    DBMS_OUTPUT.PUT_LINE('| Produto com Maior Preço : ' || NVL(TO_CHAR(v_max_price, '9999.99'), 'N/A'));
    DBMS_OUTPUT.PUT_LINE('| Média dos Valores Vendidos: ' || TO_CHAR(v_avg_price, '9999.99'));
  END LOOP;

  CLOSE c_salesmen;
END;
/


-- 2. 
-- a) Criar a role
CREATE ROLE role_vendas;

-- b) Conceder permissões aos objetos do banco
GRANT SELECT, INSERT, UPDATE ON Aula.Countries TO role_vendas;
GRANT SELECT, INSERT, UPDATE ON Aula.Regions TO role_vendas;
GRANT SELECT ON Aula.Warehouses TO role_vendas;
GRANT SELECT ON Aula.Inventories TO role_vendas;


-- 3.
-- c) As assertivas III e IV estão corretas

-- 4.
-- a) VERDADEIRA

-- 5. 
-- a) Modelo ponto a ponto


