/****** Object:  Database [b2b]    Script Date: 07-04-2021 20:21:08 ******/
CREATE DATABASE [b2b]  (EDITION = 'Standard', SERVICE_OBJECTIVE = 'S0', MAXSIZE = 20 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [b2b] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [b2b] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [b2b] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [b2b] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [b2b] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [b2b] SET ARITHABORT OFF 
GO
ALTER DATABASE [b2b] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [b2b] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [b2b] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [b2b] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [b2b] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [b2b] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [b2b] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [b2b] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [b2b] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [b2b] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [b2b] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [b2b] SET  MULTI_USER 
GO
ALTER DATABASE [b2b] SET ENCRYPTION ON
GO
ALTER DATABASE [b2b] SET QUERY_STORE = ON
GO
ALTER DATABASE [b2b] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Table [dbo].[companies]    Script Date: 07-04-2021 20:21:09 ******/
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
/****** Object:  Table [dbo].[customers]    Script Date: 07-04-2021 20:21:09 ******/
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
/****** Object:  Table [dbo].[order_status]    Script Date: 07-04-2021 20:21:09 ******/
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
/****** Object:  Table [dbo].[orders]    Script Date: 07-04-2021 20:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [bigint] IDENTITY(23456700,7) NOT NULL,
	[supplier_id] [int] NULL,
	[customer_id] [int] NULL,
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
/****** Object:  Table [dbo].[products]    Script Date: 07-04-2021 20:21:09 ******/
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
/****** Object:  Table [dbo].[suppliers]    Script Date: 07-04-2021 20:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[suppliers](
	[supplier_id] [int] IDENTITY(5000,1) NOT NULL,
	[cuit] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[price] [numeric](18, 2) NOT NULL,
	[last_modified] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT ('Cash on Delivery') FOR [payment_type]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [modified_time]
GO
ALTER TABLE [dbo].[suppliers] ADD  DEFAULT (getdate()) FOR [last_modified]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([company_id])
REFERENCES [dbo].[companies] ([cuit])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customers] ([customer_id])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([supplier_id])
REFERENCES [dbo].[suppliers] ([supplier_id])
GO
ALTER TABLE [dbo].[suppliers]  WITH CHECK ADD FOREIGN KEY([cuit])
REFERENCES [dbo].[companies] ([cuit])
GO
ALTER TABLE [dbo].[suppliers]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([product_id])
GO
ALTER DATABASE [b2b] SET  READ_WRITE 
GO
