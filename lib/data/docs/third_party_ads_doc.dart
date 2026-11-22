import '../../models/doc_block.dart';

const String thirdPartyAdsTitle = 'Third-Party Ads';
const String thirdPartyAdsSubtitle = 'STATEMENT OF USE';

const List<DocBlock> thirdPartyAdsBlocks = [
  ParagraphBlock([Span('As described in our Privacy Policy, we collect personal information from your interactions with us and our website, including through cookies and similar technologies. We may also share this personal information with third parties, including advertising partners. We do this in order to show you ads on other websites that are more relevant to your interests and for other reasons outlined in our privacy policy.')]),
  ParagraphBlock([Span('Sharing of personal information for targeted advertising based on your interaction on different websites may be considered "sales", "sharing", or "targeted advertising" under certain U.S. state privacy laws. Depending on where you live, you may have the right to opt out of these activities. If you would like to exercise this opt-out right, please follow the instructions below.')]),
  ParagraphBlock([Span('If you visit our website with the Global Privacy Control opt-out preference signal enabled, depending on where you are, we will treat this as a request to opt-out of activity that may be considered a “sale” or “sharing” of personal information or other uses that may be considered targeted advertising for the device and browser you used to visit our website.')]),
  ParagraphBlock([Span('To opt out of the "sale" or "sharing" of your personal information collected using cookies and other device-based identifiers as described above, it shall be in adherence with '), Span('California Consumer Privacy Act of 2018 (CCPA)', href: 'http://leginfo.legislature.ca.gov/faces/codes_displayText.xhtml?division=3.&part=4.&lawCode=CIV&title=1.81.5'), Span(', '), Span('the California Privacy Rights Act, 2020 (CPRA)', href: 'https://www.caprivacy.org/annotated-cpra-text-with-ccpa-changes/'), Span(' and '), Span('the California Online Privacy Protection Act of 2013 (CalOPPA) as codified at California Business and Professions Code sections 22575–22579.', href: 'https://leginfo.legislature.ca.gov/faces/codes_displaySection.xhtml?lawCode=BPC§ionNum=22575.')]),
  ParagraphBlock([Span('This Statement was published for the first time in 2021. It was last reviewed and updated on July 13, 2026', italic: true)]),
];
