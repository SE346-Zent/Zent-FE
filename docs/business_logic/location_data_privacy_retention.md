# Location Data Privacy & Retention

This documentation defines the philosophical boundaries, retention schemas, and data sharing protocols regarding the collection of personal location data associated with Technicians executing field service logic.

### 22. Is the technician's location tracked only during active work orders, or throughout their shift?

**Response:**
To rigidly comply with global privacy standards, minimize unnecessary battery consumption, and maintain trust with field staff, the Technician's location is fundamentally and strictly tracked **only during active Work Order sequences**. 

The application architecture will absolutely not poll GPS location coordinates while the application is backgrounded or when the Technician is navigating between Work Orders without having explicitly initiated a trip. 

The tracking window initiates strictly when the Technician interacts with the UI to declare an intention to travel (e.g., pressing "Start Trip" or "En Route" to the customer site) and entirely ceases its operational awareness of the physical location the moment the Technician finalizes the hardware interaction by pressing "Submit" or "Check-out." Any location changes, route deviations, or lunch breaks occurring outside those clearly defined temporal Work Order boundaries remain deliberately unknown and untracked by the Zent platform system.

### 23. If tracked throughout the shift, does the technician consent to continuous monitoring? Are there labor law implications?

**Response:**
As established previously, continuous tracking is definitively omitted from the platform architecture. However, addressing the labor law implications clarifies the absolute necessity of this omission.

In numerous global jurisdictions (especially throughout the European Union under GDPR stipulations, and various state-level privacy statues within the United States), continuous geographic monitoring of an employee—even when performed on a company-issued device—poses profound legal and ethical risks regarding employee privacy. Pervasive tracking exposes companies to class-action litigation and intense union backlash.

By limiting tracking exclusively to the discrete transactional endpoints of direct customer service actions (Check-in and Check-out), the company avoids the quagmire of "continuous surveillance." Nevertheless, the application must feature explicitly worded pop-up consent dialogues during the first launch: *"The Zent application collects location data solely when executing active work orders to calculate estimated arrival times for customers and verify proximity to the repair location. Location tracking immediately ceases upon completion of the work order."*

### 24. How long is location data retained? Is it purged after the work order is closed, or kept for audit purposes?

**Response:**
Location coordinate logs associated with Work Order checkpoints contain highly sensitive historical data. While retaining this data is critical for defending the company against fraudulent customer claims (e.g., a customer incorrectly asserting a Technician never arrived to perform a warranty repair), hoarding this data indefinitely creates long-term cyber-liability.

The systematic retention pipeline dictates that granular location telemetry payloads (Timestamp, Latitude, Longitude, Accuracy String) associated with Check-in/Check-out events must be securely maintained within the primary operational database for a rigid timeframe—typically **6 months (180 days)**.

Once the Work Order ages past the 6-month threshold, a scheduled chronological backend daemon will execute an automated sanitization sweep. The granular GPS coordinates tied to the Work Order record will be programmatically scrubbed (nulled) or aggressively anonymized into generalized postal code metrics for macro-analytics, ensuring pure coordinates tying specific humans to specific physical locations vanish completely, significantly mitigating theoretical data breach impacts.

### 25. Can a technician dispute their recorded location data? Is there a correction mechanism?

**Response:**
Yes, a dispute and correction pipeline is a fundamental necessity. Inherent flaws within civilian GPS triangulation hardware imply that incorrect location data capture is a statistical guarantee, not merely a theoretical edge case. 

If a Technician checks into a location, but terrible atmospheric interference causes a GPS signal reflection (multipath error) that places their digital coordinate 2 kilometers away from their physical body, the system might improperly flag a geo-fence violation. If this violation penalizes the Technician's KPI scorecard, they must possess a structured method to challenge the faulty data.

The correction mechanism operates directly through the Admin Dashboard. The Technician can flag a completed Work Order under a "Dispute Geolocation Metric" ticket. The Admin reviewing the dispute can cross-reference the undeniable photographic evidence provided by the Technician (the Pre-Disassembly photo containing the asset sitting in the customer's distinct office, timestamped identically to the erroneous GPS check-in). Upon manual visual confirmation, the Admin possesses the authority to expunge the "Violation Flag" tied to that specific Work Order, effectively correcting the Technician's performance metric while leaving an audit trail denoting "Violation Overruled via Photographic Evidence."

### 26. Does the customer ever see the technician's real-time location (like a delivery tracking map)?

**Response:**
Yes, exposing real-time ETA tracking during the travel phase significantly elevates perceived professionalism and drastically reduces failure rates associated with "Customer Not Available" scenarios.

When the Technician actively selects "En Route" within the app interface, the backend triggers an automated SMS/Email notification to the registered customer containing a secure, randomized web URL. 

When the customer accesses this URL on their mobile browser, they are presented with a simplified, real-time map displaying the generic location of the Technician's vehicle converging toward their address, similar to popular rideshare interfaces. 

However, strict privacy bounds dictate this feature's limitations:
1. The map intentionally limits granularity so the exact starting location (e.g., the Technician's personal residence if they are departing for their first morning shift) is abstracted.
2. The Live Tracking Web Socket link immediately and permanently severs the millisecond the Technician triggers the "Check-In" / "Arrival" button.
3. The map view reveals zero personal identifiers regarding the Technician beyond a First Name and an ETA string.
