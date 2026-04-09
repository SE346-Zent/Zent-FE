# Work Order States & Transitions

This detailed specification outlines the exhaustive Finite State Machine (FSM) defining the absolute status progression of a Work Order entity, focusing on state transitions, pauses, partial completions, and finalization criteria.

### 10. What is the complete state machine for a work order? (e.g., Created → Assigned → En Route → Arrived → In Progress → Pending Parts → Completed → Closed → Escalated → Reopened)

**Response:**
A rigid, predictable Finite State Machine prevents database chaos and overlapping dispatch directives. The operational linear trajectory for a standard, successful hardware intervention on the Zent platform follows this explicit path:

`CREATED` -> `UNASSIGNED` -> `ASSIGNED` -> `EN ROUTE` -> `IN PROGRESS` -> `COMPLETED` -> `CLOSED`.

To handle the complexity of environmental variables and logistical failures, the core trajectory includes specific branching nodes (sub-states/anomalies):
- **ASSIGNED -> REJECTED:** (Tech refuses the queue injection; reverts ticket to Unassigned).
- **EN ROUTE -> FAILED ARRIVAL:** (Customer absent, structural barrier; requires rescheduling).
- **IN PROGRESS -> PENDING PARTS (Paused):** (Unforeseen damage requires additional un-stocked hardware).
- **COMPLETED -> RE-OPENED:** (Administrative quality control rejects the photo artifacts, kicking the WO back to the Technician's active queue).

Every single state shift is permanently immutably logged into an internal audit trail alongside the triggering User ID and the granular UNIX Timestamp to resolve SLA disputes.

### 11. Can a work order be paused? (e.g., technician needs a part not in inventory, must return another day)

**Response:**
Yes, the ability to safely suspend an active engagement is structurally mandatory for repair logistics. 

Consider a scenario where a Technician begins disassembling an enterprise workstation slated for a simple RAM upgrade (`IN PROGRESS` state). Upon dismantling the chassis, they discover severe secondary liquid damage across the primary logic board. The Technician does not have an authorized logic board replacement present in their vehicle inventory.

The Technician accesses the command module within the mobile app and selects "Pause Intervention." The system forces them to log a structured reason parameter—in this scenario, establishing a `PENDING ADDITIONAL PARTS` sub-state flag. The Technician executes a localized 'Check-out', and the Work Order temporarily drops off their active daily radar, resting in a suspended holding pattern in the backend until the regional warehouse authorizes and ships the necessary secondary components to the Technician’s possession.

### 12. If paused, does the geo-fence requirement apply again upon resumption?

**Response:**
Absolutely. Resuming a paused Work Order after returning with additional components constitutes a completely new physical and temporal Service Session. 

Because the Technician drove away and potentially engaged entirely different client environments before returning to the original target three days later, the geo-fencing engine resets instantly upon the assignment becoming active again. When the Technician drives back to the facility holding the newly authorized logic board, the entire validation protocol fires from scratch: they must trigger "En Route," they must breach the 300-meter physical perimeter radius, and they must distinctly press "Check-in" to resume the repair session. Treating paused work orders as a continuous location stream is a security risk and massively invalidates duration logging metrics.

### 13. Can a work order be split? (e.g., partial repair today, remaining work scheduled separately)

**Response:**
No. Splitting a unified Work Order entity into branching child tickets introduces catastrophic logistical fragmentation, particularly regarding serialized part tracking.

If a machine requires two discrete actions (e.g., swapping a battery today but waiting on a specialized 4K panel shipment arriving next week), the Work Order envelope fundamentally does not bifurcate. Instead, the Technician completes the battery replacement, photographs the partially assembled machine, and effectively "Pauses" the Work Order (as defined intricately in the logic above). The Work Order merely remains suspended. A Work Order exists in a strictly 1-to-1 singular relationship with the distinct Machine Serial Number.

### 14. What triggers the transition from "In Progress" to "Completed"? Is it the signature, the self-test log, the final photo, or a manual action?

**Response:**
The transition is triggered by a discrete, culminating manual action executed by the Technician at the absolute edge of the procedural checklist sequence. 

The Zent platform utilizes a highly linear stepper interface. The system structurally blocks the Technician from viewing or accessing the final "Step 5: Digital Signature" form array until all preceding data prerequisites—Pre-disassembly artifacts, Uninstalled Barcode Scans, Installed Barcode Scans, Post-assembly artifacts, and diagnostic notes—are completely populated with valid payloads. 

Once the customer inscribes their physical signature onto the touch substrate and the Technician captures it, the UI reveals the final actionable "Submit Work Order" command hook. Pressing this button bundles the final JSON array to the API and forcefully flips the server state from `IN PROGRESS` to `COMPLETED`.  

### 15. Is there a distinction between "Completed" (technician done) and "Closed" (admin verified)? Who closes?

**Response:**
Yes, this distinction dictates the fundamental division of labor between field operations and centralized quality assurance pipelines. 

`COMPLETED` strictly signifies that the localized Technician has retreated from the physical premises and uploaded their field logic to the cloud database. It is a declaration by the field agent. 

However, before a Work Order is authorized to be billed or forwarded to the manufacturer for lucrative warranty reimbursements, a higher authority must evaluate the data integrity. A centralized Quality Assurance Administrator will pull up the `COMPLETED` Work Order array, visually verify that the Post-assembly photograph clearly demonstrates the monitor displaying the OS boot screen, and verify the scanned serial number mathematically matches the OEM dispatched part. Only when human intelligence has audited these assets will an Administrator actively press "Close Work Order," finalizing the lifecycle permanently and mutating the state to `CLOSED`.

### 16. Can a closed work order be reopened? Under what authority?

**Response:**
No. The `CLOSED` state acts as the absolute terminal point within the FSM lifecycle, functionally freezing the entire record into a readonly historical archive block. 

If a Work Order was heavily audited, formally closed by administration, and filed back to the OEM manufacturer, it structurally ceases to exist as an actionable entity. If the customer calls two weeks later asserting that the replaced motherboard spontaneously combusted, a completely fresh, distinct Work Order will be generated by the upstream CRM containing a new SLA tracking timeline and referencing the previous deployment exclusively as historical background data. 

*Note: A `COMPLETED` order can absolutely be rejected backward to `IN PROGRESS` by an Administrator (e.g., if the photos were hopelessly blurry), but a `CLOSED` order is fundamentally un-editable.*

### 17. How long does a work order remain in "Completed" before auto-closing (if ever)?

**Response:**
While relying purely on manual Admin review ensures maximum payload fidelity, high-volume operational environments inevitably generate processing backlogs where flawlessly executed tickets languish un-audited for days. 

To prevent systemic congestion from freezing operational analytics interfaces, a Chron Job executes across the database matrix checking timestamps on all entities resting in the `COMPLETED` state. If a Work Order surpasses **72 continuous hours (3 Calendar Days)** resting entirely un-audited by Administrative oversight, the system automatically intervenes. The Chron Job executes a forced state mutation override, sealing the file into the `CLOSED` state mathematically so the accounting cycle can proceed uninterrupted.
