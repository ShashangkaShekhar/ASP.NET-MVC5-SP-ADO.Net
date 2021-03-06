USE [master]
GO
/****** Object:  Database [SampleDB]    Script Date: 1/26/2016 11:26:23 AM ******/
CREATE DATABASE [SampleDB] ON  PRIMARY 
( NAME = N'SampleDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\SampleDB.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SampleDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\SampleDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SampleDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SampleDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SampleDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SampleDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SampleDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SampleDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SampleDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SampleDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SampleDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SampleDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SampleDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SampleDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SampleDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SampleDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SampleDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SampleDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SampleDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SampleDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SampleDB] SET  MULTI_USER 
GO
ALTER DATABASE [SampleDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SampleDB] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SampleDB', N'ON'
GO
USE [SampleDB]
GO
/****** Object:  Table [dbo].[tblCustomer]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCustomer](
	[CustID] [bigint] NOT NULL,
	[CustName] [nvarchar](50) NULL,
	[CustEmail] [nvarchar](50) NOT NULL,
	[CustAddress] [nvarchar](256) NULL,
	[CustContact] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblCustomer] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[CustEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [dbo].[CREATE_CUSTOMER]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Shashangka,,Shekhar>
-- Create date: <05/10/2015,,>
-- Description:	<With this SP we will Insert Customer Record to Customer Table,,>
-- =============================================
CREATE PROCEDURE [dbo].[CREATE_CUSTOMER]
	-- Add the parameters for the stored procedure here
(
	 @CustName NVarchar(50)
	,@CustEmail NVarchar(50)
	,@CustAddress NVarchar(256)
	,@CustContact  NVarchar(50)
)
AS
BEGIN
	---- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	---- Try Catch--
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @CustID Bigint
			SET @CustID = isnull(((SELECT max(CustID) FROM [dbo].[tblCustomer])+1),'1')

		-- Insert statements for procedure here
		INSERT INTO [dbo].[tblCustomer] ([CustID],[CustName],[CustEmail],[CustAddress],[CustContact])
		VALUES(@CustID,@CustName,@CustEmail,@CustAddress,@CustContact)
		SELECT 1
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT;
			SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();
			RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
		ROLLBACK TRANSACTION
	END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[DELETE_CUSTOMER]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Shashangka,,Shekhar>
-- Create date: <05/10/2015,,>
-- Description:	<With this SP we will Delete Customer Record from Customer Table,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_CUSTOMER]
	-- Add the parameters for the stored procedure here
	  @CustID BIGINT
AS
BEGIN
	---- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	---- Try Catch--
	BEGIN TRY
		BEGIN TRANSACTION

		-- Delete statements for procedure here
		DELETE [dbo].[tblCustomer]
		WHERE [CustID] = @CustID 
		SELECT 1
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT;
			SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();
			RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
		ROLLBACK TRANSACTION
	END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[READ_CUSTOMER]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Shashangka,,Shekhar>
-- Create date: <05/10/2015,,>
-- Description:	<With this SP we will Retrive Customer Record from Customer Table,,>
-- =============================================
CREATE PROCEDURE [dbo].[READ_CUSTOMER]
	-- Add the parameters for the stored procedure here
	 @PageNo INT
	,@RowCountPerPage INT
	,@IsPaging INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
    -- Select statements for procedure here

	IF(@IsPaging = 0)
	BEGIN
		SELECT top(@RowCountPerPage)* FROM [dbo].[tblCustomer]
		ORDER BY CustID DESC
	END

	IF(@IsPaging = 1)
	BEGIN
		DECLARE @SkipRow INT
		SET @SkipRow = (@PageNo - 1) * @RowCountPerPage

		SELECT * FROM [dbo].[tblCustomer]
		ORDER BY CustID DESC
	
		OFFSET @SkipRow ROWS FETCH NEXT @RowCountPerPage ROWS ONLY
	END
END

GO
/****** Object:  StoredProcedure [dbo].[UPDATE_CUSTOMER]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Shashangka,,Shekhar>
-- Create date: <05/10/2015,,>
-- Description:	<With this SP we will Update Customer Record to Customer Table,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_CUSTOMER]
	-- Add the parameters for the stored procedure here
	 @CustID BIGINT
	,@CustName NVarchar(50)
	,@CustEmail NVarchar(50)
	,@CustAddress NVarchar(256)
	,@CustContact  NVarchar(50)
AS
BEGIN
	---- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	---- Try Catch--
	BEGIN TRY
		BEGIN TRANSACTION

		-- Update statements for procedure here
		UPDATE [dbo].[tblCustomer]
		SET [CustName] = @CustName,
			[CustAddress] = @CustAddress,
			[CustContact] = @CustContact
		WHERE [CustID] = @CustID AND [CustEmail] = @CustEmail
		SELECT 1
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT;
			SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();
			RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
		ROLLBACK TRANSACTION
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[VIEW_CUSTOMER]    Script Date: 1/26/2016 11:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Shashangka,,Shekhar>
-- Create date: <05/10/2015,,>
-- Description:	<With this SP we will Retrive Single Customer Record from Customer Table,,>
-- =============================================
CREATE PROCEDURE [dbo].[VIEW_CUSTOMER]
	-- Add the parameters for the stored procedure here
	@CustID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
    -- Select statements for procedure here

	SELECT * FROM [dbo].[tblCustomer]
	WHERE [CustID] = @CustID 
END

GO
USE [master]
GO
ALTER DATABASE [SampleDB] SET  READ_WRITE 
GO
