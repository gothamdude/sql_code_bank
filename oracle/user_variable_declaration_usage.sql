SET SERVEROUTPUT ON;

DECLARE 
    v_test VARCHAR2(15); 
BEGIN 
    v_test:='Rebellion';
    DBMS_OUTPUT.PUT_LINE(v_test);
END;

