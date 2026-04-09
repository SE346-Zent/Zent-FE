# Warranty & Service Eligibility

This outline details the strict scoping barriers separating initial Warranty Claim diagnostics handled upstream, and the physical execution pipeline managed downstream. It addresses deviations involving unauthorized damage algorithms.

### 27. The doc mentions "Warranty Checkup & Service Eligibility Query" for customers. What determines eligibility — purchase date, warranty plan, contract terms?

**Response:**
To be resolutely clear regarding the platform boundaries: the Zent Field Service application is fundamentally the downstream logistical execution terminus. It does not—and functionally should not—possess the internal processing logic required to evaluate complex warranty eligibility geometry. 

The determination encompassing factors such as localized purchase date validations, multi-tiered extended warranty SLA upgrades, and nuanced retail contract terms is processed exclusively via the upstream Manufacturer (e.g., Lenovo) core CRM API engines (such as Salesforce, Zendesk, or SAP schemas). 

The Zent backend integrates primarily to query the existence of a valid claim string tied to an external machine serial tag. If the upstream API returns an explicit *"Authorization Valid"* boolean, the Zent Dispatch console legally renders the Work Order entity onto the logistical map grid. 

### 28. Who defines warranty policies — Company X, or is it product-specific from the manufacturer?

**Response:**
The Manufacturer inherently constructs and mandates the overarching Warranty Policy taxonomy globally. 

In a third-party field execution paradigm, the Zent enterprise operates fundamentally as a subcontracted deployment force. Therefore, Zent possesses zero jurisdiction to independently define, alter, supersede, or override warranty restrictions. If the OEM parameters dictate that LCD screen defects under 5 dead pixels do not trigger a valid hardware deployment criterion, that dictate is universally absolute. Zent acts merely as the proxy hands mechanically swapping the authorized logic boards under strict manufacturer supervision. 

### 29. Can a customer be denied service? What are the grounds? (e.g., out-of-warranty, accidental damage, unauthorized prior repair)

**Response:**
Yes. Field deployments are frequently compromised by real-time hardware manifestations that were explicitly hidden from the remote Helpdesk operators. 

A Technician arrives on-site assigned to replace a "faulty trackpad" strictly under the assumption of a manufacturer defect. Upon initiating the predefined diagnostic disassembly array, the Technician explicitly uncovers overwhelming liquid corrosion covering the motherboard and smells burnt circuitry. 

This damage matrix violates the standard baseline warranty parameters, crossing heavily into **Customer Induced Damage (CID)** or Unauthorized Tampering taxonomy structures. The Technician immediately suspends the physical execution tree. They are required to generate exhaustive photographic documentation highlighting the corrosion logic. The Technician logs a `Suspend Job - Report CID Violation` reason code into the Zent application architecture. The service is functionally denied on the spot.

### 30. If service is denied, is a work order still created to document the denial? Or is the denial recorded elsewhere?

**Response:**
The Work Order entity is permanently retained within the database and mutated into heavily specialized terminal state, distinctly never erased or structurally deleted. 

Accountability and audit trails are paramount defense mechanisms against customer retaliation. The Work Order state must be advanced to a terminal flag categorized as `CANCELED - VOID WARRANTY / CID`. 

The high-resolution photographic evidence captured during the site visit immediately becomes permanently legally bound to this specific cancelled JSON ledger element. When the customer invariably escalates a furious complaint to the Lenovo executive teams demanding explanations for the denial, the administrators will seamlessly recall the archival Work Order UUID pinpointing exactly the timestamp and coordinates attached directly to the visual documentation of massive liquid seepage, neutralizing the dispute instantaneously. 

### 31. Does the system distinguish between warranty repair (free), out-of-warranty repair (paid), and recall/mandatory repair?

**Response:**
During the initial deployment phases (MVP), the Zent logistical system operates overwhelmingly under the strict paradigm of standard Warranty Execution mandates. All Work Orders are universally categorized under this functional pillar, wherein the End Customer does not conduct financial transactions dynamically with the ground Technician. The company extracts payment exclusively through bulk invoice generation submitted to the OEM. 

In advanced systemic iterations targeting Out-of-Warranty (Paid) interventions, distinguishing these workflows is vital. Paid structures require massively complex integrated billing API hooks (e.g., Stripe/Square POS interactions) executed locally on the tablet, generating taxation complexities and distinct localized invoice generation PDF templates based intimately upon the specific parts consumed. Currently, this taxonomy divergence remains largely out-of-scope for the core architecture MVP.

### 32. If paid service is offered, does Zent handle billing/invoicing, or is that external?

**Response:**
Presently, external financial processing structures maintain sole jurisdiction over comprehensive customer payment extraction mechanics. 

While implementing massive API payloads linking dynamic invoice generation directly with the Zent backend is a future roadmap aspiration, current operational capacity treats the Zent platform strictly as a Logistics Execution and Data Quality Checkpoint tool. Should an anomaly trigger a localized customer invoice requirement (e.g., a formal quote accepted for accidental shatter damage), the Technician utilizes distinct external corporate POS hardware to capture the payment, manually logging a succinct `"Customer Satisfied Debt via External CC Scanner"` string input inside the final Zent Diagnostic Notes array to generate an audit correlation string.
