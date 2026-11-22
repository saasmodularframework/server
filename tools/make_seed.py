import re
O = [
 ('STICKY-TIMETABLE','™','2.6',None,'REACT FLUTTER ANDROID SWIFTUI DOTNET','a pinned weekly timetable that keeps lectures, shifts and appointments in view'),
 ('SERVERSIDE-UTILITY','™','1.0',2026,'REACT IOS ANDROID','small server-side utilities for batch jobs, queues and scheduled tasks'),
 ('SAAS-SUBSECTIONS','™','2.4',2025,'REACT FLUTTER ANDROID SWIFTUI DOTNET','nested sub-sections of a SaaS dashboard, each one a lazily loaded module'),
 ('ANIMATED-STOCK','™','2.1',2024,'REACT FLUTTER ANDROID SWIFTUI DOTNET','animated stock tickers, candlesticks and portfolio sparklines'),
 ('MULTISERVER-FICTION','™','2.5',2022,'REACT FLUTTER ANDROID SWIFTUI DOTNET','multi-server story worlds that share one consistent narrative state'),
 ('METRICS-APPLIANCES','™','2.2',2023,'REACT FLUTTER ANDROID SWIFTUI DOTNET','metric appliances: gauges, counters and sparkline widgets for any dashboard'),
 ('STATISTICS-ANALYZER','™','2.3',2023,'REACT FLUTTER ANDROID SWIFTUI DOTNET','a statistics analyzer for distributions, regressions and outliers'),
 ('PORTABLE-PULLS','™','2.3',2022,'REACT FLUTTER ANDROID SWIFTUI DOTNET','portable data pulls that refresh feeds on demand from any device'),
 ('GOODS-DELIVERY','®','2.3',2021,'REACT FLUTTER ANDROID SWIFTUI DOTNET','goods delivery tracking from the warehouse shelf to the doorstep'),
 ('TRAVEL-NUGGETS','™','2.3',2021,'REACT FLUTTER ANDROID SWIFTUI DOTNET','bite-sized travel guides and itinerary nuggets'),
 ('REPAIRS-APPLICATION','™','1.0',2022,'IOS REACT ANDROID','repair tickets, parts lists and technician visits'),
 ('VR-REPAIR-APPLICATION','™','1.0',2021,'IOS ANDROID','guided repairs in virtual reality, step by step in 3D'),
 ('AR-REPAIR-APPLICATION','™','1.0',2021,'IOS ANDROID','guided repairs overlaid on the real device through augmented reality'),
 ('API DEPLOYMENT','','2.7',2021,'IOS REACT FLUTTER ANDROID DOTNET SERVER SERVERLESS','API deployment on dedicated servers and on serverless platforms'),
]
X = [
 ('DOUBLE-ENTRY-LEDGER','2.0','immutable double-entry accounting ledger with automated period close'),
 ('INVOICE-GENERATOR','1.8','templated billing invoices with structured line items and PDF export'),
 ('TELEMETRY-GRID','3.1','hierarchical telemetry grids that scale dynamically by node tier'),
 ('TIMEZONE-SCHEDULER','1.4','UTC-normalized cross-timezone event scheduler with conflict previews'),
 ('CONTACT-GRAPH-CRM','2.2','relational CRM data store indexing interaction graphs per entity'),
 ('SHARED-QUEUE-INBOX','1.1','multi-operator message queue with low-latency triage and state locks'),
 ('USAGE-METER-BILLING','2.9','metered subscription billing engine with real-time quota usage meters'),
 ('WAREHOUSE-STOCK-API','1.6','multi-zone inventory service with bin-level stock coordinates'),
 ('EVENT-STREAM-BOARD','2.4','event feed service with live capacity counters and reservation state'),
 ('BUILD-PIPELINES','3.0','CI/CD build and release pipelines with real-time status telemetry'),
 ('FUNNEL-ANALYTICS','2.5','event analytics pipeline for funnels, cohorts and retention matrices'),
 ('SCHEMA-BUILDER','1.7','form and JSON schema builder with strict validation rules'),
 ('ENCRYPTED-VAULT','1.3','zero-trust secrets manager for API keys, credentials and encrypted blobs'),
 ('THREADED-CHAT-BUS','2.1','real-time messaging bus with threads, reactions and focus mode'),
 ('CATALOG-INDEX-UI','1.9','structured product catalog browser with high-density gallery views'),
 ('TICKET-ROUTER','2.8','rule-based support ticket router with SLA timers and queue balancing'),
 ('PORTFOLIO-VIEWER','1.2','project showcase renderer with framed media previews and metadata'),
 ('DAG-WORKFLOW-ENGINE','2.6','directed acyclic graph workflow runner with state transitions and retries'),
 ('CRYPTO-SIGNATURES','1.5','digital document signing service with cryptographic stamps and audit trails'),
 ('ACCESS-CONTROL','1.0','RBAC permission lists, token invites and QR credential verification'),
 ('BOOKING-CALENDAR-API','2.3','availability and slot-locking booking engine with date-range calendars'),
 ('SEATMAP-ALLOCATOR','3.2','atomic seat-allocation engine with interactive spatial venue maps'),
 ('ROUTING-DISPATCH-API','2.0','freight routing and shortest-path dispatch service with route planning'),
 ('NOTIFICATION-DISPATCHER','1.6','multi-channel push, email and in-app notification dispatcher with scheduling'),
 ('INDEX-ENGINE','2.7','inverted-index search engine with typo tolerance and faceted filters'),
 ('LOCALIZATION-PIPELINE','1.4','translation memory store and automated localization workflows'),
]
SETS = ['REACT FLUTTER ANDROID SWIFTUI DOTNET','REACT FLUTTER ANDROID','IOS ANDROID DOTNET','REACT SERVER SERVERLESS','FLUTTER SWIFTUI ANDROID IOS']
rows=[]
for n,m,v,y,t,pu in O: rows.append((n,m,v,y,t,pu))
for i,(n,v,pu) in enumerate(X): rows.append((n,'™',v,2020+(i%7),SETS[i%len(SETS)],pu))
assert len(rows)==40
slugs=[r[0].lower().replace(' ','-') for r in rows]; assert len(set(slugs))==40
def q(s): return "'" + s.replace("'", "\\'") + "'"
out = ["",
"class SeedProduct {\n  final String name, mark, version, tags, purpose;\n  final int? startYear;\n  const SeedProduct(this.name, this.mark, this.version, this.startYear, this.tags, this.purpose);\n\n  String get slug => name.toLowerCase().replaceAll(' ', '-');\n  List<String> get tagList => tags.split(' ');\n}\n",
"const int kOriginalProducts = 14;\n",
"const List<SeedProduct> seedProducts = [\n"]
for n,m,v,y,t,pu in rows:
    out.append(f"  SeedProduct({q(n)}, {q(m)}, {q(v)}, {y if y else 'null'}, {q(t)}, {q(pu)}),\n")
