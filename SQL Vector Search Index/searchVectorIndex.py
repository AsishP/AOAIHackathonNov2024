import pandas as pd
import pyodbc
import json
from openai import AzureOpenAI
from tqdm.auto import tqdm
from dotenv import load_dotenv
import os
from tenacity import retry, wait_random_exponential, stop_after_attempt
from azure.core.credentials import AzureKeyCredential
import requests
import os.path
from azure.search.documents import SearchClient, SearchIndexingBufferedSender
from azure.search.documents.indexes import SearchIndexClient
from azure.search.documents.models import (
    QueryAnswerType,
    QueryCaptionType,
    QueryLanguage,
    QueryType,
    VectorizableTextQuery,
    VectorFilterMode,
)
from azure.search.documents.indexes.models import (
    ExhaustiveKnnAlgorithmConfiguration,
    ExhaustiveKnnParameters,
    SearchIndex,
    SearchField,
    SearchFieldDataType,
    SimpleField,
    SearchableField,
    SearchIndex,
    SemanticConfiguration,
    SemanticSearch,
    SemanticField,
    SearchField,
    VectorSearch,
    HnswParameters,
    HnswAlgorithmConfiguration,
    VectorSearch,
    VectorSearchAlgorithmKind,
    VectorSearchProfile,
    VectorSearchVectorizer,
    VectorSearchVectorizerKind,
    AzureOpenAIParameters,
    AzureOpenAIVectorizer,
    SemanticPrioritizedFields,
    SearchIndex,
    SearchField,
    SearchFieldDataType,
    VectorSearch,
    ExhaustiveKnnParameters,
    SearchIndex,
    SearchField,
    SimpleField,
    SearchableField,
    SearchIndex,
    SemanticConfiguration,
    SemanticField,
    SearchField,
    VectorSearch,
    HnswParameters,
    VectorSearch,
    VectorSearchAlgorithmKind,
    VectorSearchProfile,
    AzureOpenAIParameters,
    AzureOpenAIVectorizer,
)

load_dotenv()
connectionString=os.environ["SQL_CONN_STRING"]

## Function to generate embeddings for title and content fields, also used for query embeddings
## Reference for limitations - https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/embeddings?tabs=python-new 
@retry(wait=wait_random_exponential(min=1, max=20), stop=stop_after_attempt(6))
def generate_embeddings(text,  embedding_model_deploy_id=os.getenv("OPENAI_EMBEDDINGMODEL")):
    
    # init openai service to create embeddings
    client = AzureOpenAI(
        api_key = os.getenv("OPENAI_EMBEDDINGAPI_KEY"),  
        api_version = os.getenv("OPENAI_EMBEDDING_VERSION"),
        azure_endpoint = os.getenv("OPENAI_EMBEDDINGBASE_URL")
    )

    # generate and return embeddings
    response = client.embeddings.create(
        input=text, model=embedding_model_deploy_id)
    embeddings = response.data[0].embedding
    return embeddings

# SQL QUERY to get products details from the database
sqlQuery="""SELECT PC.Name AS ProductCategoryName, SP.ProductId, SP.Name, SP.ProductNumber, SP.Color, SP.ListPrice, SP.Size, SP.ProductCategoryID, SP.ProductModelID, PD.ProductDescriptionID, PD.Description
from [dbo].[Product] SP
INNER JOIN dbo.ProductCategory PC ON PC.ProductCategoryID = SP.ProductCategoryID
INNER JOIN [dbo].[ProductModelProductDescription] PMPD ON PMPD.ProductModelID = SP.ProductModelID
INNER JOIN [dbo].[ProductDescription] PD ON PD.ProductDescriptionID = PMPD.ProductDescriptionID
WHERE PMPD.Culture = 'en'"""

# Connect to the database and execute the query to get the data for indexing
conn = pyodbc.connect(connectionString)
cursor = conn.cursor()
queryResults = pd.DataFrame()
try:
    cursor.execute(sqlQuery)
    records = cursor.fetchall()
    queryResults = pd.DataFrame.from_records(records, columns=[col[0] for col in cursor.description])
except Exception as e:
    print(f"connection could not be established: {e}")
finally:
    cursor.close()

# Import queryResultsJson from a queryResults.json file if it exists
override = True ## Set to True to override the upload the queryResults file
output_file_path = "./queryResults.json"
if os.path.exists(output_file_path) and override:
    with open(output_file_path, 'r') as infile:
        queryResultsJson = json.load(infile)
        print(f"Total records to be indexed: {len(queryResultsJson)}, the maximum length of the description field is {queryResults['Description'].str.len().max()} characters.")
