USE BWSdb
GO

-- Rename a model -- EVERYWHERE

BEGIN TRAN;

	DECLARE @t AS TABLE (
		[ID] INT IDENTITY(0, 1)
		, [OldName] NVARCHAR(MAX)
		, [NewName] NVARCHAR(MAX)
	)

	INSERT INTO @t ([OldName], [NewName]) VALUES
	('B-Train LEAD 3X - Pace', 'BTL3XSS PACE'),
	('B-Train Lead  - 4X - S.S. Pace', 'BTL4XASS PACE'),
	
	('B-Train Lead - 4XAF - Pace', 'BTL4XAS PACE'),
	('B-Train Pull - 2XAF - Pace', 'BTP2XAS PACE'),

	('B-Train Lead - 4X - Pace', 'BTL4XSS PACE'),
	('B-Train Pull - 2X - Pace', 'BTP2XSS PACE'),

	('B-Train Lead - 4X - S.S. Pace', 'BTL4XASS PACE'),
	('B-Train Pull - 2X - S.S. Pace', 'BTP2XASS PACE'),

	('B-Train Lead - 3X - Pace', 'BTL3XSS PACE'),
	('B-Train Pull - 3X - Pace', 'BTP3XSS PACE')

	DECLARE @doUpdate AS BIT = 0;

	SELECT 'Bef OrdersV2' AS [T], * FROM [OrdersV2] INNER JOIN @t ON [OrdersV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [OrdersV2] SET
			[Model No] = [NewName]
			, [Special Instructions] = ISNULL([Special Instructions] + ' ', '') + CAST(GETDATE() AS NVARCHAR(MAX)) + ', Model name change: ''' + [OldName] + ''' to ''' + [NewName] + '''.'
		FROM [OrdersV2] INNER JOIN @t ON [OrdersV2].[Model No] = [@t].[OldName];
		SELECT 'Aft OrdersV2' AS [T], * FROM [OrdersV2] INNER JOIN @t ON [OrdersV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Order OptionsV2' AS [T], * FROM [Order OptionsV2] INNER JOIN @t ON [Order OptionsV2].[Option No] LIKE '%' + [@t].[OldName] + '%';
	IF @doUpdate = 1 BEGIN
		UPDATE [Order OptionsV2] SET [Option No] = REPLACE([Option No], [OldName], [NewName]) FROM [Order OptionsV2] INNER JOIN @t ON [Order OptionsV2].[Option No] LIKE '%' + [@t].[OldName] + '%';
		SELECT 'Aft Order OptionsV2' AS [T], * FROM [Order OptionsV2] INNER JOIN @t ON [Order OptionsV2].[Option No] LIKE '%' + [@t].[NewName] + '%';
	END

	SELECT 'Bef Order OptionsV2_FactoryLines' AS [T], * FROM [Order OptionsV2_FactoryLines] INNER JOIN @t ON [Order OptionsV2_FactoryLines].[Option No] LIKE '%' + [@t].[OldName] + '%';
	IF @doUpdate = 1 BEGIN
		UPDATE [Order OptionsV2_FactoryLines] SET [Option No] = REPLACE([Option No], [OldName], [NewName]) FROM [Order OptionsV2_FactoryLines] INNER JOIN @t ON [Order OptionsV2_FactoryLines].[Option No] LIKE '%' + [@t].[OldName] + '%';
		SELECT 'Aft Order OptionsV2_FactoryLines' AS [T], * FROM [Order OptionsV2_FactoryLines] INNER JOIN @t ON [Order OptionsV2_FactoryLines].[Option No] LIKE '%' + [@t].[NewName] + '%';
	END

	SELECT 'Bef Order OptionsV2_SpecLines' AS [T], * FROM [Order OptionsV2_SpecLines] INNER JOIN @t ON [Order OptionsV2_SpecLines].[Option No] LIKE '%' + [@t].[OldName] + '%';
	IF @doUpdate = 1 BEGIN
		UPDATE [Order OptionsV2_SpecLines] SET [Option No] = REPLACE([Option No], [OldName], [NewName]) FROM [Order OptionsV2_SpecLines] INNER JOIN @t ON [Order OptionsV2_SpecLines].[Option No] LIKE '%' + [@t].[OldName] + '%';
		SELECT 'Aft Order OptionsV2_SpecLines' AS [T], * FROM [Order OptionsV2_SpecLines] INNER JOIN @t ON [Order OptionsV2_SpecLines].[Option No] LIKE '%' + [@t].[NewName] + '%';
	END

	SELECT 'Bef DesignV2' AS [T], * FROM [DesignV2] INNER JOIN @t ON [DesignV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [DesignV2] SET [Model No] = [NewName] FROM [DesignV2] INNER JOIN @t ON [DesignV2].[Model No] = [@t].[OldName];
		SELECT 'Aft DesignV2' AS [T], * FROM [DesignV2] INNER JOIN @t ON [DesignV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef ProductionV2' AS [T], * FROM [ProductionV2] INNER JOIN @t ON [ProductionV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [ProductionV2] SET [Model No] = [NewName] FROM [ProductionV2] INNER JOIN @t ON [ProductionV2].[Model No] = [@t].[OldName];
		SELECT 'Aft ProductionV2' AS [T], * FROM [ProductionV2] INNER JOIN @t ON [ProductionV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef ProductsV2' AS [T], * FROM [ProductsV2] INNER JOIN @t ON [ProductsV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [ProductsV2] SET
			[Model No] = [NewName]
			, [Model] = [NewName]
		FROM [ProductsV2] INNER JOIN @t ON [ProductsV2].[Model No] = [@t].[OldName];
		SELECT 'Aft ProductsV2' AS [T], * FROM [ProductsV2] INNER JOIN @t ON [ProductsV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef StandardsV2' AS [T], * FROM [StandardsV2] INNER JOIN @t ON [StandardsV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [StandardsV2] SET
			[Model No] = [NewName]
			, [Standard No] = REPLACE([Standard No], [OldName], [NewName])
		FROM [StandardsV2] INNER JOIN @t ON [StandardsV2].[Model No] = [@t].[OldName];
		SELECT 'Aft StandardsV2' AS [T], * FROM [StandardsV2] INNER JOIN @t ON [StandardsV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Order StandardsV2' AS [T], * FROM [Order StandardsV2] INNER JOIN @t ON [Order StandardsV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [Order StandardsV2] SET
			[Model No] = [NewName]
			, [Standard No] = REPLACE([Standard No], [OldName], [NewName])
		FROM [Order StandardsV2] INNER JOIN @t ON [Order StandardsV2].[Model No] = [@t].[OldName];
		SELECT 'Aft Order StandardsV2' AS [T], * FROM [Order StandardsV2] INNER JOIN @t ON [Order StandardsV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef OptionsV2' AS [T], * FROM [OptionsV2] INNER JOIN @t ON [OptionsV2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [OptionsV2] SET
			[Model No] = [NewName]
			, [Option No] = REPLACE([Option No], [OldName], [NewName])
		FROM [OptionsV2] INNER JOIN @t ON [OptionsV2].[Model No] = [@t].[OldName];
		SELECT 'Aft OptionsV2' AS [T], * FROM [OptionsV2] INNER JOIN @t ON [OptionsV2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Budget Options V2' AS [T], * FROM [Budget Options V2] INNER JOIN @t ON [Budget Options V2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [Budget Options V2] SET
			[Model No] = [NewName]
			, [Option No] = REPLACE([Option No], [OldName], [NewName])
		FROM [Budget Options V2] INNER JOIN @t ON [Budget Options V2].[Model No] = [@t].[OldName];
		SELECT 'Aft Budget Options V2' AS [T], * FROM [Budget Options V2] INNER JOIN @t ON [Budget Options V2].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Options V2_FactoryLines' AS [T], * FROM [Options V2_FactoryLines] INNER JOIN @t ON [Options V2_FactoryLines].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [Options V2_FactoryLines] SET [Model No] = [NewName] FROM [Options V2_FactoryLines] INNER JOIN @t ON [Options V2_FactoryLines].[Model No] = [@t].[OldName];
		SELECT 'Aft Options V2_FactoryLines' AS [T], * FROM [Options V2_FactoryLines] INNER JOIN @t ON [Options V2_FactoryLines].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Options V2_SpecLines' AS [T], * FROM [Options V2_SpecLines] INNER JOIN @t ON [Options V2_SpecLines].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [Options V2_SpecLines] SET [Model No] = [NewName] FROM [Options V2_SpecLines] INNER JOIN @t ON [Options V2_SpecLines].[Model No] = [@t].[OldName];
		SELECT 'Aft Options V2_SpecLines' AS [T], * FROM [Options V2_SpecLines] INNER JOIN @t ON [Options V2_SpecLines].[Model No] = [@t].[NewName];
	END

	SELECT 'Bef Budget Std V2' AS [T], * FROM [Budget Std V2] INNER JOIN @t ON [Budget Std V2].[Model No] = [@t].[OldName];
	IF @doUpdate = 1 BEGIN
		UPDATE [Budget Std V2] SET [Model No] = [NewName] FROM [Budget Std V2] INNER JOIN @t ON [Budget Std V2].[Model No] = [@t].[OldName];
		SELECT 'Aft Budget Std V2' AS [T], * FROM [Budget Std V2] INNER JOIN @t ON [Budget Std V2].[Model No] = [@t].[NewName];
	END

ROLLBACK;
COMMIT;