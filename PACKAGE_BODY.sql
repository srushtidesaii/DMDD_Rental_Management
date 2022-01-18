SET SERVEROUTPUT ON;
CREATE OR REPLACE Package body Insertion
as
PROCEDURE LANDLORD_APARTMENT(
    p_LANDLORD_FIRST_NAME landlord.landlord_first_name%TYPE,
    p_LANDLORD_LAST_NAME LANDLORD.LANDLORD_LAST_NAME%TYPE,           
    p_LANDLORD_CONTACT landlord.landlord_contact%TYPE,
    p_LANDLORD_EMAIL landlord.landlord_email%TYPE,
    p_LANDLORD_APARTMENT_NUMBER landlord.landlord_apartment_number%TYPE,
    p_LANDLORD_STREET_NAME landlord.landlord_street_name%TYPE,
    p_LANDLORD_ZIPCODE landlord.landlord_zipcode%TYPE,
    p_APARTMENT_TYPE_ID apartment.apartment_type_id%TYPE,
    p_APARTMENT_NUMBER apartment.apartment_number%TYPE,
    p_APARTMENT_STREET_NAME apartment.apartment_street_name%TYPE,
    p_APARTMENT_NEIGHBOURHOOD apartment.apartment_neighbourhood%TYPE,
    p_APARTMENT_ZIPCODE apartment.apartment_zipcode%TYPE,
    p_APARTMENT_TOTAL_AREA apartment.total_area%TYPE,
    p_APARTMENT_MONTHLY_RENT apartment.monthly_rent%TYPE)
AS
  count_months1 int;  
  count1 number;
  count2 number;
  count3 number;
  v_landlord_id landlord.landlord_id%TYPE;
  ex1 exception;
  ex2 exception;
  ex3 exception;
  ex4 exception;
  ex5 exception;
  ex6 exception;
  ex7 exception;
  
  
BEGIN 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
    SELECT COUNT(Landlord_id) INTO count1 from Landlord where Landlord_email = p_LANDLORD_EMAIL;
    SELECT COUNT(*) INTO count2 from APARTMENT_TYPE where APARTMENT_TYPE_ID = p_APARTMENT_TYPE_ID;
    --select count(apartment_Type_id) into v_id from apartment_type where apartment_type = P_apartment_type and number_of_rooms = P_rooms and number_of_baths = P_bath;
    --SELECT COUNT(*) INTO count2 from APARTMENT_TYPE where upper(p_APARTMENT_TYPE_ID)like upper(APARTMENT_TYPE_ID);
    
    if(count2>0 and count1=0) THEN  
        INSERT INTO landlord(LANDLORD_ID,landlord_first_name,landlord_last_name,landlord_contact,landlord_email,landlord_apartment_number,landlord_street_name,landlord_zipcode) 
        VALUES (seq_landlord_id.nextval ,p_LANDLORD_FIRST_NAME,p_LANDLORD_LAST_NAME,p_LANDLORD_CONTACT,p_LANDLORD_EMAIL,p_LANDLORD_APARTMENT_NUMBER,p_LANDLORD_STREET_NAME,p_LANDLORD_ZIPCODE);
        select landlord_id into v_landlord_id from landlord where Landlord_email = p_LANDLORD_EMAIL;
        --dbms_output.put_line(v_landlord_id);                                     
        INSERT INTO Apartment(APARTMENT_ID,LANDLORD_ID,APARTMENT_TYPE_ID,APARTMENT_NUMBER,APARTMENT_STREET_NAME,APARTMENT_NEIGHBOURHOOD,APARTMENT_ZIPCODE,
                             TOTAL_AREA,MONTHLY_RENT) VALUES(seq_apartment_id.nextval,v_LANDLORD_ID,p_APARTMENT_TYPE_ID,p_APARTMENT_NUMBER,p_APARTMENT_STREET_NAME,p_APARTMENT_NEIGHBOURHOOD,
                                     p_APARTMENT_ZIPCODE,p_APARTMENT_TOTAL_AREA,p_APARTMENT_MONTHLY_RENT);
        dbms_output.put_line('Successfully inserted row into  APARTMENT');
    else if(count1>0 and count2>=0) Then
        select landlord_id into v_landlord_id from landlord where Landlord_email = p_LANDLORD_EMAIL;
        INSERT INTO Apartment(APARTMENT_ID,LANDLORD_ID,APARTMENT_TYPE_ID,APARTMENT_NUMBER,APARTMENT_STREET_NAME,APARTMENT_NEIGHBOURHOOD,APARTMENT_ZIPCODE,
                             TOTAL_AREA,MONTHLY_RENT) VALUES(seq_apartment_id.nextval,v_LANDLORD_ID,p_APARTMENT_TYPE_ID,p_APARTMENT_NUMBER,p_APARTMENT_STREET_NAME,p_APARTMENT_NEIGHBOURHOOD,
                                     p_APARTMENT_ZIPCODE,p_APARTMENT_TOTAL_AREA,p_APARTMENT_MONTHLY_RENT);
        dbms_output.put_line('else block');
         else if (count2<=0) then 
              raise ex6;
                     end if;
                 end if;
           end if;
