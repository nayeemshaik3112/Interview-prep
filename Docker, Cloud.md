## Why do we use Docker? What problem does it actually solve?
- Without Docker, "works on my machine" is a real problem — different Java versions, OS differences, missing dependencies. Docker packages the app WITH its runtime into one container. It runs identically everywhere.
WHY: Environment parity. Dev, staging, and production run the exact same image. Deployment becomes predictable.
----------------------------------------------------------------------
## What is the difference between a Docker image and a container?
- Image = blueprint (like a class). Container = running instance (like an object). One image can run as many containers. Image is read-only. Container adds a writable layer on top.
WHY: This is asked to check if you understand the build-once-run-anywhere model.
----------------------------------------------------------------------
## Docker vs Virtual Machine — what's the difference?
- VM runs a full OS on top of hypervisor — heavy, takes minutes to start, GBs in size. Docker shares the host OS kernel — lightweight, starts in seconds, MBs in size.
WHY: Docker containers are faster, use fewer resources. For microservices with 10+ services, Docker is practical. VMs per service would be too heavy.
----------------------------------------------------------------------
## What is Docker Compose and when do you use it?
- Docker Compose starts multiple containers together with one command. In your IVR project — Claims, Notification, Kafka, MySQL, Axon Server all start with docker compose up.
WHY: Without Compose, you'd manually start 10+ containers with individual docker run commands and handle networking yourself. Compose does it declaratively.
When NOT to use: Production. Production uses Kubernetes or ECS — not Compose.
----------------------------------------------------------------------
## What happens if a container crashes in production?
- Container stops. In Docker Compose, restart: always policy auto-restarts it. In cloud (ECS/Kubernetes), the orchestrator detects unhealthy container via health check endpoint and replaces it automatically.
WHY health checks matter: Without /actuator/health configured, orchestrator doesn't know the app is broken even if container is "running."
----------------------------------------------------------------------
## What is a Docker volume and why do you need it?
- Container filesystem is temporary — data dies when container dies. Volumes persist data outside the container on the host machine. Database data, logs, config files need volumes.
WHY: Without volumes, your MySQL container restart = all data gone. Volumes survive container restarts and replacements.
----------------------------------------------------------------------
## How do containers communicate with each other in Docker Compose?
- Docker Compose creates a default network. Containers reach each other by service name — mysql-customer:3306, kafk-29092. No IP needed — DNS resolution by service name.
WHY: Container IPs change on restart. Service name = stable DNS. This is exactly how your application.yml references kafk-29092 inside Docker network.
----------------------------------------------------------------------
## How do you pass environment-specific config to Docker containers?
- Environment variables in Docker Compose or at docker run. Spring Boot reads them automatically. SPRING_KAFKA_BOOTSTRAP_SERVERS=kafk-29092 overrides any application.yml value.
WHY: Same image runs in dev, staging, prod. Different env vars = different behavior. Never bake secrets into image.
----------------------------------------------------------------------
## What is the difference between COPY and ADD in Dockerfile?
- COPY copies files from our local machine to image. ADD does same + can extract tar files + fetch from URL. Always use COPY unless you specifically need ADD's extras — simpler and more predictable.
----------------------------------------------------------------------
## CMD vs ENtrypoint
Entry point is fixed
CMD can be overridden with run ccommand
----------------------------------------------------------------------
## What is .dockerignore and why does it matter?
- Like .gitignore — tells Docker what NOT to copy into build context. 
Exclude target/, node_modules/, .git/. Smaller build context = faster build, no sensitive files in image accidentally.
--------------------------------------------------------------------------------------------------------------------------------------------
## CLOUD
## Horizontal scaling vs Vertical scaling — when to use which?
Vertical scaling means increasing the resources of a single machine, like adding more CPU or RAM.
Horizontal scaling means adding more machines to handle load.
Vertical scaling is simpler and used initially, while horizontal scaling is used for high traffic systems and provides better fault tolerance.
----------------------------------------------------------------------
## What is a Load Balancer? Why is it needed?
- Distributes incoming traffic across multiple service instances. If one instance is down, load balancer stops sending traffic to it. Clients don't know about individual instances — they talk to one endpoint.
WHY needed: Without it, adding 5 more service instances is useless — clients still hit only one. Load balancer is what makes horizontal scaling actually work.
Application Load Balancer (ALB)
Network Load Balancer (NLB)
Gateway Load Balancer (GWLB)
Classic Load Balancer (CLB)
----------------------------------------------------------------------
## hat is auto-scaling?
- Automatically adds or removes instances based on metrics — CPU, memory, request rate, Kafka consumer lag. Scales up during peak, scales down to save cost.
Real example: IVR system at 9 AM — call volume spikes. Auto-scaling adds 3 more orchestrator pods. At midnight — removes them. You pay only for what you use.
----------------------------------------------------------------------      
## What is a CDN (Content Delivery Network)?
Example : Mumbai
-Network of servers worldwide that cache static content close to users. User in Mumbai gets content from Mumbai server, not US server. Faster load times, reduced origin server load.
WHY relevant: IVR systems may have static assets or API documentation cached via CDN. Reduces latency for geographically distributed users.
----------------------------------------------------------------------
## What is serverless? When would you use it?
A: You write code, cloud runs it — no servers to manage. Scales automatically, pay per execution. AWS Lambda is the most common.
When to use: Event-driven, short-lived tasks — send email on claim creation, process uploaded document. Not for long-running microservices.
----------------------------------------------------------------------
## DEPLOYMENT

“In my current role, the actual deployment is handled by the DevOps team, but as a backend developer I have a clear understanding of the deployment flow. I containerize my services using Docker, ensure configurations are externalized, and coordinate with DevOps for deployment. Typically, our microservices are deployed using container orchestration like ECS or Kubernetes, behind a load balancer, with CI/CD pipelines handling build and release. I also ensure my services are production-ready with proper health checks, logging, and configurations.”
----------------------------------------------------------------------
## Stateless service
A stateless service does not store any client session data, and each request contains all the required information. 
This allows any instance to handle any request, making horizontal scaling easier and avoiding the need for sticky sessions.
----------------------------------------------------------------------
## Pagination

Cursor-based pagination uses a reference like lastId, making it faster and more consistent, especially for large datasets.
----------------------------------------------------------------------
Why REST over SOAP?

SOAP is verbose XML, strict contracts, heavy to parse. REST uses JSON, lightweight, standard HTTP methods, cacheable responses. REST is stateless — scales horizontally easily. For microservices communication, REST is the standard. SOAP only when integrating with legacy enterprise systems that mandate it.
----------------------------------------------------------------------
## Why Docker over just running the JAR directly?

"Running JAR directly means the server must have exact Java version, correct env vars, right OS libraries. Docker packages all of that — same JAR, same Java, same OS libraries run everywhere. In our IVR system with 8+ services, Docker Compose gave us one-command local setup that mirrored production exactly."
----------------------------------------------------------------------
## Why horizontal scaling over vertical?

Vertical has a ceiling — you can't add infinite CPU to one machine. It also requires downtime to upgrade. Horizontal adds more instances behind a load balancer — no ceiling, no downtime, pay only for what you use. Our stateless microservices are built for horizontal scaling — any instance handles any request.
----------------------------------------------------------------------