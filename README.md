# Azure AI Hackathon Demo
**Important:** Run the Hackathon Prerequisties if not done already

1. Activate your virtual environment using the scripts below

    a. Remove the virtual environment
    ** For Linux, To delete the virtual environment, use the following command: **
    rm -rf venv
    ** For Windows, **
    Remove-Item -Recurse -Force .venv 
    
    b. Install the Virtual Environment
    python -m venv .venv
    
    b. Activate the envrionment
        # For Linux - Unix source env/bin/activate 
        # Windows  
        # For Command prompt: venv\Scripts\activate.bat
        # In PowerShell
        venv\Scripts\Activate.ps1  

    c. pip install -r requirements.txt

2. Create and Update the Environment Config file
    a. Locate the .env.sample file
    b. Rename it to .env
    c. Open and set the configuration values for Search, OpenAI and Search Settings 

3. Enable Python Debugging (Optional if launch.json is absent)
    a. Click on Run and Debug on Visual Studio Code
    b. Add the python configuration on Python Debugger if not already configured

**Lab 01 - Semantic Chat with Vectorised Information**
1. Create a database called "sqldemo-websessions-chat" in the Database Server already created (set it to General Purpose Serverless to minimize cost)
2. Create a new connection in Azure AI Studio pointing to the new database
3. Run the scripts in SQL folder under Semantic Kernel in order of 010 - 100 files using Azure AI Data Studio
4. Create a .env file
    a. Locate the .env.sample file
    b. Rename it to .env
    c. Open and set the configuration values for Search, OpenAI and Search Settings 
5. Create a run.bat file 
    a. Locate the run.bat.sample file
    b. Rename to run.bat
    c. Replace the <azure entra tenant id> with the Tenant ID in Microsoft Entra
    d. In PowerShell Terminal run it using command "Start-Process -FilePath "..\run.bat" -Wait"
6. Some Sample questions below
    Question: what are the different sessions in AI tour in Sydney
    Question:  I am interested in AI sessions with SQL. Could you please suggest some?
    Question:  Could you please list down sessions where Judson is speaking?
    Question:  Could you please list down all the speakers in the AI Tour?
    Question: Hi, I am interested in AI. Is there any feature in preview that I might be interested in? I am using Azure SQL to store my data

(Optional Labs)
**Prerequisties Setup**
Create a SQL demo setup using the below steps if not already
a. Create a new Serverless Azure Sql instance (Development) 
    if need free use this - [SQL Database Free offer](https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer?view=azuresql)

**Note:** Select [AdventureWorks Sample](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms#deploy-new-sample-database) while creating the SQL database.

b. Run the SQL scripts for creating a view for Products and Sales orders
    Go to SQL Scripts folder -> CreateView-SalesOrderswithProducts.sql file and then copy the View code and run it is Azure Data Studio for the Demo database using New SQL query

**Lab 02 - SQL with Azure AI Search Chat**
1. Open sql-chat.py file and hit F5 to launch Python Debugger. 
2. Ask the query on the data. For testing, use the following query "Give me a total of all orders from Jeffrey"

**Lab 03 - SQL with Azure AI Search Vectorised data**
1. Open the File SQL Vector Search Index
2. Run the python debugger by hitting F5
3. A Vector index named - sqldemo-product-description-vector will be created in the Search service provided.
 **Note:** After success, the documents might show zero for some time, please wait and it will the exact rows indexed which should be about 294
4. Open the Azure AI playground and configure with "Chat with your data" as per documentation here: [Chat with your data](https://learn.microsoft.com/en-us/azure/ai-services/openai/use-your-data-quickstart)
5. Sample question 
   Question: Give me bike recommendation for mountain biking

**Lab 04 - SQL with Langchain Framework**
1. Make sure the root .env file is filled with Search and OpenAI values
2. If Langchain doesn't see all the tables, then make sure the tables are part of dbo schema