out.append("];\n")
out.append(r"""
String seedBody(SeedProduct p) {
  final tags = p.tagList.map((t) => t.toLowerCase()).join(', ');
  return '${p.name} is a SaaS building block for ${p.purpose}.\n\n'
      'It is part of the software and machine learning engineering family, with sample screens in 2D and 3D '
      'and a virtual & augmented reality preview. Version ${p.version}-pre ships for $tags.\n\n'
      'Everything on this page, the text you are reading, the hero picture (JPG), the fourteen animated '
      'GIFs in the stacked carousel and the MP4 reel, is read from the local SQLite database. '
      'Use the Database tab to edit this text and watch it persist.';
}
""")
open('./lib/data/products_seed.dart','w').write(''.join(out))

base='https://saas-app-server.onrender.com'
urls=[base+'/',base+'/about-saas-products',base+'/library',base+'/services',base+'/case-studies']+[f'{base}/p/{s}' for s in slugs]
for sec in ('services','case-studies'): urls+=[f'{base}/{sec}/instance-{n:02d}' for n in range(1,41)]
sm='<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'+''.join(f'  <url>\n    <loc>{u}</loc>\n    <changefreq>weekly</changefreq>\n    <priority>{"1.0" if u==base+"/" else "0.7"}</priority>\n  </url>\n' for u in urls)+'</urlset>\n'
open('./web/sitemap.xml','w').write(sm)
print(len(urls))

