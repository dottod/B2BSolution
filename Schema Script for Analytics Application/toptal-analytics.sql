/****** Object:  Database [toptal-analytics]    Script Date: 07-04-2021 20:38:06 ******/
CREATE DATABASE [toptal-analytics]  (EDITION = 'Standard', SERVICE_OBJECTIVE = 'S0', MAXSIZE = 250 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [toptal-analytics] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [toptal-analytics] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [toptal-analytics] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [toptal-analytics] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [toptal-analytics] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [toptal-analytics] SET ARITHABORT OFF 
GO
ALTER DATABASE [toptal-analytics] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [toptal-analytics] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [toptal-analytics] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [toptal-analytics] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [toptal-analytics] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [toptal-analytics] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [toptal-analytics] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [toptal-analytics] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [toptal-analytics] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [toptal-analytics] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [toptal-analytics] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [toptal-analytics] SET  MULTI_USER 
GO
ALTER DATABASE [toptal-analytics] SET ENCRYPTION ON
GO
ALTER DATABASE [toptal-analytics] SET QUERY_STORE = ON
GO
ALTER DATABASE [toptal-analytics] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Schema [stg]    Script Date: 07-04-2021 20:38:07 ******/
CREATE SCHEMA [stg]
GO
/****** Object:  Table [dbo].[logs]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logs](
	[records] [varchar](max) NULL,
	[EventProcessedUtcTime] [varchar](max) NULL,
	[PartitionId] [varchar](max) NULL,
	[EventEnqueuedUtcTime] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_realtime_logs]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_realtime_logs] As
select distinct
json_value(value,'lax $.properties.CsUsername') as UserName,
cast(json_value(value,'lax $.time') as datetime2) as Time, 
json_value(value,'lax $.properties.CIp')  as Ip,
EventProcessedUtcTime
from 
logs a
outer apply 
OPENJSON(
a.records
, 'lax $') 
b 
GO
/****** Object:  Table [dbo].[companies]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[companies](
	[cuit] [int] IDENTITY(1000,1) NOT NULL,
	[company_name] [varchar](200) NOT NULL,
	[phone] [varchar](20) NULL,
	[email] [varchar](300) NULL,
	[billing_address] [varchar](300) NULL,
	[postal_code] [numeric](10, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[cuit] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customers]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customers](
	[customer_id] [int] IDENTITY(700,1) NOT NULL,
	[document_number] [int] NOT NULL,
	[full_name] [varchar](100) NOT NULL,
	[dob] [datetime] NOT NULL,
	[phone] [varchar](20) NULL,
	[email] [varchar](50) NULL,
	[billing_address] [varchar](300) NULL,
	[postal_code] [numeric](10, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[error]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[error](
	[error_name] [varchar](70) NULL,
	[created_date] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactOrderDetails]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactOrderDetails](
	[order_id] [bigint] NULL,
	[supplier_id] [bigint] NULL,
	[purchaser_id] [bigint] NULL,
	[payment_type] [smallint] NULL,
	[created_date] [date] NULL,
	[quantity] [int] NULL,
	[transaction_amount] [money] NULL,
	[order_status] [varchar](70) NULL,
	[cuit] [bigint] NULL,
	[productid] [bigint] NULL,
	[source] [varchar](40) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[logs_analysis]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logs_analysis](
	[UserName] [varchar](500) NULL,
	[Time] [datetime] NULL,
	[IP] [varchar](70) NULL,
	[processedTime] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[marketing]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[marketing](
	[Id] [bigint] NULL,
	[Quote_Product_id] [bigint] NULL,
	[Quote_Price] [bigint] NULL,
	[Quote_Value] [numeric](10, 2) NULL,
	[Sale_flag] [smallint] NULL,
	[Order_Id] [bigint] NULL,
	[Customer_Id] [int] NULL,
	[Company_Id] [int] NULL,
	[Created_Date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_status]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_status](
	[order_id] [bigint] NULL,
	[order_status] [varchar](30) NULL,
	[created_time] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [bigint] IDENTITY(23456700,7) NOT NULL,
	[supplier_id] [int] NULL,
	[person_id] [int] NULL,
	[company_id] [int] NULL,
	[payment_type] [varchar](30) NULL,
	[created_time] [datetime] NULL,
	[modified_time] [datetime] NULL,
	[quantity] [int] NULL,
	[transaction_amount] [numeric](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[products]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[product_id] [int] IDENTITY(200,1) NOT NULL,
	[product_name] [varchar](400) NULL,
	[product_description] [varchar](400) NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[suppliers]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[suppliers](
	[supplier_id] [int] NULL,
	[cuit] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[price] [numeric](18, 2) NOT NULL,
	[last_modified] [datetime] NULL,
	[validFrom] [datetime] NOT NULL,
	[validTill] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [stg].[marketing]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [stg].[marketing](
	[Id] [bigint] NULL,
	[Quote_Product_id] [bigint] NULL,
	[Quote_Price] [bigint] NULL,
	[Quote_Value] [numeric](10, 2) NULL,
	[Sale_flag] [smallint] NULL,
	[Order_Id] [bigint] NULL,
	[Customer_Id] [int] NULL,
	[Company_Id] [int] NULL,
	[Created_Date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [stg].[orders]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [stg].[orders](
	[order_id] [bigint] IDENTITY(23456700,7) NOT NULL,
	[supplier_id] [int] NULL,
	[person_id] [int] NULL,
	[company_id] [int] NULL,
	[payment_type] [varchar](30) NULL,
	[created_time] [datetime] NULL,
	[modified_time] [datetime] NULL,
	[quantity] [int] NULL,
	[transaction_amount] [numeric](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [stg].[suppliers]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [stg].[suppliers](
	[supplier_id] [int] IDENTITY(5000,1) NOT NULL,
	[cuit] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[price] [numeric](18, 2) NOT NULL,
	[last_modified] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[suppliers] ADD  DEFAULT (CONVERT([date],getdate())) FOR [validFrom]
GO
ALTER TABLE [dbo].[suppliers] ADD  DEFAULT (CONVERT([date],'9999-12-31')) FOR [validTill]
GO
ALTER TABLE [stg].[orders] ADD  DEFAULT ('Cash on Delivery') FOR [payment_type]
GO
ALTER TABLE [stg].[orders] ADD  DEFAULT (getdate()) FOR [modified_time]
GO
/****** Object:  StoredProcedure [dbo].[FactMarketingInsert]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[FactMarketingInsert] AS 
	insert into FactOrderDetails
	select a.order_id,
		b.supplier_id,
		a.customer_id as purchaser_id,
		Null as payment_type,
		cast(a.Created_Date as date) as created_time,
		Cast(quote_value/Quote_Price as int) quantity,
		a.Quote_Value as transaction_amount,
		'Sold by Marketing' order_status,
		b.cuit,
		b.product_id,
		'market' as source	
		from (select * from stg.marketing  where Order_Id is not null)a inner join 
			(
				SELECT supplier_ID,cuit,product_id,price,validTill,validFrom  FROM 
				suppliers a where validTill = (select max(validTill) from suppliers where supplier_id = a.supplier_id)
			)
		b on a.Company_ID = b.cuit
		and a.Quote_product_ID = b.product_id;
		
;
GO
/****** Object:  StoredProcedure [dbo].[FactOrdersInsert]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[FactOrdersInsert] AS 

	INSERT into factorderdetails 
	select a.order_id,
		a.supplier_id,
		COALESCE(a.person_id,a.company_id) as purchaser_id,
		a.payment_type,
		cast(a.created_time as date) as created_time,
		a.quantity,
		a.transaction_amount,
		c.order_status,
		b.cuit,
		b.product_id,
		'db' as source	
		from stg.orders a inner join 
		stg.suppliers 
		b on a.supplier_id = b.supplier_id
		inner join dbo.order_status c on a.order_id = c.order_id and 
		c.created_time = a.modified_time
;
GO
/****** Object:  StoredProcedure [dbo].[sp_log_analytics]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_log_analytics]
AS
INSERT INTO logs_analysis
select * from vw_realtime_logs a
 where a.EventProcessedUtcTime>(select max(processedTime) from logs_analysis);

GO
/****** Object:  StoredProcedure [dbo].[Sp_suppliers]    Script Date: 07-04-2021 20:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_suppliers]
AS
  BEGIN
      WITH cte
           AS (SELECT A.*,
                      b.price AS updated_price
               FROM   suppliers A
                      INNER JOIN stg.suppliers B
                              ON B.supplier_id = A.supplier_id
               WHERE  a.price != b.price
                      AND validtill = '9999-12-31 00:00:00.000')
      UPDATE cte
      SET    validtill = DateAdd(DAY,-1,Cast(Getdate() AS DATE));

      INSERT INTO suppliers
      SELECT a.*,
             Cast(Getdate() AS DATE) AS validFrom,
             '9999-12-31'            AS validTill
      FROM   stg.suppliers a
             LEFT JOIN suppliers b
                    ON a.supplier_id = b.supplier_id
      WHERE  b.supplier_id IS NULL;

	  INSERT INTO suppliers
      SELECT a.*,
             Cast(Getdate() AS DATE) AS validFrom,
             '9999-12-31'            AS validTill
      FROM   stg.suppliers a
             LEFT JOIN suppliers b
                    ON a.supplier_id = b.supplier_id
      WHERE  b.price != a.price;
  END

GO
ALTER DATABASE [toptal-analytics] SET  READ_WRITE 
GO
