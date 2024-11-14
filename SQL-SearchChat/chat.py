from azure.core.credentials_async import AsyncTokenCredential
from azure.identity.aio import get_bearer_token_provider
from azure.search.documents.aio import SearchClient
from azure.search.documents.models import VectorizableTextQuery, HybridSearch
from openai import AsyncAzureOpenAI
import os
from enum import Enum
from typing import List, Optional
from dotenv import load_dotenv

load_dotenv()

def create_openai_client(credential: AsyncTokenCredential, openAIKey: str) -> AsyncAzureOpenAI:
    token_provider = get_bearer_token_provider(credential, "https://cognitiveservices.azure.com/.default")
    return AsyncAzureOpenAI(
        api_version=os.getenv("OPENAI_API_VERSION"),
        azure_endpoint=os.getenv("OPENAI_BASE_URL"),
        api_key=openAIKey
        #azure_ad_token_provider=token_provider
    )

def create_search_client(credential: AsyncTokenCredential) -> SearchClient:
    return SearchClient(
        endpoint=os.getenv("AZURE_SEARCH_ENDPOINT"),
        index_name=os.getenv("AZURE_SEARCH_INDEX"),
        credential=credential
    )

class SearchType(Enum):
    TEXT = "text"
    VECTOR = "vector"
    HYBRID = "hybrid"

async def get_sources(search_client: SearchClient, query: str, search_type: SearchType, use_semantic_reranker: bool = True, sources_to_include: int = 500, k: int = 50) -> List[str]:
    if search_type == SearchType.TEXT:
        response = await search_client.search(
            search_text=query,
            query_type="semantic" if use_semantic_reranker else "simple",
            top=sources_to_include,
            select="SalesOrderID, SalesOrderNumber, OrderDate, Status, TotalDue, CustomerID, CompanyName, FirstName, LastName, ProductName, OrderQty, UnitPrice, LineTotal"
        )
    elif search_type == SearchType.VECTOR:
        response = await search_client.search(
            search_text="*",
            query_type="simple",
            top=sources_to_include,
            vector_queries=[
                VectorizableTextQuery(text=query, k_nearest_neighbors=k, fields="contentVector")
            ],
            semantic_query=query if use_semantic_reranker else None,
            select="SalesOrderID, SalesOrderNumber, OrderDate, Status, TotalDue, CustomerID, CompanyName, FirstName, LastName, ProductName, OrderQty, UnitPrice, LineTotal"
        )
    else:
        response = await search_client.search(
            search_text=query,
            query_type="semantic" if use_semantic_reranker else "simple",
            top=sources_to_include,
            vector_queries=[],
            hybrid_search=HybridSearch(
                max_text_recall_size=k
            ),
            semantic_configuration_name="semantic-sql1",
            semantic_query=query if use_semantic_reranker else None,
            select="SalesOrderID, SalesOrderNumber, OrderDate, Status, TotalDue, CustomerID, CompanyName, FirstName, LastName, ProductName, OrderQty, UnitPrice, LineTotal"
        )

    return [ document async for document in response ]

####
## Azure Open AI Solution 
####

