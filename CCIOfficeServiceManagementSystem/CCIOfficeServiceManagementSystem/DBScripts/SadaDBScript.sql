USE [master]
GO
/****** Object:  Database [CCIDatabase]    Script Date: 4/15/2014 9:19:38 AM ******/
CREATE DATABASE [CCIDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CCIDatabase', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CCIDatabase.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CCIDatabase_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CCIDatabase_log.ldf' , SIZE = 1536KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CCIDatabase] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CCIDatabase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CCIDatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CCIDatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CCIDatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CCIDatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CCIDatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [CCIDatabase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CCIDatabase] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CCIDatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CCIDatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CCIDatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CCIDatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CCIDatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CCIDatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CCIDatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CCIDatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CCIDatabase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CCIDatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CCIDatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CCIDatabase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CCIDatabase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CCIDatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CCIDatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CCIDatabase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CCIDatabase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CCIDatabase] SET  MULTI_USER 
GO
ALTER DATABASE [CCIDatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CCIDatabase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CCIDatabase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CCIDatabase] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [CCIDatabase]
GO
/****** Object:  StoredProcedure [dbo].[AddImportDates]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddImportDates]
(
@UploadedDate date,
@ForWhichMonth date,
@DateId int output
)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Insert into [dbo].DataImportDates values(@UploadedDate,@ForWhichMonth)
	SET @DateId = @@IDENTITY
	SELECT @DateId AS DateID
END
GO
/****** Object:  StoredProcedure [dbo].[AddNewData]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|7|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[AddNewData]
(
@EmployeeName varchar(50),
@AccountName varchar(50),
@EmailAddress varchar(50),
@CostCenterId int,
@MobileNumber bigint,
@MobileAcNumber bigint,
@DatacardNumber bigint,
@DataCardAcNumber bigint
)	
AS
BEGIN
	
	SET NOCOUNT ON;

    insert into [dbo].staticEmployeeDetails values(@EmployeeName,@AccountName,@EmailAddress,@CostCenterId,@MobileNumber,
	@MobileAcNumber,@DatacardNumber,@DataCardAcNumber)
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|33|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[DeleteDetails]
(
@EmployeeId varchar(50)
)	
AS
BEGIN
	
	SET NOCOUNT ON;

    delete from [dbo].staticEmployeeDetails where EmployeeId=@EmployeeId
END

GO
/****** Object:  StoredProcedure [dbo].[EditSingleData]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|50|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[EditSingleData]
(
@UserId int,
@EmployeeName varchar(50),
@AccountName varchar(50),
@EmailAddress varchar(50),
@CostCenterId bigint,
@MobileNumber bigint,
@MobileAcNumber bigint,
@DataCardNumber bigint,
@DatacardAcNumber bigint
)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    update [dbo].staticEmployeeDetails set EmployeeName=@EmployeeName,AccountName=@AccountName,EmailAddress=@EmailAddress,CostCenterId=@CostCenterId,
	MobileNumber=@MobileNumber,MobileAcNumber=@MobileAcNumber,DatacardNumber=@DataCardNumber,DataCardAcNumber=@DatacardAcNumber where UserId=@UserId  
END


GO
/****** Object:  StoredProcedure [dbo].[getSingleEmployeeDetail]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|78|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[getSingleEmployeeDetail]
(
   @EmployeeId int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from [dbo].staticEmployeeDetails where EmployeeId=@EmployeeId
END


GO
/****** Object:  StoredProcedure [dbo].[GetUserName]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|96|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[GetUserName]
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from  [dbo].StaticAdminDetails
END


GO
/****** Object:  StoredProcedure [dbo].[SaveDataIntoDataBase]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveDataIntoDataBase]
	@MobileAcNumber bigint,
	@AirtelNumber bigint,
	@OnetimeCharges int,
	@Monthlycharges float,
	@CallCharges float,
	@ValueAdddedServices float,
	@MobileInternetUsage float,
	@Roaming float,
	@Discounts float,
	@Taxes float,
	@TotalCharges float,
	@WhoUploaded varchar(50),
	@DateImportId int

AS
BEGIN
	
	SET NOCOUNT ON;

   
	Insert into [dbo].AirtelManagement values(@MobileAcNumber,@AirtelNumber,@OnetimeCharges,@Monthlycharges,
	@CallCharges,@ValueAdddedServices,@MobileInternetUsage,@Roaming,@Discounts,@Taxes,@TotalCharges,@WhoUploaded,@DateImportId)
END
GO
/****** Object:  StoredProcedure [dbo].[ViewAirtelDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ViewAirtelDetails]
	
AS
BEGIN
	
	SET NOCOUNT ON;

    
	Select AccountNo,AirtelNumber,OnetimeCharges,MonthlyCharges,CallCharges,ValueAddedServices,MobileInternetUsage,Roaming,Discounts,Taxes,TotalCharges,ForWhichMonth from [dbo].AirtelManagement
END

GO
/****** Object:  StoredProcedure [dbo].[viewEmployeeDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: CCIDatabase_FullScript.sql|140|0|C:\MyData\CCIDatabase_FullScript.sql
CREATE PROCEDURE [dbo].[viewEmployeeDetails] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from [dbo].staticEmployeeDetails
END


GO
/****** Object:  StoredProcedure [dbo].[ViewReportDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ViewReportDetails]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	select MobileNumber,EmployeeName,CostCenterId,TotalCharges from [dbo].staticEmployeeDetails,[dbo].AirtelManagement where [dbo].staticEmployeeDetails.MobileNumber=[dbo].AirtelManagement.AirtelNumber

END

GO
/****** Object:  Table [dbo].[AirtelManagement]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AirtelManagement](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountNo] [bigint] NOT NULL,
	[AirtelNumber] [bigint] NOT NULL,
	[OnetimeCharges] [float] NOT NULL,
	[MonthlyCharges] [float] NOT NULL,
	[CallCharges] [float] NOT NULL,
	[ValueAddedServices] [float] NOT NULL,
	[MobileInternetUsage] [float] NOT NULL,
	[Roaming] [float] NOT NULL,
	[Discounts] [float] NOT NULL,
	[Taxes] [float] NOT NULL,
	[TotalCharges] [float] NOT NULL,
	[WhoUploaded] [varchar](50) NOT NULL,
	[ImportId] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataImportDates]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataImportDates](
	[DateId] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedData] [varchar](50) NOT NULL,
	[ForWhichMonth] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StaticAdminDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StaticAdminDetails](
	[UserId] [int] NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserPassword] [varchar](50) NOT NULL,
	[RememberMe] [bit] NOT NULL,
 CONSTRAINT [PK_StaticAdminDetails] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[staticEmployeeDetails]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[staticEmployeeDetails](
	[EmployeeId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeName] [varchar](50) NULL,
	[AccountName] [varchar](50) NULL,
	[EmailAddress] [varchar](50) NULL,
	[CostCenterId] [bigint] NULL,
	[MobileNumber] [bigint] NULL,
	[MobileAcNumber] [bigint] NULL,
	[DataCardNumber] [bigint] NULL,
	[DatacardAcNumber] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[webpages_Membership]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Membership](
	[UserId] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[IsConfirmed] [bit] NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordFailuresSinceLastSuccess] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_OAuthMembership]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_OAuthMembership](
	[Provider] [nvarchar](30) NOT NULL,
	[ProviderUserId] [nvarchar](100) NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_Roles]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_UsersInRoles]    Script Date: 4/15/2014 9:19:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_UsersInRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [PasswordFailuresSinceLastSuccess]
GO
ALTER TABLE [dbo].[AirtelManagement]  WITH CHECK ADD FOREIGN KEY([ImportId])
REFERENCES [dbo].[DataImportDates] ([DateId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_RoleId]
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[StaticAdminDetails] ([UserId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_UserId]
GO
USE [master]
GO
ALTER DATABASE [CCIDatabase] SET  READ_WRITE 
GO



USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetMonthFromDates]    Script Date: 4/28/2014 4:39:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetMonthFromDates]
AS
BEGIN
	
	SET NOCOUNT ON;

    select MONTH(ForWhichMonth)as MonthId,{ fn MonthName(ForWhichMonth) } as MonthOfDate into #MonthTable from [dbo].DataImportDates where @YearId=DateName(YEAR,"ForWhichMonth") 
	select * from #MonthTable
END

GO


USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetYearFromDates]    Script Date: 6/5/2014 1:52:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetYearFromDates]
AS
BEGIN
	
	SET NOCOUNT ON;

    select distinct YEAR(ForWhichMonth) as Id, DateName(YEAR,"ForWhichMonth") as YearOfDate into #YearTable from [dbo].DataImportDates
	select * from #YearTable
END
GO



USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetCitiesFromDatabase]    Script Date: 5/13/2014 4:30:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCitiesFromDatabase] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select distinct identity(int,1,1) as CityId,OfficeLocation as CityName into #CityTable from [dbo].staticEmployeeDetails
	select * from #CityTable
END

GO



USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[FilterAirtelDetails]    Script Date: 5/13/2014 4:30:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FilterAirtelDetails]
@SearchString varchar(50),
@DateId int,
@CityName varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    select distinct AccountNo,AirtelNumber,OneTimeCharges,MonthlyCharges,CallCharges,ValueAddedServices,MobileInternetUsage,Roaming,Discounts,Taxes,TotalCharges 
	from [dbo].staticEmployeeDetails S Left join [dbo].AirtelManagement A on A.AirtelNumber=@SearchString or A.ImportDateId=@DateId or S.OfficeLocation=@CityName 
END
GO


USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetImportDateId]    Script Date: 6/5/2014 1:42:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetImportDateId] 
	@SelectedYear int,
	@SelectedMonth int
AS
BEGIN
	
	SET NOCOUNT ON;

    select DateId from [dbo].DataImportDates where YEAR(ForWhichMonth)=@SelectedYear and MONTH(ForWhichMonth)=@SelectedMonth
END

GO



USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetMonthData]    Script Date: 6/5/2014 1:44:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[GetMonthData]
  @month int,
  @year int
AS
BEGIN
	 
	SET NOCOUNT ON;

   
	
	select PresentDate,Name,Place,Driver,Vehiclenumber,Amount,Costcentre from [dbo].TransportDetails where MONTH(PresentDate)=@month and YEAR(PresentDate)=@year
	end

GO





USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[SaveTransData]    Script Date: 6/5/2014 1:54:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveTransData]
	 @PresentDate Date,
	 @Name Varchar(20),
	 @Place Varchar(20),
	 @Draiver varchar(20),
	 @Vehiclenumber Varchar(20),
	 @Amount int,
	 @Costcentre int,
	 @DateImportId int


AS
BEGIN
	
	SET NOCOUNT ON;

   
	Insert into [dbo].[TransportDetails] values(@PresentDate,@Name,@Place, @Draiver,@Vehiclenumber,@Amount,@Costcentre, @DateImportId )
END


GO




USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[ViewTranportDetails]    Script Date: 6/5/2014 1:58:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ViewTranportDetails]
	 
AS
BEGIN
	 
	SET NOCOUNT ON;

    select PresentDate,Name,Place,Driver,Vehiclenumber,Amount,Costcentre from dbo.TransportDetails
END


GO


USE [CCIDatabase]
GO

/****** Object:  StoredProcedure [dbo].[GetCitiesFromDatabase]    Script Date: 6/5/2014 2:04:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCitiesFromDatabase] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select distinct identity(int,1,1) as CityId,OfficeLocation as CityName into #CityTable from [dbo].staticEmployeeDetails
	select * from #CityTable
END

GO



