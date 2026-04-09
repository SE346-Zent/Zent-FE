# Entry & Exit Logic

This document defines the systemic rules, state transitions, and logging mechanisms associated with a Technician entering, interacting within, and exiting the designated geographic boundaries of a Work Order.

### 9. What constitutes "arrival" — first GPS fix inside the fence, or sustained presence for N seconds?

**Response:**
In the Zent platform architecture, "arrival" is strictly defined as dynamic, active consent by the user, not passive background tracking. 

An arrival event is successfully registered exclusively when two conditions are met simultaneously:
1. The mobile device's geographic coordinates (with acceptable accuracy metrics) mathematically intersect with the active geo-fence radius.
2. The Technician explicitly presses the "Check-In" operational button within the application User Interface.

Relying on passive background triggers (e.g., the first GPS fix inside the fence or sustained presence) introduces critical flaws. A Technician might simply be driving past the customer's neighborhood on their way to lunch, which would fraudulently trigger a passive check-in. By requiring a deliberate physical action (pressing "Check-in") while inside the valid GPS zone, the system ensures intent, preserves battery life by disabling continuous background polling, and prevents false-positive timeline data.

### 10. What happens if GPS signal is lost while the technician is inside the geo-fence? Is the session invalidated?

**Response:**
Absolutely not; the session is completely secure and undeniably valid. 

Field service inherently involves venturing into signal-hostile environments—subterranean parking garages, thick-walled server rooms, and remote basement facilities. 

Once the initial "Check-In" authentication is successfully validated against the geo-fence, the mobile application locks the Work Order into the `In Progress` state locally and broadcasts this state shift to the backend. From this exact millisecond forward, the continuous presence of a GPS signal is entirely irrelevant to the integrity of the active session. The application will not aggressively poll the GPS hardware while deeply engaged in the Work Order steps, thus preserving critical battery power. All subsequent actions, scans, forms, and photographs are cached locally. The session remains fully validated until the Technician manually concludes the repair and executes the formal "Check-Out" or "Submit" process.

### 11. Does the technician need to remain inside the geo-fence for the entire service duration, or only at check-in and check-out?

**Response:**
The Technician is only explicitly required to interact with the geo-fence security protocol during specific transactional moments: Check-in and Check-out. 

During the execution of a complex hardware repair, it is entirely expected and common for a Technician to exit the immediate vicinity of the asset. They may need to return to their service van parked several streets away to retrieve a specialized tool, fetch a replacement motherboard, or step outside to take a phone call with Level 2 Support. 

The system logic understands this reality. Once the Work Order is `In Progress`, the geographic bindings are temporarily suppressed. The system does not penalize, log, or restrict the Technician if they wander outside the 300-meter radius mid-service. However, when the Technician attempts to finalize the Work Order and initiate the "Submit/Check-out" protocol, the system will execute a final location poll to ensure they are physically present to hand over the device to the customer.

### 12. What happens if the technician steps outside the geo-fence mid-service? (e.g., goes to their vehicle for tools)

**Response:**
As noted in the previous logic definition, stepping outside the geo-fence mid-service triggers zero systemic repercussions. 

The application architecture assumes that the `In Progress` state represents a fluid period of hardware intervention that may require mobility. The application will not generate warning notifications, will not lock the user out of the documentation screens, and will not secretly record a "geo-fence exit" event. Imposing restrictions upon mid-service mobility would drastically impair the Technician's efficiency and cause significant operational frustration.

### 13. Does the system record all entry/exit events, or only the first entry and last exit?

**Response:**
To prioritize Technician privacy, optimize data storage arrays, and maximize device battery longevity, the system strictly records **action-triggered location events** rather than continuous breadcrumb tracking.

The system will only record location coordinates logging to the Work Order history during specific procedural steps:
1. When the Technician presses "Start Trip" (recording origin).
2. When the Technician presses "Check-In" (First Entry).
3. When the Technician presses "Submit & Complete" (Last Exit / Conclusion).

The system explicitly does not record silent background entries and exits while the Work Order is suspended in the active state. The goal of the system is to ensure the job is performed at the right place and track total time-on-site, not to construct a surveillance map of the Technician's every footstep during the appointment.

### 14. Is there a maximum duration a technician can be inside a geo-fence before the system flags it as anomalous?

**Response:**
Yes, establishing a maximum operational duration is a crucial safeguard for both anomaly detection and operational safety.

While hardware repairs vary wildly in complexity, a standard service intervention rarely exceeds a standard operational shift. The system backend runs a chronological cron job that monitors all Work Orders currently flagged as `In Progress`. 

If a Work Order remains in the `In Progress` state for a continuous duration exceeding **6 hours** without any subsequent state updates, the backend logic will automatically generate an "Anomalous Duration Warning." This warning is visually flagged on the centralized Dispatcher/Admin Dashboard. 

This flag serves multiple purposes:
1. It identifies Technicians who simply forgot to press the "Submit/Check-Out" button after finishing a job and driving home.
2. It serves as a safety protocol; if a Technician is unaccounted for and unresponsive after 6 hours on site, dispatchers are alerted to potentially intervene or conduct a welfare check.
3. It prevents drastically skewed Time-to-Repair metrics in the overarching analytics engine.
