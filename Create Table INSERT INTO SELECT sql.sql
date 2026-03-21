USE [WorldEconomicData]
GO

/****** Object:  Table [dbo].[UK_economic_data]    Script Date: 3/21/2026 1:43:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UK_economic_data]( 
	[SysRecId] [int] IDENTITY(1,1) NOT NULL, -- This identity column creates a unique identifier that auto-increments with each new record -- VERY helpful in indexes
	[country] [varchar](max) NULL,
	[year] [bigint] NULL,
	[iso_code] [varchar](max) NULL,
	[population] [bigint] NULL,
	[gdp] [float] NULL,
	[gdp_per_capita] [float] NULL,
	[poverty_rate] [float] NULL,
	[gini_index] [float] NULL,
	[income_top1] [float] NULL,
	[income_top10] [float] NULL,
	[income_bottom50] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


INSERT INTO [WorldEconomicData].[dbo].[UK_economic_data](
      [country] -- Notice here that I left out the SysRecId column - you cannot INSERT into an IDENTITY column without first turning on IDENTITY INSERT = ON, but I allow the identity column to auto populated
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
  FROM [WorldEconomicData].[dbo].[world_economic_data] -- selects data to populate the UK table from the world data table using a WHERE filter (below)
  WHERE country='United Kingdom'
