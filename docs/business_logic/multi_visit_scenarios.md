# Multi-Visit Scenarios

This logic definition details the systematic implementation strategies applied when a hardware intervention requires numerous fragmented temporal sessions to reach successful resolution without shattering data coherency.

### 18. What happens when a repair requires multiple visits? Is it one work order with multiple service sessions, or multiple linked work orders?

**Response:**
A rigid one-to-one mapping rule must be maintained between the unique OEM Dispatch Ticket defining the malfunctioning hardware and the Zent database entity representing that intervention. 

Therefore, a complex hardware deployment that spans three distinct days, involves multiple diagnostic tear-downs, and requires shipping massive custom parts on flatbed trucks structurally remains enclosed inside **One Singular Work Order**. 

To handle the fragmented temporal timeline without destroying the chronological logic narrative, the underlying architecture deploys a "Nested Session" data model. The overarching Work Order entity (the parent) manages the machine identifiers, global SLA metrics, and Authorized Parts Pool. Every time the Technician functionally checks in and subsequently checks out of the geo-fence without explicitly triggering the terminal `Submit Completion` command, the database generates a locked, immutable `Service Session` child entity. A single Work Order can therefore cleanly encapsulate an infinite array of distinct Service Sessions, rendering a fully auditable timeline. 

### 19. If multiple visits, do photos from visit 1 carry over to visit 2's documentation?

**Response:**
Absolutely not. Allowing historical photographic data to automatically persist or "carry over" to future diagnostic pipelines fundamentally destroys the empirical integrity of the warranty claim packet. 

Consider the implications: A Technician visits a site for Session 1, photographs a pristine laptop chassis, realizes they lack the tools, and pauses the job. Three days later during Session 2, the customer accidentally kicks the laptop off the desk, shattering the screen enclosure. 

If the application lazily carried over the pristine Pre-Disassembly photographs from Session 1 to validate the completely distinct hardware intervention occurring during Session 2, the manufacturer would falsely reimburse the company based on falsified environmental states. Therefore, the system mandates a radical artifact reset. Whenever a Technician initiates a fresh Service Session upon resuming a Work Order, the entire photographic checklist array mathematically blanks out. They must capture current, accurate Pre-Disassembly artifacts demonstrating the exact, immediate physical reality of the machine *at that exact temporal moment* before touching a screwdriver. 

### 20. If a work order spans multiple days, is the escalation window measured from the first visit or the last?

**Response:**
Service Level Agreement (SLA) penalty parameters governing field operations are universally and strictly anchored to the absolute inception timeline, never a fluid, cascading checkpoint. 

The escalation warning window mathematically measures the temporal delta beginning explicitly at the millisecond the origin Work Order Ticket is flagged `CREATED` within the Zent deployment ecosystem. It does not measure from the initial baseline tech assignment, nor from the conclusion of a secondary incomplete visit sequence. 

If a premium warranty contract dictates a grueling "Three Day Turn Around", the chronological trigger begins the moment the system inhales the API JSON payload. If a Technician pauses the job locally because they forgot an intricate part or failed an execution parameter, the overarching SLA timer does not pause, reset, or yield. It ticks relentlessly. The system relies on this unyielding constant to aggressively signal Regional Management when fragmented multi-visit interventions are catastrophically endangering contractual metric compliance clauses.

### 21. Can different technicians service the same work order across visits?

**Response:**
Yes, high-throughput enterprise logistics functionally demands robust rotational deployment capabilities. 

If Technician Alpha executes a complex diagnostic breakdown on a sprawling internal network server (Session 1) but unexpectedly claims medical sick leave the following morning, the massive server frame cannot sit dismantled waiting for their recovery. The Dispatch Admin immediately targets the paused Work Order on the live queue map and overrides the assignment parameter, forcefully routing it to Technician Beta. 

When Technician Beta drives to the geo-fence and breaches the asset perimeter, their mobile interface unpacks the exact same Work Order shell. Because of the stringent artifact resets defined previously (Question 19), Technician Beta captures entirely fresh Pre-Disassembly states, effectively documenting precisely the state in which Technician Alpha abandoned the machinery. The centralized `CLOSED` Work Order record permanently displays a chronological history reflecting the complete rotational execution chain.
