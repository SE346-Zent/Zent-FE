# GPS & Connectivity

This document details the strategies and algorithms for managing location services, offline capabilities, telemetry polling, and hardware continuity constraints within the application.

### 15. Comment LP7/LP8 discusses offline location tracking with sync on reconnect. How much location data is stored locally? Is there a buffer limit?

**Response:**
The architecture for offline capability requires the application to aggressively cache all user actions locally when the network socket drops. 

Regarding location data specifically, the amount of data stored locally is microscopic. Because the Zent app utilizes an event-driven location recording model (as opposed to continuous background streaming), an offline "Check-in" event consists merely of a tiny JSON payload containing the Work Order ID, the exact UNIX Timestamp, Latitude, Longitude, and GPS Accuracy string. This payload is roughly a few hundred bytes.

Consequently, there is no practical buffer limit implemented within the local SQL or SharedPreferences architecture. A modern smartphone possesses gigabytes of available storage; compiling thousands of offline timestamp payloads would not even conceptually threaten device storage limits. The application is designed to gracefully absorb limitless offline procedural events and automatically execute an asynchronous batch synchronization sequence the moment an active TCP/IP connection to the backend is re-established.

### 16. If the technician's device has no GPS signal at arrival (indoor, basement), can they still check in?

**Response:**
Yes, operational continuity dictates that strict tracking must gracefully degrade when hardware fails to achieve satellite locks. 

When a Technician presses "Check-in" deep within a signal-blocking environment, the application's location services will attempt to resolve a fix. If the `FusedLocationProvider` fails to return a valid coordinate within the timeout threshold (e.g., 10 seconds), the application pivots automatically to the "Degraded Check-In" protocol. 

The UI will inform the user: *"GPS signal unattainable. Proceeding with Offline Validation."* The system will then fall back to the Last Known Coordinate registered by the OS before entering the building. If this coordinate is excessively old or inaccurate, the system inherently permits the check-in to proceed, but forcefully logs the event under a "Low Accuracy/No Signal" flag. To maintain accountability, the standard procedural photographs (Pre-Disassembly photos) inherently act as the definitive, undeniable proof of location presence, effectively overriding the failure of the atomic GPS hardware.

### 17. Does the system use only GPS, or also Wi-Fi positioning, cell tower triangulation, or Bluetooth beacons?

**Response:**
The architectural blueprint strictly demands that the application does not manage bare-metal GPS parsing. Instead, the ultimate system implementation will leverage the operating system's native multi-modal location aggregation APIs—specifically utilizing standard Flutter packages like `geolocator` interacting with Google’s `FusedLocationProviderClient` for Android devices and `CoreLocation` for iOS devices.

Once integrated, these advanced OS-level libraries will inherently and automatically synthesize data streams from pure satellite GPS, surrounding mapped Wi-Fi SSIDs, and cellular tower triangulation to instantly calculate the fastest and most accurate coordinate possible. The Zent application will simply request a "High Accuracy Priority" coordinate upon pressing the Check-in button, deferring the complex algebraic amalgamation to the underlying OS. The integration of Bluetooth beacons (indoor positioning systems) remains unnecessary and out of scope for standard field service at unpredictable customer residences.

### 18. How frequently is location sampled? The doc mentions "adaptive sampling" — is this still in scope given the simplification?

**Response:**
"Adaptive sampling" (the concept of increasing GPS polling frequency when moving fast and decreasing it when stationary) is a complex paradigm typically reserved for logistics delivery fleets tracking vehicles moving across interstate highways in real-time. 

Given the pivot towards a streamlined, privacy-conscious, and simplified field service app, continuous adaptive sampling is explicitly **de-scoped**. 

Location sampling in the Zent MVP is purely discrete and transactional. The GPS hardware is commanded to wake up, poll the satellites, retrieve a coordinate, and immediately shut down solely upon discrete UI button triggers (e.g., Start Trip, Check In, Submit Complete). There is no continuous background loop requesting location variables. This simplification vastly reduces developmental complexity and completely nullifies widespread battery drain issues.

### 19. What is the battery impact of continuous GPS tracking? Does the system throttle tracking to preserve battery?

**Response:**
Because the system deliberately abandons continuous background GPS tracking in favor of the transactional model detailed above, the battery impact associated with location services is effectively zero.

Continuous background GPS polling forces the mobile device's antenna into a high-power state, preventing the CPU from entering deep sleep modes, resulting in catastrophic battery drain (often consuming 10-15% of battery capacity per hour). 

By strictly engaging the GPS module for less than 5 seconds only when a critical procedural button is pressed, the Zent application guarantees that Technicians can comfortably run a full 10-hour shift handling multiple back-to-back repairs without needing to plug into auxiliary power banks or vehicle chargers to sustain application operations.

### 20. If the technician's phone dies mid-service, what happens to the work order? Can they resume on a different device?

**Response:**
Resilience against hardware failure is a core tenet of the architecture. If a device experiences a catastrophic failure (battery dies, screen shatters, dropped in water) mid-service, the Work Order state is securely preserved.

Because the Zent app actively synchronizes state changes and captured artifacts (such as forms and partial photos) to the backend API incrementally whenever possible, the majority of the progress is safely mirrored on the server. 

The Technician can simply acquire a backup company device, download the Zent application, and log in with their credentials. The application will fetch the active, suspended state of the `In Progress` Work Order directly from the cloud. The Technician can immediately resume the repair procedure from exactly where they left off. For security and auditing purposes, the backend will log the Device Signature/IMEI shift mid-work order, ensuring accountability for the sudden hardware transition.

### 21. Is location data transmitted in real-time (streaming) or batched at intervals?

**Response:**
Location data is transmitted in real-time as an integrated segment of the transactional API payloads, provided an active network connection exists. 

When the Technician clicks "Start Trip," the coordinate payload is instantly REST-POSTed to the server. When they hit "Check-in," the coordinate is embedded in the Check-in API JSON payload and transmitted instantly. 

We do not implement WebSocket/streaming feeds or continuous background worker interval batching for location telemetry. The telemetry strictly rides 'piggyback' on the critical state-transition HTTP requests. If the request fails due to network blackout, the entire payload is natively queued in the local SQLite database and re-transmitted as a comprehensive batch payload immediately upon the restoration of internet connectivity.