EXCEPTION 
when ex6 then 
DBMS_OUTPUT.PUT_LINE('APARTMENT_TYPE DOESNT EXIST');
END LANDLORD_APARTMENT;

PROCEDURE LEASE_CUSTOMERS_INSERTIONS
(
    p_LEASE_ID LEASE_DETAILS.lease_id%TYPE,
    p_APARTMENT_ID APARTMENT.APARTMENT_ID%TYPE, --Using apartment table as we want to check if the apartment exists in apartment table
    p_START_DATE lease_details.start_date%TYPE,
    p_END_DATE lease_details.end_date%TYPE,
    p_MEMBERS_ON_LEASE lease_details.members_on_lease%TYPE,
    p_CUSTOMER_ID CUSTOMERS.CUSTOMER_ID%TYPE,
    p_CUSTOMER_FIRST_NAME CUSTOMERS.CUSTOMER_FIRST_NAME%TYPE,
    p_CUSTOMER_LAST_NAME CUSTOMERS.CUSTOMER_LAST_NAME%TYPE,
    p_CUSTOMER_CONTACT CUSTOMERS.CUSTOMER_CONTACT%TYPE,
    p_CUSTOMER_EMAIL CUSTOMERS.CUSTOMER_EMAIL%TYPE,
    p_CUSTOMER_APARTMENT_NUMBER CUSTOMERS.CUSTOMER_APARTMENT_NUMBER%TYPE,
    p_CUSTOMER_STREET_NUMBER CUSTOMERS.CUSTOMER_STREET_NUMBER%TYPE,
    p_CUSTOMER_STREET_NAME CUSTOMERS.CUSTOMER_STREET_NAME%TYPE,
    p_CUSTOMER_NEIGHBORHOOD CUSTOMERS.CUSTOMER_NEIGHBOURHOOD%TYPE,
    p_CUSTOMER_CITY CUSTOMERS.CUSTOMER_CITY%TYPE,
    p_CUSTOMER_STATE CUSTOMERS.CUSTOMER_STATE%TYPE,
    p_CUSTOMER_COUNTRY CUSTOMERS.CUSTOMER_COUNTRY%TYPE,
    p_CUSTOMER_ZIPCODE CUSTOMERS.CUSTOMER_ZIPCODE%TYPE
)
AS
  count_months1 int;  
  count3 INT;
  count1 INT;
  count2 INT;
  dup_lease exception;
  dup_customer exception;
  no_apartment exception;
  ex1 exception;
  ex2 exception;
  ex3 exception;
  ex4 exception;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
   
    SELECT COUNT(*) INTO count1 from APARTMENT where upper(p_APARTMENT_ID) like upper(APARTMENT_ID);
    SELECT COUNT(*) INTO count2 from CUSTOMERS where upper(p_CUSTOMER_ID) like upper(CUSTOMER_ID);
    SELECT COUNT(*) INTO count3 from LEASE_DETAILS where upper(p_LEASE_ID) like upper (LEASE_ID);
    --SELECT MONTHS_BETWEEN(p_END_DATE,SYSDATE) into count_months1 FROM dual;--FOR CHECKING LEASE EXPIRED/ONGOING
    if((count3<=0) AND (count1>0) and (count2<=0)) THEN --Empty database and apartment exists(new leaseid, new customer and apartment exists)
        INSERT INTO LEASE_DETAILS(LEASE_ID,APARTMENT_ID, START_DATE, END_DATE, MEMBERS_ON_LEASE) VALUES (p_LEASE_ID, p_APARTMENT_ID,  p_START_DATE, p_END_DATE, p_MEMBERS_ON_LEASE);
        INSERT INTO CUSTOMERS VALUES(p_CUSTOMER_ID,p_LEASE_ID,p_CUSTOMER_FIRST_NAME, p_CUSTOMER_LAST_NAME, p_CUSTOMER_CONTACT,
                                     p_CUSTOMER_EMAIL, p_CUSTOMER_APARTMENT_NUMBER, p_CUSTOMER_STREET_NUMBER, p_CUSTOMER_STREET_NAME,
                                     p_CUSTOMER_NEIGHBORHOOD, p_CUSTOMER_CITY, p_CUSTOMER_STATE, p_CUSTOMER_COUNTRY, p_CUSTOMER_ZIPCODE);
        dbms_output.put_line('Successfully inserted row into LEASE_DETAILS AND CUSTOMERS');
    
    ELSE    
         if((count3>0) and (count2<=0) and (count1>0)) then --Leaseid exists, many customers, apartment exists
                INSERT INTO CUSTOMERS VALUES(p_CUSTOMER_ID,p_LEASE_ID,p_CUSTOMER_FIRST_NAME, p_CUSTOMER_LAST_NAME, p_CUSTOMER_CONTACT,
                                     p_CUSTOMER_EMAIL, p_CUSTOMER_APARTMENT_NUMBER, p_CUSTOMER_STREET_NUMBER, p_CUSTOMER_STREET_NAME,
                                     p_CUSTOMER_NEIGHBORHOOD, p_CUSTOMER_CITY, p_CUSTOMER_STATE, p_CUSTOMER_COUNTRY, p_CUSTOMER_ZIPCODE); 
        dbms_output.put_line('Successfully inserted row into LEASE_DETAILS AND CUSTOMERS');
          
         if((count1<=0) and (count2>0) and (count3>0)) then 
                raise ex4;
                elsif((count1<=0) and (count2>0)) THEN --apartment doesnt exist and duplicate customer
                    raise ex1;
                    elsif((count1<=0) and (count3>0)) THEN --apartment doesnt exist and duplicate lease id
                        raise ex2;
                        elsif((count3>0) and (count2>0)) THEN --duplicate lease id and duplicate customer id
                            raise ex3;
                            elsif((count1<=0))THEN
                                raise no_apartment;
                                elsif(count3>0) then
                                    raise dup_lease;
                                      else 
                                        raise dup_customer;
                
            end if;
        end if;