else:
    queryResultsJson = json.loads(queryResults.to_json(orient='records'))
    print(f"Total records to be indexed: {len(queryResultsJson)}, the maximum length of the description field is {queryResults['Description'].str.len().max()} characters.")

    # generate embeddings for the product name and product description fields
    print("Generating embeddings for the product name and product description fields.")
    for i in tqdm(range(len(queryResultsJson))):
        doc = queryResultsJson[i]
        queryResultsJson[i]['@search.action'] = "upload"
        queryResultsJson[i]['ProductId'] = str(queryResultsJson[i]['ProductId'])
        queryResultsJson[i]['DescriptionVector'] = generate_embeddings(doc['Description'].strip())
        queryResultsJson[i]['ProductCategoryNameVector'] = generate_embeddings(doc['ProductCategoryName'])

    # Export queryResultsJson to a JSON file
    output_file_path = "./queryResults.json"
    with open(output_file_path, 'w') as outfile:
        json.dump(queryResultsJson, outfile, indent=4)
    print(f"Data exported to {output_file_path}")

# init Azure Cognitive Search Service
index_name = "sqldemo-product-description-vector"
service_endpoint = os.getenv("AZURE_SEARCH_ENDPOINT")
key = os.getenv("AZURE_SEARCHKEY")
credential = AzureKeyCredential(key)
model = os.getenv("OPENAI_EMBEDDINGMODEL")


# Create a search index
index_client = SearchIndexClient(
    endpoint=service_endpoint, credential=credential)
fields = [
    SearchableField(name="ProductCategoryName", type=SearchFieldDataType.String, searchable = True, filterable=True, facetable=False, retrievable = True),
    SearchableField(name="ProductId", type=SearchFieldDataType.String, searchable = True, filterable=True, key=True),
    SearchableField(name="Name", type=SearchFieldDataType.String, key=False, searchable = True, sortable=False, filterable=True, facetable=False, retrievable = True),
    SearchableField(name="ProductNumber", type=SearchFieldDataType.String, searchable = True),
    SearchableField(name="Color", type=SearchFieldDataType.String, searchable = True),
    SimpleField(name="ListPrice", type=SearchFieldDataType.Double, searchable = False, filterable=True),
    SimpleField(name="Size", type=SearchFieldDataType.String, searchable = False, filterable=True),
    SimpleField(name="ProductCategoryID", type=SearchFieldDataType.Int32, searchable = True, filterable=True),
    SimpleField(name="ProductModelID", type=SearchFieldDataType.Int32, searchable = True, filterable=True),
    SimpleField(name="ProductDescriptionID", type=SearchFieldDataType.Int32, searchable = True, filterable=True, ),
    SearchableField(name="Description", type=SearchFieldDataType.String,
                    filterable=True, searchable = True),
    SearchField(name="DescriptionVector", type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
                searchable=True, vector_search_dimensions=1536, vector_search_profile_name="myHnswProfile"),
    SearchField(name="ProductCategoryNameVector", type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
                searchable=True, vector_search_dimensions=1536, vector_search_profile_name="myHnswProfile"),
]

# Configure the vector search configuration
vector_search = VectorSearch(
    algorithms=[
        HnswAlgorithmConfiguration(
            name="myHnsw",
            kind=VectorSearchAlgorithmKind.HNSW,
            parameters=HnswParameters(
                m=4,
                ef_construction=400,
                ef_search=500,
                metric="cosine"
            )
        ),
        ExhaustiveKnnAlgorithmConfiguration(
            name="myExhaustiveKnn",
            kind=VectorSearchAlgorithmKind.EXHAUSTIVE_KNN,
            parameters=ExhaustiveKnnParameters(
                metric="cosine"
            )
        )
    ],
    profiles=[
        VectorSearchProfile(
            name="myHnswProfile",
            algorithm_configuration_name="myHnsw",
            vectorizer="myOpenAI"
        ),
        VectorSearchProfile(
            name="myExhaustiveKnnProfile",
            algorithm_configuration_name="myExhaustiveKnn",
            vectorizer="myOpenAI"
        )
    ],
    vectorizers=[
        AzureOpenAIVectorizer(
            name="myOpenAI",
            kind="azureOpenAI",
            azure_open_ai_parameters=AzureOpenAIParameters(
                resource_uri=os.getenv("OPENAI_EMBEDDINGBASE_URL"),
                model_name=model,
                deployment_id=os.getenv("OPENAI_EMBEDDINGMODEL"),
                api_key=os.getenv("OPENAI_EMBEDDINGAPI_KEY")
            )
    )
]
)

semantic_config = SemanticConfiguration(
    name="my-semantic-config",
    prioritized_fields=SemanticPrioritizedFields(
        title_field=SemanticField(field_name="Name"),
        keywords_fields=[SemanticField(field_name="Description")],
        content_fields=[SemanticField(field_name="Description")]
    )
)

# Create the semantic settings with the configuration
semantic_settings = SemanticSearch(configurations=[semantic_config])

# Create the search index with the semantic settings
index = SearchIndex(name=index_name, fields=fields,
                    vector_search=vector_search, semantic_settings=semantic_settings)
result = index_client.create_or_update_index(index)
print(f'{result.name} created')
   

search_client = SearchClient(endpoint=service_endpoint, index_name=index_name, credential=credential)
result = search_client.upload_documents(documents=queryResultsJson)
print(f"Uploaded {len(queryResultsJson)} documents")