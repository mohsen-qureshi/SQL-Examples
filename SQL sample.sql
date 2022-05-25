SELECT DATE_FORMAT("Membershipsstatsview"."recorddate", '%Y-%m') AS "Month",
       COUNT(DISTINCT "Membershipsstatsview"."employerid") AS "Employers",
       SUM("Membershipsstatsview"."eligible") AS "Eligible",
       SUM("Membershipsstatsview"."insystem") AS "Insystem",
       SUM("Membershipsstatsview"."enrolled") AS "Enrolled",
       SUM("Membershipsstatsview"."enrolledworking") AS "Enrolled Working",
       SUM("Membershipsstatsview"."activeusers") AS "Actives",
       SUM("Membershipsstatsview"."deactivated") AS "Deactivated",
       SUM("Membershipsstatsview"."maus") AS "MAUs"
FROM "perceptdatalake"."membershipsstatsview" AS "Membershipsstatsview"
WHERE ("Membershipsstatsview"."recorddate" >= CAST({DATERANGE.START} AS DATE)
       AND "Membershipsstatsview"."recorddate" < CAST({DATERANGE.END} AS DATE)
       AND {ENVIRONMENT.IN('"Membershipsstatsview"."env"')}
	   AND (DAY("Membershipsstatsview"."recorddate")=1
			AND {EMPLOYER.IN('"Membershipsstatsview"."EmployerName"')}
	  
		   )
	  )
GROUP BY DATE_FORMAT("Membershipsstatsview"."recorddate", '%Y-%m')
ORDER BY "Month" ASC
LIMIT 1000


################################################################################




SELECT "Cardapplicationsviewv2"."authaccountid" AS "Authaccountid",
       "Cardapplicationsviewv2"."maskedcardnumber" AS "CardNumber",
	   DATE_FORMAT("Cardapplicationsviewv2"."dateapplied", '%Y-%m-%d') AS "DateApplied",
       "Cardapplicationsviewv2"."firstname" AS "FirstName",
       "Cardapplicationsviewv2"."lastname" AS "LastName",
	   "Cardapplicationsviewv2"."employername" AS "EmployerName",
	   "Cardapplicationsviewv2"."mobilenumber",
       "Cardapplicationsviewv2"."physicalcardactivateddatetime" AS "PhysicalCardActivationDate",
	   b.referredcampaignname
FROM "datalake"."cardapplicationsviewv2" AS "Cardapplicationsviewv2"
inner join datalake.lvlyusersview b on ("Cardapplicationsviewv2"."authaccountid"=b.authaccountid)
WHERE ("Cardapplicationsviewv2"."dateapplied" BETWEEN CAST({CALENDAR.START} AS DATE) AND CAST({CALENDAR.END} AS DATE)
       AND "Cardapplicationsviewv2"."applicationstatus" IN ('Approved')
       AND "Cardapplicationsviewv2"."maskedcardnumber" NOT IN ('') and b.authaccountid > 0  AND {CAMPAIGN.IN('b.referredcampaignname')})
GROUP BY "Cardapplicationsviewv2"."authaccountid",
         DATE_FORMAT("Cardapplicationsviewv2"."dateapplied", '%Y-%m-%d'),
         "Cardapplicationsviewv2"."maskedcardnumber",
         "Cardapplicationsviewv2"."firstname",
         "Cardapplicationsviewv2"."lastname",
         "Cardapplicationsviewv2"."physicalcardactivateddatetime",
		 "Cardapplicationsviewv2"."employername" ,
		 b.referredcampaignname, 
		 "Cardapplicationsviewv2"."mobilenumber"
ORDER BY "DateApplied" ASC
LIMIT 1000000
