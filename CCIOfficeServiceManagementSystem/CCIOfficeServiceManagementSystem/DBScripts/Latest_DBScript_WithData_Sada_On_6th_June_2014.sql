USE [CCIDatabase]
GO
/****** Object:  StoredProcedure [dbo].[AddImportDates]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddImportDates]
(
@UploadedDate DATETIME,
@ForWhichMonth DATETIME,
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
/****** Object:  StoredProcedure [dbo].[AddNewData]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewData]
(
@EmployeeName varchar(50),
@AccountName varchar(50),
@EmailAddress varchar(50),
@CostCenterId int,
@MobileNumber bigint,
@MobileAcNumber bigint,
@DatacardNumber bigint,
@DataCardAcNumber bigint,
@OfficeLocation varchar(50)
)	
AS
BEGIN
	
	SET NOCOUNT ON;

    insert into [dbo].staticEmployeeDetails values(@EmployeeName,@AccountName,@EmailAddress,@CostCenterId,@MobileNumber,
	@MobileAcNumber,@DatacardNumber,@DataCardAcNumber,@OfficeLocation)
END

GO
/****** Object:  StoredProcedure [dbo].[AddTransImportDates]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTransImportDates]
(
@UploadedDate DATETIME,
@ForWhichMonth DATETIME,
@DateId int output
)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Insert into [dbo].TransImportDates values(@UploadedDate,@ForWhichMonth)
	SET @DateId = @@IDENTITY
	SELECT @DateId AS DateID
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[EditSingleData]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
@DatacardAcNumber bigint,
@OfficeLocation varchar(50)
)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    update [dbo].staticEmployeeDetails set EmployeeName=@EmployeeName,AccountName=@AccountName,EmailAddress=@EmailAddress,CostCenterId=@CostCenterId,
	MobileNumber=@MobileNumber,MobileAcNumber=@MobileAcNumber,DatacardNumber=@DataCardNumber,DataCardAcNumber=@DatacardAcNumber,OfficeLocation=@OfficeLocation where EmployeeId=@UserId  
END
GO
/****** Object:  StoredProcedure [dbo].[FilterAirtelDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
	from [dbo].staticEmployeeDetails S Left join [dbo].AirtelManagement A on A.AirtelNumber=@SearchString or A.ImportId=@DateId or S.OfficeLocation=@CityName 
END

GO
/****** Object:  StoredProcedure [dbo].[GetCitiesFromDatabase]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetImportDateId]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetMonthData]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetMonthDataForAirtel]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[GetMonthDataForAirtel]
  @month int,
  @year int
AS
BEGIN
	 
	SET NOCOUNT ON;

   
	
	select Accountno,AirtelNumber,OnetimeCharges,MonthlyCharges,CallCharges,ValueAddedServices,MobileInternetUsage,
	Roaming,Discounts,Taxes,TotalCharges from dbo.AirtelManagement where ImportID=(select DateId from dbo.DataImportDates where MONTH(ForWhichMonth)=@month and YEAR(ForWhichMonth)=@year)
	end



GO
/****** Object:  StoredProcedure [dbo].[GetMonthFromDates]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMonthFromDates]
@YearId int
AS
BEGIN
	
	SET NOCOUNT ON;

    select distinct MONTH(ForWhichMonth)as MonthId,{ fn MonthName(ForWhichMonth) } as MonthOfDate into #MonthTable from [dbo].DataImportDates where @YearId=DateName(YEAR,"ForWhichMonth") 
	select * from #MonthTable
END

GO
/****** Object:  StoredProcedure [dbo].[getSingleEmployeeDetail]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserName]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetYearFromDates]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SaveDataIntoDataBase]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SaveTransData]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTransData]
	 @PresentDate DATETIME,
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
/****** Object:  StoredProcedure [dbo].[ViewAirtelDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ViewAirtelDetails]
	
AS
BEGIN
	
	SET NOCOUNT ON;
    
	Select AccountNo,AirtelNumber,OnetimeCharges,MonthlyCharges,CallCharges,ValueAddedServices,MobileInternetUsage,Roaming,Discounts,Taxes,TotalCharges,ImportId from [dbo].AirtelManagement
END

GO
/****** Object:  StoredProcedure [dbo].[viewEmployeeDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ViewReportDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ViewTranportDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  Table [dbo].[AirtelManagement]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  Table [dbo].[DataImportDates]    Script Date: 6/9/2014 2:19:59 PM ******/
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
/****** Object:  Table [dbo].[StaticAdminDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StaticAdminDetails](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserPassword] [varchar](50) NOT NULL,
	[RememberMe] [bit] NOT NULL DEFAULT(0),
 CONSTRAINT [PK_StaticAdminDetails] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[staticEmployeeDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
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
	[OfficeLocation] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransImportDates]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransImportDates](
	[DateId] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedData] [varchar](50) NOT NULL,
	[ForWhichMonth] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransportDetails]    Script Date: 6/9/2014 2:19:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[TransportDetails](
	[PresentDate] [DATETIME] NULL,
	[Name] [varchar](40) NULL,
	[Place] [varchar](40) NULL,
	[Driver] [varchar](40) NULL,
	[Vehiclenumber] [int] NULL,
	[Amount] [int] NULL,
	[Costcentre] [int] NULL,
	[DateImportId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[AirtelManagement] ON 

INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10690, 1020200340, 8700008990, 0, 970, 0.60000002384185791, 90, 9006.7001953125, 9.6999998092651367, -9079.8701171875, 9.8000001907348633, 60, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10691, 1020200102, 9790009000, 0, 0, 0.800000011920929, 0, 0.059999998658895493, 0.89999997615814209, -600.65997314453125, 0, 709.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10692, 1020200200, 8700008990, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10693, 1020200200, 8700008996, 0, 70, 70, 0, 0.090000003576278687, 888, -0.79000002145767212, 9, 70.800003051757812, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10694, 1020020300, 8700000000, 0, 0, 70.699996948242188, 0, 8, 0, -70.9000015258789, 0.89999997615814209, 99, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10695, 1020020430, 8700000000, 0, 0, 0, 76, 70.05999755859375, 77, -700.760009765625, 90, 600, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10696, 1020020440, 8700000000, 0, 0, 0, 0, 688, 0, -800, 70.9000015258789, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10697, 1020020310, 8700000000, 0, 970, 86, 6, 80, 8, -660.79998779296875, 9, 60.799999237060547, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10698, 1020004310, 8700000000, 0, 0, 0.699999988079071, 0, 0, 0, -0.60000002384185791, 0, 0.800000011920929, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10699, 1020014000, 8700000006, 0, 0, 800.70001220703125, 6, 9, 8806.0595703125, -678, 0, 6600, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10700, 1020120001, 8700006700, 0, 70, 90, 9, 0, 6, -78.699996948242188, 60, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10701, 1020120000, 8700006700, 0, 0, 0, 0, 0, 0, -97, 7.78000020980835, 0.079999998211860657, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10702, 1020120011, 8700006700, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10703, 1020400000, 8700080000, 0, 0, 88.800003051757812, 0, 0, 96, -70, 0.87999999523162842, 860.08001708984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10704, 1020400000, 8700080000, 0, 0, 80, 78, 0, 0, -6, 67, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10705, 1020001432, 8700007800, 0, 70, 0.800000011920929, 7.5999999046325684, 7.9000000953674316, 7, -9, 90.760002136230469, 770.65997314453125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10706, 1030041003, 9900080900, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10707, 1033301033, 8700060060, 0, 0, 90, 0, 8, 96, 0, 89, 708, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10708, 1030200020, 8700006886, 0, 0, 60, 0.699999988079071, 8.09000015258789, 70, -7.0900001525878906, 90, 707.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10709, 1030100210, 9800006096, 0, 80, 0.699999988079071, 9, 0, 77.800003051757812, -98.699996948242188, 60.700000762939453, 60, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10710, 1030020101, 9800690070, 0, 0, 67, 70, 80, 700.70001220703125, -600.9000244140625, 0.67000001668930054, 0.67000001668930054, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10711, 1041411030, 8700077006, 0, 80, 77, 70, 6809, 0, -6806, 0, 907, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10712, 1040001140, 9900000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10713, 1004000040, 9790788700, 0, 6, 0, 0, 0, 0, -70, 7, 7, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10714, 1004004000, 9790890000, 0, 6, 9.8999996185302734, 0, 0, 78, -78.9000015258789, 0.87999999523162842, 98.9800033569336, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10715, 1004004000, 9790800000, 0, 6, 0.800000011920929, 0, 0, 0.699999988079071, -8, 8.8000001907348633, 60, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10716, 1022000031, 8978800070, 0, 99, 0, 0, 0, 0, 0, 0.60000002384185791, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10717, 1022000000, 8978800070, 0, 99, 0.800000011920929, 0, 0, 0, 0, 0.800000011920929, 97.9000015258789, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10718, 1022000414, 8978800076, 0, 70, 78.9000015258789, 0, 0, 900, -88, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10719, 1022000010, 8978800070, 0, 0, 80.699996948242188, 0.699999988079071, 70.699996948242188, 690, -8, 6, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10720, 1022000411, 8978800070, 0, 99, 0, 0.60000002384185791, 0, 0.699999988079071, 0, 0.88999998569488525, 7.9000000953674316, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10721, 1020200100, 8978800000, 0, 70, 68, 0.60000002384185791, 0, 0, -80, 80.089996337890625, 776.09002685546875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10722, 1020200122, 8978800070, 0, 7, 0, 0, 0, 0, 0, 0.059999998658895493, 0.059999998658895493, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10723, 1020200340, 8978800007, 0, 0, 0, 0.800000011920929, 989, 90, 0, 60.689998626708984, 69.69000244140625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10724, 1020200100, 8978800000, 0, 70, 6.9000000953674316, 0, 0.60000002384185791, 0.699999988079071, -6, 0.699999988079071, 900.9000244140625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10725, 1020200334, 8978800000, 0, 70, 0.60000002384185791, 0, 0, 800, 0, 7, 9, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10726, 1020200100, 8978800008, 0, 99, 90.800003051757812, 7, 97, 0, -60.799999237060547, 66, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10727, 1020200333, 8978800000, 0, 99, 97, 0, 0, 8.6999998092651367, -8, 87.080001831054688, 790, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10728, 1020200004, 8978800006, 0, 70, 700.5999755859375, 60, 0, 7, -80, 6.5999999046325684, 9.8000001907348633, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10729, 1020200300, 8978800000, 0, 99, 0.89999997615814209, 0, 0, 90, -6, 70.7699966430664, 670.66998291015625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10730, 1020200100, 8978800009, 0, 0, 0, 7, 0.070000000298023224, 70, -0.070000000298023224, 0, 800.79998779296875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10731, 1020200000, 8978800070, 0, 99, 0, 0.89999997615814209, 0, 600, 0, 0.97000002861022949, 0.070000000298023224, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10732, 1020200203, 8978800000, 0, 70, 600, 0.89999997615814209, 0, 0, -68, 0.090000003576278687, 0.090000003576278687, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10733, 1020200123, 8978800000, 0, 70, 7.9000000953674316, 9.8999996185302734, 7, 700, -760.70001220703125, 0.87999999523162842, 906.08001708984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10734, 1020200004, 8978800008, 0, 98, 0, 0, 0, 8, 0, 0.070000000298023224, 0.070000000298023224, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10735, 1020200023, 8978800000, 0, 0, 9.8000001907348633, 0.60000002384185791, 8.8999996185302734, 800, -0.699999988079071, 88.080001831054688, 609.780029296875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10736, 1020200000, 8978800006, 0, 0, 0.800000011920929, 0.60000002384185791, 0, 0.699999988079071, -80, 90, 800, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10737, 1020200230, 8978800000, 0, 70, 7.9000000953674316, 0, 0, 0, 0, 90, 777.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10738, 1031220003, 8978080807, 0, 70, 80, 7.5999999046325684, 0, 0.699999988079071, -0.99000000953674316, 6.6999998092651367, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10739, 1031220002, 8978080809, 0, 7, 0.89999997615814209, 0, 7.9800000190734863, 609, -0.079999998211860657, 80.9800033569336, 90.9800033569336, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10740, 1031220300, 8978080806, 0, 99, 7.5999999046325684, 0, 0, 9, 0, 60, 66.800003051757812, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10741, 1031220300, 8978080800, 0, 99, 760, 0.699999988079071, 0, 0, -8.6000003814697266, 7.8000001907348633, 980, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10742, 1031220200, 8978080808, 0, 70, 9.8999996185302734, 0, 0, 7, 0, 60.900001525878906, 60, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10743, 1031220300, 8978080800, 0, 99, 98, 0.699999988079071, 0, 77, 0, 90.699996948242188, 700, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10744, 1031220204, 8978080800, 0, 8, 97, 96.800003051757812, 0, 70, -6.5999999046325684, 0.89999997615814209, 7.5999999046325684, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10745, 1031220203, 8978080800, 0, 70, 0.60000002384185791, 0, 0, 9.6000003814697266, -60.599998474121094, 0.699999988079071, 800.5999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10746, 1031220200, 8978080800, 0, 70, 897, 0, 0, 0, 0, 0.800000011920929, 6, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10747, 1031220000, 8978080800, 0, 70, 667.79998779296875, 6, 0, 0, -90.699996948242188, 7, 970.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10748, 1030240120, 9909080000, 0, 70, 0.800000011920929, 0, 80, 800.70001220703125, -8.7700004577636719, 66.699996948242188, 0.800000011920929, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10749, 1030240000, 9866900800, 0, 70, 9.6000003814697266, 8, 0, 98, -68, 0, 800, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10750, 1030000043, 9600666077, 0, 98, 0, 0, 0.070000000298023224, 8.6999998092651367, -6.070000171661377, 88.800003051757812, 600.8599853515625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10751, 1030100042, 9600666088, 0, 70, 77, 0.89999997615814209, 0, 9, -60, 67.699996948242188, 600.5999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10752, 1030000422, 9600666000, 0, 70, 9.6999998092651367, 0.800000011920929, 0, 0, -7, 90.860000610351562, 800.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10753, 1030000024, 9600666000, 0, 99, 80, 0, 0, 0, -87, 80.5999984741211, 700.5999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10754, 1030000400, 9600666000, 0, 98, 80.800003051757812, 0, 0.079999998211860657, 77.699996948242188, -0.079999998211860657, 90.9000015258789, 700.97998046875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10755, 1040000340, 7700670000, 0, 99, 7, 0, 0, 8, 0, 98.080001831054688, 890.08001708984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10756, 1040000400, 7700670000, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10757, 1040000101, 7700670000, 0, 99, 0.89999997615814209, 7, 0, 6.6999998092651367, -9, 80.699996948242188, 700.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10758, 1040000000, 7700600707, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10759, 1040000300, 7700670000, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10760, 1003203310, 8006000088, 0, 70.069999694824219, 6, 0, 0, 0, -7, 0, 0.89999997615814209, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10761, 1003204201, 8006000066, 0, 70.069999694824219, 7.9000000953674316, 0, 0, 0.699999988079071, -76.7699966430664, 69, 600.09002685546875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10762, 1003204202, 8006000077, 0, 70.069999694824219, 0, 0, 0, 0, 0, 0, 90.790000915527344, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10763, 1020002020, 9900000000, 0, 99, 0, 0, 0, 0, -8, 0.60000002384185791, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10764, 1021200000, 9686680090, 0, 0, 800, 9.8999996185302734, 0.059999998658895493, 700.70001220703125, -0.059999998658895493, 7, 970, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10765, 1021000002, 7760970000, 0, 70, 88, 0, 0, 0, -90.800003051757812, 0.070000000298023224, 808.66998291015625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10766, 1022000040, 7760970070, 0, 70, 0.800000011920929, 7, 0.68000000715255737, 90.699996948242188, 0, 0, 800, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10767, 1023040212, 7760980600, 0, 8, 0, 0, 0, 0, 0, 0.89999997615814209, 89.9000015258789, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10768, 1023040200, 7760980600, 0, 0, 80.699996948242188, 9, 0, 69.05999755859375, 0, 97, 790.780029296875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10769, 1023002200, 7760980670, 0, 0, 0, 0, 0, 0, 0, 60, 80, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10770, 1023010000, 7760980670, 0, 70, 600, 6.5999999046325684, 6.9000000953674316, 0, -88, 0.6600000262260437, 900.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10771, 1023000320, 7760980709, 0, 70, 800.70001220703125, 0, 0, 0, -7.8000001907348633, 9.65999984741211, 78.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10772, 1023000101, 7760980700, 0, 0, 700, 8.6000003814697266, 0, 90, -7.8000001907348633, 0.079999998211860657, 0.079999998211860657, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10773, 1023000320, 7760980700, 0, 0, 80.699996948242188, 0, 0, 0.699999988079071, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10774, 1024000034, 8860000007, 0, 0, 80, 0, 0, 0, -88, 0, 800.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10775, 1024000000, 8860000006, 0, 70, 0.60000002384185791, 0, 0.89999997615814209, 0, -8, 0.60000002384185791, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10776, 1024020020, 8860000006, 0, 0, 70, 6.8000001907348633, 0.699999988079071, 0, -7, 99, 800.79998779296875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10777, 1024000120, 8860008060, 0, 70, 98, 0, 90.05999755859375, 0, -60.060001373291016, 0, 807.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10778, 1020220031, 8860000760, 0, 70, 70.699996948242188, 0, 0, 0, 0, 0, 0.89999997615814209, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10779, 1020200302, 9600006000, 0, 8, 0, 0, 0, 0, 0, 9, 7, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10780, 1020200003, 9900090000, 0, 9, 0, 8, 900.5999755859375, 0, -8.869999885559082, 80.05999755859375, 609, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10781, 1020200210, 9970800766, 0, 9, 80.800003051757812, 0, 0, 9.6999998092651367, -90, 60.970001220703125, 70, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10782, 1020200440, 9686000770, 0, 99, 0, 0.60000002384185791, 0, 0, 0, 9, 68, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10783, 1020200013, 9900000000, 0, 8, 8.6999998092651367, 0.89999997615814209, 9.8999996185302734, 0, -9.6000003814697266, 0.6600000262260437, 69, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10784, 1020200330, 9686660000, 0, 0, 7.6999998092651367, 9, 0.079999998211860657, 800, -88.800003051757812, 79.5999984741211, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10785, 1020200004, 9980090000, 0, 8, 700.5999755859375, 8, 0.86000001430511475, 68, -600.08001708984375, 0, 709, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10786, 1020200220, 9700080908, 0, 7, 78.5999984741211, 86, 0, 77, 0, 9.0600004196167, 86.5999984741211, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10787, 1020200000, 9980608000, 0, 0, 0.60000002384185791, 8, 0, 60.700000762939453, -88.800003051757812, 79.089996337890625, 700.9000244140625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10788, 1020200430, 9008077900, 0, 80, 60, 0, 0, 667.09002685546875, -80.9000015258789, 600.08001708984375, 70.069999694824219, N'Admin', 4)
GO
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10789, 1020200200, 9900007088, 0, 808, 0, 0, 0, 780, -700, 89.069999694824219, 600.07000732421875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10790, 1020200000, 9600897606, 0, 8, 8.6999998092651367, 90, 0, 79, -79.9800033569336, 98.9800033569336, 809, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10791, 1020200200, 9600007086, 0, 8, 800.79998779296875, 0.60000002384185791, 0.89999997615814209, 0, -7, 0.090000003576278687, 0.090000003576278687, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10792, 1020200024, 9700000099, 0, 7, 706.70001220703125, 0.800000011920929, 8, 0, -6, 0, 0.89999997615814209, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10793, 1020200002, 9900000806, 0, 0, 600, 80, 0.800000011920929, 809, -90, 7, 880.07000732421875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10794, 1020200241, 9686000777, 0, 70, 0, 6, 700.8699951171875, 9, -77, 700.989990234375, 6800, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10795, 1020200014, 9000007079, 0, 0, 0, 0.60000002384185791, 0, 0, -99.699996948242188, 88.660003662109375, 700.96002197265625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10796, 1020200000, 9900808000, 0, 909, 0.89999997615814209, 0.800000011920929, 0.090000003576278687, 0, -70.05999755859375, 9, 8, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10797, 1020200201, 9970800700, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10798, 1020200000, 9900007600, 0, 70, 8.8999996185302734, 0.60000002384185791, 900.05999755859375, 9, -970.760009765625, 6, 960, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10799, 1020200100, 9686000770, 0, 70, 0, 0, 0, 0, 0, 76.989997863769531, 699.989990234375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10800, 1020200300, 9600000800, 0, 8, 0, 0, 0, 908, 0, 0.60000002384185791, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10801, 1020200200, 9660090000, 0, 608, 80.5999984741211, 7, 8, 0.800000011920929, -0.699999988079071, 80.9000015258789, 80, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10802, 1020200101, 9880097700, 0, 8, 0.699999988079071, 7.5999999046325684, 90.779998779296875, 7, -90, 790.760009765625, 7098, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10803, 1020200100, 9980008609, 0, 907, 86.800003051757812, 0, 0.090000003576278687, 0, -6.059999942779541, 90.779998779296875, 688.5999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10804, 1020000001, 8860000890, 0, 0, 0, 0, 0, 0, -89.05999755859375, 7, 9.09000015258789, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10805, 1020000001, 8860086800, 0, 70, 0, 0, 0, 0, 0, 0.87000000476837158, 7.869999885559082, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10806, 1020400320, 8860086890, 0, 780.5999755859375, 0, 0, 0, 0, -90.9000015258789, 80, 770.9000244140625, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10807, 1020041000, 9686077000, 0, 70, 900, 9, 0, 990.5999755859375, -78, 700.09002685546875, 6076.08984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10808, 1020041001, 9700000000, 0, 70, 0.800000011920929, 0, 0.070000000298023224, 0, -0.87000000476837158, 80, 668.5999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10809, 1020041000, 9660000000, 0, 0, 90.9000015258789, 0, 0, 0, 0, 60, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10810, 1030000003, 9900060660, 0, 90, 790, 0, 600, 0, -809, 0.090000003576278687, 9.8999996185302734, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10811, 1032403002, 9700980660, 0, 70, 60.700000762939453, 0, 0, 0.800000011920929, -9, 88.879997253417969, 707.08001708984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10812, 1034030004, 7009000000, 0, 600, 0, 0, 766.70001220703125, 0, -766.70001220703125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10813, 1034030123, 7009000000, 0, 600, 0, 0, 9798, 0, -9798, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10814, 1034030300, 7009000009, 0, 600, 0, 0, 6008.080078125, 0, -6008.080078125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10815, 1034030330, 7009000009, 0, 600, 0, 0, 7006.7001953125, 0, -7006.7001953125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10816, 1034030002, 7009000080, 0, 600, 0, 0, 6009.06982421875, 0, -6009.06982421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10817, 1034030100, 7009000000, 0, 600, 0, 0, 7609.89990234375, 0, -7609.89990234375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10818, 1034030120, 7009000067, 0, 600, 0, 0, 0.800000011920929, 0, -0.800000011920929, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10819, 1034030300, 7009000009, 0, 600, 0, 0, 79.760002136230469, 0, -79.760002136230469, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10820, 1034030130, 7009000080, 0, 600, 0, 0, 788.70001220703125, 0, -788.70001220703125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10821, 1034030000, 7009000000, 0, 600, 0, 0, 8990, 0, -8990, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10822, 1034030000, 7760976008, 0, 600, 0, 0, 707.07000732421875, 0, -707.07000732421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10823, 1034030330, 7009000000, 0, 600, 0, 0, 0.699999988079071, 0, -0.699999988079071, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10824, 1034030300, 7009000006, 0, 600, 0, 0, 6007.06982421875, 0, -6007.06982421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10825, 1034030000, 7009000060, 0, 600, 0, 0, 6600.7998046875, 0, -6600.7998046875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10826, 1034030304, 7009000000, 0, 600, 0, 0, 677.97998046875, 0, -677.97998046875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10827, 1034030330, 7009000068, 0, 600, 0, 0, 980.5999755859375, 0, -980.5999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10828, 1034030132, 7009000000, 0, 600, 0, 0, 6.0799999237060547, 0, -6.0799999237060547, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10829, 1034030130, 7009000060, 0, 600, 0, 0, 0.88999998569488525, 0, -0.88999998569488525, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10830, 1034030000, 7009000079, 0, 600, 0, 0, 8090.08984375, 0, -8090.08984375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10831, 1034030300, 7009000007, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10832, 1034030100, 7009000090, 0, 600, 0, 0, 7.6700000762939453, 0, -7.6700000762939453, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10833, 1034030001, 7009000000, 0, 600, 0, 0, 0.60000002384185791, 0, -0.60000002384185791, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10834, 1034030002, 7009000070, 0, 600, 0, 0, 6608.7001953125, 0, -6608.7001953125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10835, 1034030000, 7009000000, 0, 600, 0, 0, 609.79998779296875, 0, -609.79998779296875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10836, 1034030120, 7760976000, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10837, 1034030130, 7009000008, 0, 600, 0, 0, 9.869999885559082, 0, -9.869999885559082, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10838, 1034030130, 7009000090, 0, 600, 0, 0, 800.09002685546875, 0, -800.09002685546875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10839, 1034030000, 7760976000, 0, 600, 0, 0, 9.8999996185302734, 0, -9.8999996185302734, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10840, 1034030233, 7009000070, 0, 600, 0, 0, 6000, 0, -6000, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10841, 1034030300, 7009000000, 0, 600, 0, 0, 70, 0, -70, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10842, 1034030000, 7009000000, 0, 600, 0, 0, 0.86000001430511475, 0, -0.86000001430511475, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10843, 1034030301, 7009000009, 0, 600, 0, 0, 786.5999755859375, 0, -786.5999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10844, 1034030340, 7760976007, 0, 600, 0, 0, 7, 0, -7, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10845, 1034030304, 7760976009, 0, 600, 0, 0, 7000.080078125, 0, -7000.080078125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10846, 1034030111, 7009000080, 0, 600, 0, 0, 766, 0, -766, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10847, 1034030003, 7009000000, 0, 600, 0, 0, 800.08001708984375, 0, -800.08001708984375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10848, 1034030232, 7009000090, 0, 600, 0, 0, 6997.89990234375, 0, -6997.89990234375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10849, 1034030140, 7009000070, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10850, 1034030100, 7009000000, 0, 600, 0, 0, 700.67999267578125, 0, -700.67999267578125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10851, 1034030300, 7009000006, 0, 600, 0, 0, 600.69000244140625, 0, -600.69000244140625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10852, 1034030304, 7009000000, 0, 600, 0, 0, 69, 0, -69, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10853, 1034030300, 7009000000, 0, 600, 0, 0, 0.699999988079071, 0, -0.699999988079071, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10854, 1034030000, 7009000099, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10855, 1034030330, 7009000078, 0, 600, 0, 0, 980.5999755859375, 0, -980.5999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10856, 1034030303, 7009000007, 0, 600, 0, 0, 9.6999998092651367, 0, -9.6999998092651367, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10857, 1034030000, 7760976000, 0, 600, 0, 0, 600.5999755859375, 0, -600.5999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10858, 1034030220, 7009000070, 0, 600, 0, 0, 0.86000001430511475, 0, -0.86000001430511475, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10859, 1034030300, 7760976006, 0, 600, 0, 0, 9006.9697265625, 0, -9006.9697265625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10860, 1034030000, 7009000000, 0, 600, 0, 0, 90, 0, -90, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10861, 1034030000, 7009000009, 0, 600, 0, 0, 6808.06982421875, 0, -6808.06982421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10862, 1034030300, 7009000000, 0, 600, 0, 0, 8.09000015258789, 0, -8.09000015258789, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10863, 1034030300, 7009000080, 0, 600, 0, 0, 60.700000762939453, 0, -60.700000762939453, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10864, 1034030000, 7009000008, 0, 600, 0, 0, 0.60000002384185791, 0, -0.60000002384185791, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10865, 1034030300, 7009000096, 0, 600, 0, 0, 6009.06982421875, 0, -6009.06982421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10866, 1034030000, 7009000000, 0, 600, 0, 0, 0.079999998211860657, 0, -0.079999998211860657, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10867, 1034030341, 9900060009, 0, 70, 70, 0, 0.89999997615814209, 0, -67, 96.699996948242188, 788, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10868, 1034030300, 7009000060, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10869, 1034030110, 7009000060, 0, 600, 0, 0, 787.09002685546875, 0, -787.09002685546875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10870, 1034030302, 7009000070, 0, 600, 0, 0, 0.60000002384185791, 0, -0.60000002384185791, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10871, 1034030300, 7009000007, 0, 600, 0, 0, 0.98000001907348633, 0, -0.98000001907348633, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10872, 1034030300, 7009000000, 0, 600, 0, 0, 790.96002197265625, 0, -790.96002197265625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10873, 1034030003, 7009000077, 0, 600, 0, 0, 9097.900390625, 0, -9097.900390625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10874, 1034030001, 7009000060, 0, 600, 0, 0, 906, 0, -906, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10875, 1034030302, 7009000000, 0, 600, 0, 0, 80.69000244140625, 0, -80.69000244140625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10876, 1034030301, 7009000090, 0, 600, 0, 0, 6.0799999237060547, 0, -6.0799999237060547, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10877, 1034030220, 7009000086, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10878, 1034030300, 7009000000, 0, 600, 0, 0, 7799.06005859375, 0, -7799.06005859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10879, 1034030221, 7009000087, 0, 600, 0, 0, 9, 0, -9, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10880, 1034030131, 7009000000, 0, 600, 0, 0, 6.96999979019165, 0, -6.96999979019165, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10881, 1034030001, 7009000007, 0, 600, 0, 0, 709.07000732421875, 0, -709.07000732421875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10882, 1034030004, 7009000069, 0, 600, 0, 0, 7070, 0, -7070, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10883, 1034030220, 7009000000, 0, 600, 0, 0, 0, 0, 0, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10884, 1034030124, 7009000000, 0, 600, 0, 0, 86.05999755859375, 0, -86.05999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10885, 1034030000, 7760976000, 0, 600, 0, 0, 7880.759765625, 0, -7880.759765625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10886, 1034030100, 7009000008, 0, 600, 0, 0, 89.680000305175781, 0, -89.680000305175781, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10887, 1034030222, 7009000097, 0, 600, 0, 0, 960.09002685546875, 0, -960.09002685546875, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10888, 1034030230, 7009000066, 0, 600, 0, 0, 6006, 0, -6006, 70.05999755859375, 670.05999755859375, N'Admin', 4)
GO
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10889, 1034030300, 7009000000, 0, 600, 0, 0, 800.8599853515625, 0, -800.8599853515625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10890, 1034030301, 7009000006, 0, 600, 0, 0, 969.05999755859375, 0, -969.05999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10891, 1034030223, 7009000076, 0, 600, 0, 0, 906.05999755859375, 0, -906.05999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10892, 1034030302, 7760976000, 0, 600, 0, 0, 77.5999984741211, 0, -77.5999984741211, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10893, 1034030142, 7760976000, 0, 600, 0, 0, 800.05999755859375, 0, -800.05999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10894, 1034030220, 7009000090, 0, 600, 0, 0, 6.059999942779541, 0, -6.059999942779541, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10895, 1034030301, 7009000088, 0, 600, 0, 0, 800.08001708984375, 0, -800.08001708984375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10896, 1034030300, 7009000000, 0, 600, 0, 0, 8700.7900390625, 0, -8700.7900390625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10897, 1034030121, 7009000006, 0, 600, 0, 0, 790, 0, -790, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10898, 1034030303, 7009000008, 0, 600, 0, 0, 0.89999997615814209, 0, -0.89999997615814209, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10899, 1034030004, 7009000000, 0, 600, 0, 0, 8000.7900390625, 0, -8000.7900390625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10900, 1034030000, 7009000060, 0, 600, 0, 0, 8997, 0, -8997, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10901, 1034030112, 7009000006, 0, 600, 0, 0, 70, 0, -70, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10902, 1034030302, 7009000070, 0, 600, 0, 0, 9000.7001953125, 0, -9000.7001953125, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10903, 1034030231, 7009000080, 0, 600, 0, 0, 770, 0, -770, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10904, 1034030110, 7009000008, 0, 600, 0, 0, 6606.60009765625, 0, -6606.60009765625, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10905, 1034030300, 7009000000, 0, 600, 0, 0, 0.98000001907348633, 0, -0.98000001907348633, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10906, 1034030003, 7009000090, 0, 600, 0, 0, 8900, 0, -8900, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10907, 1034030122, 7009000089, 0, 600, 0, 0, 960.05999755859375, 0, -960.05999755859375, 70.05999755859375, 670.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10908, 1034020020, 8860000000, 0, 70, 700, 0, 0.090000003576278687, 0, -89.089996337890625, 0.699999988079071, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10909, 1030204400, 9686090070, 0, 70, 0, 0, 6, 0, -6, 0.99000000953674316, 7.9899997711181641, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10910, 1030204401, 9686090708, 0, 70, 86.800003051757812, 8, 0, 0, -0.699999988079071, 6, 0.89999997615814209, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10911, 1030314000, 9900060080, 0, 70, 0, 0, 0, 0, -88, 0.079999998211860657, 808.08001708984375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10912, 1030314004, 8860000006, 0, 98, 89.9000015258789, 6.8000001907348633, 0.98000001907348633, 8, -9.0799999237060547, 9, 900.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10913, 1030001021, 9900087060, 0, 0, 0.699999988079071, 7, 0.090000003576278687, 0.699999988079071, -7.9000000953674316, 0.800000011920929, 97.9000015258789, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10914, 1030000000, 7009088600, 0, 999, 0, 0, 80, 0, -80, 0.079999998211860657, 0.079999998211860657, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10915, 1030000030, 9090079000, 0, 70, 0, 0, 0, 0, 0, 0.99000000953674316, 7.9899997711181641, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10916, 1030000030, 9090079007, 0, 70, 76, 0, 0, 90, -90, 67.9000015258789, 6, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10917, 1030000043, 9900080706, 0, 70, 98, 0.699999988079071, 0, 0, -99, 90.889999389648438, 780.78997802734375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10918, 1030000203, 9900080687, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10919, 1030000004, 9090079070, 0, 70, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10920, 1030242113, 7760960608, 0, 70, 607, 9, 0.070000000298023224, 0, -0.97000002861022949, 0, 908, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10921, 1030241001, 7760960606, 0, 0, 0, 0.60000002384185791, 706, 0, -709, 60.700000762939453, 88, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10922, 1030241021, 7760960600, 0, 0, 80, 6, 0, 0.699999988079071, -70, 70.5999984741211, 60, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10923, 1030242101, 7760960607, 0, 70, 80.800003051757812, 0, 0, 0, -8, 8.0799999237060547, 76.080001831054688, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10924, 1030241030, 7760960600, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10925, 1030242141, 7760960600, 0, 0, 0, 0, 0, 70.5999984741211, 0, 7, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10926, 1030241020, 7760960600, 0, 0, 9, 8, 8.880000114440918, 0, -0.079999998211860657, 0, 908, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10927, 1030242123, 7760960600, 0, 70, 70, 0, 0, 0, -80, 0, 0, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10928, 1030320000, 9700070006, 0, 70, 8, 0, 8, 9.6000003814697266, 0, 60.799999237060547, 80, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10929, 1041410301, 9970000000, 0, 0, 0, 0, 0.090000003576278687, 67.5999984741211, -90.790000915527344, 66.089996337890625, 0.79000002145767212, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10930, 1041411300, 9900600000, 0, 0, 60, 0, 0.090000003576278687, 70.9000015258789, -6.0900001525878906, 80.699996948242188, 600, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10931, 1041411300, 9980688600, 0, 70, 7.6999998092651367, 6.5999999046325684, 0.800000011920929, 0, 0, 70, 90, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10932, 1043300424, 9008070009, 0, 70, 70.699996948242188, 0, 8.09000015258789, 0, -8.09000015258789, 0, 76, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10933, 1040040210, 9090980807, 0, 99, 0, 0, 0, 0.699999988079071, 0, 6, 9.7899999618530273, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10934, 1040040210, 9090980770, 0, 900, 0, 0, 0, 0, -6, 90.069999694824219, 860.07000732421875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10935, 1000320020, 7009700600, 0, 99, 0, 0, 0, 0, 0, 0.60000002384185791, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10936, 1000320000, 7009700006, 0, 98, 80, 8.8999996185302734, 0, 0, -8, 0.68999999761581421, 800.09002685546875, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10937, 1000320000, 7009666990, 0, 99, 0, 0, 0, 0, 0, 0.60000002384185791, 0.60000002384185791, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10938, 1003020440, 9900008000, 0, 99, 80, 0, 0, 0, -70, 8.0799999237060547, 9.9799995422363281, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10939, 1003020410, 9686099000, 0, 98, 8, 0, 0, 70, -87, 0.059999998658895493, 807.05999755859375, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10940, 1003020343, 9900008000, 0, 708, 9.8999996185302734, 0, 70.069999694824219, 0, -90.970001220703125, 8, 980.70001220703125, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10941, 1003020400, 9686600000, 0, 98, 80, 0.699999988079071, 0, 0, -8.6000003814697266, 70, 70.9000015258789, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10942, 1004000210, 9700098909, 0, 9, 0, 0, 0, 0, -9, 6.6999998092651367, 0.89999997615814209, N'Admin', 4)
INSERT [dbo].[AirtelManagement] ([Id], [AccountNo], [AirtelNumber], [OnetimeCharges], [MonthlyCharges], [CallCharges], [ValueAddedServices], [MobileInternetUsage], [Roaming], [Discounts], [Taxes], [TotalCharges], [WhoUploaded], [ImportId]) VALUES (10943, 1032030033, 9900900990, 0, 70, 606, 0, 0.090000003576278687, 6.6999998092651367, 0, 0, 86, N'Admin', 4)
SET IDENTITY_INSERT [dbo].[AirtelManagement] OFF
SET IDENTITY_INSERT [dbo].[DataImportDates] ON 

INSERT [dbo].[DataImportDates] ([DateId], [CreatedData], [ForWhichMonth]) VALUES (1, N'2014-06-04', N'2014-03-04')
INSERT [dbo].[DataImportDates] ([DateId], [CreatedData], [ForWhichMonth]) VALUES (2, N'2014-06-04', N'2014-03-03')
INSERT [dbo].[DataImportDates] ([DateId], [CreatedData], [ForWhichMonth]) VALUES (3, N'2014-06-04', N'2014-03-10')
INSERT [dbo].[DataImportDates] ([DateId], [CreatedData], [ForWhichMonth]) VALUES (4, N'2014-06-04', N'2014-03-04')
SET IDENTITY_INSERT [dbo].[DataImportDates] OFF
INSERT [dbo].[StaticAdminDetails] ([UserName], [UserPassword], [RememberMe]) VALUES (N'Admin', N'cciadmin', 0)
SET IDENTITY_INSERT [dbo].[staticEmployeeDetails] ON 

INSERT [dbo].[staticEmployeeDetails] ([EmployeeId], [EmployeeName], [AccountName], [EmailAddress], [CostCenterId], [MobileNumber], [MobileAcNumber], [DataCardNumber], [DatacardAcNumber], [OfficeLocation]) VALUES (6, N'Sadanand', N'SonarSadanand', N'sadanandsnr@gmail.com', 34323, 9620839737, 34243, 54545, 45553, N'Banglore')
INSERT [dbo].[staticEmployeeDetails] ([EmployeeId], [EmployeeName], [AccountName], [EmailAddress], [CostCenterId], [MobileNumber], [MobileAcNumber], [DataCardNumber], [DatacardAcNumber], [OfficeLocation]) VALUES (7, N'Umakanta Swain', N'swainumakanta', N'umakanta@gmail.com', 12234, 9878987670, 122342, 322343, 453323, N'Banglore')
INSERT [dbo].[staticEmployeeDetails] ([EmployeeId], [EmployeeName], [AccountName], [EmailAddress], [CostCenterId], [MobileNumber], [MobileAcNumber], [DataCardNumber], [DatacardAcNumber], [OfficeLocation]) VALUES (10007, N'Raghav Shastri', N'raghav,shastri', N'raghav@gmail.com', 123423, 9678990981, 6787787, 678788, 768489, N'Banglore')
INSERT [dbo].[staticEmployeeDetails] ([EmployeeId], [EmployeeName], [AccountName], [EmailAddress], [CostCenterId], [MobileNumber], [MobileAcNumber], [DataCardNumber], [DatacardAcNumber], [OfficeLocation]) VALUES (10008, N'Manoj', N'Manoj K', N'manoj@ccivalve.com', 1232324, 8998990099, 2324234, 4234343, 2323323, N'Banglore')
INSERT [dbo].[staticEmployeeDetails] ([EmployeeId], [EmployeeName], [AccountName], [EmailAddress], [CostCenterId], [MobileNumber], [MobileAcNumber], [DataCardNumber], [DatacardAcNumber], [OfficeLocation]) VALUES (10009, N'Prabhanjan', N'kumars', N'prabs@ccivalve.com', 1400, 9999388383, 112211221, 1121, 1121, N'Bangalore')
SET IDENTITY_INSERT [dbo].[staticEmployeeDetails] OFF
ALTER TABLE [dbo].[AirtelManagement]  WITH CHECK ADD FOREIGN KEY([ImportId])
REFERENCES [dbo].[DataImportDates] ([DateId])
GO
ALTER TABLE [dbo].[AirtelManagement]  WITH CHECK ADD FOREIGN KEY([ImportId])
REFERENCES [dbo].[DataImportDates] ([DateId])
GO
