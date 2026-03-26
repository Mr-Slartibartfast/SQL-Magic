--https://stackoverflow.com/questions/14783680/sql-pivot-and-string-concatenation-aggregate



DECLARE @MyTempTable TABLE 	([Event Name] varchar(7), [Resource Type] varchar(15), [Resource Name] varchar(11))
;
	
INSERT INTO @MyTempTable
	([Event Name], [Resource Type], [Resource Name])
VALUES
	('Event 1', 'Resource Type 1', 'Resource 1'),
	('Event 1', 'Resource Type 1', 'Resource 2'),
	('Event 1', 'Resource Type 2', 'Resource 3'),
	('Event 1', 'Resource Type 2', 'Resource 4'),
	('Event 1', 'Resource Type 3', 'Resource 5'),
	('Event 1', 'Resource Type 3', 'Resource 6'),
	('Event 1', 'Resource Type 3', 'Resource 7'),
	('Event 1', 'Resource Type 4', 'Resource 8'),
	('Event 2', 'Resource Type 5', 'Resource 1'),
	('Event 2', 'Resource Type 2', 'Resource 3'),
	('Event 2', 'Resource Type 3', 'Resource 11'),
	('Event 2', 'Resource Type 3', 'Resource 12'),
	('Event 2', 'Resource Type 3', 'Resource 13'),
	('Event 2', 'Resource Type 4', 'Resource 14'),
	('Event 2', 'Resource Type 5', 'Resource 9'),
	('Event 2', 'Resource Type 5', 'Resource 16')
;





	  SELECT  e.[Event Name]
	  ,e.[Resource Type]
	  ,r.ResourceName
	 -- ,e.[Resource Type]
	--	,LEFT(r.ResourceName , LEN(r.ResourceName)-1) ResourceName
	  FROM @MyTempTable e
	  CROSS APPLY
	  (

		  SELECT r.[Resource Name] + ', '
		  FROM @MyTempTable r
 		  where e.[Event Name] = r.[Event Name]
 		   and e.[Resource Type] = r.[Resource Type]
		  FOR XML PATH('')

	  ) r (ResourceName)


