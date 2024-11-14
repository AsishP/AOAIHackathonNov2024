-- This script creates the necessary security objects for the Semantic Kernel to work properly and set the OpenAI URL and API key.

-- declare @OPENAI_URL nvarchar(255) = 'https://***.openai.azure.com';
-- declare @OPENAI_KEY nvarchar(255) = '**<api-key>**';

if not exists(select * from sys.symmetric_keys where [name] = '##MS_DatabaseMasterKey##')
begin
    create master key encryption by password = N'V3RYStr0NGP@ssw0rd!';
end
go

if exists(select * from sys.[database_scoped_credentials] where name = '$OPENAI_URL$')
begin
	drop database scoped credential [$OPENAI_URL$];
end
go

create database scoped credential [$OPENAI_URL$]
with identity = 'HTTPEndpointHeaders', secret = '{"api-key":"$OPENAI_KEY$"}';
go

if schema_id('web') is null begin
    exec('create schema [web] authorization [dbo]');
end
go



