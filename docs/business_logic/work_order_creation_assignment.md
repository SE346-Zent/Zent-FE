# Work Order Creation & Assignment

This document defines the systemic flow governing the generation, validation, and hierarchical assignment models controlling exactly how field instructions move into and out of the Zent maintenance platform.

### 1. Who creates work orders? Only administrators, or can customers submit service requests that become work orders?

**Response:**
In an enterprise architecture primarily handling tier-1 warranty claims for large-scale manufacturers (like Lenovo), end-users (customers) do not directly utilize the Zent frontend application to spontaneously generate binding field-service Work Orders. 

The primary intake funnel for Work Orders originates from the manufacturer's upstream Customer Service ecosystem (e.g., Zendesk, Salesforce Service Cloud). When a customer registers a hardware complaint with the international call center, the OEM's Tier-2 technical support attempts remote remote resolution. Upon definitive confirmation of a hardware fault that mandates on-site disassembly, the upstream system automatically executes a RESTful API hook into the Zent backend. This automated payload strictly generates the core structural Work Order containing the asset's symptom description, authorized barcode part numbers, and validated shipping addresses. 

Zent platform Administrators retain the manual authority to spawn "Emergency" or "Walk-in" Work Orders directly via the Admin Dashboard web construct, bypassing the API, but this is reserved as a secondary override capability.

### 2. If customers submit service requests, is there an approval step before it becomes a work order? Who approves?

**Response:**
As established, customers are barred from bypassing the upstream hardware validation pipeline to directly spam the Zent field queue with frivolous repair requests. 

Consequently, any service request pushed downwards via the OEM API into the Zent database is inherently pre-approved. The Zent platform fundamentally assumes that any Work Order manifest received has successfully cleared the manufacturer's rigorous warranty eligibility parameters and hardware vetting processes. The Zent platform's primary mandate is the logistical physical execution of the repair, not the analytical approval of the underlying warranty policy.

### 3. What information is required to create a work order? (Machine ID? Part numbers? Symptom description? Priority? SLA tier?)

**Response:**
A Work Order matrix cannot logically proceed to assignment unless it contains a rigid baseline of validated field data. 

To successfully instantiate a Work Order within the database schema, the following array of variables is absolutely mandatory:
1. **Target Identification:** Customer Name, Phone Number, and fully formatted Physical Address.
2. **Asset Identification:** The distinct `Serial Number` and the `Machine Type Model (MTM)` identifier representing the failing unit.
3. **Problem Statement:** A qualitative text string defining the "Reported Symptom" gathered by the upstream helpdesk.
4. **Logistics Pipeline:** The specific Service Level Agreement (SLA) tier (e.g., "Next Business Day On-Site").
5. **Inventory Clearance:** A definitive list of the unique `Part Numbers (FRU/CRU)` that have been authorized for deployment from the inventory warehouse to execute the repair schema.

Unless the incoming API payload successfully populates this precise atomic structure, the backend service rejects the array and flags an integration error, preventing corrupt tickets from cascading into the visible map grid.

### 4. Can a work order have multiple tasks/line items (e.g., replace screen AND replace battery), or is each task a separate work order?

**Response:**
To optimize logistical transit paths and preserve administrative sanity, an intervention involving a single distinct machine must remain consolidated under **One Singular Work Order** payload envelope.

If a malfunctioning laptop requires both a motherboard replacement and a new trackpad assembly to resurrect full functionality, these elements are logged as nested `Authorized Part Line Items` belonging to a single overarching Work Order construct. Generating two parallel Work Orders for the exact same physical chassis deployed to the exact same geographical coordinate introduces chaotic scheduling overlaps, fragments the diagnostic photography chains, and forces the Technician to confusingly Check-in to the exact same room twice independently.

### 5. The doc mentions assignment "based on skills, availability, and geographic proximity." Is skill-matching automated or manual?

**Response:**
For Phase 1 (MVP) deployment, skill-matching and assignment are strictly **Manual procedural operations** driven by human intelligence within the Admin Dispatch portal.

