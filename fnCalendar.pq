//
  This formula creates a Calendar table from 2 given dates.
//
(
    FromDate as date,
    UntilDate as date
    ) =>
let
    dur = Duration.TotalDays(UntilDate - FromDate) + 1,
    DateList = List.Dates(FromDate, dur, #duration(1,0,0,0)),
    DatesTable = Table.FromList(DateList, Splitter.SplitByNothing(), type table [Date = date], null, ExtraValues.Error),
    #"Inserted Year" = Table.AddColumn(DatesTable, "Año", each Date.Year( [Date]), Int64.Type),
    #"Inserted Quarter" = Table.AddColumn(#"Inserted Year", "Trimestre", each Date.QuarterOfYear([Date]), Int64.Type),
    #"Inserted Month" = Table.AddColumn(#"Inserted Quarter", "Mes", each Date.Month([Date]), Int64.Type),
    #"Inserted Week of Year" = Table.AddColumn(#"Inserted Month", "Semana del año", each Date.WeekOfYear([Date]), Int64.Type),
    #"Inserted Day" = Table.AddColumn(#"Inserted Week of Year", "Dia", each Date.Day([Date]), Int64.Type),
    #"Added Custom" = Table.AddColumn(#"Inserted Day", "TrimestreNombre", each "Trim" & Text.From([Trimestre]), Text.Type),
    #"Inserted Month Name" = Table.AddColumn(#"Added Custom", "Mes Nombre", each Date.MonthName([Date]), type text),
    #"Inserted Day of Week" = Table.AddColumn(#"Inserted Month Name", "Day of Week", each Date.DayOfWeek([Date]), Int64.Type),
    #"Inserted Day Name" = Table.AddColumn(#"Inserted Day of Week", "Dia Nombre", each Date.DayOfWeekName([Date]), type text),
    #"Replaced Value" = Table.ReplaceValue(#"Inserted Day Name",0,7,Replacer.ReplaceValue,{"Day of Week"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Replaced Value",{{"Day of Week", Int64.Type}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type1", "Año_Trimestre", each [Año]*100 + [Mes], Int64.Type),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "Año-Trimestre Nombre", each Date.ToText([Date],"MMMyyyy"), Text.Type)
in
    #"Added Custom2"