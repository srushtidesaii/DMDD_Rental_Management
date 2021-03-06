---INDEXES---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TO REDUCE THE TIME TAKEN TO SEARCH FOR THE UTILITIES INCLUDED IN RENT

CREATE INDEX INDEX_APARTMENT_UTILITY
ON APARTMENT_UTILITY(IS_INCLUDED_IN_RENT);

SELECT APARTMENT.APARTMENT_ID, APARTMENT_UTILITY.UTILITY_ID, UTILITY.UTILITY_NAME FROM APARTMENT
JOIN APARTMENT_UTILITY ON APARTMENT.APARTMENT_ID=APARTMENT_UTILITY.APARTMENT_ID
JOIN UTILITY ON APARTMENT_UTILITY.UTILITY_ID=UTILITY.UTILITY_ID
WHERE APARTMENT_UTILITY.IS_INCLUDED_IN_RENT= 'Yes' order by utility.utility_id,apartment.apartment_id;