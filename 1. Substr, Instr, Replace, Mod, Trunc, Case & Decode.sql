-- 1.    Display the first name and last name concatenated into a single column, separated by a space, and label the column as Full Name.
select first_name || ' ' || last_name as Full_Name
from EMPLOYEES 
 
 -- 2.    Retrieve the last name, department ID, and salary for employees whose department ID is either 50 or 60, and whose salary is greater than $5000.
 select LAST_NAME,SALARY, DEPARTMENT_ID
 from EMPLOYEES
 where DEPARTMENT_ID in (50,60)
 and SALARY >5000
 
 -- 3. Find all employees whose job id contains the word 'Mgr' (case insensitive).
 select *
 from EMPLOYEES
 where lower(JOB_ID) like lower('%Mgr%')
 
 --  4.  Show the last name and email address of employees whose email ends with 'oracle.com'. ( update data to check your answer )
select LAST_NAME, EMAIL 
from EMPLOYEES
where email like lower ('%@oracle.com')
-------
select LAST_NAME, EMAIL 
from EMPLOYEES
where substr(email, instr(email, '@' ) + 1 ) = 'oracle.com' 

-- 5.  List the first name, job ID, and salary for employees whose salary is between $3000 and $6000 and whose job ID is not IT_PROG.
select FIRST_NAME, JOB_ID, SALARY
from EMPLOYEES
where salary between 3000 and 6000
and JOB_ID != 'IT_PROG'

-- 6. Display the first and last name of employees who do not have any commission set
select FIRST_NAME ,LAST_NAME
from EMPLOYEES
where COMMISSION_PCT is null

-- 7.  Display the first character of the first name and the first character of the last name as initials, separated by a period (.), for all employees.
select substr(first_name, 1,1) || '.' || substr(last_name, 1,1) as Initials
from EMPLOYEES

-- 8. Replace all dots (.) in phone numbers with hyphens ('-') in the phone_number column.
select PHONE_NUMBER,  replace(PHONE_NUMBER, '.', '-')
from EMPLOYEES

-- 9. Extract the last word ( after _ ) from the job_title columns of each employee from table jobs
select JOB_TITLE,JOB_ID, substr(JOB_ID, instr(JOB_ID, '_') +1)
from jobs

-- 10. Display all employees whose emp id is odd.
select *
from EMPLOYEES
where  mod(EMPLOYEE_ID, 2) =1

-- 11. How many filled boxes will we need for 176 bottles – if box capacity = 6 And show if there are remaining bottles after filling those boxes
select trunc(176 / 6) as FullBoxes, mod(176, 6) as RemainingBottles
from dual

-- 12. Write a query that displays the grade of all employees based on the value of the column JOB ID, as per the table shown below using case, decode
select JOB_ID,
    case JOB_ID
        when 'AD_ASST' then 'A'
        when 'IT_PROG' then 'B'
        when 'SA_REP'  then 'C'
        when 'FI_MGR' then 'D'
        else 'F'
    end as Grade
       

from EMPLOYEES
-----------------
 select JOB_ID, decode(JOB_ID, 'AD_ASST', 'A', 'IT_PROG' , 'B', 'SA_REP' , 'C', 'FI_MGR', 'D', 'F') as Grade
 from EMPLOYEES
