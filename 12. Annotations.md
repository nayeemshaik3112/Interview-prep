These 3 tell Spring: "manage this class as a bean"

Difference (interview answer):
@Component  → generic class
@Service    → business logic layer (semantic meaning only)
@Repository → DB layer + auto-translates DB exceptions
              to Spring's DataAccessException

Memory trick: CSR = Component(generic) Service(logic) Repository(DB)
---------------------------------------------------------------------
@Autowired 
- "We prefer constructor injection over @Autowired on fields —
         constructor injection makes dependencies explicit and
         easier to test with mocks."
---------------------------------------------------------------------
@SpringBootApplication =
    @Configuration +
    @EnableAutoConfiguration +
    @ComponentScan

---------------------------------------------------------------------
@Value("${kafka.topic}")          → single property injection
@ConfigurationProperties("kafka") → whole group, type-safe, validated

Interview answer:
"We use @ConfigurationProperties for groups of related config
 like Outbox settings — batchSize, retryDelay, maxAttempts.
 Validated at startup. @Value for single standalone properties."

 @RestController
 @RequestMapping / @GetMapping / @PostMapping
 @PathVariable vs @RequestParam vs @RequestBody
---------------------------------------------------------------------
 @RequestHeader
Extracts HTTP header value.

In your project:
@RequestHeader("X-Claim-Request-ID") String requestId
→ idempotency key from IVR caller
---------------------------------------------------------------------
@ResponseStatus
Sets HTTP status on response.

@ResponseStatus(HttpStatus.CREATED)   → returns 201
@ResponseStatus(HttpStatus.NO_CONTENT) → returns 204

Often used on @ExceptionHandler methods too.
---------------------------------------------------------------------
@Entity / @Table / @Column
@Transactional 

What is @Transactional?
One word:
Atomic = All or Nothing
Wwhen trans not works

class A {

   @Transactional
   public void method1() {}

   public void method2() {
       method1(); // ❌ transaction NOT applied
   }
}
---------------------------------------------------------------------
What is N + 1

select * from customer - 1 query to get all the customer
select * from orders where customer_id = ? // N queries

to just select all the customer one query
to select the orders where customer ID is present this takes n queries 

this is called n + 1 problem
to solve this we use join fetch

select c.*, o.* 
from customers
join order o on where c.customer_id = o.customer_id

JOIN FETCH solves the N+1 problem by fetching both parent and child entities in a single query using a join, instead of triggering additional queries for each child entity. This reduces database calls and improves performance.
---------------------------------------------------------------------
@EnableKafka
ONE WORD: "Activate"
"Spring doesn't scan for Kafka listeners by default.
 @EnableKafka activates the listener infrastructure."
---------------------------------------------------------------------
@KafkaListener
 ONE WORD: "Subscribe"
Registers method as consumer for a topic.

Key attributes:
topics       = which topic
groupId      = consumer group (offset tracking)
concurrency  = parallel threads (= partition count)
containerFactory = your custom factory (manual ack, error handler)

Interview Q: "What if groupId is same across two services?"
"They share offset — each message goes to only ONE of them.
 That's load balancing. For independent processing, each
 service needs its own groupId."    
---------------------------------------------------------------------
@RetryableTopic
ONE WORD: "Background-retry"
Failed messages go to retry topic, not block main topic.
Creates retry topics automatically.

Interview Q: "Why not just retry inside catch block?"
"Catch block retry blocks the partition — no other messages
 processed. @RetryableTopic frees the partition immediately.
 Other claims keep flowing while one retries in background."
---------------------------------------------------------------------
@DltHandler
ONE WORD: "Dead-letter-catch"
Fires when all retry attempts exhausted.
Last chance to log, alert, save to DB.

Interview: "What happens without @DltHandler?"
"Messages silently disappear from DLT.
 In insurance — compliance risk. Every failed notification
 must be tracked."
---------------------------------------------------------------------

CORE:
@Service/@Repository/@Component → Register bean (CSR trick)
@Bean                           → Custom create
@Configuration                  → Config class
@Transactional                  → Atomic (watch self-invocation!)

REST:
@RestController                 → API class
@GetMapping/@PostMapping        → HTTP verb mapping
@PathVariable/@RequestParam/@RequestBody → where data comes from

KAFKA:
@EnableKafka                    → Activate listeners
@KafkaListener                  → Subscribe to topic
@RetryableTopic                 → Background retry
@DltHandler                     → Dead letter catch

RESILIENCE:
@CircuitBreaker                 → Stop calling (CLOSED/OPEN/HALF-OPEN)
@Retry                          → Try again
@TimeLimiter                    → Timeout
@FeignClient                    → HTTP interface

SCHEDULING:
@Scheduled(fixedDelay)          → Timer (outbox poller)
@Async                          → Background thread
---------------------------------------------------------------------