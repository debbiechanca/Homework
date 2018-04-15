' Unit 2 Assignment - Stock Market Analyst

'Background
'You are well on your way to becoming a programmer and Excel master! In this homework assignment you will use VBA scripting to analyze real stock market data. Depending on your comfort level with VBA, choose your assignment from Easy, Moderate, or Hard below.

'Files
'Test Data - Use this while developing your scripts.

'Stock Data - Run your scripts on this data to generate the final homework report.

'Part I - Easy
'Create a script that will loop through each year of stock data and grab the total amount of volume each stock had over the year.
'Display the ticker symbol to coincide with the total volume.

'Part II - Moderate
'Create a script that will loop through all the stocks and take the following info.
'   Yearly change from what the stock opened the year at to what the closing price was.
'   The percent change from the what it opened the year at to what it closed.
'   The total Volume of the stock
'   Ticker Symbol
' Include conditional formatting that will highlight positive change in green and negative change in red.

'Part II - Hard
' The solution will include everything from the moderate challenge.
' The solution will also include the stock with the "Greatest % increase", "Greatest % Decrease" and "Greatest total volume".

Sub StockMkt()
  ' Set a variable for specifying the column of interest
  Dim Column, ResultRow, StartRow, TickerColumn, YChangeColumn, PercentColumn
  Dim TotalVolume As Double
  Dim OpeningPrice, ClosingPrice, YearlyChange, PercentChange As Double
  Dim SearchRange As Range
  Dim SummaryTitleColumn, TickerColumn2, ValueColumn As Integer
  Dim MaxValue, MinValue As Double
  Dim MaxTotal As Integer
  Dim MaxRow, MinRow, MaxVolRow As Integer
  
  Column = 1
  
  ' Determine the Last Column Number
  LastColumn = Sheets(1).Cells(1, Columns.Count).End(xlToLeft).Column
  
  ' Set column number for Ticker name, Yearly Change, Percent Change, and Total Stock Volume
  TickerColumn = LastColumn + 2
  YChangeColumn = LastColumn + 3
  YPercentColumn = LastColumn + 4
  TotalColumn = LastColumn + 5
  SummaryTitleColumn = LastColumn + 7
  TickerColumn2 = LastColumn + 8
  ValueColumn = LastColumn + 9
  
  TotalVolume = 0
  
  For Each ws In Worksheets
        
    ' Create title for Ticker Symbol and Total Stock Volume columns in each worksheet
    ws.Cells(1, TickerColumn).Value = "Ticker"
    ws.Cells(1, YChangeColumn).Value = "Yearly Change"
    ws.Cells(1, YPercentColumn).Value = "Percent Change"
    ws.Cells(1, TotalColumn).Value = "Total Stock Volume"
    ws.Cells(1, TickerColumn2).Value = "Ticker"
    ws.Cells(1, ValueColumn) = "Value"

    ' Determine the Last Row, Result Row and Total VOlume
    LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    
    StartRow = 2
    ResultRow = 2
               
    ' Loop through rows of the ticker symbol in the first column to calculate the the total stock volume, yearly change, and percent change
    For i = 2 To LastRow
      
      ' Searches for when the value of the next cell is different than that of the current cell
      If ws.Cells(i + 1, Column).Value <> ws.Cells(i, Column).Value Then
        
        ws.Cells(ResultRow, TickerColumn) = ws.Cells(i, Column).Value
        TotalVolume = TotalVolume + ws.Cells(i, LastColumn).Value
        ws.Cells(ResultRow, TotalColumn).Value = TotalVolume
       
       ' Find Opening Price
        For Each C In ws.Range(ws.Cells(StartRow, 3), ws.Cells(i, 3))
          If C.Value > 0 Then
            OpeningPrice = C.Value
            'MsgBox ("OpeningPrice is " & OpeningPrice & " for Ticker Symbol" & ws.Cells(ResultRow, TickerColumn))
            Exit For
          End If
        Next C
     
        ' Calculate Yearly Change and Percent Change
        ClosingPrice = ws.Cells(i, 6).Value
        'MsgBox ("ClosingPrice is " & ClosingPrice & " for Ticker Symbol" & ws.Cells(ResultRow, TickerColumn))
       If (OpeningPrice <> 0) And (ClosingPrice <> 0) Then
          YearlyChange = ClosingPrice - OpeningPrice

          If (YearlyChange <> 0) Then
          PercentChange = (YearlyChange / OpeningPrice) / 1
          End If
        End If
        
        ' Populate Yearly Change and Percent Change in corresponding column
        ws.Cells(ResultRow, YChangeColumn).Value = YearlyChange
        ws.Cells(ResultRow, YPercentColumn).Value = PercentChange
        
        ' Conditional formatting - green for positive change and red for negative change
        If YearlyChange >= 0 Then
          ws.Cells(ResultRow, YChangeColumn).Interior.ColorIndex = 4
        ElseIf YearlyChange < 0 Then
          ws.Cells(ResultRow, YChangeColumn).Interior.ColorIndex = 3
        End If
        
        'Reset values for processing next Ticker symbol
        StartRow = i + 1
        
        ' Increment result row for next ticker symbol where total volumne results are stored
        ResultRow = ResultRow + 1
        
        YearlyChange = 0
        PercentChange = 0
        TotalVolume = 0
        OpeningPrice = 0
        ClosingPrice = 0

      ' Otherwise, continue to sum up total volume of the current ticker symbol
      Else
        
        TotalVolume = TotalVolume + ws.Cells(i, LastColumn).Value
        
      End If
    
    Next i
    
    ' Format Percent column as percent and Total Volume column as a number
    ws.Columns(YPercentColumn).NumberFormat = "0.00%"
    ws.Columns(TotalColumn).NumberFormat = "0"
    
    ' Part III - Calculate the greatest increase, decrease and total volume
    
    ws.Activate
         
    Set SearchRange = Range(Cells(2, YPercentColumn), Cells(LastRow, YPercentColumn))
    
    ' Format Value column so Match function can be used to find the Ticker symbol for greatest % increase, decrease and total volume
    Range("P2:P3").NumberFormat = "0.00%"
    Cells(4, ValueColumn).NumberFormat = "0"
    
    ' Determine the greatest % increase and show in current worksheet
    Cells(2, SummaryTitleColumn).Value = "Greatest % Increase"
    Cells(2, ValueColumn).Value = Application.WorksheetFunction.Max(SearchRange)
    MaxValue = Cells(2, ValueColumn).Value
    Cells(2, TickerColumn2).Value = Cells(WorksheetFunction.Match(MaxValue, SearchRange, 0) + 1, TickerColumn)
    
    ' Only use for TESTING
    'MaxRow = WorksheetFunction.Match(MaxValue, SearchRange, 0) + 1
    'MsgBox "Maximum value found at row " & Str(MaxRow)
    
    ' Determine the greatest % decrease and show in current worksheet
    Cells(3, SummaryTitleColumn).Value = "Greatest % Decrease"
    Cells(3, ValueColumn).Value = Application.WorksheetFunction.Min(SearchRange)
    MinValue = Cells(3, ValueColumn).Value
    Cells(3, TickerColumn2).Value = Cells(WorksheetFunction.Match(MinValue, SearchRange, 0) + 1, TickerColumn)
    
    ' Use only for TESTING
    'MinRow = WorksheetFunction.Match(MinValue, SearchRange, 0) + 1
    'MsgBox (Str(MinValue))
    'MsgBox "Minimum value found at row " & Str(MinRow)
      
    ' Determine the greatest total volume and show in current worksheet
    Set SearchRange = Range(Cells(2, TotalColumn), Cells(LastRow, TotalColumn))
        
    Cells(4, SummaryTitleColumn).Value = "Greatest Total Volume"
    Cells(4, ValueColumn).Value = Application.WorksheetFunction.Max(SearchRange)
    MaxVolume = Cells(4, ValueColumn).Value
    Cells(4, TickerColumn2).Value = Cells(WorksheetFunction.Match(MaxVolume, SearchRange, 0) + 1, TickerColumn)
    
    ' Use only for TESTING
    'MaxVolRow = WorksheetFunction.Match(MaxVolume, SearchRange, 0) + 1
    'MsgBox (Str(MaxVolume))
    'MsgBox "Greatest total volume found at row " & Str(MaxVolRow)
     
  Next ws
End Sub
