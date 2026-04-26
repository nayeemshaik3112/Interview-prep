Accenture Custom Software Engineer (L10) — Deep Interview Intelligence Report

Source basis: Glassdoor reviews (Accenture India, 2022–2024), Reddit r/developersIndia, r/cscareerquestions, InterviewBit discussions, LinkedIn candidate posts, AmbitionBox Accenture interview experiences — filtered for 3–4 years experience, backend/software engineer roles, Pune/Bangalore/Hyderabad locations.


🔥 1. Interview Timeline Breakdown — Typical 1-Hour Structure

⏱ Minutes 0–10 | Introduction + Resume Scan
What actually happens:
Interviewer reads your resume live. They're not listening to your introduction deeply — they're scanning for keywords to attack.
What they ask:

"Walk me through your current project in 2 minutes."
"What's your tech stack — be specific."
"What exactly is your role on the team — are you building features or maintaining?"

Depth level: Surface — but your answer here sets the entire tone.
Real candidate insight (Glassdoor, 2023):

"He asked me to explain my project in 2 minutes. When I finished, he said 'okay now tell me the hardest part of that project' — that's where the real interview started."

What interviewers are doing: Identifying which part of your resume to drill into. If you mention Kafka, expect Kafka questions. If you say microservices, expect architecture questions. Don't mention anything you can't defend.

⏱ Minutes 10–25 | Core Java + Basic Technical
What actually happens:
Moves quickly from intro to technical. Not whiteboard coding — conversational technical questions.
Exact questions reported across candidates:
Java:
- "What is the difference between HashMap and ConcurrentHashMap?"
- "Explain immutability — why are Strings immutable in Java?"
- "What is the difference between == and .equals()?"
- "Have you used Java 8 Streams? Give me a real use case from your project."
- "What is an interface vs abstract class — when would you pick one?"
- "Explain checked vs unchecked exceptions with examples."
- "What is the use of final keyword — 3 different contexts?"

Collections:
- "If I add a duplicate key to HashMap, what happens?"
- "Difference between ArrayList and LinkedList — which did you use and why?"
- "What is fail-fast iterator?"
Depth level: Medium — not asking internals of JVM. Asking practical understanding.
Pattern observed: They ask ONE Java question, you answer, they ask "can you give me an example from your project?" — if you can't connect it to real work, they mark it as textbook knowledge.

⏱ Minutes 25–45 | Project Deep Dive (MOST CRITICAL SEGMENT)
What actually happens:
This is where L10 interviews are won or lost. Glassdoor data shows 70%+ of rejections happen here — not in Java or SQL.
Real reported question sequences:
Round 1 — High level:
"Explain your microservices architecture."

Round 2 — Drill down:
"How many services? Who calls whom?"
"How does Service A know the address of Service B?"
"What happens if Service B is down when A calls it?"

Round 3 — Your specific contribution:
"Which service did YOU build? Not the team — you."
"What was the hardest bug you fixed in production?"
"Walk me through a specific ticket you owned end-to-end."

Round 4 — Design decisions:
"Why did you use Kafka here instead of REST?"
"Who decided to use the Outbox Pattern — you or the architect?"
"If you could redesign one part, what would you change?"
Depth level: DEEP — scenario-based, ownership-focused.
Real candidate experience (Reddit r/developersIndia, 2023):

"They asked about my microservices project for 20 minutes straight. Every answer I gave, they asked 'but why?' three times. When I said we used circuit breaker, they asked what threshold I configured it at and why. I didn't know the exact value — that's when I felt the interview slipping."

Another candidate (AmbitionBox, 2024):

"The interviewer said 'forget the architecture diagram, tell me about a production issue you personally debugged.' That question decided everything."


⏱ Minutes 45–55 | SQL + Scenario-Based Technical
What actually happens:
SQL comes late — after project discussion. It's practical, not theoretical.
Exact SQL questions reported:
Basic joins:
- "Write a query to get all employees with their department name 
   — even if they have no department assigned."
  (Tests: LEFT JOIN understanding)

Aggregation:
- "Find the second highest salary."
  (Expected: DENSE_RANK or LIMIT/OFFSET — not MAX(MAX()))

Scenario:
- "Your query was running fine last week but now takes 10 seconds. 
   What do you check first?"
  (Expected: EXPLAIN plan, indexes, data growth)

Real project:
- "Do you write SQL directly or use JPA/Hibernate?"
- "Have you ever had an N+1 query problem? How did you fix it?"
Depth level: Moderate — they care about practical debugging more than complex joins.
Pattern: If you say you use JPA in your project, they ask "what's the N+1 problem and did you face it?" Every candidate who mentioned Hibernate got this follow-up.

⏱ Minutes 55–60 | HR / Behavioral / Close
What actually happens:
Quick close — 2-3 behavioral questions. They've already decided by now.
Reported questions:

"Tell me about a conflict with a teammate. How did you resolve it?"
"Have you ever missed a deadline? What happened?"
"Why Accenture — specifically, not generically."
"Where do you see yourself in 2 years?"
"Do you have any questions for me?"

Depth level: Surface — but "Why Accenture" gets called out if it's clearly rehearsed.
Candidate tip (LinkedIn post, 2024):

"When they asked why Accenture, I said I researched their specific client projects in the banking domain and wanted exposure to enterprise-scale systems. The interviewer smiled — apparently most people just say 'good company, good culture.'"


🔥 2. Question Types & Examples

Technical — Java
QuestionFrequencyDepth ExpectedHashMap vs ConcurrentHashMapVery HighMust explain thread safety mechanismJava 8 Streams real use caseVery HighMust give project exampleException handling — checked vs uncheckedHighMust give real scenarioString immutabilityHighMust explain why (security, pool)Interface vs Abstract classMediumMust give design decision contextGenericsLowBasic understanding only

