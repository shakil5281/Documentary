const ALL_LESSONS = [
  {
    "section": "Basic",
    "number": "01",
    "title": "What is ASP.NET Core Web API?",
    "summary": "Understand what ASP.NET Core Web API is, why developers use it, and how it connects frontend applications with backend logic and data.",
    "url": "../docs/01-basic/lesson-01-what-is-aspnet-core-web-api.md",
    "keywords": "basic lesson-01-what-is-aspnet-core-web-api lesson 01: what is asp.net core web api? understand what asp.net core web api is, why developers use it, and how it connects frontend applications with backend logic and data."
  },
  {
    "section": "Basic",
    "number": "02",
    "title": "HTTP, REST API, and JSON",
    "summary": "Understand how HTTP, REST, and JSON work together in ASP.NET Core Web API development.",
    "url": "../docs/01-basic/lesson-02-http-rest-json.md",
    "keywords": "basic lesson-02-http-rest-json lesson 02: http, rest api, and json understand how http, rest, and json work together in asp.net core web api development."
  },
  {
    "section": "Basic",
    "number": "03",
    "title": "Controller, Route, and Action Method",
    "summary": "Learn how controllers group related API endpoints, how routes define URLs, and how action methods handle HTTP requests.",
    "url": "../docs/01-basic/lesson-03-controller-route-action-method.md",
    "keywords": "basic lesson-03-controller-route-action-method lesson 03: controller, route, and action method learn how controllers group related api endpoints, how routes define urls, and how action methods handle http requests."
  },
  {
    "section": "Basic",
    "number": "04",
    "title": "GET, POST, PUT, and DELETE",
    "summary": "Understand the four most common HTTP methods used to build CRUD endpoints in Web API.",
    "url": "../docs/01-basic/lesson-04-get-post-put-delete.md",
    "keywords": "basic lesson-04-get-post-put-delete lesson 04: get, post, put, and delete understand the four most common http methods used to build crud endpoints in web api."
  },
  {
    "section": "Basic",
    "number": "05",
    "title": "Model, DTO, Request, and Response",
    "summary": "Learn the difference between internal data models and public API request/response DTOs.",
    "url": "../docs/01-basic/lesson-05-model-dto-request-response.md",
    "keywords": "basic lesson-05-model-dto-request-response lesson 05: model, dto, request, and response learn the difference between internal data models and public api request/response dtos."
  },
  {
    "section": "Basic",
    "number": "06",
    "title": "Dependency Injection",
    "summary": "Understand how ASP.NET Core built-in dependency injection helps keep code clean, testable, and loosely coupled.",
    "url": "../docs/01-basic/lesson-06-dependency-injection.md",
    "keywords": "basic lesson-06-dependency-injection lesson 06: dependency injection understand how asp.net core built-in dependency injection helps keep code clean, testable, and loosely coupled."
  },
  {
    "section": "Basic",
    "number": "07",
    "title": "appsettings.json",
    "summary": "Learn how ASP.NET Core stores configuration values such as connection strings, logging levels, and JWT settings.",
    "url": "../docs/01-basic/lesson-07-appsettings-json.md",
    "keywords": "basic lesson-07-appsettings-json lesson 07: appsettings.json learn how asp.net core stores configuration values such as connection strings, logging levels, and jwt settings."
  },
  {
    "section": "Basic",
    "number": "08",
    "title": "Middleware",
    "summary": "Understand the ASP.NET Core request pipeline and how middleware processes HTTP requests and responses.",
    "url": "../docs/01-basic/lesson-08-middleware.md",
    "keywords": "basic lesson-08-middleware lesson 08: middleware understand the asp.net core request pipeline and how middleware processes http requests and responses."
  },
  {
    "section": "Basic",
    "number": "09",
    "title": "Error Handling",
    "summary": "Learn how to return clear, consistent, and safe error responses from Web API endpoints.",
    "url": "../docs/01-basic/lesson-09-error-handling.md",
    "keywords": "basic lesson-09-error-handling lesson 09: error handling learn how to return clear, consistent, and safe error responses from web api endpoints."
  },
  {
    "section": "Basic",
    "number": "10",
    "title": "Swagger and OpenAPI",
    "summary": "Understand how Swagger/OpenAPI documents Web API endpoints and helps developers test APIs during development.",
    "url": "../docs/01-basic/lesson-10-swagger-openapi.md",
    "keywords": "basic lesson-10-swagger-openapi lesson 10: swagger and openapi understand how swagger/openapi documents web api endpoints and helps developers test apis during development."
  },
  {
    "section": "Intermediate",
    "number": "01",
    "title": "Entity Framework Core",
    "summary": "Learn how EF Core maps C# classes to database tables and lets a Web API query and save data.",
    "url": "../docs/02-intermediate/lesson-01-entity-framework-core.md",
    "keywords": "intermediate lesson-01-entity-framework-core lesson 01: entity framework core learn how ef core maps c# classes to database tables and lets a web api query and save data."
  },
  {
    "section": "Intermediate",
    "number": "02",
    "title": "SQL Server Connection",
    "summary": "Learn how a .NET 10 Web API reads a SQL Server connection string and registers EF Core with SQL Server.",
    "url": "../docs/02-intermediate/lesson-02-sql-server-connection.md",
    "keywords": "intermediate lesson-02-sql-server-connection lesson 02: sql server connection learn how a .net 10 web api reads a sql server connection string and registers ef core with sql server."
  },
  {
    "section": "Intermediate",
    "number": "03",
    "title": "Code First Migration",
    "summary": "Understand how EF Core migrations create and update database schema from C# entity classes.",
    "url": "../docs/02-intermediate/lesson-03-code-first-migration.md",
    "keywords": "intermediate lesson-03-code-first-migration lesson 03: code first migration understand how ef core migrations create and update database schema from c# entity classes."
  },
  {
    "section": "Intermediate",
    "number": "04",
    "title": "Repository Pattern",
    "summary": "Learn how repositories hide data access details behind clear interfaces.",
    "url": "../docs/02-intermediate/lesson-04-repository-pattern.md",
    "keywords": "intermediate lesson-04-repository-pattern lesson 04: repository pattern learn how repositories hide data access details behind clear interfaces."
  },
  {
    "section": "Intermediate",
    "number": "05",
    "title": "Service Layer",
    "summary": "Learn how a service layer keeps business logic out of controllers.",
    "url": "../docs/02-intermediate/lesson-05-service-layer.md",
    "keywords": "intermediate lesson-05-service-layer lesson 05: service layer learn how a service layer keeps business logic out of controllers."
  },
  {
    "section": "Intermediate",
    "number": "06",
    "title": "Validation",
    "summary": "Learn how to validate request data before business logic and database operations run.",
    "url": "../docs/02-intermediate/lesson-06-validation.md",
    "keywords": "intermediate lesson-06-validation lesson 06: validation learn how to validate request data before business logic and database operations run."
  },
  {
    "section": "Intermediate",
    "number": "07",
    "title": "AutoMapper",
    "summary": "Understand how AutoMapper reduces repetitive mapping between entities and DTOs.",
    "url": "../docs/02-intermediate/lesson-07-automapper.md",
    "keywords": "intermediate lesson-07-automapper lesson 07: automapper understand how automapper reduces repetitive mapping between entities and dtos."
  },
  {
    "section": "Intermediate",
    "number": "08",
    "title": "Pagination, Filtering, Searching, and Sorting",
    "summary": "Learn how to design list endpoints that are fast, useful, and scalable.",
    "url": "../docs/02-intermediate/lesson-08-pagination-filtering-searching-sorting.md",
    "keywords": "intermediate lesson-08-pagination-filtering-searching-sorting lesson 08: pagination, filtering, searching, and sorting learn how to design list endpoints that are fast, useful, and scalable."
  },
  {
    "section": "Intermediate",
    "number": "09",
    "title": "JWT Authentication",
    "summary": "Learn how JWT authentication proves who is calling your Web API.",
    "url": "../docs/02-intermediate/lesson-09-jwt-authentication.md",
    "keywords": "intermediate lesson-09-jwt-authentication lesson 09: jwt authentication learn how jwt authentication proves who is calling your web api."
  },
  {
    "section": "Intermediate",
    "number": "10",
    "title": "Role-based Authorization",
    "summary": "Learn how roles control what authenticated users are allowed to do.",
    "url": "../docs/02-intermediate/lesson-10-role-based-authorization.md",
    "keywords": "intermediate lesson-10-role-based-authorization lesson 10: role-based authorization learn how roles control what authenticated users are allowed to do."
  },
  {
    "section": "Intermediate",
    "number": "11",
    "title": "Global Exception Handling",
    "summary": "Learn how to centralize unexpected error handling instead of repeating try/catch in every endpoint.",
    "url": "../docs/02-intermediate/lesson-11-global-exception-handling.md",
    "keywords": "intermediate lesson-11-global-exception-handling lesson 11: global exception handling learn how to centralize unexpected error handling instead of repeating try/catch in every endpoint."
  },
  {
    "section": "Intermediate",
    "number": "12",
    "title": "Logging",
    "summary": "Learn how logging helps you understand API behavior, debug problems, and monitor production systems.",
    "url": "../docs/02-intermediate/lesson-12-logging.md",
    "keywords": "intermediate lesson-12-logging lesson 12: logging learn how logging helps you understand api behavior, debug problems, and monitor production systems."
  },
  {
    "section": "Advanced",
    "number": "01",
    "title": "Clean Architecture",
    "summary": "This advanced lesson explains **Clean Architecture** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application ",
    "url": "../docs/03-advanced/lesson-01-clean-architecture.md",
    "keywords": "advanced lesson-01-clean-architecture lesson 01: clean architecture this advanced lesson explains **clean architecture** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application "
  },
  {
    "section": "Advanced",
    "number": "02",
    "title": "CQRS Pattern",
    "summary": "This advanced lesson explains **CQRS Pattern** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application develo",
    "url": "../docs/03-advanced/lesson-02-cqrs-pattern.md",
    "keywords": "advanced lesson-02-cqrs-pattern lesson 02: cqrs pattern this advanced lesson explains **cqrs pattern** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application develo"
  },
  {
    "section": "Advanced",
    "number": "03",
    "title": "MediatR",
    "summary": "This advanced lesson explains **MediatR** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application developers.",
    "url": "../docs/03-advanced/lesson-03-mediatr.md",
    "keywords": "advanced lesson-03-mediatr lesson 03: mediatr this advanced lesson explains **mediatr** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application developers."
  },
  {
    "section": "Advanced",
    "number": "04",
    "title": "Unit of Work",
    "summary": "This advanced lesson explains **Unit of Work** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application develo",
    "url": "../docs/03-advanced/lesson-04-unit-of-work.md",
    "keywords": "advanced lesson-04-unit-of-work lesson 04: unit of work this advanced lesson explains **unit of work** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application develo"
  },
  {
    "section": "Advanced",
    "number": "05",
    "title": "Redis Caching",
    "summary": "This advanced lesson explains **Redis Caching** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel",
    "url": "../docs/03-advanced/lesson-05-redis-caching.md",
    "keywords": "advanced lesson-05-redis-caching lesson 05: redis caching this advanced lesson explains **redis caching** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel"
  },
  {
    "section": "Advanced",
    "number": "06",
    "title": "Background Services",
    "summary": "This advanced lesson explains **Background Services** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application",
    "url": "../docs/03-advanced/lesson-06-background-services.md",
    "keywords": "advanced lesson-06-background-services lesson 06: background services this advanced lesson explains **background services** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application"
  },
  {
    "section": "Advanced",
    "number": "07",
    "title": "RabbitMQ",
    "summary": "This advanced lesson explains **RabbitMQ** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application developers",
    "url": "../docs/03-advanced/lesson-07-rabbitmq.md",
    "keywords": "advanced lesson-07-rabbitmq lesson 07: rabbitmq this advanced lesson explains **rabbitmq** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application developers"
  },
  {
    "section": "Advanced",
    "number": "08",
    "title": "API Versioning",
    "summary": "This advanced lesson explains **API Versioning** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application deve",
    "url": "../docs/03-advanced/lesson-08-api-versioning.md",
    "keywords": "advanced lesson-08-api-versioning lesson 08: api versioning this advanced lesson explains **api versioning** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application deve"
  },
  {
    "section": "Advanced",
    "number": "09",
    "title": "Rate Limiting",
    "summary": "This advanced lesson explains **Rate Limiting** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel",
    "url": "../docs/03-advanced/lesson-09-rate-limiting.md",
    "keywords": "advanced lesson-09-rate-limiting lesson 09: rate limiting this advanced lesson explains **rate limiting** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel"
  },
  {
    "section": "Advanced",
    "number": "10",
    "title": "Health Checks",
    "summary": "This advanced lesson explains **Health Checks** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel",
    "url": "../docs/03-advanced/lesson-10-health-checks.md",
    "keywords": "advanced lesson-10-health-checks lesson 10: health checks this advanced lesson explains **health checks** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application devel"
  },
  {
    "section": "Advanced",
    "number": "11",
    "title": "Docker for Web API",
    "summary": "This advanced lesson explains **Docker for Web API** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application ",
    "url": "../docs/03-advanced/lesson-11-docker-for-web-api.md",
    "keywords": "advanced lesson-11-docker-for-web-api lesson 11: docker for web api this advanced lesson explains **docker for web api** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application "
  },
  {
    "section": "Advanced",
    "number": "12",
    "title": "Kubernetes for Web API",
    "summary": "This advanced lesson explains **Kubernetes for Web API** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applicat",
    "url": "../docs/03-advanced/lesson-12-kubernetes-for-web-api.md",
    "keywords": "advanced lesson-12-kubernetes-for-web-api lesson 12: kubernetes for web api this advanced lesson explains **kubernetes for web api** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applicat"
  },
  {
    "section": "Advanced",
    "number": "13",
    "title": "CI/CD Pipeline",
    "summary": "This advanced lesson explains **CI/CD Pipeline** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application deve",
    "url": "../docs/03-advanced/lesson-13-cicd-pipeline.md",
    "keywords": "advanced lesson-13-cicd-pipeline lesson 13: ci/cd pipeline this advanced lesson explains **ci/cd pipeline** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise application deve"
  },
  {
    "section": "Advanced",
    "number": "14",
    "title": "Performance Optimization",
    "summary": "This advanced lesson explains **Performance Optimization** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applic",
    "url": "../docs/03-advanced/lesson-14-performance-optimization.md",
    "keywords": "advanced lesson-14-performance-optimization lesson 14: performance optimization this advanced lesson explains **performance optimization** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applic"
  },
  {
    "section": "Advanced",
    "number": "15",
    "title": "Security Best Practices",
    "summary": "This advanced lesson explains **Security Best Practices** for ASP.NET Core Web API using .NET 10. The focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applica",
    "url": "../docs/03-advanced/lesson-15-security-best-practices.md",
    "keywords": "advanced lesson-15-security-best-practices lesson 15: security best practices this advanced lesson explains **security best practices** for asp.net core web api using .net 10. the focus is production-grade thinking for senior developers, solution architects, technical leads, and enterprise applica"
  },
  {
    "section": "Architecture",
    "number": "01",
    "title": "HLD High Level Design",
    "summary": "HLD High Level Design teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-01-hld-high-level-design.md",
    "keywords": "architecture architecture-01-hld-high-level-design architecture 01: hld high level design hld high level design teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "02",
    "title": "LLD Low Level Design",
    "summary": "LLD Low Level Design teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-02-lld-low-level-design.md",
    "keywords": "architecture architecture-02-lld-low-level-design architecture 02: lld low level design lld low level design teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "03",
    "title": "System Design Fundamentals",
    "summary": "System Design Fundamentals teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-03-system-design-fundamentals.md",
    "keywords": "architecture architecture-03-system-design-fundamentals architecture 03: system design fundamentals system design fundamentals teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "04",
    "title": "Monolith vs Modular Monolith vs Microservices",
    "summary": "Monolith vs Modular Monolith vs Microservices teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-04-monolith-vs-modular-monolith-vs-microservices.md",
    "keywords": "architecture architecture-04-monolith-vs-modular-monolith-vs-microservices architecture 04: monolith vs modular monolith vs microservices monolith vs modular monolith vs microservices teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "05",
    "title": "API Design Best Practices",
    "summary": "API Design Best Practices teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-05-api-design-best-practices.md",
    "keywords": "architecture architecture-05-api-design-best-practices architecture 05: api design best practices api design best practices teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "06",
    "title": "Database Design",
    "summary": "Database Design teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-06-database-design.md",
    "keywords": "architecture architecture-06-database-design architecture 06: database design database design teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "07",
    "title": "Authentication and Authorization Architecture",
    "summary": "Authentication and Authorization Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-07-authentication-and-authorization-architecture.md",
    "keywords": "architecture architecture-07-authentication-and-authorization-architecture architecture 07: authentication and authorization architecture authentication and authorization architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "08",
    "title": "Caching Architecture",
    "summary": "Caching Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-08-caching-architecture.md",
    "keywords": "architecture architecture-08-caching-architecture architecture 08: caching architecture caching architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "09",
    "title": "Event Driven Architecture",
    "summary": "Event Driven Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-09-event-driven-architecture.md",
    "keywords": "architecture architecture-09-event-driven-architecture architecture 09: event driven architecture event driven architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "10",
    "title": "Message Broker RabbitMQ Architecture",
    "summary": "Message Broker RabbitMQ Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-10-message-broker-rabbitmq-architecture.md",
    "keywords": "architecture architecture-10-message-broker-rabbitmq-architecture architecture 10: message broker rabbitmq architecture message broker rabbitmq architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "11",
    "title": "API Gateway Architecture",
    "summary": "API Gateway Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-11-api-gateway-architecture.md",
    "keywords": "architecture architecture-11-api-gateway-architecture architecture 11: api gateway architecture api gateway architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "12",
    "title": "Distributed System Design",
    "summary": "Distributed System Design teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-12-distributed-system-design.md",
    "keywords": "architecture architecture-12-distributed-system-design architecture 12: distributed system design distributed system design teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "13",
    "title": "Observability Monitoring Logging",
    "summary": "Observability Monitoring Logging teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-13-observability-monitoring-logging.md",
    "keywords": "architecture architecture-13-observability-monitoring-logging architecture 13: observability monitoring logging observability monitoring logging teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "14",
    "title": "Deployment Architecture",
    "summary": "Deployment Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-14-deployment-architecture.md",
    "keywords": "architecture architecture-14-deployment-architecture architecture 14: deployment architecture deployment architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  },
  {
    "section": "Architecture",
    "number": "15",
    "title": "Enterprise ERP Architecture",
    "summary": "Enterprise ERP Architecture teaches architecture thinking for ASP.NET Core Web API (.NET 10), SQL Server, Redis, RabbitMQ, Docker, Kubernetes, and enterprise systems.",
    "url": "../docs/04-architecture/architecture-15-enterprise-erp-architecture.md",
    "keywords": "architecture architecture-15-enterprise-erp-architecture architecture 15: enterprise erp architecture enterprise erp architecture teaches architecture thinking for asp.net core web api (.net 10), sql server, redis, rabbitmq, docker, kubernetes, and enterprise systems."
  }
];
window.ALL_LESSONS = ALL_LESSONS;
const root=document.documentElement,menuButton=document.getElementById('menuButton'),nav=document.getElementById('nav'),themeToggle=document.getElementById('themeToggle'),markStarted=document.getElementById('markStarted'),progressBar=document.getElementById('progressBar'),lessonGrid=document.getElementById('lessonGrid'),lessonSearch=document.getElementById('lessonSearch'),filterButtons=[...document.querySelectorAll('[data-filter]')];let currentFilter=window._archPage?'architecture':(new URLSearchParams(window.location.search).get('filter')||'all');const savedTheme=localStorage.getItem('aspnet-docs-theme');if(savedTheme)root.dataset.theme=savedTheme;function updateThemeButton(){if(themeToggle)themeToggle.textContent=root.dataset.theme==='dark'?'Light':'Dark'}function resolveRawUrl(url){return window.location.pathname.includes('/web/')?url:url.replace(/^\.\.\//,'')}function lessonCard(item){var readerUrl="lesson.html?file="+encodeURIComponent(item.url);var rawUrl=resolveRawUrl(item.url);return `<article class="card lesson-card" style="display:flex;flex-direction:column"><span class="badge">${item.section} ${item.number}</span><h2>${item.title}</h2><p style="flex:1">${item.summary}</p><div class="card-actions"><a href="${readerUrl}" class="btn-read">&#128214; Read Lesson</a><a href="${rawUrl}" target="_blank" rel="noreferrer" class="btn-raw">Raw MD</a></div></article>`}function renderLessons(){if(!lessonGrid)return;const q=(lessonSearch?.value||'').trim().toLowerCase();const filtered=ALL_LESSONS.filter(item=>(currentFilter==='all'||item.section.toLowerCase()===currentFilter)&&`${item.number} ${item.section} ${item.title} ${item.summary} ${item.keywords}`.toLowerCase().includes(q));lessonGrid.innerHTML=filtered.length?filtered.map(lessonCard).join(''):'<article class="card"><h2>No document found</h2><p>Try another keyword or filter.</p></article>';filterButtons.forEach(b=>b.classList.toggle('active',b.dataset.filter===currentFilter))}menuButton?.addEventListener('click',()=>nav?.classList.toggle('open'));themeToggle?.addEventListener('click',()=>{const n=root.dataset.theme==='dark'?'light':'dark';root.dataset.theme=n;localStorage.setItem('aspnet-docs-theme',n);updateThemeButton()});markStarted?.addEventListener('click',()=>{localStorage.setItem('aspnet-docs-started','true');if(progressBar)progressBar.style.width='100%';markStarted.textContent='Started'});filterButtons.forEach(b=>b.addEventListener('click',()=>{currentFilter=b.dataset.filter;renderLessons()}));lessonSearch?.addEventListener('input',renderLessons);if(localStorage.getItem('aspnet-docs-started')==='true'){if(progressBar)progressBar.style.width='100%';if(markStarted)markStarted.textContent='Started'}updateThemeButton();renderLessons();if(window.mermaid)mermaid.initialize({startOnLoad:true,theme:root.dataset.theme==='dark'?'dark':'default'});