END IF;

EXCEPTION
WHEN dup_lease THEN
dbms_output.put_line('Duplicate LEASE_ID found');
WHEN dup_customer THEN
dbms_output.put_line('Duplicate CUSTOMER_ID found');
WHEN no_apartment  THEN
dbms_output.put_line('APARTMENT_ID DOESNT EXIST, Please enter valid APARTMENT_ID');
WHEN ex1 THEN
dbms_output.put_line('APARTMENT_ID DOESNT EXIST, Please enter valid APARTMENT_ID and Duplicate CUSTOMER_ID found');
WHEN ex2 THEN
dbms_output.put_line('APARTMENT_ID DOESNT EXIST, Please enter valid APARTMENT_ID and Duplicate LEASE_ID found');
WHEN ex3 THEN
dbms_output.put_line('Duplicate CUSTOMER_ID and Duplicate LEASE_ID found');
WHEN ex4 THEN
dbms_output.put_line('APARTMENT_ID DOESNT EXIST, Duplicate CUSTOMER_ID and Duplicate LEASE_ID found');
END LEASE_CUSTOMERS_INSERTIONS;


PROCEDURE PAYMENT_DETAILS
(
    p_PAYMENT_ID PAYMENT.PAYMENT_ID%TYPE,
   
    p_LEASE_ID LEASE_DETAILS.LEASE_ID%TYPE, --Using apartment table as we want to check if the apartment exists in apartment table
    p_AMOUNT_TRANSFERRED PAYMENT.AMOUNT_TRANSFERRED%TYPE,
    p_TRANSACTION_DATE PAYMENT.TRANSACTION_DATE%TYPE,
    p_PAYMENT_TYPE PAYMENT.PAYMENT_TYPE%TYPE,
    P_PAYEE_FIRST_NAME PAYMENT.PAYEE_FIRST_NAME%TYPE,
    P_PAYEE_LAST_NAME PAYMENT.PAYEE_LAST_NAME%TYPE


    
   )
