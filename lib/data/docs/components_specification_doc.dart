import '../../models/doc_block.dart';

const String componentsSpecificationTitle = 'Webapp Components Specification';
const String componentsSpecificationSubtitle = 'The details about webapplication components specification';

const List<DocBlock> componentsSpecificationBlocks = [
  CardsBlock([CardItem(title: 'JAVA SDK', body: [Span('Java object-oriented implementation runtime specifications models.')]), CardItem(title: 'JAVASCRIPT', body: [Span('JavaScript dynamic capabilities include runtime object execution, variable parameters, function variables in dynamic environments.')], flex: 2)], weighted: true),
  CardsBlock([CardItem(title: 'BLAZOR DOTNET', body: [Span('WebAssembly UI compilation targets converting native C# pipelines directly.')], flex: 2), CardItem(title: 'JAVA RMI ARCHITECTURE', body: [Span('Remote Method Invocation allows an object to invoke methods inside external environments.')])], weighted: true),
  CardsBlock([CardItem(title: 'JAVA SERVER CONTEXT', body: [Span('Backend handling of native infrastructure contexts and enterprise routing models.')]), CardItem(title: 'NODEJS MODULES', body: [Span('V8 runtime configurations structuring module dependencies across scale environments.')], flex: 2)], weighted: true),
  CardsBlock([CardItem(title: 'WEBRTC NODEJS', body: [Span('Real-Time Communication pipeline metrics utilizing fast event loops.')], flex: 2), CardItem(title: 'NODEJS ENVIRONMENT', body: [Span('Statically typed structured compilation patterns targetting fast enterprise layers.')])], weighted: true),
  CardsBlock([CardItem(title: 'SQL/NOSQL DATABASE', body: [Span('SQL/NoSQL payload distribution php patterns over connections.')]), CardItem(title: 'STREAMING PROTOCOLS', body: [Span('RTSP and RTP video delivery engine optimization architectures mapping.')], flex: 2)], weighted: true),
  CardsBlock([CardItem(title: 'ASYNCHRONOUS FLUTTER', body: [Span('Dart-based async AJAX pipeline rendering matrix arrays into client widgets.')], flex: 2), CardItem(title: 'RESTFUL API INFRASTRUCTURE', body: [Span('Java Boot clustered nested runtime environment configurations mapping context.')])], weighted: true),
  CardsBlock([CardItem(title: 'REDUX ASYNC THUNK', body: [Span('State management dispatch middleware pipeline workflow parsing network payloads.')]), CardItem(title: 'UDP IOS TRANSPORT', body: [Span('SwiftUI interface connection configurations rendering unacknowledged packets quickly.')], flex: 2)], weighted: true),
  CardsBlock([CardItem(title: 'ASYNC FETCH EXPO', body: [Span('React Native native hook fetch lifecycle events orchestrating platform hooks.')], flex: 2), CardItem(title: 'TYPESCRIPT', body: [Span('TypeScript is an open-source language designed to enhance code maintainability.')])], weighted: true),
  CardsBlock([CardItem(title: 'TCP SOCKET SYSTEM', body: [Span('Low-level structural system map referencing dynamic state transactions over networks.')]), CardItem(title: 'DOTNET GRPC SERVER', body: [Span('Protobuf compiler record architectures executing high performance schemas.')], flex: 2)], weighted: true),
];