GROUNDED_PROMPT="""

You are an AI assistant that uses the provided data source to analyse Tabular data. 

#### Business Rules for answer User queries
To achieve this, below are the rules.
1. Extract keywords and entities from the provided text. Return the data in Json
2. Create an Azure AI Search query with keywords extracted from the above step and return the query in Json appending above information
3. Run the query on the Azure AI search index provided
4. Before performing any mathematical calculations requested, calculate one value each time based on the mathematical calculation requested using BODMAS mathematical rules. 
5. Provide the results in JSON for the information returned from Search

####INSTRUCTIONS:
- You MUST find the right information from the retrieved data to answer questions. If no relevant information provided, please say you don't know, DO NOT invent new facts. For example, if there is nothing showed in #Previous purchases#, just tell the user that they have no purchases in the past.
- Remain grounded, do not invent new facts.
- Since the data is returned by Azure Cognitive Search, be mindful of the importance the search gave to various document.
- Use MARKDOWN to highlight your text.
- You MUST greet the user using the name and title that are provided to you, for example, say "Hello Mr. Liu".
- Please explain in details and step by step in your answer.
- Make sure to reference any documentation used in the response.
- Reference past orders by name and relevant information like color, size, and description that would indicate user would like the suggested item. It is important to refer user information and past orders.
- When giving recommendation, you MUST recommend features including color, size that the user haven't purchased before based on their purchase history. For example, if the user have purchased a product of black color and size Medium, you can say that now we also have this product with yellow color and Large size in the inventory that the user may want to try.
- When describing products, make sure to refer to its color, size, price, description, and other useful information.
- DO NOT create new product with new features, answer question based on documents provided to you.

#### Data Schema Details
Below is the Azure AI Search Columns and a brief of type of values in these columns.

SalesOrderNumber: Order number of the Sales items
OrderDate: Date of the order in YYYY-MM-DD HH:MM:SS format
Status: Status in integer where 5 = Shipped, 4 = Packaging, 3 = Order Accepted, 2 = Order submitted, and  1 = Order received
TotalDue: Total Due amount in Dollars
CompanyName: Name of the Company in the Order
FirstName: First Name of the Customer
LastName: Last Name of the Customer
ProductName: Name of the Product ordered
OrderQty: Quantity Ordered
UnitPrice: Price of each item in Dollars
LineTotal: Total Price of the line

Query: {query}
Sources:\n{sources}
"""
class ChatThread:
    def __init__(self):
        self.messages = []
        self.search_results = []
    
    def append_message(self, role: str, message: str):
        self.messages.append({
            "role": role,
            "content": message
        })

    async def append_grounded_message(self, search_client: SearchClient, query: str, search_type: SearchType, use_semantic_reranker: bool = True, sources_to_include: int = 5, k: int = 50):
        sources = await get_sources(search_client, query, search_type, use_semantic_reranker, sources_to_include, k)
        print("Returned Sources" + str(len(sources)))
        sources_formatted = "\n".join([
            f'{{"SalesOrderID":{document["SalesOrderID"]},'
            f'"SalesOrderNumber":{document["SalesOrderNumber"]},'
            f'"OrderDate":{document["OrderDate"]},'
            f'"Status":{document["Status"]},'
            f'"TotalDue":{document["TotalDue"]},'
            f'"CompanyName":{document["CompanyName"]},'
            f'"FirstName":{document["FirstName"]},'
            f'"LastName":{document["LastName"]},'
            f'"ProductName":{document["ProductName"]},'
            f'"OrderQty":{document["OrderQty"]},'
            f'"UnitPrice":{document["UnitPrice"]},'
            f'"LineTotal":{document["LineTotal"]}}}'
            for document in sources
        ])
        self.append_message(role="user", message=GROUNDED_PROMPT.format(query=query, sources=sources_formatted))
        self.search_results.append(
            {
                "message_index": len(self.messages) - 1,
                "query": query,
                "sources": sources
            }
        )

    async def get_openai_response(self, openai_client: AsyncAzureOpenAI, model: str, temperature: float = 0.7, top_p: float = 0.9, do_sample: bool = True, max_new_tokens: int = 256):
        response = await openai_client.chat.completions.create(
            messages=self.messages,
            model=model,
            temperature=temperature,
            top_p=top_p,
            max_tokens=max_new_tokens
        )
        self.append_message(role="assistant", message=response.choices[0].message.content)


    def get_last_message(self) -> Optional[object]:
        return self.messages[-1] if len(self.messages) > 0 else None

    def get_last_message_sources(self) -> Optional[List[object]]:
        return self.search_results[-1]["sources"] if len(self.search_results) > 0 else None
    
    def printMessages(self) -> Optional[str]:
        print(self.messages) if len(self.search_results) > 0 else print ("No messages to display")
    