AS
BEGIN

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
INSERT INTO PAYMENT(PAYMENT_ID,LEASE_ID,AMOUNT_TRANSFERRED,TRANSACTION_DATE,PAYMENT_TYPE,PAYEE_FIRST_NAME,PAYEE_LAST_NAME) VALUES ( p_PAYMENT_ID,p_LEASE_ID,p_AMOUNT_TRANSFERRED,p_TRANSACTION_DATE,p_PAYMENT_TYPE, P_PAYEE_FIRST_NAME, P_PAYEE_LAST_NAME );
dbms_output.put_line('Successfully inserted row into PAYMENT_DETAILS');
EXCEPTION 
WHEN DUP_VAL_ON_INDEX THEN
DBMS_OUTPUT.PUT_LINE('Duplicate PAYMENT_ID found');
END PAYMENT_DETAILS;

PROCEDURE MAINTENANCE
(   
    p_REQUEST_ID MAINTENANCE_REQUESTS.REQUEST_ID%TYPE,
    p_APARTMENT_ID MAINTENANCE_REQUESTS.APARTMENT_ID%TYPE,
    p_EMPLOYEE_ID MAINTENANCE_REQUESTS.EMPLOYEE_ID%TYPE,
    p_REQUEST_DATE  MAINTENANCE_REQUESTS.REQUEST_DATE%TYPE
)
AS
BEGIN
dbms_output.put_line('------------------------------------------------------------------------------------------------');
INSERT INTO MAINTENANCE_REQUESTS(REQUEST_ID, APARTMENT_ID, EMPLOYEE_ID, REQUEST_DATE) VALUES(  p_REQUEST_ID, p_APARTMENT_ID, p_EMPLOYEE_ID, p_REQUEST_DATE);
dbms_output.put_line('Successfully inserted row into MAINTENANCE_REQUESTS');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
dbms_output.put_line('DUPLICATE REQUEST_ID NOT ALLOWED!'); 
END MAINTENANCE;

 PROCEDURE UTILITIES
(   
    p_UTILITY_ID UTILITY.UTILITY_ID%TYPE,
    p_UTILITY_NAME UTILITY.UTILITY_NAME%TYPE
)
AS
BEGIN
dbms_output.put_line('------------------------------------------------------------------------------------------------');
INSERT INTO UTILITY VALUES(p_UTILITY_ID,  p_UTILITY_NAME );
dbms_output.put_line('Successfully inserted row into UTILITY');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
dbms_output.put_line('DUPLICATE UTILITY_ID IS NOT ALLOWED!'); 
END UTILITIES;

