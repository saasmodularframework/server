class SeedProduct {
  final String name, mark, version, tags, purpose;
  final int? startYear;
  const SeedProduct(this.name, this.mark, this.version, this.startYear, this.tags, this.purpose);

  String get slug => name.toLowerCase().replaceAll(' ', '-');
  List<String> get tagList => tags.split(' ');
}

const int kOriginalProducts = 14;
const List<SeedProduct> seedProducts = [
  SeedProduct('STICKY-TIMETABLE', '™', '2.6', null, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'pinned weekly schedule view for lectures, shifts and cron appointments'),
  SeedProduct('SERVERSIDE-UTILITY', '™', '1.0', 2026, 'REACT IOS ANDROID', 'server-side workers for batch jobs, message queues and scheduled tasks'),
  SeedProduct('SAAS-SUBSECTIONS', '™', '2.4', 2025, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'nested SaaS dashboard routes, each rendered as a lazy-loaded module'),
  SeedProduct('ANIMATED-STOCK', '™', '2.1', 2024, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'real-time market tickers, candlestick charts and portfolio sparklines'),
  SeedProduct('MULTISERVER-FICTION', '™', '2.5', 2022, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'distributed multi-node state engines sharing a single synchronized world state'),
  SeedProduct('METRICS-APPLIANCES', '™', '2.2', 2023, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'telemetry widgets: gauges, counters and sparkline components for dashboards'),
  SeedProduct('STATISTICS-ANALYZER', '™', '2.3', 2023, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'statistical compute engine for distributions, regressions and anomaly detection'),
  SeedProduct('PORTABLE-PULLS', '™', '2.3', 2022, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'on-demand data sync clients that pull and cache remote feeds across devices'),
  SeedProduct('GOODS-DELIVERY', '®', '2.3', 2021, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'shipment telemetry tracking payloads from warehouse pick to client endpoint'),
  SeedProduct('TRAVEL-NUGGETS', '™', '2.3', 2021, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'structured itinerary payloads and geolocation route snippets'),
  SeedProduct('REPAIRS-APPLICATION', '™', '1.0', 2022, 'IOS REACT ANDROID', 'issue tracking workflows, BOM parts manifests and field service logs'),
  SeedProduct('VR-REPAIR-APPLICATION', '™', '1.0', 2021, 'IOS ANDROID', 'step-by-step 3D virtual reality diagnostic and assembly guides'),
  SeedProduct('AR-REPAIR-APPLICATION', '™', '1.0', 2021, 'IOS ANDROID', 'real-time augmented reality hardware overlays and spatial annotations'),
  SeedProduct('API DEPLOYMENT', '', '2.7', 2021, 'IOS REACT FLUTTER ANDROID DOTNET SERVER SERVERLESS', 'automated API deployments across dedicated containers and serverless runtimes'),
  SeedProduct('DOUBLE-ENTRY-LEDGER', '™', '2.0', 2020, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'immutable double-entry accounting ledger with automated period close'),
  SeedProduct('INVOICE-GENERATOR', '™', '1.8', 2021, 'REACT FLUTTER ANDROID', 'templated billing invoices with structured line items and PDF rendering'),
  SeedProduct('KPI-TELEMETRY-GRID', '™', '3.1', 2022, 'IOS ANDROID DOTNET', 'hierarchical KPI telemetry grids that scale dynamically by node tier'),
  SeedProduct('TIMEZONE-SCHEDULER', '™', '1.4', 2023, 'REACT SERVER SERVERLESS', 'UTC-normalized cross-timezone event scheduler with slot conflict previews'),
  SeedProduct('CONTACT-GRAPH-CRM', '™', '2.2', 2024, 'FLUTTER SWIFTUI ANDROID IOS', 'relational CRM data store indexing interaction graphs per entity'),
  SeedProduct('SHARED-QUEUE-INBOX', '™', '1.1', 2025, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'multi-operator message queue with low-latency triage and state locks'),
  SeedProduct('USAGE-METER-BILLING', '™', '2.9', 2026, 'REACT FLUTTER ANDROID', 'metered subscription billing engine with real-time quota consumption curves'),
  SeedProduct('WAREHOUSE-STOCK-API', '™', '1.6', 2020, 'IOS ANDROID DOTNET', 'multi-zone inventory service with bin-level stock coordinates'),
  SeedProduct('EVENT-STREAM-BOARD', '™', '2.4', 2021, 'REACT SERVER SERVERLESS', 'event feed UI with live capacity counters and reservation state'),
  SeedProduct('BUILD-PIPELINES', '™', '3.0', 2022, 'FLUTTER SWIFTUI ANDROID IOS', 'CI/CD build and release pipelines with real-time status telemetry'),
  SeedProduct('FUNNEL-ANALYTICS', '™', '2.5', 2023, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'event analytics pipeline for conversion funnels, cohorts and retention matrices'),
  SeedProduct('SCHEMA-BUILDER', '™', '1.7', 2024, 'REACT FLUTTER ANDROID', 'visual form and JSON schema builder with strict type validation'),
  SeedProduct('ENCRYPTED-VAULT', '™', '1.3', 2025, 'IOS ANDROID DOTNET', 'zero-trust secrets manager for API keys, credentials and encrypted blobs'),
  SeedProduct('THREADED-CHAT-BUS', '™', '2.1', 2026, 'REACT SERVER SERVERLESS', 'real-time messaging bus with threaded payloads, reactions and focus filtering'),
  SeedProduct('CATALOG-INDEX-UI', '™', '1.9', 2020, 'FLUTTER SWIFTUI ANDROID IOS', 'structured product catalog browser with high-density media grids'),
  SeedProduct('TICKET-ROUTER', '™', '2.8', 2021, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'rule-based support ticket router with SLA timers and queue balancing'),
  SeedProduct('PORTFOLIO-VIEWER', '™', '1.2', 2022, 'REACT FLUTTER ANDROID', 'project showcase renderer with cropped media previews and metadata'),
  SeedProduct('DAG-WORKFLOW-ENGINE', '™', '2.6', 2023, 'IOS ANDROID DOTNET', 'directed acyclic graph workflow runner with state transitions and retries'),
  SeedProduct('SIGNATURES', '™', '1.5', 2024, 'REACT SERVER SERVERLESS', 'digital document signing service with cryptographic stamps and audit logs'),
  SeedProduct('ACCESS-CONTROL', '™', '1.0', 2025, 'FLUTTER SWIFTUI ANDROID IOS', 'RBAC permission lists, token invites and QR credential verification'),
  SeedProduct('BOOKING-CALENDAR-API', '™', '2.3', 2026, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'availability and slot-locking booking engine with date-range indexing'),
  SeedProduct('SEATMAP-ALLOCATOR', '™', '3.2', 2020, 'REACT FLUTTER ANDROID', 'atomic seat-allocation engine with interactive spatial venue maps'),
  SeedProduct('ROUTING-DISPATCH-API', '™', '2.0', 2021, 'IOS ANDROID DOTNET', 'freight routing and shortest-path dispatch service with live telemetry'),
  SeedProduct('NOTIFICATION-DISPATCHER', '™', '1.6', 2022, 'REACT SERVER SERVERLESS', 'multi-channel push, SMTP and webhook dispatcher with scheduled queues'),
  SeedProduct('INDEX-ENGINE', '™', '2.7', 2023, 'FLUTTER SWIFTUI ANDROID IOS', 'inverted-index search engine with fuzzy token matching and facet filters'),
  SeedProduct('LOCALIZATION-PIPELINE', '™', '1.4', 2024, 'REACT FLUTTER ANDROID SWIFTUI DOTNET', 'translation memory store and automated i18n string sync pipeline'),
];

String seedBody(SeedProduct p) {
  final tags = p.tagList.map((t) => t.toLowerCase()).join(', ');
  return '${p.name} is a SaaS building block for ${p.purpose}.\n\n'
      'It is part of the software and machine learning engineering family, with sample screens in 2D and 3D '
      'and a virtual & augmented reality preview. Version ${p.version}-pre ships for $tags.\n\n'
      'Everything on this page, the text you are reading, the hero picture (JPG), the fourteen animated '
      'GIFs in the stacked carousel and the MP4 reel, is read from the local SQLite database. '
      'Use the Database tab to edit this text and watch it persist.';
}

