delete from [web].[sessions];
delete from [web].[sessions_abstracts_embeddings];
delete from [web].[sessions_details_embeddings];
go

-- This query creates entry into Web.sessions from the data provided.
INSERT INTO [web].[sessions] (title, abstract, external_id, details)  
VALUES   
('Accelerate nonprofit impact with AI',   
 'Are you curious how nonprofit organizations can harness the power of AI to drive social impact and innovation? Join experts from Microsoft\''s dedicated nonprofit industry team as we explore real-world examples of AI applications in areas such as fundraising, resource allocation, and community engagement. Join us to gain insights into how to start your own AI journey, including through technology and skilling.',   
 'BRK213-AU',   
 CAST(JSON_QUERY('{  
   "speakers": ["Tim Allen", "Kate Behncken", "Jordan France", "Aung Maung"],  
   "track": "Workshop",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Advancing sustainability together with AI',   
 'From datacenter to cloud to copilot, we’re advancing the sustainability of AI and developing technology solutions to accelerate data readiness, build resilience, and create new opportunities on our collective journey to a more sustainable world.',   
 'BRK210-AU',   
 CAST(JSON_QUERY('{  
   "speakers": [],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Bring opportunity to life with AI in education',   
 'AI is having a tremendous impact on how we learn, work, and play. Microsoft is fully committed to responsible AI development and preparing students for the future with equitable opportunities for all. Join us to explore our path forward, together.',   
 'BRK201-AU',   
 CAST(JSON_QUERY('{  
   "speakers": ["David Dans", "Adam Pollington", "Kylie Readman", "Leigh Williams"],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Drive secure AI innovation in financial services',   
 'Achieving secure and compliant AI innovation is a top priority for financial services organizations. Join industry experts as they share best practices and industry standards using AI to improve customer experiences and unlock new insights.',   
 'BRK203-AU',   
 CAST(JSON_QUERY('{  
   "speakers": ["Duncan Taylor"],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Grow revenue and bring joy back to retail with AI',   
 'AI solutions help solve longstanding retail challenges, transforming the shopper journey, creating agile supply chains, empowering the future workforce, and unlocking retail data. Learn how retailers leverage AI for growth and efficiencies.',   
 'BRK209-AU',   
 CAST(JSON_QUERY('{  
   "speakers": [],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Harness the power of data and AI in healthcare',   
 'Discover how AI is revolutionizing healthcare by streamlining workflow, unlocking insights from data, and empowering your organization to deliver more meaningful outcomes. Learn about the latest innovations for deploying and adopting AI responsibly.',   
 'BRK205-AU',   
 CAST(JSON_QUERY('{  
   "speakers": [],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('The next steps to adopting AI in Government',   
 'AI is transforming government operations, enhancing public services and accelerating decision-making. Discover how government agencies leverage AI to deliver outcomes that better serve their citizens and help solve society’s biggest challenges.',   
 'BRK204-AU',   
 CAST(JSON_QUERY('{  
   "speakers": [],  
   "track": "Breakout",  
   "language": "English",  
   "level": 2  
 }') AS NVARCHAR(MAX))  
),  
('Leading in the age of AI transformation',   
 'Microsoft’s Chief Commercial Officer, Judson Althoff, will share how this new generation of AI is reshaping how people live and work everywhere, including in the region.',   
 'KEY100-AU',   
 CAST(JSON_QUERY('{  
   "speakers": ["Judson Althoff", "Steven Worrall"],  
   "track": "Keynote",  
   "language": "English",  
   "level": 3  
 }') AS NVARCHAR(MAX))  
),  
('AI at Work: Unlock value & opportunity with Copilot',   
 'Microsoft Copilot unleashes AI’s capabilities across every role and function to transform personal productivity and reinvent how organizations operate. Join us to understand the business value already realized in the era of AI and what leaders are doing today to build an AI-powered enterprise.',   
 'BRK310-AU',   
 CAST(JSON_QUERY('{  
   "speakers": ["Maryleen Emeric", "Brenna Robinson"],  
   "track": "Keynote",  
   "language": "English",  
   "level": 3  
 }') AS NVARCHAR(MAX))  
),
('Copilot implementation essentials',   
'Deliver AI value quickly with our guide for Copilot for Microsoft 365 implementations. Ensure secure, efficient rollouts with data governance and user support. This session is enriched by customer success stories.',   
'BRK410-AU',   
JSON_QUERY(N'{  
    "speakers": ["Rishi Nicolai"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Delivering AI with impact through intelligent apps',   
'Leaders from every industry are reinventing digital experiences, reshaping business processes and creating new products with generative AI. Explore use cases and the value your business can realize with intelligent apps built on Azure.',   
'BRK350-AU',   
JSON_QUERY(N'{  
    "speakers": ["Mike Hulme"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Leverage cloud native infra for intelligent apps',   
'Deploying AI-enabled apps involves an application or microservice interacting with a LLM inferencing endpoint. Microservices architectures and a cloud native approach is ideal for hosting your intelligent apps. Learn how to use Kubernetes and cloud-native tools to reduce operational overhead in building and running intelligent apps.',   
'BRK470-AU',   
JSON_QUERY(N'{  
    "speakers": ["Jorge Arteiro"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Microsoft Fabric: what\''s new and what\''s next',   
'Microsoft Fabric is changing data teams landscape by providing an integrated platform to enable collaboration among data, AI, BI and application development professionals. Join us to learn and see the latest announcements and what the future holds.',   
'BRK460-AU',   
JSON_QUERY(N'{  
    "speakers": ["Alvaro Videla"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Securing AI applications on Azure',   
'Discover the best practices for securely deploying AI apps to Azure: keyless access to Azure AI, user auth with Microsoft Entra, AI safety with content safety filters and jailbreak detection, private network deployment, and Microsoft Defender.',   
'BRK420-AU',   
JSON_QUERY(N'{  
    "speakers": ["Sarah Young"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('The foundation of Generative AI in Azure',   
'Discover the basics of generative AI, including core models, functionalities, and how they work. Learn how to utilize these models within the Azure ecosystem, leveraging various services to build your own generative AI applications.',   
'BRK440-AU',   
JSON_QUERY(N'{  
    "speakers": ["Vinayak Hegde"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Azure OpenAI Service: Customizing trustworthy GenAI systems at scale',   
'It’s ‘year two’ for generative AI and the pace of innovation since launching Azure OpenAI only continues to skyrocket. With 60,000+ customers using Azure AI today and expanding capabilities across the platform, this is the session where we’ll decode the latest news and distill which patterns are making real waves. From powerful performance with speech, vision, and language, to simplified fine-tuning and built-in safety tools, Azure OpenAI lets you build without boundaries.',   
'BRK351-AU',   
JSON_QUERY(N'{  
    "speakers": ["Sarah Carney", "Mike Hulme"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Build and customize agents with Copilot Studio',   
'Learn how to build your own agent using the latest features and updates from Copilot Studio. Explore how to leverage generative AI to create engaging, intelligent and connected assistants for your employees and customers.',   
'BRK430-AU',   
JSON_QUERY(N'{  
    "speakers": ["Elaiza Benitez"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('From Hype to Habit: The real value of generative AI at work​',   
'Discover how the earliest AI adopters in Australia are turning personal productivity gains into meaningful business value. Learn how they are helping users integrate Copilot into daily work habits and how they\''re articulating the value of Copilot investments. The session will also explore how AI can impact national productivity and what\''s needed to drive this forward.',   
'BRK311-AU',   
JSON_QUERY(N'{  
    "speakers": ["Melinda Cilento", "Jo Dooley", "Cameron Quirke"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('GitHub advanced security: securing your workflow',   
'Learn how to prevent common security issues from being merged into your codebase, how to find and fix vulnerabilities faster with AI, and how to keep your dependencies updated via GitHub Advanced Security.',   
'BRK422-AU',   
JSON_QUERY(N'{  
    "speakers": ["Damian Brady"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Leverage AI for infrastructure management',   
'How can IT Pros leverage AI-enhancements in Microsoft Azure? In this session, you’ll learn how Microsoft Copilot for Azure can optimize your cloud & hybrid infrastructure management, and how VS Code Copilot and other tools can take your scripting to the next level.',   
'BRK471-AU',   
JSON_QUERY(N'{  
    "speakers": ["Rick Claus"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Prompty, AI Studio and practical E2E development',   
'Integrating GenAI into traditional development can be daunting. Prompty simplifies LLM app development and works seamlessly with tools like Visual Studio Code and GitHub. Learn how to build multi-model LLM (agent) architecture, evaluation, deployment, and monitoring.',   
'BRK450-AU',   
JSON_QUERY(N'{  
    "speakers": ["Seth Juarez"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Build a multi-tasking assistant with Azure OpenAI',   
'Attendees will learn about AI Agents, an approach that gives LLMs tools to carry out tasks. Build a Python writing assistant app to take a user topic, use agents for research, product search, writing, and editing, and present a refined article.',   
'WRK551-AU',   
JSON_QUERY(N'{  
    "speakers": ["Cassie Breviu", "Cedric Vidal"],  
    "track": "Workshop",  
    "language": "English",  
    "level": 2  
}')),  
('Data, security and compliance practices for Copilot',   
'Join this hands-on workshop to learn how to deploy Microsoft 365 securely and quickly. We’ll highlight best practices for data, security, compliance and governance. Prepare for user enablement, value measurement and AI-powered transformation.',   
'WRK510-AU',   
JSON_QUERY(N'{  
    "speakers": ["Emily Luo"],  
    "track": "Workshop",  
    "language": "English",  
    "level": 2  
}')),  
('Interacting with Large Language Models',   
'Join a hands-on learning opportunity for working with LLMs by using advanced prompt engineering techniques. See the creative possibilities of generative AI for image creation and multi-modal scenarios and master the skill of function calling.',   
'WRK540-AU',   
JSON_QUERY(N'{  
    "speakers": ["Marc Baiza"],  
    "track": "Workshop",  
    "language": "English",  
    "level": 2  
}')),  
('Microsoft Fabric: start with real-time Intelligence',   
'Microsoft Fabric\''s Real-Time Intelligence lets you handle streams of data in real time. This workshop covers how to use Real-Time hub, KQL, and Power BI to ingest, query and process data while setting alerts, building dashboards, and reports from it.',   
'WRK560-AU',   
JSON_QUERY(N'{  
    "speakers": ["Minni Walia"],  
    "track": "Workshop",  
    "language": "English",  
    "level": 2  
}')),  
('Advanced coding: Visual Studio & GitHub Copilot',   
'This session will cover using GitHub Copilot to solve a real-world scenario where an ecommerce application is having performance issues. GitHub Copilot will be used to understand the unfamiliar codebase and then explore and apply a solution.',   
'BRK432-AU',   
JSON_QUERY(N'{  
    "speakers": ["Aaron Powell"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Cloud infrastructure for AI transformation',   
'Many organizations exploring the potential of AI overlook a critical consideration – is their technology estate ready to scale and innovate? Learn how to scale AI with Microsoft Azure\''s secure, adaptive, and purpose-built cloud infrastructure.',   
'BRK370-AU',   
JSON_QUERY(N'{  
    "speakers": ["Alistair Speirs"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('From concept to creation with Azure AI Studio',   
'Selecting the right model for your generative AI app is key, but the true differentiator lies in your input. Come discover how to maximize your model\''s potential through prompt engineering and grounding context by leveraging Azure AI Studio.',   
'BRK441-AU',   
JSON_QUERY(N'{  
    "speakers": ["Bethany Jepchumba"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Next gen AI apps with databases at scale anywhere',   
'Unlock potential in your AI apps with cloud databases featuring built-in intelligence, integrated vector database, and Azure AI Search integration. Learn how to transform business apps with AI and modernize your workloads for growth.',   
'BRK461-AU',   
JSON_QUERY(N'{  
    "speakers": ["Anthony Shaw"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Operationalize AI responsibly with Azure AI Studio',   
'Explore Azure AI Studio’s new tools for generative AI security, privacy, and quality. Shift from reactive risk management to agile, responsible-by-design governance for better observability and efficiency.',   
'BRK452-AU',   
JSON_QUERY(N'{  
    "speakers": ["Michelle Sandford"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Secure your future in the age of AI',   
'Discover why security should be your top priority in your AI transformation. Gain insight on how the threat landscape is evolving, how AI can assist IT and security teams with cyber defense, and how IT and security teams can accelerate the safe adoption of AI.',   
'BRK320-AU',   
JSON_QUERY(N'{  
    "speakers": ["Orin Thomas"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Applying the functional blueprint to transform your business',   
'Organizations using Copilot see boosts in productivity and creativity, but transforming this into enterprise-wide value can be challenging. Join us to explore Microsoft\''s analysis of 300 business processes across seven functions, which were used to build a blueprint to use today to enable AI-powered business transformation.',   
'BRK331-AU',   
JSON_QUERY(N'{  
    "speakers": ["Erin Friedman", "Jason Gregory"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Exploring cutting-edge models: LLMs, SLMs, and more',   
'There are many Generative AI models: LLMs, SLMs, proprietary, open, cloud-based, on-device, text, code, image, and multimodal. Learn how to choose the right model for your needs and about tools to evaluate and compare models for specific tasks.',   
'BRK453-AU',   
JSON_QUERY(N'{  
    "speakers": ["Infey Lo"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Forging modern security with Copilot for Security',   
'Discover how Copilot for Security modernizes security operations and defense intelligence through Generative AI and Microsoft’s Threat Intelligence. A fusion of innovation, vigilance, and adaptability where efficiency and excellence converge.',   
'BRK423-AU',   
JSON_QUERY(N'{  
    "speakers": ["Sarah Young"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Optimizing your AI costs',   
'AI workloads are amazing and then you get the invoice. Learn how to avoid bill shock & improve cost visibility with FinOps principles, product controls and cost management tools.',   
'BRK473-AU',   
JSON_QUERY(N'{  
    "speakers": ["Alvaro Videla"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Advance your enterprise AI infrastructure',   
'AI workloads have a range of requirements and, let’s face it, cost, when it comes to deploying. That\''s why choosing the right hardware is critical to achieve your desired outcomes and ROI. Learn how AMD and Azure together offer cutting-edge AI infrastructure with AMD Instinct MI300X GPUs and AMD EPYC CPUs.',   
'BRKFP901-AU',   
JSON_QUERY(N'{  
    "speakers": ["Craig Emery", "Levi Watters"],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Get ready to deliver on the promise of AI',   
'To harness the potential of AI, you need the right combination of infrastructure and software to handle massive data and compute demands. Discover how AMD\''s open ecosystem and partnerships with leading AI developers enable you to build and deploy AI solutions with ease and efficiency.',   
'BRKFP900-AU',   
JSON_QUERY(N'{  
    "speakers": [],  
    "track": "Breakout",  
    "language": "English",  
    "level": 1  
}')),  
('Deploy high-quality AI applications with Azure Databricks Mosaic AI',   
'Organizations struggle to transition Generative AI projects from pilot to production due to issues with delivering accurate, business-specific, and governed outputs. Azure Databricks Mosaic AI empowers teams to build high-quality Agent Systems with accurate, context-driven results.',   
'DISFP944-AU',   
JSON_QUERY(N'{  
    "speakers": [],  
    "track": "Discussion",  
    "language": "English",  
    "level": 1  
}')),  
('Deploy Hugging Face Models on Azure powered by AMD Instinct & ROCm Software',   
'In this session you’ll learn how simple it is to pull down and deploy Hugging Face models on Microsoft Azure instances, including on the Azure ND MI300X v5 VM, powered by AMD Instinct MI300X accelerators using AMD ROCm software.',   
'DISFP941-AU',   
JSON_QUERY(N'{  
    "speakers": [],  
    "track": "Discussion",  
    "language": "English",  
    "level": 1  
}')),  
('Get ready for AI with AMD EPYC on Azure',   
'Learn how to leverage Azure infrastructure with AMD EPYC CPUs for your AI workloads. From making room in your budget to prepping data for training, and onto inferencing with small and medium-sized models on the CPU.',   
'DISFP941-AU',   
JSON_QUERY(N'{  
    "speakers": [],  
    "track": "Discussion",  
    "language": "English",  
    "level": 1  
}'));  
go

-- This query creates embedding entry into Web.sessions from the data provided.
declare @id int;
declare @a nvarchar(max);
declare @d nvarchar(max);
declare @e vector(1536);

declare session_cursor cursor for
select id, abstract, cast(details as nvarchar(max)) from [web].[sessions];

open session_cursor;
fetch next from session_cursor into @id, @a, @d;

while @@FETCH_STATUS = 0
begin
    exec web.get_embedding @a, @e output;
    insert into [web].[sessions_abstracts_embeddings] ([session_id], abstract_vector_text3) values (@id, @e);

    exec web.get_embedding @d, @e output;
    insert into [web].[sessions_details_embeddings] ([session_id], details_vector_text3) values (@id, @e);

    fetch next from session_cursor into @id, @a, @d;
end

close session_cursor;
deallocate session_cursor;
go
