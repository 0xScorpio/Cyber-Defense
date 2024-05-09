## EXAMPLE: Finds PowerShell execution events that could involve a download
```
union DeviceProcessEvents, DeviceNetworkEvents
| where Timestamp > ago(7d)
| where FileName in~ ("powershell.exe", "powershell_ise.exe")
| where ProcessCommandLine has_any("WebClient",
 "DownloadFile",
 "DownloadData",
 "DownloadString",
"WebRequest",
"Shellcode",
"http",
"https")
| project Timestamp, DeviceName, InitiatingProcessFileName, InitiatingProcessCommandLine,
FileName, ProcessCommandLine, RemoteIP, RemoteUrl, RemotePort, RemoteIPType
| top 100 by Timestamp
```
- The query itself will typically start with a table name followed by several elements that start with a pipe (|). In this example, we start by creating a union of two tables, DeviceProcessEvents and DeviceNetworkEvents, and add piped elements as needed.
- The first piped element is a time filter scoped to the previous seven days. Limiting the time range helps ensure that queries perform well, return manageable results, and don't time out.
- Now that your query clearly identifies the data you want to locate, you can define what the results look like. project returns specific columns, and top limits the number of results. These operators help ensure the results are well-formatted and reasonably large and easy to process.

## Common Query Operators
| Operator  | Description and Usage                                                                   |
|-----------|-----------------------------------------------------------------------------------------|
| where     | Filter a table to the subset of rows that satisfy a predicate.                           |
| summarize | Produce a table that aggregates the content of the input table.                          |
| join      | Merge the rows of two tables to form a new table by matching values of the specified column(s) from each table.  |
| count     | Return the number of records in the input record set.                                     |
| top       | Return the first N records sorted by the specified columns.                               |
| limit     | Return up to the specified number of rows.                                                |
| project   | Select the columns to include, rename or drop, and insert new computed columns.            |
| extend    | Create calculated columns and append them to the result set.                               |
| makeset   | Return a dynamic (JSON) array of the set of distinct values that Expr takes in the group. |
| find      | Find rows that match a predicate across a set of tables.                                   |

## Basic Data Types in KQL
| Data type | Description and Query Implications                                                                                     |
|-----------|-------------------------------------------------------------------------------------------------------------------------|
| datetime  | Data and time information typically representing event timestamps.   |
| string    | Character string in UTF-8 enclosed in single quotes (') or double quotes (").        |
| bool      | This data type supports true or false states. See supported literals and operators         |
| int       | 32-bit integer            |
| long      | 64-bit integer    |

Kusto Query Language Documentation: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/
