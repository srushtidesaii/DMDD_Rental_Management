SET SERVEROUTPUT ON;

--TRIGGER FOR LEASE_STATUS UPDATE (ONGOING OR EXPIRED)
CREATE OR REPLACE TRIGGER A_I_LEASE_STATUS_UPDATE 
AFTER INSERT ON LEASE_DETAILS
DECLARE
    COUNT1 NUMBER;
    COUNT2 NUMBER;
    RECENT_LEASE_ID NUMBER;
    CURSOR COUNT_MONTHS IS SELECT MONTHS_BETWEEN(END_DATE,SYSDATE) INTO COUNT1 FROM LEASE_DETAILS;
BEGIN
      
      SELECT MAX(TO_NUMBER(SUBSTR(LEASE_ID,2))) INTO RECENT_LEASE_ID FROM LEASE_DETAILS;
       if(sql%notfound) then
        OPEN COUNT_MONTHS;
            LOOP
            FETCH COUNT_MONTHS INTO COUNT1;
            IF(COUNT1>=0) THEN 
                UPDATE LEASE_DETAILS SET LEASE_STATUS='ON GOING' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            ELSE 
                UPDATE LEASE_DETAILS SET LEASE_STATUS='EXPIRED' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            END IF;
            EXIT WHEN COUNT_MONTHS%NOTFOUND;
            END LOOP;
        CLOSE COUNT_MONTHS;
      
      ELSE
        OPEN COUNT_MONTHS;
            LOOP
            FETCH COUNT_MONTHS INTO COUNT1;
            IF(COUNT1>=0) THEN 
                UPDATE LEASE_DETAILS SET LEASE_STATUS='ON GOING' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            ELSE
                UPDATE LEASE_DETAILS SET LEASE_STATUS='EXPIRED' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            END IF;
            EXIT WHEN COUNT_MONTHS%NOTFOUND;
            END LOOP;
        CLOSE COUNT_MONTHS;
       end if;
END;
/
--FOR UPDATING MAINTENANCE STATUS TO 'PENDING' 
create or replace trigger A_I_MAINTENANCE_STATUS_UPDATE
after insert on maintenance_requests
declare
    id1 number;
    cls_date1 VARCHAR(50);
    cursor c1 is select request_closed_date into cls_date1 from maintenance_requests;
begin 
    
        select max(TO_NUMBER(SUBSTR(request_id,5))) into id1 from maintenance_requests;
        update maintenance_requests set maintenance_status = 'PENDING'where to_number(substr(request_id,5)) = id1;
        
end;
/
--FOR UPDATING MAINTENANCE STATUS TO 'DONE'
create or replace trigger A_U_MAINTENANCE_STATUS_UPDATE
after  UPDATE on maintenance_requests
BEGIN
    if updating('request_closed_date') then
    UPDATE  maintenance_requests SET  maintenance_status = 'DONE' where request_closed_date= SYSDATE;
    end if ;
END;
/



    
    
    