While robust logistical algorithms determining routing optimized against traffic models, technician certification levels (e.g., "ThinkServer Certified" vs "IdeaPad Certified"), and live inventory cross-matching are theoretically ideal, implementing a true algorithmic dispatch engine is enormously complex. 

In the initial operational reality, the Administrator visually oversees the active queue representing their regional zone. By observing which Technicians possess the correct replacement motherboards allocated to their vans and identifying which geographic zone they are currently roaming, the Admin manually executes a "drag-and-drop" assignment, pushing the Work Order payload directly into the Technician’s mobile queue.

### 6. What happens if no technician is available for a work order? Is there a queue? Does it escalate automatically?

**Response:**
If optimal routing conditions fail and no operational Technician possesses the bandwidth, localized proximity, or correct physical replacement parts, the Work Order remains securely parked within the `Unassigned` organizational segment of the centralized Admin Dashboard.

The Work Order will idle in this pool until the visual UI triggers an automated SLA warning threshold. Because warranty contracts legally mandate repair attempts within strict temporal windows (e.g., 3 Business Days), the unassigned row will begin aggressively flashing red as it approaches the violation mark. This visual escalation forces the regional Administrator to conduct emergency schedule overrides, contact the customer to renegotiate SLA expectations, or coordinate emergency courier runs to transfer bare-metal parts between technician vans to satisfy the ticket.

### 7. Can a work order be reassigned mid-flight? Under what conditions?

**Response:**
Yes. The volatility of physical logistics mandates robust mid-flight state reallocation. 

If Technician Alpha accepts a Work Order, drives 15 kilometers, but suffers a sudden vehicular breakdown before reaching the target geo-fence, the assigned Work Order is fundamentally trapped in a compromised vector. 

The Technician will contact the dispatch authority via phone or Chat. The acting Administrator possesses absolute authority to open the Work Order on the backend, revoke Technician Alpha's assignment state (rolling the WO state visually backward), and immediately reallocate the payload to Technician Beta. Technician Beta's mobile interface immediately reflects the new inbound asset, allowing them to intercept the customer appointment.

### 8. Can a technician refuse/cancel a work order on-site? (Comment LP6 says yes, with a reason.) What happens next — does it go back to the admin queue?

**Response:**
Technicians are entrusted with significant operational latitude, including the capability to logically reject a compromised assignment from the mobile interface.

If a Technician arrives on-site and discovers that the deployment is unviable—e.g., the address provided exists in an uncontrolled construction zone lacking power, or the Technician opened their parts manifest only to realize the warehouse provided a fundamentally incorrect component footprint—they will trigger a "Reject Assignment" API call on their device. 

The UI explicitly mandates that the Technician selects a taxonomy-driven Reason Code detailing the failure matrix. Once submitted, the system instantly revokes their accountability for the assignment, wiping the Work Order from their active mobile array. Simultaneously, the system automatically shunts the isolated Work Order squarely back to the `Unassigned` global dashboard queue, heavily flagging it with the Technician's rejection payload notes so the Administrator can remediate the logistical failure before dispatching the job a second time.

### 9. If a technician cancels on-site, is a partial service record created? Are the photos taken so far preserved?

**Response:**
Yes. Any photographic artifact captured by the Technician traversing through the application schema represents invaluable empirical data that must survive local task cancellation.

If a Technician arrives, photographs the exterior structure, checks into the geo-fence, but the enraged customer violently refuses entry because the repair was delayed by a day, the Technician will log a "Failed Execution - Hostile Environment" cancellation state. 

The backend does not annihilate the partial artifact record. It permanently affixes the uploaded "Arrival Photograph", the explicit timestamp, and the GPS telemetry coordinate permanently onto the historical timeline of the Work Order. This empirical proof empowers the company to legally defend their Service Level Agreement compliance against the manufacturer, proving incontestably that a certified Technician physically fulfilled their transit obligation to the coordinate despite the customer rejecting the actual intervention.