PROCEDURE APARTMENT_UTILITIES
(   
    p_UTILITY_ID APARTMENT_UTILITY.UTILITY_ID%TYPE,
    p_APARTMENT_ID APARTMENT_UTILITY.APARTMENT_ID%TYPE,
    p_IS_INCLUDED_IN_RENT APARTMENT_UTILITY.IS_INCLUDED_IN_RENT%TYPE
)
AS
   count1 number;
   count2 number;
   foreignkey1 exception;
   foreignkey2 exception;
   foreignkey3 exception;
BEGIN
     dbms_output.put_line('------------------------------------------------------------------------------------------------');
     SELECT COUNT(*) INTO count1 from APARTMENT where upper(p_APARTMENT_ID) like upper(APARTMENT_ID);
     SELECT COUNT(*) INTO count2 from UTILITY where upper(p_UTILITY_ID) like upper(UTILITY_ID);
     IF(count1<=0 and count2<=0) then
        raise foreignkey3;
     ELSE
        IF(count1<=0) then
            raise foreignkey1;
        elsif(count2<=0)then
            raise foreignkey2;
        else
            INSERT INTO APARTMENT_UTILITY VALUES(p_UTILITY_ID, p_APARTMENT_ID, p_IS_INCLUDED_IN_RENT );
            dbms_output.put_line('Successfully inserted row into UTILITY');
        end if;
    END IF;


EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
dbms_output.put_line('DUPLICATE UTILITY_ID IS NOT ALLOWED!'); 
when foreignkey1 then
dbms_output.put_line('ENTERED APARTMENT_ID DOESNT EXIST'); 
when foreignkey2 then
dbms_output.put_line('ENTERED UTILITY_ID DOESNT EXIST');
when foreignkey3 then
dbms_output.put_line('ENTERED APARTMENT_ID AND UTILITY_ID DOESNT EXIST');
END APARTMENT_UTILITIES;

PROCEDURE EMPLOYEES
(
    p_EMPLOYEE_ID EMPLOYEE.EMPLOYEE_ID%TYPE,
    p_ROLE_ID  EMPLOYEE_ROLES.ROLE_ID %TYPE,
    p_EMPLOYEE_FIRST_NAME EMPLOYEE.EMPLOYEE_FIRST_NAME%TYPE,
    p_EMPLOYEE_LAST_NAME EMPLOYEE.EMPLOYEE_LAST_NAME%TYPE,
    p_EMPLOYEE_CONTACT EMPLOYEE.EMPLOYEE_CONTACT%TYPE,
    p_EMPLOYEE_EMAIL EMPLOYEE.EMPLOYEE_EMAIL%TYPE,
    p_EMPLOYEE_APARTMENT_NUMBER EMPLOYEE.EMPLOYEE_APARTMENT_NUMBER%TYPE,
    p_EMPLOYEE_STREET_NAME EMPLOYEE.EMPLOYEE_STREET_NAME%TYPE,
    p_EMPLOYEE_NEIGHBOURHOOD EMPLOYEE.EMPLOYEE_NEIGHBOURHOOD%TYPE,
    p_EMPLOYEE_ZIPCODE EMPLOYEE.EMPLOYEE_ZIPCODE%TYPE

    
)
AS
CNT_EMP NUMBER;
CNT_ROL NUMBER;
FORIEGNKEY10 EXCEPTION;
FORIEGNKEY11 EXCEPTION;
FORIEGNKEY12 EXCEPTION;
BEGIN
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------');

SELECT COUNT(*) INTO CNT_EMP FROM EMPLOYEE WHERE EMPLOYEE_ID =  p_EMPLOYEE_ID;
SELECT COUNT(*) INTO CNT_ROL FROM EMPLOYEE_ROLES WHERE ROLE_ID =  p_ROLE_ID;
 
