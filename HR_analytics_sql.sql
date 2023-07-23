create database hr;

use hr;

select * from hrs ;

desc hrs;
alter table hrs change column  ï»¿id emp_id varchar(20) null;
update hrs 
set birthdate = case 
       when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
       when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table hrs modify column birthdate date;


update hrs 
set hire_date = case 
       when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
       when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table hrs modify column hire_date date;
desc hrs;

update hrs 
set termdate = date(str_to_date(termdate,'%Y-%m-%d  %H:%i:%s UTC'))
where termdate is not null and termdate !='';

update hrs set termdate = null 
where termdate ='';

alter table hrs add column age int;

select * from hrs;

update hrs 
set age = timestampdiff(Year, birthdate,curdate())

select min(age) , max(age) from hrs; 

-- quesions  what is the gender breakdown of emp in the company

select gender,  count(*) as count from hrs where termdate is null  group by gender;

-- 2 what is the race breakdown of emp in the company 

 select race , count(*) as count from hrs where termdate  is null group by race;
 
 -- 3.  what is the age dirtribution of emp 
 
 select 
   case when  age >= 18 and age<=24 then '18-24'
       when age >= 25 and age<= 34 then '25-34'
       when age >= 35 and age <= 44 then '35-44'
	  when age >= 45 and age <= 24 then '45-54'
      when age >= 55 and age<= 64 then '55-64'
      else'65+'
      end as age_group,
      count(*) as count
      from hrs 
      where termdate is null 
      group by age_group
      order by age_group;
 
 
 -- 4 how many emp work at HQ vs remote
      
      select location, count(*) as count from hrs  where termdate is null group by location;
      
      -- 5. what is the average length of emp who have been terminated 
      
      select round (avg(year(termdate) - year(hire_date)),0) as length_of_emp from  hrs where termdate is not null  and termdate <=curdate();
      
      
      -- 6 how does the gender distribution vary across dept and job titles 
      
      select * from hrs;
	
      select department, jobtitle, gender,count(*) as count
      from hrs
      where termdate is not null 
      group by department, jobtitle, gender
      order by department, jobtitle, gender;
      
      select department, gender,count(*) as count
      from hrs
      where termdate is not null 
      group by department,  gender
      order by department, gender;
      
      -- 7 what is the distribution of jovbtitle across the country
      
      select jobtitle, count(*) as count from hrs
      where termdate is not null group by jobtitle;
      
      select * from hrs;
	
      select department, jobtitle, gender,count(*) as count
      from hrs
      where termdate is not null 
      group by department, jobtitle, gender
      order by department, jobtitle, gender;
      
      select department ,count(*) as count
      from hrs

      group by department
      
      
      -- 8  which dept has higher turnover/ termination rate 
      
      select  
       department, count(*) as total_count, 
           count(case 
            when termdate is not null and termdate <= curdate() then 1 end ) as terminated_count,
            round((count(case 
            when termdate is not null and termdate <= curdate() then 1 end)/ count(*))*100,2) as termination_rate
              from hrs 
			group by department 
            order by termination_rate desc;
      
      
      -- 9  what is distribution of emp across loaction state 
      
      select location_state, count(*) as count from hrs 
      where termdate is not null 
      group by location_state;
       
       
       -- 10 how has  the company emp count changed  count changed over time based om hire and termination date 
       
       select year, hires, terminations, hires-terminations as net_change, (terminations/hires)*100 as change_percent
       from(
             select year(hire_date) as year, 
             count(*) as hires, 
             sum(case
                   when termdate is not null and termdate <= curdate() then 1 
                   end) as terminations
			from hrs
            group by year(hire_date)) as subquery 
group by year
order by year ;          

-- 11 what is the tenure distribution for each deapt

select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
 from hrs 
 where termdate is not null and termdate <=curdate()
 group by department; 