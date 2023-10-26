USE [BWSdb]
GO

/****** Object:  View [dbo].[v_EditModelBudgetInfoV2]    Script Date: 2023-10-26 2:16:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









ALTER view [dbo].[v_EditModelBudgetInfoV2] as
select ProductsV2.CompanyID, Class, ProductsV2.[Model No], Price, [US Price], [Budget Std V2].COGS as AccessCOGS, [Budget Std V2].[Labour Cost] as AccessLabourCost,
[Budget Std V2].[Made In Material] as AccessMadeIn, [Budget Std V2].[Bought Out Material] as AccessBoughtOut,
[Budget Std V2].Axles as AccessAxles, [Budget Std V2].[Step 1] as AccessStep1, [Budget Std V2].[Step 2] as AccessStep2,
[Budget Std V2].Blast as AccessBlast, [Budget Std V2].Paint as AccessPaint, [Budget Std V2].[Finish - GNK] as AccessFGNK,
[Budget Std V2].[Final Assembly] as AccessFinalAssembly, [Budget Std V2].[Tire Assembly] as AccessTireAssembly,
[Budget Std V2].Shipping as AccessShipping,
([Budget Std V2].Axles + [Budget Std V2].[Step 1] + [Budget Std V2].[Step 2] + [Budget Std V2].Blast + [Budget Std V2].Paint 
+ [Budget Std V2].[Finish - GNK] + [Budget Std V2].[Final Assembly] + [Budget Std V2].[Tire Assembly] + [Budget Std V2].Shipping) as AccessTotalHours,
cast(v_BOMCosting.COGS as money) as SYSPROCOGS, 
cast(v_BOMCosting.LabourCost as money) as SYSPROLabourCost,
cast(v_BOMCosting.MadeInMaterial as money) as SYSPROMadeIn, 
cast(v_BOMCosting.BoughtOutMaterial as money) as SYSPROBoughtOut,
cast(v_BOMCosting.Axle as float) as SYSPROAxles, 
cast(v_BOMCosting.Step1 as float) as SYSPROStep1, 
cast(v_BOMCosting.Step2 as float) as SYSPROStep2,
cast(v_BOMCosting.Blast as float) as SYSPROBlast, 
cast(v_BOMCosting.Paint as float) as SYSPROPaint, 
cast(v_BOMCosting.FGNK as float) as SYSPROFGNK,
cast(v_BOMCosting.FinalAssembly as float) as SYSPROFinalAssembly, 
cast(v_BOMCosting.TireAssembly as float) as SYSPROTireAssembly,
cast(v_BOMCosting.Shipping as float) as SYSPROShipping,
cast((v_BOMCosting.Axle + v_BOMCosting.Step1 + v_BOMCosting.Step2 + v_BOMCosting.Blast + v_BOMCosting.Paint 
+ v_BOMCosting.FGNK + v_BOMCosting.FinalAssembly + v_BOMCosting.TireAssembly + v_BOMCosting.Shipping) as float) as SYSPROTotalHours,
ProductsV2.[Top Level Part# (SYSPRO)], Model, [Start Date], [End Date], Weight, Width, Spread, [Promo Drawing], Proposed, [Non-Current],
QR_Discount1, QR_Discount2, QR_Discount3, Customer, NVIS, [GROUPING]
from ProductsV2 with (nolock)
inner join [Budget Std V2] with (nolock) on ProductsV2.CompanyID = [Budget Std V2].CompanyID
											and ProductsV2.[Model No] = [Budget Std V2].[Model No]
left outer join SysproCompanyA.dbo.v_BOMCosting on cast(ProductsV2.[Top Level Part# (SYSPRO 8)] as varchar(30)) collate Latin1_General_BIN = v_BOMCosting.ParentPart
GO


