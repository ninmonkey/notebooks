using System;
using TOM = Microsoft.AnalysisServices.Tabular;

/*
XMLA refresh examples
Source: <https://learn.microsoft.com/en-us/power-bi/connect-data/incremental-refresh-xmla>
*/

namespace Hybrid_Tables
{
    class Program
    {
        static string workspaceUrl = "<Enter your Workspace URL here>";
        static string databaseName = "AdventureWorks";
        static string tableName = "FactInternetSales";
        static void Main(string[] args)
        {
            using (var server = new TOM.Server())
            {
                // Connect to the dataset.
                server.Connect(workspaceUrl);
                TOM.Database database = server.Databases.FindByName(databaseName);
                if (database == null)
                {
                    throw new ApplicationException("Database cannot be found!");
                }
                if(database.CompatibilityLevel < 1565)
                {
                    database.CompatibilityLevel = 1565;
                    database.Update();
                }
                TOM.Model model = database.Model;
                // Add RangeStart, RangeEnd, and DateKey function.
                model.Expressions.Add(new TOM.NamedExpression {
                    Name = "RangeStart",
                    Kind = TOM.ExpressionKind.M,
                    Expression = "#datetime(2021, 12, 30, 0, 0, 0) meta [IsParameterQuery=true, Type=\"DateTime\", IsParameterQueryRequired=true]"
                });
                model.Expressions.Add(new TOM.NamedExpression
                {
                    Name = "RangeEnd",
                    Kind = TOM.ExpressionKind.M,
                    Expression = "#datetime(2021, 12, 31, 0, 0, 0) meta [IsParameterQuery=true, Type=\"DateTime\", IsParameterQueryRequired=true]"
                });
                model.Expressions.Add(new TOM.NamedExpression
                {
                    Name = "DateKey",
                    Kind = TOM.ExpressionKind.M,
                    Expression =
                        "let\n" +
                        "    Source = (x as datetime) => Date.Year(x)*10000 + Date.Month(x)*100 + Date.Day(x)\n" +
                        "in\n" +
                        "    Source"
                });
                // Apply a RefreshPolicy with Real-Time to the target table.
                TOM.Table salesTable = model.Tables[tableName];
                TOM.RefreshPolicy hybridPolicy = new TOM.BasicRefreshPolicy
                {
                    Mode = TOM.RefreshPolicyMode.Hybrid,
                    IncrementalPeriodsOffset = -1,
                    RollingWindowPeriods = 1,
                    RollingWindowGranularity = TOM.RefreshGranularityType.Year,
                    IncrementalPeriods = 1,
                    IncrementalGranularity = TOM.RefreshGranularityType.Day,
                    SourceExpression =
                        "let\n" +
                        "    Source = Sql.Database(\"demopm.database.windows.net\", \"AdventureWorksDW\"),\n" +
                        "    dbo_FactInternetSales = Source{[Schema=\"dbo\",Item=\"FactInternetSales\"]}[Data],\n" +
                        "    #\"Filtered Rows\" = Table.SelectRows(dbo_FactInternetSales, each [OrderDateKey] >= DateKey(RangeStart) and [OrderDateKey] < DateKey(RangeEnd))\n" +
                        "in\n" +
                        "    #\"Filtered Rows\""
                };
                salesTable.RefreshPolicy = hybridPolicy;
                model.RequestRefresh(TOM.RefreshType.Full);
                model.SaveChanges();
            }
            Console.WriteLine("{0}{1}", Environment.NewLine, "Press [Enter] to exit...");
            Console.ReadLine();
        }
    }
}