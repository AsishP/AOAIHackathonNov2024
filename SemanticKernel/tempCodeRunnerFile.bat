echo off
echo Logging into Azure...
call az login --tenant 16b3c013-d300-468d-ac64-7eda0820b6d3 --output none
echo Login completed
call dotnet run chat