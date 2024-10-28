use mydb;
#1. Напишіть SQL запит, який буде відображати таблицю order_details та 
# поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.
# Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT 
SELECT 
    od.*,
    (SELECT customer_id 
     FROM orders 
     WHERE orders.id = od.order_id) as customer_id
FROM order_details od;

#2. Напишіть SQL запит, який буде відображати таблицю order_details. 
# Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
# Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.
SELECT *
FROM order_details od
WHERE order_id IN 
    (SELECT id 
     FROM orders 
     WHERE shipper_id = 3);

#3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 з таблиці order_details.
# Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.
SELECT 
    order_id,
    AVG(quantity) as avg_quantity
FROM 
    (SELECT * 
     FROM order_details 
     WHERE quantity > 10) as filtered_orders
GROUP BY order_id;

#4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. 
# Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті. 
WITH temp AS (
    SELECT *
    FROM order_details
    WHERE quantity > 10
)
SELECT 
    order_id,
    AVG(quantity) as avg_quantity
FROM temp
GROUP BY order_id;

#5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
# Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
# Використайте конструкцію DROP FUNCTION IF EXISTS. Застосуйте функцію до атрибута quantity таблиці order_details . Другим параметром може бути довільне число на ваш розсуд.
DROP FUNCTION IF EXISTS divide_quantity;

DELIMITER //

CREATE FUNCTION divide_quantity(value1 FLOAT, value2 FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    RETURN value1 / value2;
END //

DELIMITER ;

-- Приклад використання функції з таблицею order_details
SELECT 
    id,
    quantity,
    divide_quantity(quantity, 2.5) as divided_quantity
FROM order_details;