IF (CNT_EMP>0 AND CNT_ROL <=0) THEN 
RAISE FORIEGNKEY10;
ELSE 
    IF(CNT_EMP >0) THEN
    RAISE FORIEGNKEY11;
    ELSE 
        IF (CNT_ROL <=0 ) THEN
        RAISE FORIEGNKEY12;
        ELSE
            INSERT INTO EMPLOYEE(EMPLOYEE_ID,ROLE_ID,EMPLOYEE_FIRST_NAME,EMPLOYEE_LAST_NAME,EMPLOYEE_CONTACT,EMPLOYEE_EMAIL,EMPLOYEE_APARTMENT_NUMBER,EMPLOYEE_STREET_NAME,
            EMPLOYEE_NEIGHBOURHOOD,EMPLOYEE_ZIPCODE) VALUES (p_EMPLOYEE_ID,p_ROLE_ID,p_EMPLOYEE_FIRST_NAME,p_EMPLOYEE_LAST_NAME,p_EMPLOYEE_CONTACT,p_EMPLOYEE_EMAIL,
            p_EMPLOYEE_APARTMENT_NUMBER,p_EMPLOYEE_STREET_NAME,p_EMPLOYEE_NEIGHBOURHOOD,p_EMPLOYEE_ZIPCODE );
            dbms_output.put_line('Successfully inserted row into EMPLOYEE');
        END IF;
    END IF;
END IF;
EXCEPTION 
WHEN FORIEGNKEY10 THEN
DBMS_OUTPUT.PUT_LINE('ROLE_ID DOES NOT EXISTS AND DUPLICATE EMPLOYEE_ID NOT ALLOWED');
WHEN FORIEGNKEY11 THEN
DBMS_OUTPUT.PUT_LINE('DUPLICATE EMPLOYEE_ID NOT ALLOWED');
WHEN FORIEGNKEY12 THEN
DBMS_OUTPUT.PUT_LINE('ROLE_ID DOES NOT EXISTS');
END EMPLOYEES;

PROCEDURE EMPLOYEE_APARTMENTS
(
    p_APARTMENT_ID APARTMENT.APARTMENT_ID%TYPE,
    p_EMPLOYEE_ID EMPLOYEE.EMPLOYEE_ID%TYPE 
)
AS
CNT_APT NUMBER;
CNT_EMP NUMBER;
FORIEGNKEY3 EXCEPTION;
FORIEGNKEY4 EXCEPTION;
FORIEGNKEY5 EXCEPTION;
BEGIN
dbms_output.put_line('------------------------------------------------------------------------------------------------');

SELECT COUNT(*) INTO CNT_APT FROM APARTMENT WHERE APARTMENT_ID =  p_APARTMENT_ID;
SELECT COUNT(*) INTO CNT_EMP FROM EMPLOYEE WHERE EMPLOYEE_ID =  p_EMPLOYEE_ID;
 
IF (CNT_APT <=0 AND CNT_EMP <=0) THEN 
RAISE FORIEGNKEY5;
ELSE 
    IF(CNT_EMP <=0) THEN
    RAISE FORIEGNKEY4;
    ELSE 
        IF (CNT_APT <=0 ) THEN
        RAISE FORIEGNKEY3;
        ELSE
            INSERT INTO EMPLOYEE_APARTMENT(APARTMENT_ID,EMPLOYEE_ID) VALUES (p_APARTMENT_ID ,p_EMPLOYEE_ID);
            dbms_output.put_line('Successfully inserted row into EMPLOYEE_APARTMENT');
        END IF;
    END IF;
END IF;
EXCEPTION 
WHEN FORIEGNKEY3 THEN
DBMS_OUTPUT.PUT_LINE('APARTMENT_ID DOES NOT EXISTS');
WHEN FORIEGNKEY4 THEN
DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID DOES NOT EXISTS');
WHEN FORIEGNKEY5 THEN
DBMS_OUTPUT.PUT_LINE('APARTMENT_ID AND EMPLOYEE_ID BOTH DOES NOT EXISTS');
END EMPLOYEE_APARTMENTS;

