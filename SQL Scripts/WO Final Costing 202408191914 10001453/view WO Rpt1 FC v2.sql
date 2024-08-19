USE [Stargatedb]
GO

/****** Object:  View [dbo].[WO Rpt1 FC v2]    Script Date: 2024-08-19 3:02:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		 James Crawford
-- Create date: 2021-10-25 13:14
-- Description: Used as part of the resultset for the Stargate "WO Final Cost Rpt1" in the SysproCompanyS Access database.

-- 2024-01-18 James Crawford - Adjusted joins and added "ISNUMERIC" where clauses to help improve performance
-- =============================================

--ALTER VIEW [dbo].[WO Rpt1 FC v2]
--AS
SELECT        TOP (100) PERCENT dbo.[WO Rpt1 FC v2-1].[Quote Date], dbo.[WO Rpt1 FC v2-1].[Order Date], dbo.[WO Rpt1 FC v2-1].WO#, dbo.[WO Rpt1 FC v2-1].Class, 
                         dbo.[WO Rpt1 FC v2-1].Model, dbo.[WO Rpt1 FC v2-1].[Model No], dbo.[WO Rpt1 FC v2-1].CONTACT, dbo.[WO Rpt1 FC v2-1].Price, 
                         dbo.[WO Rpt1 FC v2-1].[Prom Drawing], dbo.[WO Rpt1 FC v2-1].[Special Instructions], dbo.[WO Rpt1 FC v2-1].[COMPANY NAME], 
                         dbo.[WO Rpt1 FC v2-1].[Serial Number], dbo.[WO Rpt1 FC v2-1].[Delivery Date], dbo.[WO Rpt1 FC v2-1].[Purchase Order], dbo.[WO Rpt1 FC v2-1].[PO Date], 
                         dbo.[WO Rpt1 FC v2-1].[Est Pro Date], dbo.[WO Rpt1 FC v2-1].[Sales Person], dbo.[WO Rpt1 FC v2-1].Width, dbo.[WO Rpt1 FC v2-1].Spread, 
                         dbo.[WO Rpt1 FC v2-1].SGQuote, dbo.[WO Rpt1 FC v2-1].PDD, dbo.[WO Rpt1 FC v2-1].[Deck Length], dbo.[WO Rpt1 FC v2-1].NetWt, dbo.[WO Rpt1 FC v2-1].UnitWt, 
                         dbo.[WO Rpt1 FC v2-1].[Prod Date], dbo.[WO Rpt1 FC v2-1].Reason, dbo.[WO Rpt1 FC v2-1].[Date Declined], dbo.[WO Rpt1 FC v2-1].[Shipped Date], dbo.[WO Rpt1 FC v2-1].BHAxles, dbo.[WO Rpt1 FC v2-1].[BHStakes/Bunks], 
                         dbo.[WO Rpt1 FC v2-1].BHBeam, dbo.[WO Rpt1 FC v2-1].BHGNK, dbo.[WO Rpt1 FC v2-1].BHParts, dbo.[WO Rpt1 FC v2-1].BHTrailer, dbo.[WO Rpt1 FC v2-1].BHLine, 
                         dbo.[WO Rpt1 FC v2-1].BHSubs, dbo.[WO Rpt1 FC v2-1].[BHMachine Shop], dbo.[WO Rpt1 FC v2-1].BHBlast, dbo.[WO Rpt1 FC v2-1].BHPaint, 
                         dbo.[WO Rpt1 FC v2-1].BHFinish, dbo.[WO Rpt1 FC v2-1].BHShipping, dbo.[WO Rpt1 FC v2-1].TtlBHrs, dbo.[WO Rpt1 FC v2-1].[Hrly Rate], 
                         dbo.[WO Rpt1 FC v2-1].NPOAxle, dbo.[WO Rpt1 FC v2-1].NPOLine, dbo.[WO Rpt1 FC v2-1].NPOTrailer, dbo.[WO Rpt1 FC v2-1].NPOSubs, dbo.[WO Rpt1 FC v2-1].NPOMS, dbo.[WO Rpt1 FC v2-1].NPOPnt, 
                         dbo.[WO Rpt1 FC v2-1].NPOFinish, dbo.[WO Rpt1 FC v2-1].[NPOTtl Hrs], dbo.[WO Rpt1 FC v2-1].TtlBHrs$, dbo.[WO Rpt1 FC v2-1].TtlBHrs$1, 
                         dbo.[WO Rpt1 FC v2-1].BudTrailer, dbo.[WO Rpt1 FC v2-1].BudSubs, dbo.[WO Rpt1 FC v2-1].[BudMachine Shop], dbo.[WO Rpt1 FC v2-1].BudPaint, 
                         dbo.[WO Rpt1 FC v2-1].BudFinish, dbo.[WO Rpt1 FC v2-1].[Bud TtlHrs], dbo.[WO Rpt1 FC v2-1].Cost, dbo.[WO Rpt1 FC v2-1].[Volume Discount], 
                         dbo.[WO Rpt1 FC v2-1].[Vol Dis], dbo.[WO Rpt1 FC v2-1].SubTtl, dbo.[WO Rpt1 FC v2-1].[Program Discount], dbo.[WO Rpt1 FC v2-1].[Pro Dis], dbo.[WO Rpt1 FC v2-1].[Other Discount],
						 dbo.[WO Rpt1 FC v2-1].Discount1_Name, dbo.[WO Rpt1 FC v2-1].Discount1_Type, dbo.[WO Rpt1 FC v2-1].Discount1,
						 dbo.[WO Rpt1 FC v2-1].Discount2_Name, dbo.[WO Rpt1 FC v2-1].Discount2_Type, dbo.[WO Rpt1 FC v2-1].Discount2,
						 dbo.[WO Rpt1 FC v2-1].Discount3_Name, dbo.[WO Rpt1 FC v2-1].Discount3_Type, dbo.[WO Rpt1 FC v2-1].Discount3,
                         dbo.[WO Rpt1 FC v2-1].TrailerOBH, dbo.[WO Rpt1 FC v2-1].SubsOBH, dbo.[WO Rpt1 FC v2-1].[Machine ShopOBH], dbo.[WO Rpt1 FC v2-1].AxlesOBH,
                         dbo.[WO Rpt1 FC v2-1].LineOBH, dbo.[WO Rpt1 FC v2-1].BlastOBH, dbo.[WO Rpt1 FC v2-1].PaintOBH, dbo.[WO Rpt1 FC v2-1].FinishOBH, dbo.[WO Rpt1 FC v2-1].TtlOBH, 
                         dbo.[WO Rpt1 FC v2-1].TtlOBH$, dbo.[WO Rpt1 FC v2-1].[US Sale], dbo.[WO Rpt1 FC v2-1].[Margins Options], dbo.[WO Rpt1 FC v2-1].[Budget Cost], 
                         dbo.[WO Rpt1 FC v2-1].Discount, dbo.[WO Rpt1 FC v2-1].[Net Cost], dbo.[WO Rpt1 FC v2-1].BudOptMat$, dbo.[WO Rpt1 FC v2-1].NPOMat$, 
                         dbo.[WO Rpt1 FC v2-1].BudMat$, dbo.[WO Rpt1 FC v2-1].[Bud TtlHrs$], dbo.[WO Rpt1 FC v2-1].[Bud TtlHrs$1], dbo.[WO Rpt1 FC v2-1].TtlBudMat, 
                         dbo.[WO Rpt1 FC v2-1].TtlBudCost, dbo.[WO Rpt1 FC v2-1].TtlBudNSP, dbo.[WO Rpt1 FC v2-1].BudNP, dbo.[WO Rpt1 FC v2-1].BudLine, dbo.[WO Rpt1 FC v2-1].BudAxle, 
                         dbo.[WO Rpt1 FC v2-1].BudBeam, dbo.[WO Rpt1 FC v2-1].BudGNK, dbo.[WO Rpt1 FC v2-1].BudShipping,
						 /*
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetMachineShop) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].[Machine ShopOBH] + dbo.[WO Rpt1 FC v2-1].NPOMS) end as [MachineShopOptions/NPOs],
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBeams) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].BeamOBH + dbo.[WO Rpt1 FC v2-1].NPOBeam) end as [BeamOptions/NPOs],
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetSubs) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].SubsOBH + dbo.[WO Rpt1 FC v2-1].NPOSubs) end as [SubsOptions/NPOs],
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAxles) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].AxlesOBH + dbo.[WO Rpt1 FC v2-1].NPOAxle) end as [AxlesOptions/NPOs],
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAssembly) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].LineOBH + dbo.[WO Rpt1 FC v2-1].NPOLine) end as [AssemblyOptions/NPOs],
						 0 as [WheelsOptions/NPOs],
						 case when (CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBlast) + CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPaint)) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].BlastOBH + dbo.[WO Rpt1 FC v2-1].PaintOBH + dbo.[WO Rpt1 FC v2-1].NPOBlast + dbo.[WO Rpt1 FC v2-1].NPOPnt) end as [PaintOptions/NPOs],
						 case when CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFinish) = 0 then 0 else (dbo.[WO Rpt1 FC v2-1].FinishOBH + dbo.[WO Rpt1 FC v2-1].NPOFinish) end as [FinishOptions/NPOs],
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseMachineShop) AS BaseMachineShop, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseAxles) AS BaseAxles, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBeams) AS BaseBeams, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseAssembly) AS BaseAssembly, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseTAssembly) AS BaseWheels, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBlast + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BasePaint) AS BasePaint, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseFinish) AS BaseFinish, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseShipping) AS BaseShipping, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseMachineShop + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseAxles + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBeams
                          + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseAssembly + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseTAssembly + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBlast 
						  + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BasePaint + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseFinish + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseShipping) AS TotalBase, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetMachineShop) AS NetMachineShop, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAxles) AS NetAxles, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBeams) AS NetBeams,
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetSubs) AS NetSubs, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAssembly) AS NetAssembly, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetTAssembly) AS NetWheels, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBlast + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPaint) AS NetPaint, 
						 CONVERT(float, case when WO# = 10013037 then SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetShipping
										else SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFinish end) AS NetFinish, 
                         CONVERT(float, case when WO# = 10013037 then SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFinish
										else SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetShipping end) AS NetShipping, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetMachineShop + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAxles + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBeams
                          + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetSubs + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetAssembly + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetTAssembly 
						  + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBlast + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPaint + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFinish + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetShipping) AS TotalNet, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualMachineShop) AS ActualMachineShop, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualAxle) AS ActualAxle, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBeam) AS ActualBeam,
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualSubs) AS ActualSubs, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualLine) AS ActualLine,
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualTAssembly) AS ActualWheels,  
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBlast + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualPaint) AS ActualPaint, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualFinish) AS ActualFinish, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualShipping) AS ActualShipping, 
						 CONVERT(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualMachineShop + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualAxle + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualLine + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualTAssembly
                          + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualSubs + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBeam + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBlast + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualPaint 
						  + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualFinish + SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualShipping) AS TotalActual, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkMachineShop) AS ReworkMachineShop, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkAxle) AS ReworkAxle, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkBeam) AS ReworkBeam,
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkSubs) AS ReworkSubs, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkLine) AS ReworkLine, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkWheels) AS ReworkWheels,
                         CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkPaint) AS ReworkPaint, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkFinish) AS ReworkFinish, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkShipping) AS ReworkShipping, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkMachineShop + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkAxle + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkLine
						  + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkWheels + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkSubs + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkBeam
                          + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkPaint + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkFinish + SysproCompanyS.dbo.v_JobReworkHours_SG.ReworkShipping)
                          AS TotalRework, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToMachineShop) AS ChargedToMachineShop, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToAxles) AS ChargedToAxle, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToSubs) AS ChargedToSubs, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToBeams) AS ChargedToBeam,
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToAssembly) AS ChargedToAssembly, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToWheels) AS ChargedToWheels,
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToPaint) AS ChargedToPaint, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToFinish) AS ChargedToFinish, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToShipping) AS ChargedToShipping, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToMachineShop + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToAxles + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToBeams
                          + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToAssembly + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToWheels + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToPaint 
						  + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToFinish + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToShipping + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToSubs) AS TotalReworkCharged, 
						  */
						0 as [PolishOptions/NPOs], 0 as [PrepOptions/NPOs], 0 as [FloorOptions/NPOs], 0 as [WallOptions/NPOs], 0 as [TGOptions/NPOs],
						0 as [BHOptions/NPOs], 0 as [PaintOptions/NPOs], 0 as [ChassisOptions/NPOs], 0 as [BoxOptions/NPOs], 0 as [FinishOptions/NPOs], 0 as [TotalOptions/NPOs],
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BasePolish) as BasePolish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BasePrep) as BasePrep,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseFloor) as BaseFloor,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseWall) as BaseWall,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseTG) as BaseTG,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBH) as BaseBH,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BasePaint) as BasePaint,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseChassis) as BaseChassis,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseBox) as BaseBox,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseFinish) as BaseFinish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].BaseTotal) as BaseTotal,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPolish) as NetPolish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPrep) as NetPrep,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFloor) as NetFloor,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetWall) as NetWall,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetTG) as NetTG,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBH) as NetBH,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetPaint) as NetPaint,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetChassis) as NetChassis,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetBox) as NetBox,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetFinish) as NetFinish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].NetTotal) as NetTotal,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualPolish) as ActualPolish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualPrep) as ActualPrep,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualFloor) as ActualFloor,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualWall) as ActualWall,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualTG) as ActualTG,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBH) as ActualBH,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualPaint) as ActualPaint,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualChassis) as ActualChassis,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualBox) as ActualBox,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualFinish) as ActualFinish,
						convert(float, SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].ActualTotal) as ActualTotal,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkPolish) as ReworkPolish,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkPrep) as ReworkPrep,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkFloor) as ReworkFloor,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkWall) as ReworkWall,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkTG) as ReworkTG,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkBH) as ReworkBH,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkPaint) as ReworkPaint,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkChassis) as ReworkChassis,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkBox) as ReworkBox,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkFinish) as ReworkFinish,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ReworkTotal) as ReworkTotal,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToPolish) as ChargedToPolish,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToPrep) as ChargedToPrep,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToFloor) as ChargedToFloor,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToWall) as ChargedToWall,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToTG) as ChargedToTG,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToBH) as ChargedToBH,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToPaint) as ChargedToPaint,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToChassis) as ChargedToChassis,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToBox) as ChargedToBox,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToFinish) as ChargedToFinish,
						convert(float, SysproCompanyS.dbo.[v_JobReworkHours_SG].ChargedToTotal) as ChargedToTotal,
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToSales) AS ChargedToSales, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToBOM) AS ChargedToBOM, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToEngineering) AS ChargedToEngineering, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToParts) AS ChargedToParts, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToPurchasing) AS ChargedToPurchasing, 
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToWorkmanship) AS ChargedToWorkmanship,
						  CONVERT(float, SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToSales + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToBOM + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToEngineering + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToParts
                          + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToPurchasing + SysproCompanyS.dbo.v_JobReworkHours_SG.ChargedToWorkmanship) AS TotalReworkSummary, 
                         CONVERT(float, case when WO# between 10012463 and 10012493 then AccessBaseWOLabour else SysproCompanyS.dbo.v_JobCosting.LabourCost end) AS NetLabourCost, 
						 CONVERT(float, case when WO# between 10012463 and 10012493 then AccessBaseWOMadeInMat else SysproCompanyS.dbo.v_JobCosting.MadeInMaterial end) AS NetMadeInMaterial, 
						 CONVERT(float, case when WO# between 10012463 and 10012493 then AccessBaseWOBoughtOutMat else SysproCompanyS.dbo.v_JobCosting.BoughtOutMaterial end) AS NetBoughtOutMaterial, 
						 CONVERT(float, case when WO# between 10012463 and 10012493 then AccessBaseWOCOGS else SysproCompanyS.dbo.v_JobCosting.TotalCost end) AS NetTotalCost, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobCosting.ActualLabourCost) AS ActualLabourCost, 
                         CONVERT(float, SysproCompanyS.dbo.v_JobCosting.ActualMadeInMaterial) AS ActualMadeInMaterial, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobCosting.ActualBoughtOutMaterial) AS ActualBoughtOutMaterial, 
						 CONVERT(float, SysproCompanyS.dbo.v_JobCosting.ActualTotalCost) AS ActualTotalCost,
                         dbo.[WO Rpt1 FC v2-1].BHAxles + dbo.[WO Rpt1 FC v2-1].BHLine + dbo.[WO Rpt1 FC v2-1].BHPaint + dbo.[WO Rpt1 FC v2-1].BHFinish AS AccessBaseBudget,
						 case when SysproCompanyS.dbo.v_CompletedJobInfo.ActCompleteDate is null then [WO Rpt1 FC v2-1].[Date Completed] else SysproCompanyS.dbo.v_CompletedJobInfo.ActCompleteDate end as [Date Completed],
						 case when SysproCompanyS.dbo.v_CompletedJobInfo.EntInvoiceDate is null then [WO Rpt1 FC v2-1].[Invoice Date] else SysproCompanyS.dbo.v_CompletedJobInfo.EntInvoiceDate end as [Invoice Date],
						 case when SysproCompanyS.dbo.v_CompletedJobInfo.ExchangeRate is null then [WO Rpt1 FC v2-1].[FE Rate] else SysproCompanyS.dbo.v_CompletedJobInfo.ExchangeRate end as [FE Rate],
						 REPLACE(LTRIM(REPLACE([Sales Order#], '0', ' ')), ' ', '0') as [Sales Order#], --leading zero removal function reference: https://stackoverflow.com/questions/28379337/removing-leading-zeros-from-a-string-in-sql-server-2008-r2
						 REPLACE(LTRIM(REPLACE(InvoiceNumber, '0', ' ')), ' ', '0') as InvoiceNumber --leading zero removal function reference: https://stackoverflow.com/questions/28379337/removing-leading-zeros-from-a-string-in-sql-server-2008-r2
FROM            
	dbo.[WO Rpt1 FC v2-1]
LEFT OUTER JOIN
	SysproCompanyS.dbo.v_JobReworkHours_SG 
ON 
	dbo.[WO Rpt1 FC v2-1].WO# = SysproCompanyS.dbo.v_JobReworkHours_SG.Job
LEFT OUTER JOIN
	SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG]
ON
	CAST(dbo.[WO Rpt1 FC v2-1].WO# AS varchar(20)) COLLATE Latin1_General_BIN = SysproCompanyS.dbo.[v_JobBudget&ActualHours_SG].Job
LEFT OUTER JOIN
	SysproCompanyS.dbo.v_JobCosting
ON
	CAST(dbo.[WO Rpt1 FC v2-1].WO# AS varchar(20)) COLLATE Latin1_General_BIN = SysproCompanyS.dbo.v_JobCosting.Job
left outer join 
	SysproCompanyS.dbo.v_CompletedJobInfo
on
	dbo.[WO Rpt1 FC v2-1].WO# = SysproCompanyS.dbo.v_CompletedJobInfo.Job
WHERE
   (
      ISNUMERIC(v_CompletedJobInfo.Job) = 1
      or v_CompletedJobInfo.Job is null
   )
   and (
      ISNUMERIC(v_JobCosting.Job) = 1
      or v_JobCosting.Job is null
   )
   and (
      ISNUMERIC([v_JobBudget&ActualHours_SG].Job) = 1
      or [v_JobBudget&ActualHours_SG].Job is null
   )
   and (
      ISNUMERIC(v_JobReworkHours_SG.Job) = 1
      or v_JobReworkHours_SG.Job is null
   )
   AND ([WO#] = 10001453)





--GO


