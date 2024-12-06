USE [master]
GO
/****** Object:  Database [ITI_Sql_Project]    Script Date: 3/30/2024 3:04:34 PM ******/
CREATE DATABASE [ITI_Sql_Project]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ITI_Sql_Project', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ITI_Sql_Project.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ITI_Sql_Project_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ITI_Sql_Project_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ITI_Sql_Project] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ITI_Sql_Project].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ITI_Sql_Project] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET ARITHABORT OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ITI_Sql_Project] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ITI_Sql_Project] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ITI_Sql_Project] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ITI_Sql_Project] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET RECOVERY FULL 
GO
ALTER DATABASE [ITI_Sql_Project] SET  MULTI_USER 
GO
ALTER DATABASE [ITI_Sql_Project] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ITI_Sql_Project] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ITI_Sql_Project] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ITI_Sql_Project] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ITI_Sql_Project] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ITI_Sql_Project] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ITI_Sql_Project', N'ON'
GO
ALTER DATABASE [ITI_Sql_Project] SET QUERY_STORE = ON
GO
ALTER DATABASE [ITI_Sql_Project] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ITI_Sql_Project]
GO
/****** Object:  Rule [GenderRule]    Script Date: 3/30/2024 3:04:34 PM ******/
CREATE RULE [dbo].[GenderRule] 
AS
@gender in('Male', 'Female')
GO
/****** Object:  Rule [Married]    Script Date: 3/30/2024 3:04:34 PM ******/
CREATE RULE [dbo].[Married] 
AS
@married IN ('Yes', 'No')
GO
/****** Object:  Rule [Offer_rule]    Script Date: 3/30/2024 3:04:34 PM ******/
CREATE RULE [dbo].[Offer_rule] 
AS
@offer IN ('None', 'A', 'B', 'C', 'D', 'E', 'Coupon')
GO
/****** Object:  Rule [Phone_Service_Rule]    Script Date: 3/30/2024 3:04:34 PM ******/
CREATE RULE [dbo].[Phone_Service_Rule] 
AS
@Phone_Service IN ('Yes', 'No')
GO
/****** Object:  UserDefinedFunction [dbo].[HighestChurnRateFunc]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[HighestChurnRateFunc]()
RETURNS @T TABLE
(
  Customer_Status NVARCHAR(50),
  churned_customers INT,
  churn_rate DECIMAL(10, 2)
)
AS
BEGIN
  INSERT INTO @T (Customer_Status, 
                  churned_customers, 
                  churn_rate)
  SELECT 
     s.Customer_Status,
    count(*) AS [Number oF Customers],
    (CAST(
        COUNT(*) AS DECIMAL(10, 2)) 
        / (SELECT COUNT(*) FROM Status)
        ) * 100 AS [Rate]
  FROM
    Status s
  JOIN
    Demographics d 
    ON s.CustomerID = d.CustomerID
  JOIN
    Location l 
    ON d.Zip_Code = l.Zip_Code
  GROUP BY
    s.Customer_Status;

  RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[HighestStateRateFunc]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--To answer question number 13
CREATE   FUNCTION [dbo].[HighestStateRateFunc]()
RETURNS @T TABLE
(
  Customer_Status NVARCHAR(50),
  Number_of_Customers INT,
  Rate DECIMAL(10, 2)
)
AS
BEGIN
  INSERT INTO @T (Customer_Status, 
                  Number_of_Customers, 
                  Rate)
  SELECT 
     s.Customer_Status,
    count(*) AS [Number oF Customers],
    (CAST(
        COUNT(*) AS DECIMAL(10, 2)) 
        / (SELECT COUNT(*) FROM Status)
        ) * 100 AS [Rate]
  FROM
    Status s
  JOIN
    Demographics d 
    ON s.CustomerID = d.CustomerID
  JOIN
    Location l 
    ON d.Zip_Code = l.Zip_Code
  GROUP BY
    s.Customer_Status;

  RETURN;
END;
GO
/****** Object:  Table [dbo].[Demographics]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Demographics](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[Gender] [varchar](6) NULL,
	[Age] [int] NULL,
	[Senior_Citizen]  AS (case when [Age]>=(65) then 'Yes' else 'No' end),
	[Married] [varchar](3) NULL,
	[Number_of_Dependents] [int] NULL,
	[Zip_Code] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[Zip_Code] [int] NOT NULL,
	[Country] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[City] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Zip_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[CustomerID] [int] NOT NULL,
	[Quar] [varchar](3) NOT NULL,
	[Tenure_in_Months] [int] NULL,
	[Offer] [varchar](6) NULL,
	[Phone_Service] [varchar](3) NULL,
	[Internet_Service] [varchar](11) NULL,
	[Streaming_TV] [varchar](3) NULL,
	[Streaming_Movies] [varchar](3) NULL,
	[Streaming_Music] [varchar](3) NULL,
	[Avg_Monthly_GB_Download] [float] NULL,
	[Contract] [varchar](25) NULL,
	[Payment_Method] [varchar](25) NULL,
	[Monthly_Charge] [decimal](10, 2) NULL,
	[Total_Charges]  AS ([Monthly_Charge]*[Tenure_in_Months]) PERSISTED,
 CONSTRAINT [PrimaryKey] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[Quar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[city_tenure_consumption]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[city_tenure_consumption](city, state, country, average_tenure, average_consumption)
AS
	SELECT l.city, l.state, l.country, 
           AVG(s.Tenure_in_Months) AS 'Average Tenure in Month', 
           AVG(s.Avg_Monthly_GB_Download) AS 'Average OF Consumption' 
	FROM 
        Location l, Demographics d, Service s
	WHERE 
        l.Zip_Code = d.Zip_Code AND d.CustomerID = s.CustomerID
	GROUP BY 
        l.city, l.state, l.country

GO
/****** Object:  Table [dbo].[Status]    Script Date: 3/30/2024 3:04:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[CustomerID] [int] NOT NULL,
	[Quar] [varchar](3) NOT NULL,
	[Satisfaction_Score] [int] NULL,
	[Customer_Status] [varchar](10) NULL,
	[Churn_Category] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[Quar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
