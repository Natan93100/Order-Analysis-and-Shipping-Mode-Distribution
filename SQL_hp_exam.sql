
--#1

Select
    Format([Order Date], 'yyyy-MM') As OrderDate,
    [Region],
    Count(*) AS OrderCount
From
    Orders
Group By 
    Format([Order Date], 'yyyy-MM'), [Region]
Order By OrderDate, OrderCount DESC;

--#2---------------------------------------------------------------------------------------
Select
    Top 1
    Format([Order Date], 'yyyy-MM') As OrderDate,
    [Region],
    Count(*) As OrderCount
From
    Orders
Group BY
    [region], 
    Format([Order Date], 'yyyy-MM')
order by 
    OrderCount Desc;

--#3---------------------------------------------------------------------------------------

-- I split the query into 4 CTEs (each for each ship mode) and used a union to merge rows.

With
    FirstClass
    AS
    (
        Select
            [Ship Mode],
            Count(*) * 100 / Cast((Select Count(*)
            From Orders
            Where [Ship Mode] = 'First Class') As float) AS PERCENTAGE
        -- i multiplied by 100 to get a %
        From
            [Orders]
        Where 
        Format([Order Date], 'MMM-yyyy') = 'Sep-2014' And [Ship Mode] = 'First Class'
        Group By 
        [Ship Mode]
    ),
    SameDay
    AS
    (
        Select
            [Ship Mode],
            Count(*) * 100 / Cast((Select Count(*)
            From Orders
            Where [Ship Mode] = 'Same Day') As float) AS PERCENTAGE
        From
            [Orders]
        Where 
        Format([Order Date], 'MMM-yyyy') = 'Sep-2014' And [Ship Mode] = 'Same Day'
        Group By 
        [Ship Mode]
    ),
    StandardClass
    AS
    (
        Select
            [Ship Mode],
            Count(*) * 100 / Cast((Select Count(*)
            From Orders
            Where [Ship Mode] = 'Standard Class') As float) AS PERCENTAGE
        From
            [Orders]
        Where 
        Format([Order Date], 'MMM-yyyy') = 'Sep-2014' And [Ship Mode] = 'Standard Class'
        Group By 
        [Ship Mode]
    ),
    SecondClass
    AS
    (
        Select
            [Ship Mode],
            Count(*) * 100 / Cast((Select Count(*)
            From Orders
            Where [Ship Mode] = 'Second Class') As float) AS PERCENTAGE
        From
            [Orders]
        Where 
        Format([Order Date], 'MMM-yyyy') = 'Sep-2014' And [Ship Mode] = 'Second Class'
        Group By 
        [Ship Mode]
    )

    Select [Ship Mode], Round([PERCENTAGE],3) As PercentRatio
    From
        FirstClass

UNION

    Select [Ship Mode], Round([PERCENTAGE],3)
    From
        SameDay

UNION

    Select [Ship Mode], Round([PERCENTAGE],3)
    From
        StandardClass

UNION

    Select [Ship Mode], Round([PERCENTAGE],3)
    From
        SecondClass;

--#4---------------------------------------------------------------------------------------

Select TOP 2
    [Product Name], COUNT(*) as count, Category, SUM(Sales) as profitORloss
From orders
    INNER JOIN
    [returns] on orders.[Order ID]=[returns].[Order ID]
GROUP by [Product Name],Category
order by count desc;

-- Attention: some of the products in the table had the same name but different product id and vice versa (e.g: KI Adjustable-Height Table), 
-- because of that it's not logical to determine which product was the most returnable.
-- Nevertheless, i found the 2 (WHICH HAD A TIE) most returnble ones by name.

--#5---------------------------------------------------------------------------------------

Select
    [Product ID],
    Avg([Sales]) As AverageSalePrice
From
    Orders
Group By 
    [Product ID]

Union
    -- since you asked to use only one query, i used union.

    Select
        [Sub Category],
        Avg([Sales])
    From
        Orders
    Group By 
    [Sub Category];

--#6---------------------------------------------------------------------------------------

select
    [Customer ID]
from
    Orders
Group by 
    [Customer ID],
    Category,
    Format([Order Date], 'yyyy-MM')
Having 
    COUNT(*) > 1;

--#7---------------------------------------------------------------------------------------

select
    distinct Left([Customer ID], 2) As [Customer Group ID]
-- just for presentation
from orders;

--#8---------------------------------------------------------------------------------------

SELECT
    [Sub Category],
    Format([Order Date], 'yyyy') AS Year,
    sum(Sales) SumOfSales
From
    orders
group by 
    [Sub Category],
    Format([Order Date], 'yyyy')
order BY
    Year;
