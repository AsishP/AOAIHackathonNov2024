from azure.search.documents.indexes import SearchIndexerClient
from azure.identity import DefaultAzureCredential
from azure.core.credentials import AzureKeyCredential
from dotenv import load_dotenv
import os
import azure.identity.aio
import asyncio
from chat import ChatThread, create_search_client, create_openai_client, SearchType

## Load variables and environment variables
print("\n Starting and Loading Variables\n")
load_dotenv()
k=50
search_type="hybrid"
use_semantic_reranker=True
sources_to_include=500
searchKey = os.getenv("AZURE_SEARCHKEY")
openAIKey = os.getenv("OPENAI_API_KEY")
chat_deployment = os.getenv("OPENAI_DEPLOYMENT_NAME") 

## Get user query
userquery = ""
while userquery == "":
    userquery = input(" Enter your query: ")
    if(userquery == ""):
        print("\n\nPlease enter a query.")

## Initialize chat thread and call the GPT model
chat_thread = ChatThread()

print("\n Searching and displaying results using GPT model...")
async def gptchat_caller():
    async with azure.identity.aio.DefaultAzureCredential() as credential, create_search_client(AzureKeyCredential(searchKey)) as search_client, create_openai_client(credential, openAIKey) as openai_client:
        await chat_thread.append_grounded_message(
            search_client=search_client,
            query=userquery,
            search_type=SearchType(search_type),
            use_semantic_reranker=use_semantic_reranker,
            sources_to_include=sources_to_include,
            k=k)
        await chat_thread.get_openai_response(openai_client=openai_client, model=chat_deployment, max_new_tokens=4000)

asyncio.run(gptchat_caller())
print("\n  Answer: \n")
print(chat_thread.get_last_message()["content"])
