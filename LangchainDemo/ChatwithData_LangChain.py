from sqlalchemy import create_engine
from sqlalchemy.engine.url import URL
from langchain_community.utilities import SQLDatabase
from dotenv import load_dotenv
from langchain_community.chat_models import AzureChatOpenAI
from langchain_community.agent_toolkits import SQLDatabaseToolkit, create_sql_agent
from langchain.agents.agent_types import AgentType
import os

load_dotenv()

db_config = {  
    'drivername': 'mssql+pyodbc',  
    #'username': os.environ["SQL_SERVER_USERNAME"] + '@' + os.environ["SQL_SERVER_ENDPOINT"],
    'username': os.environ["SQL_SERVER_USERNAME"],   
    'password': os.environ["SQL_SERVER_PASSWORD"],  
    'host': os.environ["SQL_SERVER_ENDPOINT"],  
    'port': 1433,  
    'database': os.environ["SQL_SERVER_DATABASE"],  
    'query': {'driver': 'ODBC Driver 18 for SQL Server'},
      
}  

db_url = URL.create(**db_config)
db = SQLDatabase.from_uri(db_url)

llm = AzureChatOpenAI(deployment_name=os.environ["OPENAI_DEPLOYMENT_NAME"], temperature=0, max_tokens=4000)

toolkit = SQLDatabaseToolkit(db=db, llm=llm)

agent_executor = create_sql_agent(
    llm=llm,
    toolkit=toolkit,
    verbose=True,
    agent_type=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
)

##agent_executor.run("how many rows in the Customer table")

userquery = ""
while userquery == "":
    userquery = input(" Enter your query: ")
    if(userquery == ""):
        print("\n\nPlease enter a query.")

agent_executor.run(userquery)