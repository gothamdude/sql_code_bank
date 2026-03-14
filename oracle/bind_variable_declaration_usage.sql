SET AUTOPRINT ON;

VARIABLE v_bind1 VARCHAR2(15);

-- #1 initializing using EXEC
EXEC :v_bind1 := 'RebellionRider';

-- #2 initializing using PL/SQL 

--BEGIN 
    --:v_bind1 := 'Manish Sharma';
--END;

PRINT :v_bind1;
/