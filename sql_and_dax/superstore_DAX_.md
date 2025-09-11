## KPI Measures
```DAX
Total Sales = SUM('Orders'[Sales])

Total Profit = SUM('Orders'[Profit])

Profit Margin % = 
    DIVIDE([Total Profit], [Total Sales], 0)

Loss Orders % = 
    DIVIDE(
        CALCULATE(COUNTROWS('Orders'), 'Orders'[Profit] < 0),
        COUNTROWS('Orders'),
        0
    )

Average Order Value (AOV) = 
    DIVIDE([Total Sales], DISTINCTCOUNT('Orders'[Order ID]), 0)
```
## Discount Analysis

```
Avg Discount (All Orders) = 
    AVERAGE('Orders'[Discount])

Avg Discount (Loss Orders) = 
    CALCULATE(
        AVERAGE('Orders'[Discount]), 
        'Orders'[Profit] < 0
    )

Avg Discount (Profit Orders) = 
    CALCULATE(
        AVERAGE('Orders'[Discount]), 
        'Orders'[Profit] > 0
    )
```

## Product and category performance
```Category Profit = 
    SUMX(
        VALUES('Orders'[Category]), 
        SUM('Orders'[Profit])
    )

Top Loss Product = 
    TOPN(
        1,
        SUMMARIZE(
            'Orders',
            'Orders'[Product Name],
            "Loss", SUM('Orders'[Profit])
        ),
        [Loss],
        ASC
    )

Top Profit Product = 
    TOPN(
        1,
        SUMMARIZE(
            'Orders',
            'Orders'[Product Name],
            "Profit", SUM('Orders'[Profit])
        ),
        [Profit],
        DESC
    )
```
## Trend Analysis

```Monthly Sales = 
    SUM('Orders'[Sales])

Monthly Profit = 
    SUM('Orders'[Profit])

Cumulative Sales = 
    CALCULATE(
        [Total Sales],
        FILTER(
            ALL('Orders'[Order Date]),
            'Orders'[Order Date] <= MAX('Orders'[Order Date])
        )
    )

Cumulative Profit = 
    CALCULATE(
        [Total Profit],
        FILTER(
            ALL('Orders'[Order Date]),
            'Orders'[Order Date] <= MAX('Orders'[Order Date])
        )
    )
```
