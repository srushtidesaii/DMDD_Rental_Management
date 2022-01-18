----To track the payment of the apartments for the current month-----

SELECT APARTMENT.APARTMENT_ID, LEASE_DETAILS.LEASE_ID, to_char(sysdate,'Month') as CURRENT_MONTH, PAYMENT.TRANSACTION_DATE, 
PAYMENT.PAYMENT_ID, PAYMENT.AMOUNT_TRANSFERRED, PAYMENT.PAYEE_FIRST_NAME,PAYMENT.PAYEE_LAST_NAME FROM APARTMENT 
JOIN LEASE_DETAILS ON APARTMENT.APARTMENT_ID=LEASE_DETAILS.APARTMENT_ID 
JOIN PAYMENT ON LEASE_DETAILS.LEASE_ID=PAYMENT.LEASE_ID
WHERE (to_char(transaction_date, 'mm') = to_char(sysdate, 'mm')
and to_char(transaction_date, 'yyyy') = to_char(sysdate, 'yyyy'));



----To track the total number of maintenance requests raised for a particular apartment------
select distinct maintenance_requests.apartment_id, 
COUNT(maintenance_requests.request_id) AS Total_no_of_requests
from maintenance_requests
group by maintenance_requests.apartment_id
order by TO_NUMBER(SUBSTR(maintenance_requests.apartment_id,2)), Total_no_of_requests desc;


---Total commission earned by real estate management in each year assuming commission to be 20% of the total revenue generated as a monthly rent from customers by each year-------
with t as (
            select extract ( year from payment.transaction_date) as year,  
            sum(payment.amount_transferred)  OVER (PARTITION BY extract ( year from payment.transaction_date)) as total_revenue_generated,
            COUNT(lease_details.lease_id) OVER (PARTITION BY extract ( year from payment.transaction_date)) AS Total_no_of_apartments_on_lease 
            from lease_details
            join
            payment
            on lease_details.lease_id = payment.lease_id
            )
select DISTINCT YEAR, 0.2*total_revenue_generated as total_commission_earned
from t 
order by year;

-- To find the number of apartments booked based on the particular locality for each year--
select distinct apartment_type.locality, extract (year from lease_details.start_date) as lease_start_date,
count(apartment_type.locality) over (partition by  apartment_type.locality,extract (year from lease_details.start_date)) as total_no_of_apartment
from apartment_type
join 
apartment
on apartment_type.apartment_type_id=apartment.apartment_type_id
join
lease_details
on apartment.apartment_id = lease_details.apartment_id
order by total_no_of_apartment desc;


---Which employees are working hard to close the maintenance requests as fast as possible----
select maintenance_requests.apartment_id, maintenance_requests.request_id, maintenance_requests.request_date, maintenance_requests.request_closed_date,
employee.employee_first_name, employee.employee_last_name,
to_date(maintenance_requests.request_closed_date)-to_date(maintenance_requests.request_date) as tot_no_of_days
from 
maintenance_requests
join 
employee
on maintenance_requests.employee_id = employee.employee_id
order by tot_no_of_days;


--SELECT * FROM PAYMENT;
