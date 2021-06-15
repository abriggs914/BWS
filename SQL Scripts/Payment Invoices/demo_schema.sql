-- borrowed from https://stackoverflow.com/q/7745609/808921

CREATE TABLE [PizzaCompany] (
  [CompanyId] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED,
  [CompanyName] [varchar](50),
  [CompanyCity] [varchar](30)  
);
SET IDENTITY_INSERT PizzaCompany ON;

INSERT INTO [PizzaCompany] ([CompanyId], [CompanyName], [CompanyCity]) VALUES
  (1, 'Dominos', 'Los Angeles'),
  (2, 'Pizza Hut', 'San Francisco'),
  (3, 'Papa johns', 'San Diego'),
  (4, 'Ah Pizz', 'Fremont'),
  (5, 'Nino Pizza', 'Las Vegas'),
  (6, 'Pizzeria', 'Boston'),
  
  (7, 'chuck e cheese', 'Chicago'),
  (8, 'chuck e cheese', 'Los Angeles'),
  (9, 'chuck e cheese', 'San Francisco'),
  (10, 'chuck e cheese', 'San Diego'),
  (11, 'chuck e cheese', 'Fremont'),
  
  (12, 'Papa johns', 'Los Angeles'),
  (13, 'Papa johns', 'San Francisco'),
  (14, 'Papa johns', 'Fremont'),
  (15, 'Papa johns', 'Las Vegas'),
  (16, 'Papa johns', 'Boston'),
  (17, 'Papa johns', 'Chicago'),
  
  (19, 'Pizza Hut', 'Los Angeles'),
  (20, 'Pizza Hut', 'San Diego'),
  (21, 'Pizza Hut', 'Fremont'),
  (22, 'Pizza Hut', 'Las Vegas'),
  (23, 'Pizza Hut', 'Boston'),
  (24, 'Pizza Hut', 'Chicago'),
  
  (25, 'Ah Pizz', 'Los Angeles'),
  (26, 'Ah Pizz', 'San Francisco'),
  (27, 'Ah Pizz', 'San Diego'),
  (28, 'Ah Pizz', 'Las Vegas'),
  (29, 'Ah Pizz', 'Boston'),
  (30, 'Ah Pizz', 'Chicago');
