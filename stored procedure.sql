-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE dbo.update_economic_data
	-- Add the parameters for the stored procedure here

--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @extract_date datetime2(7) = getutcdate()
    -- Insert statements for procedure here
;WITH existing_years as (
    SELECT --[Extract_DateTime_UTC]
      existing.[country]
      ,existing.[year]
      ,existing.[iso_code]
      ,existing.[population]
      ,existing.[gdp]
      ,existing.[gdp_per_capita]
      ,existing.[poverty_rate]
      ,existing.[gini_index]
      ,existing.[income_top1]
      ,existing.[income_top10]
      ,existing.[income_bottom50]
      FROM [WorldEconomicData].[dbo].[world_economic_data] new      
      LEFT JOIN [WorldEconomicData].[dbo].[CA_economic_data] existing
        ON new.year=existing.year
      WHERE new.country='Canada'
)
DELETE FROM existing
FROM [WorldEconomicData].[dbo].[CA_economic_data] existing
LEFT JOIN existing_years 
    ON existing.year=existing_years.year
WHERE existing.Extract_DateTime_UTC < @extract_date;
WITH new_data AS (
	SELECT [country]
      ,[year]
      ,[iso_code]
      ,[population]
      ,[gdp]
      ,[gdp_per_capita]
      ,[poverty_rate]
      ,[gini_index]
      ,[income_top1]
      ,[income_top10]
      ,[income_bottom50]
      ,ROW_NUMBER() over (partition by [country] order by [year] desc) as rn
  FROM [WorldEconomicData].[dbo].[world_economic_data]
)
INSERT INTO [WorldEconomicData].[dbo].[CA_economic_data](
[Extract_DateTime_UTC]
      ,[country]
      ,[year]
      ,[iso_code]
      ,[population]
      ,[gdp]
      ,[gdp_per_capita]
      ,[poverty_rate]
      ,[gini_index]
      ,[income_top1]
      ,[income_top10]
      ,[income_bottom50])
SELECT @extract_date [Extract_DateTime_UTC]
      ,new.[country]
      ,new.[year]
      ,new.[iso_code]
      ,new.[population]
      ,new.[gdp]
      ,new.[gdp_per_capita]
      ,new.[poverty_rate]
      ,new.[gini_index]
      ,new.[income_top1]
      ,new.[income_top10]
      ,new.[income_bottom50]
      FROM new_data new
      WHERE country='Canada'
     


END
GO
