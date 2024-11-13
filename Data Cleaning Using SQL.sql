Create database project;
use project;

select * from hr;

set sql_safe_updates = 0;
select birthdate, hire_date, age, termdate, timestampdiff(year, birthdate, hire_date),
     (case
     when termdate is null then null
     else round(timestampdiff(month,hire_date,termdate)/12,0)
     end) as Tenure
from hr;

alter table hr add column tenure int;
update hr
set tenure = case
     when termdate is null then round(TIMESTAMPDIFF(month, hire_date, CURDATE())/12,0)
     else round(timestampdiff(month,hire_date,termdate)/12,0)
     end;

alter table hr add column tenure_distribution varchar(20);
select birthdate, hire_date, termdate, tenure, age, age_groups,
case when tenure <=1 then '<1'
	 when tenure >1 and tenure <=5 then '2-5'
     when tenure >6 and tenure <=10 then '6-10'
     when tenure >11 and tenure <=15 then '11-15'
     when tenure >16 and tenure <= 20 then '16-20'
     when tenure > 20 then '>20'
     else null
     end as tenure_designation
     from hr;
    
update hr
set tenure_distribution = case
	 when tenure is null then null
	 when tenure <=1 then '<=1'
	 when tenure >1 and tenure <=5 then '2-5'
     when tenure >=6 and tenure <=10 then '6-10'
     when tenure >=11 and tenure <=15 then '11-15'
     when tenure >=16 and tenure <= 20 then '16-20'
     when tenure >20 then '>20'
     else null
     end;
     
select hire_date, termdate, tenure, tenure_distribution from hr
where tenure is null;
     
alter table hr change ï»¿id emp_id varchar(20) null;

update hr
set birthdate = date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d');

alter table hr
modify column birthdate date;


update hr
set hire_date = date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d');

alter table hr
modify column hire_date date;

select
termdate, date_format(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'),'%Y-%m-%d')
from hr
;

update hr
set termdate = date_format(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'),'%Y-%m-%d')
where termdate is not null and termdate != '';

update hr
set termdate = null
where termdate ='';

alter table hr
modify column termdate date;

describe hr;

alter table hr add column age int;
alter table hr add column age_groups varchar(20);
select * from hr;

update hr
set age = timestampdiff(year,birthdate,curdate());

update hr
set age_groups =case 
	when age >=20 and age <= 25 then '20-25'
	when age >=26 and age <= 30 then '26-30'
	when age >=31 and age <= 35 then '31-35'
	when age >=36 and age <= 40 then '36-40' 
	when age >=41 and age <= 45 then '41-45'
	when age >=46 and age <= 50 then '46-50'
	when age >=51 and age <= 55 then '51-55'
	when age >=56 and age <= 60 then '56-60'
    when age >60 then '60+'
    else null
    end;

select age, tenure from hr
where tenure is not null;


select (age - tenure) from hr
where tenure is not null and (age - tenure) < 18;

DELETE FROM hr
WHERE (age - tenure) < 17;

select min(age), max(age) from hr;  ##22 & 59

select hire_date,termdate from hr
where termdate > curdate();

update hr
set termdate = null
where termdate > curdate();


select * from hr;
#Questions

#1.What is the gender breakdown of the employees in the company? --Still working.

select
gender,
count(*)
from hr
where termdate is null
group by gender
order by count(*) desc;

#2.What is the race/ethnicity breakdown of the employees in the company? --Still working.

select
race,
count(*)
from hr
where termdate is null
group by race
order by count(*) desc;


#3. What is the age distribution of employees in the company?
select
min(age) as Youngest,
max(age) as Oldest
from hr
where termdate is null;

select
age_groups,
count(*)
from hr
where termdate is null
group by age_groups;

#4. How many employees work at headquarters versus remote locations

select
location,
count(*)
from hr
where termdate is null
group by location;


#5. average length of employement of employees who have been terminated?

select
round(avg(timestampdiff(year, hire_date, termdate)),2) as Avg_employement_years
from hr
where termdate is not null;

#6 How does gender distribution varies across departments and job titles?
select
department,
jobtitle,
gender,
count(*)
from hr
group by 
department,
jobtitle,
gender;



#7.distribution of jobtitles across the companny?
select
	jobtitle,
    count(*) 
from hr
where termdate is not null
group by
	jobtitle;

#8. which department has highest turnover rate


select
department,
count(*) as total_count,
count(termdate) as terminated_count,
count(termdate)/count(*) as termination_rate
from hr
group by department
order by termination_rate desc;

select count(*) from hr
where termdate is not null;

#9 Distribution of employees across locations by city and state

select
location_city,
location_state,
count(*)
from hr
where termdate is not null
group by location_city,
		 location_state
order by count(*) desc;

#10 How has the company's employee count changed based on the hiredate and termdate.

select
sq.yr,
sq.Hires,
sq.tnd,
(sq.hires-sq.tnd) as net_change,
round((1-sq.tnd/sq.hires)*100,1) as 'Percent_change'
from (select
year(hire_date) as Yr,
count(*) as Hires,
count(termdate) as tnd
from hr
group by
	year(hire_date)) as sq;
    
#11.What is the tenure distribution for each department.
select 
	department,
    count(*),
    round(avg(timestampdiff(year,hire_date, termdate)),1) avg_tenure_yr
from hr
where termdate is not null
group by department;




select * from hr 
where tenure_distribution is null;
    