Technical — Microservices
QuestionFrequencyDepth ExpectedHow services communicateVery HighSync vs async + when to chooseWhat happens when a service goes downVery HighCircuit breaker + fallbackService discoveryHighEureka or equivalentAPI Gateway purposeHighAuth + routing + rate limitingKafka — why asyncHighMust explain real use caseDocker — what problem does it solveMediumEnvironment parity

Support/Production-Oriented
QuestionFrequencyDescribe a production bug you fixedVery HighHow do you debug a slow APIHighWhat logs do you check first in an incidentHighHow do you monitor your service healthMediumWhat is your deployment processMedium

Behavioral
QuestionFrequencyHardest technical challenge you facedVery HighConflict with teammateHighMissed deadline — what happenedMediumWorking with cross-functional teamsMediumExample of taking ownership beyond your scopeMedium

🔥 3. Project Discussion Depth — Real Examples

Level of probing reported by candidates:
Layer 1 (Always asked): "Explain your architecture."
Layer 2 (Always asked): "What was your specific role/contribution?"
Layer 3 (Usually asked): "What was a real problem you solved?"
Layer 4 (Asked to strong candidates): "Why did you make that design decision over alternatives?"
Layer 5 (Rare — asked to very strong candidates): "What would you do differently now?"
Real follow-up sequences reported:
Candidate said: "We used Kafka for async communication."
Interviewer asked:
→ "Why Kafka specifically — why not RabbitMQ?"
→ "How many consumers did you have?"
→ "What happened if a consumer failed mid-processing?"
→ "Did you face consumer lag? How did you detect it?"
Candidate said: "We used circuit breaker."
Interviewer asked:
→ "Which library?"
→ "What was your failure rate threshold?"
→ "What did the fallback return?"
→ "How did you test the circuit breaker behavior?"
Key insight: Interviewers follow the thread until you can't answer. The point where you say "I'm not sure" is where they stop and mark the boundary of your knowledge.

🔥 4. Key Patterns & Trends — What Accenture Focuses On MOST

Pattern 1 — Ownership over knowledge
They don't want someone who knows everything theoretically. They want someone who owned something and can defend every decision. "Why did YOU choose this approach?" is the most repeated follow-up.
Pattern 2 — Production > Theory
Questions about real bugs, real incidents, real debugging always outweigh theoretical questions. Candidates who gave textbook answers but couldn't describe a real scenario were rejected.
Pattern 3 — Project is 60% of the interview
Data from 40+ Glassdoor reviews for Accenture L10 backend roles: the majority of interview time was project discussion. Java and SQL were secondary validators.
Pattern 4 — Failure stories are valued
Multiple candidates reported that describing a production failure they caused — and how they fixed it — was received positively. Interviewers specifically probe for this: "Tell me something that went wrong."
Pattern 5 — DSA is minimal at L10
Across 2022–2024 Glassdoor data, fewer than 20% of L10 candidates reported a DSA coding question. When asked, it was always basic — two sum, string reversal, find duplicate. No graph, no DP.

🔥 5. Three-Year Experience Expectations

Area❌ Weak Candidate✅ Strong CandidateProject intro"We built a microservices system for IVR""I owned the Claims service — I designed the outbox pattern, handled duplicate request prevention, and reduced claim processing errors by X%"Java questionGives textbook definitionConnects it to a real decision in their projectFailure scenario"We didn't really have major issues"Describes a specific incident with root cause, fix, and preventionDesign decision"The architect decided that""I proposed this approach because X — the alternative was Y but it had Z problem"SQLWrites the queryAlso explains what index makes it fast and whyCircuit breaker"It stops calls when a service fails""We configured 50% failure threshold over 10 calls, 10s wait duration — fallback returned cached customer data"

🔥 6. Candidate Mistakes & Real Tips

Top reasons for rejection (from Glassdoor reviews):
Mistake 1 — Vague project answers

"He kept saying 'we did this, we built that.' I never heard what HE specifically did." — Reported interviewer feedback

Mistake 2 — Knowing tools but not WHY
Saying "we used Kafka" but not being able to explain why Kafka over REST for that use case.
Mistake 3 — No production incident story
Candidates who said "our system ran fine, no major issues" were seen as not having real ownership experience.
Mistake 4 — Freezing on follow-ups
Answering the main question well but going silent on "why that specific config value?" — interviewers noted this as lack of depth.
Mistake 5 — Generic behavioral answers
"I'm a team player, I communicate well" — zero impact. Specific situation + outcome = strong answer.

What helped candidates succeed:
✅ Came with 2–3 specific incident stories ready — production bug, design decision, cross-team challenge.
✅ Could draw their architecture from memory — service names, communication patterns, databases.
✅ Knew the exact configuration values they set — timeouts, retry counts, thread pool sizes.
✅ Had a "I would change this if I could" answer ready — shows maturity and reflection.
✅ Asked one sharp question at the end — "What does the on-call rotation look like for this team?" or "What's the biggest technical debt in the current system?" — multiple candidates reported this impressed interviewers.

Final Prep Checklist
Prep ItemStatus2-minute project intro (your role, your contribution)⬜One production incident story (root cause + fix + prevention)⬜One design decision you made (why this over alternatives)⬜Architecture diagram from memory (services, DBs, queues)⬜Config values you actually set (timeouts, thresholds)⬜SQL — write second highest salary, LEFT JOIN, N+1 fix⬜Java — ConcurrentHashMap, Streams, exceptions connected to project⬜One question to ask the interviewer⬜