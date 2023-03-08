SELECT 
	[IDTrailer],
	BWSdb_ProductsV2.Class,
	BWSdb_ProductsV2.[Model No]
	FROM [ProductsV2] AS BWSdb_ProductsV2
	WHERE 
		(
			(
				(BWSdb_ProductsV2.Class)='Pace' 
		--	And ((BWSdb_ProductsV2.CompanyID)=1) 
			--And ((BWSdb_ProductsV2.[Non-Current])=0) 
			--And ((BWSdb_ProductsV2.Proposed)=0) 
			--And ((BWSdb_ProductsV2.Customer)=0))
	))
	ORDER BY 
	BWSdb_ProductsV2.[Model No]; 

DECLARE @cl AS TABLE ([ID] INT IDENTITY(0, 1), [MN] NVARCHAR(MAX));
INSERT INTO @cl ([MN]) VALUES
	('BTL4XSS PACE'),
	('BTP2XSS PACE'),

	('BTL3XSS PACE'),
	('BTP3XSS PACE'),

	('BTL4XAS PACE'),
	('BTP2XAS PACE'),

	('BTL4XASS PACE'),
	('BTP2XASS PACE'),

	('ED4X Detroit'),

	('ED4X PACE')
;

SELECT * FROM [ProductsV2] INNER JOIN @cl ON [Model No] = [MN];
SELECT * FROM [ProductsV2] ORDER BY [IDTrailer];

BEGIN TRAN

DELETE FROM [ProductsV2]
WHERE
	[IDTrailer] = 622
ROLLBACK;
COMMIT;