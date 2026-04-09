# Geo-Fence Definition

This document outlines the business logic, architectural decisions, and edge case handling regarding the definition and scope of Geo-Fencing within the Zent Field Service Management system.

### 1. Who defines the geo-fence center point for each service location? The admin when creating the work order? The customer's address geocoded automatically?

**Response:**
In an enterprise-grade Field Service system, manual definition of the geo-fence for every single work order is highly inefficient and prone to human error. Therefore, the geo-fence center point must be automatically generated via a Geocoding Service (such as Google Maps Geocoding API or Mapbox Geocoding API).

When a Work Order (WO) is either imported from the primary CRM (e.g., Lenovo's ticketing system) or manually created by an Admin, the system extracts the physical address string provided by the customer. The backend system immediately processes this string through the Geocoding API to resolve the exact Latitude and Longitude coordinates. These coordinates become the absolute center point of the geo-fence for that specific Work Order. 

In situations where the automated geocoding returns a low-confidence result (for instance, an unmapped rural road or a newly developed residential area), the system will flag the Work Order. Only in these flagged scenarios will an Administrator be required to manually define or adjust the geo-fence center point using a map interface on the Admin Dashboard before the Work Order is dispatched to a Technician.

### 2. What is the fixed geo-fence radius? Is it configurable per-location, per-work-order, or globally?

**Response:**
For the Initial Phase (MVP) of the Zent platform, the geo-fence radius should be defined as a **Global Configuration Variable** managed at the Super Admin level, rather than being uniquely configured per work order. 

A standard industry best practice for civilian GPS accuracy combined with structural interference (such as densely packed urban areas or suburban complexes) is a default radius of **300 meters**. Setting the radius too small (e.g., 50 meters) will result in a massive volume of false-positive geo-fence violations due to standard GPS drift and indoor signal attenuation. 

In future iterations of the system, this architecture can be upgraded to support a tiered radius system. For example, standard residential addresses could maintain the 300-meter radius, whereas Work Orders flagged as "Enterprise/Campus" or "Industrial Complex" could automatically default to a 600-meter radius to account for sprawling corporate properties where the device location might be drastically far from the primary address coordinate. However, to maintain simplicity and rapid deployment, a globally fixed radius of 300 meters is the recommended starting point.

### 3. How accurate is the GPS fix required? What is the minimum acceptable accuracy threshold before the system considers the reading unreliable?

**Response:**
Modern mobile operating systems evaluate location data constantly and return an `accuracy` variable, measured in meters, representing the estimated radius of uncertainty. 

The Zent application must actively monitor this accuracy metric. Any GPS fix returning an accuracy radius greater than **100 meters** must be immediately classified by the system as "Unreliable." 

If a Technician attempts to execute a "Check-in" action while the device is reporting an unreliable fix, the application must block the automated geo-fence validation. Instead of silently failing, the UI must intelligently inform the Technician: *"Current GPS signal is weak or inaccurate. Please step outside or connect to a local Wi-Fi network to improve location accuracy."* 

If the Technician is deep inside a server room or basement where signal acquisition is impossible, the system must provide a fallback mechanism. The Technician can select an "Emergency Check-in" option. This workflow bypasses the strict GPS accuracy requirement but forcibly mandates the Technician to capture a timestamped, watermarked photograph of the asset or the facility's door as undeniable proof of presence. This action will flag the Work Order for subsequent Admin review.

### 4. What happens if the customer's address geocodes incorrectly? (Common in new developments, rural areas, apartment complexes.)

**Response:**
Incorrect geocoding is a ubiquitous challenge in field service logistics. When the system geocodes an address to an incorrect location (e.g., predicting a location 5 miles away from the actual newly built subdivision), the Technician will arrive at the correct physical address but the application will register them as being severely out-of-bounds.

To resolve this edge case smoothly without hindering the repair process:
1. The system must never strictly lock the Technician out of completing the Work Order. Efficacy and customer satisfaction supersede strict geo-compliance.
2. The Technician must be provided with a "Report Invalid Geo-Fence" button on the Check-in screen. 
3. Selecting this option prompts the Technician to select a pre-defined reason (e.g., "Address geocoded incorrectly by system," "Customer moved asset to neighboring building").
4. The Technician is then permitted to proceed with the service log. However, the exact GPS coordinates where the Technician manually checked in will be captured and sent to the backend, updating the actual assumed location of the asset and generating an anomaly log for the Dispatcher or Admin to review post-service.

### 5. Does the system account for vertical position? (e.g., technician is on the correct floor of a high-rise vs. the parking garage below)

**Response:**
No, the system does not and should not account for vertical position (Altitude/Z-axis). 

Civilian smartphone GPS altitude readings are notoriously inaccurate, often varying wildly by tens of meters based on atmospheric pressure and satellite triangulation geometry. Attempting to enforce geo-fencing based on altitude (e.g., verifying if the Technician is on the 45th floor versus the 2nd floor) will result in a catastrophic failure rate for Check-ins.

Geo-fencing within the Zent platform must strictly remain a Two-Dimensional (Latitude and Longitude) construct. The verification of the Technician being in the correct specific room, floor, or suite is managed entirely through secondary validation protocols: scanning the unique QR Code/Barcode of the broken machine, taking pre-disassembly photographs of the exact environment, and obtaining the final physical signature from the authorized customer representative.

### 6. For campus-style locations (hospitals, universities, industrial complexes), is a single geo-fence center adequate?

**Response:**
For standard, simplified operations, a single geo-fence center point is adequate **provided that** the address is highly specific (e.g., "Building C, 123 University Drive" instead of just "123 University Drive"). 

If the geocoding merely hits the center of a massive 5-square-kilometer university campus, a 300-meter radius will fail when the Technician attempts to check into a dormitory on the outskirts of the campus. 

To handle this elegantly within a simplified systemic framework, the business logic must rely on the previously described "Report Invalid Geo-Fence" workflow. When the Technician is on a massive campus and falls outside the singular geocoded center, they will leverage the violation override, declaring "Campus/Enterprise Environment." This ensures the Technician is never blocked from performing their duties, while still providing Admins with the telemetry data showing the Technician's exact coordinates at the time of bypass.

### 7. Can the geo-fence be overridden by an admin in real-time? (e.g., customer moves, incorrect address)

**Response:**
Yes, real-time administrative override is a critical necessity for operational continuity. 

The Admin Dashboard must include a feature for "Live Work Order Management." If a Technician calls dispatch stating that they are at the correct location but the app refuses to acknowledge it (due to severe network issues or drastic geocoding failures), the Administrator can locate the active Work Order on the web portal and execute a "Force Check-In" command. 

Furthermore, if the customer informs support that the machine has been temporarily moved to a different office branch 10 kilometers away, the Administrator inherently has the power to edit the physical address fields of the Work Order. Upon saving the new address, the backend will automatically trigger a re-geocoding sequence, instantly calculating and deploying the new geo-fence coordinates to the Technician's mobile device via a silent push data sync.

### 8. The geo-fence radius is fixed and circular. What if the service location is a massive industrial complex where the entrance or parking area is outside the calculated radius of the specific building coordinates?

**Response:**
This scenario highlights the difference between tracking "arrival at the facility" versus "arrival at the asset." 

The business objective of the Zent application's check-in process is to verify the Technician's presence at the **Actual Asset** to begin the localized repair procedure, not merely their arrival at a security gate 2 kilometers away. 

Therefore, the geo-fence should remain strictly tied to the asset's specific coordinates. The Technician is not expected—nor instructed—to initiate the "Check-in" sequence while interacting with the parking attendant or security guard at the complex perimeter. The "Check-in" action represents the declaration of the commencement of the hardware intervention. Standard operating procedure dictates that the Technician must navigate through the complex, arrive at the specific office suite or server room containing the broken Lenovo device, and only then press "Check-in." At this point, assuming the geocoding is accurate to the building, they will be safely within the 300-meter circular radius.
