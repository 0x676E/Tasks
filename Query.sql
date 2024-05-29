DECLARE
    -- Cursor to fetch top 5 customers with their total amount spent
    CURSOR top_customers_cur IS
        SELECT c.customer_id,
               c.name,
               SUM(oi.quantity * oi.price) AS total_amount_spent
          FROM customers c
               JOIN orders o ON c.customer_id = o.customer_id
               JOIN order_items oi ON o.order_id = oi.order_id
         WHERE o.order_date >= ADD_MONTHS(SYSDATE, -6) -- Last 6 months
      GROUP BY c.customer_id, c.name
      ORDER BY total_amount_spent DESC
         FETCH FIRST 5 ROWS ONLY;
         
    -- Cursor to fetch product names and quantities for each customer
    CURSOR customer_products_cur (p_customer_id NUMBER) IS
        SELECT p.product_name,
               oi.quantity
          FROM customers c
               JOIN orders o ON c.customer_id = o.customer_id
               JOIN order_items oi ON o.order_id = oi.order_id
               JOIN products p ON oi.product_id = p.product_id
         WHERE c.customer_id = p_customer_id
           AND o.order_date >= ADD_MONTHS(SYSDATE, -6); -- Last 6 months
           
    -- Variables to store customer details
    v_customer_id customers.customer_id%TYPE;
    v_customer_name customers.name%TYPE;
    v_total_amount_spent NUMBER;
BEGIN
    -- Loop through top 5 customers
    FOR top_customer_rec IN top_customers_cur LOOP
        v_customer_id := top_customer_rec.customer_id;
        v_customer_name := top_customer_rec.name;
        v_total_amount_spent := top_customer_rec.total_amount_spent;
        
        -- Print customer details
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id);
        DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
        DBMS_OUTPUT.PUT_LINE('Total Amount Spent: ' || v_total_amount_spent);
        
        -- Print product names and quantities for the customer
        DBMS_OUTPUT.PUT_LINE('Products Purchased:');
        
        -- Loop through products purchased by the customer
        FOR customer_product_rec IN customer_products_cur(v_customer_id) LOOP
            DBMS_OUTPUT.PUT_LINE(customer_product_rec.product_name || ' - Quantity: ' || customer_product_rec.quantity);
        END LOOP;
        
        -- Print separator between customers
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;
/