PROCEDURE APARTMENT_TYPES(
P_Locality apartment_type.locality%TYPE,
P_apartment_type apartment_type.apartment_type%TYPE,
P_rooms apartment_type.number_of_rooms%TYPE,
P_bath apartment_type.number_of_baths%TYPE)
as
v_apartment_type apartment_type.apartment_type%TYPE;
v_rooms apartment_type.number_of_rooms%TYPE;
v_bath apartment_type.number_of_baths%TYPE;
v_id apartment_type.apartment_type_id%TYPE;
begin
--select count(apartment_Type_id) into v_id from apartment_type where apartment_type = P_apartment_type and number_of_rooms = P_rooms and number_of_baths = P_bath;
INSERT INTO APARTMENT_TYPE(APARTMENT_TYPE_ID,LOCALITY,APARTMENT_TYPE,NUMBER_OF_ROOMS,NUMBER_OF_BATHS) VALUES 
    (seq_apartment_type_id.nextval ,P_LOCALITY, P_APARTMENT_TYPE,P_rooms, P_bath);
dbms_output.put_line('Successfully inserted row into APARTMENT_TYPE');
--dbms_output.put_line(v_id);
end APARTMENT_TYPES;

PROCEDURE EMPLOYEE_ROLESS
(
    p_ROLE_ID EMPLOYEE_ROLES.ROLE_ID%TYPE,
    p_ROLE_TYPE EMPLOYEE_ROLES.ROLE_TYPE%TYPE 
)
AS
BEGIN
DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
INSERT INTO EMPLOYEE_ROLES(ROLE_ID,ROLE_TYPE) VALUES (p_ROLE_ID , p_ROLE_TYPE);
dbms_output.put_line('Successfully inserted row into EMPLOYEE_ROLES');
EXCEPTION 
WHEN DUP_VAL_ON_INDEX THEN
DBMS_OUTPUT.PUT_LINE('DUPLICATE ROLE_ID IS NOT ALLOWED');
END EMPLOYEE_ROLESS;

 PROCEDURE APARTMENT_SOLD
(
    s_apartment_number apartment.apartment_number%type,
    s_apartment_street_name apartment.apartment_street_name%type
)
as
   v_apt_id apartment.apartment_id%type;
   v_count number(38);
   v_lease_status lease_details.lease_status%type;
Begin
    select  apartment_id into v_apt_id from apartment where apartment.apartment_number=s_apartment_number and upper(apartment_street_name) like upper(s_apartment_street_name);
    select count(lease_status) into v_count from lease_details where lease_details.apartment_id=v_apt_id and lease_status='ON GOING';
    if(v_count=1) then
         update apartment set apartment_status='SOLD' where apartment_id=v_apt_id;
         update lease_details set lease_status='EXPIRED', END_DATE=SYSDATE where lease_details.apartment_id=v_apt_id;
    else 
         update apartment set apartment_status='SOLD' where apartment_id=v_apt_id;
    end if;
Exception 
when no_data_found then 
DBMS_OUTPUT.PUT_LINE('No such Apartment exists');
end apartment_sold;

PROCEDURE LEASE_BREAKAGE
(u_Lease_id lease_details.lease_id%type, 
 u_end_date lease_details.End_date%type
)
as
u_months number;
status varchar2(50);
invalid_date exception;
Begin
   select lease_status into status from lease_details where lease_id=u_Lease_id;
   if(status='ON GOING')then
        update lease_details set end_date=u_end_date where lease_id=u_Lease_id;
        update lease_details set lease_status='EXPIRED' where lease_id=u_Lease_id;
   else 
        --if(status='EXPIRED')then
            raise invalid_date;
        --end if;
   end if;
EXCEPTION 
when invalid_date then 
DBMS_OUTPUT.PUT_LINE('Not on Lease');
end lease_breakage;

PROCEDURE UPDATE_REQ_CLOSED_DATE
(
  REQ_ID MAINTENANCE_REQUESTS.REQUEST_ID%TYPE,
  CLOSED_DATE MAINTENANCE_REQUESTS.REQUEST_CLOSED_DATE%TYPE
)
AS
BEGIN 
    UPDATE  MAINTENANCE_REQUESTS SET REQUEST_CLOSED_DATE=SYSDATE WHERE REQUEST_ID=REQ_ID;
END UPDATE_REQ_CLOSED_DATE;

end insertion;

