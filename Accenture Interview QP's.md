## 🔹 Intro & Project Related Intro
- Introduction about yourself  
- Explanation of your project (architecture, tech stack, your role, challenges)
- How do you structure your microservice project

-------------------------------------------------------------------------------------------------------------------------------
## 🔹 Core Java

1. Can private methods be overridden? Why?  
2. Can static methods be overridden?  
3. Can static and private methods be overloaded?  
4. JVM and its components  
5. Why Java is platform independent  
6. What is String Pool  
7. Why String is immutable  
8. How do you create a custom exception in plain Java  
9. Checked vs Unchecked exceptions  
10. Can we catch exceptions in static blocks or constructors  
11. Throw vs Throws  
12. Tell me about access modifiers  
13. Hashmap() vs Concurrenthashmap()
ConcurrentHashmap() - it is a thread safe, where it won't allow the null's . it will throw NullPointerException

Provides thread-safe operations without locking the entire map, improving concurrency.
Allows multiple threads to read and write simultaneously with minimal blocking.
Does not allow null keys or null values, preventing ambiguity in concurrent operations.

-------------------------------------------------------------------------------------------------------------------------------
## 🔹 Java 8 / Functional Programming

13. What is Functional Interface  
14. Can functional interfaces have default methods  

- Default methods are introduced in Java 8 to allow interfaces to have method implementations, enabling backward compatibility when new methods are added. They are inherited and can be overridden by implementing classes.

- Static methods in interfaces belong to the interface itself, are not inherited, and are used for utility or helper functionality related to the interface.

15. Why default methods are introduced when abstract classes are already present  
16. Difference between intermediate and terminal stream operations  

Intermediate operations are lazy and return a stream, while terminal operations trigger execution and produce a result.
Intermediate - filter , map . Terminal - which collect(), foreach(), count(). 

17. Map vs FlatMap  

// Sample data
User1 (active): roles = [ADMIN, USER, MANAGER]
User2 (active): roles = [USER, VIEWER]
User3 (active): roles = [ADMIN, VIEWER]

// After filter(User::isActive)
Stream: [User1, User2, User3]

// After flatMap(user -> user.getRoles().stream())
// ↓ Flattens all role lists into single stream
Stream: [ADMIN, USER, MANAGER, USER, VIEWER, ADMIN, VIEWER]

// After map(Role::getRoleName)
Stream: ["ADMIN", "USER", "MANAGER", "USER", "VIEWER", "ADMIN", "VIEWER"]

// After distinct()
Stream: ["ADMIN", "USER", "MANAGER", "VIEWER"]

// After sorted()
Stream: ["ADMIN", "MANAGER", "USER", "VIEWER"]


List: ["ADMIN", "MANAGER", "USER", "VIEWER"]
-------------------------------------------------------------------------------------------------------------------------------
## 🔹 Spring Boot / Web

1. Controller vs RestController  
2. What is CORS
-CORS is a browser security mechanism that restricts cross-origin HTTP requests, and it can be configured on the server to allow trusted domains.

3. Path Variable vs Request Parameter  
- Path variables are used to identify resources in the URL path, while request parameters are used to pass optional query parameters.

4. Difference b/w Spring vs Spring Boot
- Spring framework provides core features like DI, AOP, MVC
- Spring Boot is provides auto configuration + embedded server

5. What is starter Depedency
spring-boot-starter-web
spring-boot-starter-data-jpa
which includes Tomcat, Jackson, Spring MVC
Starter dependencies are pre-configured dependency sets that simplify dependency management in Spring Boot.

6. Application.Properties vs Application.YML
7. How do we secure rest API's 
- Through JWT token and with Spring Security

8. How do you connect Spring Boot to Data Base
spring.datasource.url=jdbc:mysql://localhost:3306/db
spring.datasource.username=root
spring.datasource.password=pass

9. What is Auto-Configuration and EnableAutoConfiguration and SpringBootApplication 
- Auto-configuration in Spring Boot automatically configures beans based on classpath dependencies, existing beans, and application properties using conditional annotations.
- @EnableAutoConfiguration triggers Spring Boot’s auto-configuration mechanism by loading configuration classes from spring.factories using AutoConfigurationImportSelector.
-   @SpringBootApplication =
    @Configuration
    + @EnableAutoConfiguration
    + @ComponentScan

10. About Service Discovery and API Gateway
@EnableEurekaServer   // for discovery server
@EnableDiscoveryClient // for services
-------------------------------------------------------------------------------------------------------------------------------
## 🔹 Hibernate / JPA

21. What is Hibernate  
22. Eager vs Lazy fetching  
Eager fetching loads related data immediately, while lazy fetching loads it only when accessed, improving performance.

23. get() vs load() methods in Hibernate  
call get() → DB hit → returns real object
call load() → returns proxy → access field → DB hit

get() immediately fetches data from the database and returns null if not found, while load() returns a proxy object and fetches data lazily, throwing an exception if the entity does not exist.
-------------------------------------------------------------------------------------------------------------------------------
## 🔹 Microservices

1. What are Microservices
2. What is a Service Discovery  
- Service discovery allows services to dynamically register and discover each other using a registry like Eureka. 

-------------------------------------------------------------------------------------------------------------------------------

## Stream Questions
1. print even numbers from list of numbers

List<Integer> list = Arrays.asList(1,2,3,4,5,6);
list.stream()
.filter(n = n % 2 == 0)
.foreach(system.out::println)
