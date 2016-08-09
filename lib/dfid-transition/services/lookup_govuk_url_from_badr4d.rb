require 'dfid-transition/services'

module DfidTransition
  module Services
    ##
    # Concerns: allows us to look up new URLs by original ID
    #
    class LookupGovukUrlFromBadr4d
      def self.mappings
        {
          'http://linked-development.org/r4d/output/65132/' =>
            'https://gov.uk/dfid-research-outputs/moving-beyond-research-to-influence-policy-workshop-university-of-southampton-23-24-january-2001',
          'http://linked-development.org/r4d/output/182322/' =>
            'https://gov.uk/dfid-research-outputs/low-level-laser-therapy-for-treating-tuberculosis-182322',
          'http://linked-development.org/r4d/output/179676/' =>
            'https://gov.uk/dfid-research-outputs/vaccines-for-preventing-malaria-blood-stage',
          'http://linked-development.org/r4d/output/179677/' =>
            'https://gov.uk/dfid-research-outputs/vaccines-for-preventing-malaria-spf66',
          'http://linked-development.org/r4d/output/179678/' =>
            'https://gov.uk/dfid-research-outputs/vaccines-for-preventing-malaria-pre-erythrocytic',
          'http://linked-development.org/r4d/output/173246/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-37-demobilising-guatemala',
          'http://linked-development.org/r4d/output/173249/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-34-north-african-islamism-in-the-blinding-light-of-9-11',
          'http://linked-development.org/r4d/output/173245/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-38-political-participation-and-war-in-colombia-an-analysis-of-the-2002-elections',
          'http://linked-development.org/r4d/output/173255/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-28-from-the-alliance-for-progress-to-the-plan-colombia-a-retrospective-look-at-us-aid-to-colombia',
          'http://linked-development.org/r4d/output/173254/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-29-decentralization-and-local-government-in-bolivia-an-overview-from-the-bottom-up',
          'http://linked-development.org/r4d/output/173278/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-11-social-differentiation-and-urban-governance-in-greater-soweto-a-case-study-of-post-apartheid-reconstruction',
          'http://linked-development.org/r4d/output/173279/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-10-the-people-behind-the-walls-insecurity-identity-and-gated-communities-in-johannesburg',
          'http://linked-development.org/r4d/output/173263/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-26-the-dynamics-of-achieving-power-and-reform-as-a-positive-sum-game-a-report-on-the-preliminary-ethnographic-explorations-of-the-politics-governance-nexus-in-madhya-pradesh-india',
          'http://linked-development.org/r4d/output/173262/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-27-criminal-rebels-a-discussion-of-war-and-criminality-from-the-colombian-experience',
          'http://linked-development.org/r4d/output/173275/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-14-since-i-am-a-dog-beware-my-fangs-beyond-a-rational-violence-framework-in-the-sierra-leonean-war',
          'http://linked-development.org/r4d/output/173266/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-23-emerging-pluralist-politics-in-mozambique-the-frelimo-renamo-party-system',
          'http://linked-development.org/r4d/output/173264/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-25-the-times-of-democratic-involutions',
          'http://linked-development.org/r4d/output/173273/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-16-domesticating-leviathan-sungusungu-groups-in-tanzania',
          'http://linked-development.org/r4d/output/173268/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-21-women-in-war-and-crisis-zones-one-key-to-africa-s-wars-of-underdevelopment',
          'http://linked-development.org/r4d/output/173269/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-20-mineral-resource-abundance-and-violent-political-conflict-a-critical-assessment-of-the-rentier-state-model',
          'http://linked-development.org/r4d/output/173267/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-no-22-tribal-traditions-and-crises-of-governance-in-north-east-india-with-special-reference-to-meghalaya',
          'http://linked-development.org/r4d/output/173492/' =>
            'https://gov.uk/dfid-research-outputs/fresh-insights-number-9-fair-miles-weighing-environmental-and-social-impacts-of-fresh-produce-exports-from-sub-saharan-africa-to-the-uk-summary',
          'http://linked-development.org/r4d/output/173490/' =>
            'https://gov.uk/dfid-research-outputs/fresh-perspectives-issue-1-fair-miles-the-concept-of-food-miles-through-a-sustainable-development-lens',
          'http://linked-development.org/r4d/output/173494/' =>
            'https://gov.uk/dfid-research-outputs/panos-media-toolkit-on-communicating-research-no-4-good-choice-the-right-to-sexual-and-reproductive-health',
          'http://linked-development.org/r4d/output/173653/' =>
            'https://gov.uk/dfid-research-outputs/dfid-policy-project-dfid-and-disability-a-mapping-of-the-department-for-international-development-and-disability-issues',
          'http://linked-development.org/r4d/output/174001/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-7-sending-them-a-message-culture-tax-collection-and-governance-in-south-africa',
          'http://linked-development.org/r4d/output/174007/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-1-taxation-and-the-political-agenda-north-and-south',
          'http://linked-development.org/r4d/output/174006/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-2-revenues-state-formation-and-the-quality-of-governance-in-developing-countries',
          'http://linked-development.org/r4d/output/173988/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-21-the-political-economy-of-the-resource-curse-a-literature-survey-ids-working-paper-no-268',
          'http://linked-development.org/r4d/output/173987/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-22-get-what-you-want-give-what-you-can-embedded-public-finance-in-porto-alegre-ids-working-paper-no-266',
          'http://linked-development.org/r4d/output/174002/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-6-the-power-of-politics-the-performance-of-the-south-african-revenue-service-and-some-of-its-implications',
          'http://linked-development.org/r4d/output/174004/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-4-budgets-and-ballots-in-brazil-participatory-budgeting-from-the-city-to-the-state-ids-working-paper-no-149',
          'http://linked-development.org/r4d/output/179360/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-24-ambiguous-institutions-traditional-governance-and-local-democracy-in-rural-india-ids-working-paper-no-282',
          'http://linked-development.org/r4d/output/174000/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-8-rivalry-or-synergy-formal-and-informal-local-governance-in-rural-india-ids-working-paper-no-226',
          'http://linked-development.org/r4d/output/173999/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-10-who-participates-civil-society-and-the-new-democratic-politics-in-sao-paulo-brazil-ids-working-paper-no-210',
          'http://linked-development.org/r4d/output/173989/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-20-new-democratic-trends-in-china-reforming-the-all-china-federation-of-trade-unions-ids-working-paper-no-263',
          'http://linked-development.org/r4d/output/173997/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-12-the-politics-and-bureaucratics-of-rural-public-works-maharashtra-s-employment-guarantee-scheme',
          'http://linked-development.org/r4d/output/173998/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-11-trading-democracy-johannesburg-informal-traders-and-citizenship',
          'http://linked-development.org/r4d/output/173994/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-15-toilet-wars-urban-sanitation-services-and-the-politics-of-public-private-partnerships-in-ghana-ids-working-paper-no-213',
          'http://linked-development.org/r4d/output/173990/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-19-blocked-drains-and-open-minds-multiple-accountability-relationships-and-improved-service-delivery-in-an-indian-city',
          'http://linked-development.org/r4d/output/173991/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-18-institutionalised-co-production-unorthodox-public-service-delivery-in-challenging-environments',
          'http://linked-development.org/r4d/output/173995/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-14-taxing-for-the-state-politics-revenue-and-the-informal-sector-in-ghana',
          'http://linked-development.org/r4d/output/173992/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-17-co-producing-citizen-security-the-citizen-police-liaison-committee-in-karachi-ids-working-paper-no-172',
          'http://linked-development.org/r4d/output/179359/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-23-how-does-taxation-affect-the-quality-of-governance-ids-working-paper-no-280',
          'http://linked-development.org/r4d/output/173874/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-get-what-you-want-give-what-you-can-embedded-public-finance-in-porto-alegre-ids-working-paper-no-266',
          'http://linked-development.org/r4d/output/173871/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-the-political-economy-of-the-resource-curse-a-literature-survey-ids-working-paper-no-268',
          'http://linked-development.org/r4d/output/173948/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-new-democratic-trends-in-china-reforming-the-all-china-federation-of-trade-unions-ids-working-paper-no-263',
          'http://linked-development.org/r4d/output/173966/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-co-producing-public-services-blocked-drains-and-open-minds-multiple-accountability-relationships-and-improved-service-delivery-performance-in-an-indian-city-ids-working-paper-no-211',
          'http://linked-development.org/r4d/output/173967/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-co-producing-public-services-institutionalised-co-production-unorthodox-public-service-delivery-in-challenging-environments',
          'http://linked-development.org/r4d/output/173970/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-co-producing-public-services-co-producing-citizen-security-the-citizen-police-liaison-committee-in-karachi-ids-working-paper-no-172',
          'http://linked-development.org/r4d/output/173965/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-co-producing-public-services-toilet-wars-urban-sanitation-services-and-the-politics-of-public-private-partnerships-in-ghana-ids-working-paper-no-213',
          'http://linked-development.org/r4d/output/173968/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-co-producing-public-services-taxing-for-the-state-politics-revenue-and-the-informal-sector-in-ghana',
          'http://linked-development.org/r4d/output/173959/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-the-politics-and-bureaucratics-of-rural-public-works-maharashtra-s-employment-guarantee-scheme',
          'http://linked-development.org/r4d/output/173964/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-trading-democracy-johannesburg-informal-traders-and-citizenship',
          'http://linked-development.org/r4d/output/173942/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-who-participates-civil-society-and-the-new-democratic-politics-in-sao-paulo-brazil-ids-working-paper-no-210',
          'http://linked-development.org/r4d/output/173881/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-rivalry-or-synergy-formal-and-informal-local-governance-in-rural-india-ids-working-paper-no-226',
          'http://linked-development.org/r4d/output/173864/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-sending-them-a-message-culture-tax-collection-and-governance-in-south-africa',
          'http://linked-development.org/r4d/output/173876/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-the-power-of-politics-the-performance-of-the-south-african-revenue-service-and-some-of-its-implications',
          'http://linked-development.org/r4d/output/50134/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-governance-taxes-and-tax-reform-in-latin-america-ids-working-paper-no-221',
          'http://linked-development.org/r4d/output/173877/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-budgets-and-ballots-in-brazil-participatory-budgeting-from-the-city-to-the-state-ids-working-paper-no-149',
          'http://linked-development.org/r4d/output/50121/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-taxation-governance-and-poverty-where-do-the-middle-income-countries-fit-ids-working-paper-no-230',
          'http://linked-development.org/r4d/output/173865/' =>
            'https://gov.uk/dfid-research-outputs/programme-1-financing-the-state-taxation-and-the-political-agenda-north-and-south',
          'http://linked-development.org/r4d/output/174147/' =>
            'https://gov.uk/dfid-research-outputs/creando-espacios-cambiando-lugares-posicionando-la-participacion-en-el-desarrollo',
          'http://linked-development.org/r4d/output/174128/' =>
            'https://gov.uk/dfid-research-outputs/making-spaces-changing-places-situating-participation-in-development',
          'http://linked-development.org/r4d/output/174286/' =>
            'https://gov.uk/dfid-research-outputs/building-effective-states-taking-a-citizens-perspective',
          'http://linked-development.org/r4d/output/120015/' =>
            'https://gov.uk/dfid-research-outputs/going-beyond-research',
          'http://linked-development.org/r4d/output/179658/' =>
            'https://gov.uk/dfid-research-outputs/artemether-lumefantrine-four-dose-regimen-for-treating-uncomplicated-falciparum-malaria',
          'http://linked-development.org/r4d/output/179659/' =>
            'https://gov.uk/dfid-research-outputs/artemether-lumefantrine-six-dose-regimen-for-treating-uncomplicated-falciparum-malaria',
          'http://linked-development.org/r4d/output/174005/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-3-taxation-governance-and-poverty-where-do-the-middle-income-countries-fit-ids-working-paper-no-230',
          'http://linked-development.org/r4d/output/174003/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-5-governance-taxes-and-tax-reform-in-latin-america-ids-working-paper-no-221',
          'http://linked-development.org/r4d/output/55505/' =>
            'https://gov.uk/dfid-research-outputs/rural-transport-services-project-golden-milestone-workshop-report-part-2',
          'http://linked-development.org/r4d/output/55496/' =>
            'https://gov.uk/dfid-research-outputs/situational-analysis-and-resource-mapping-of-rural-transport-services-project-localities-part-2',
          'http://linked-development.org/r4d/output/55150/' =>
            'https://gov.uk/dfid-research-outputs/situational-analysis-and-resource-mapping-of-rural-transport-services-project-localities-part-1',
          'http://linked-development.org/r4d/output/55149/' =>
            'https://gov.uk/dfid-research-outputs/rural-transport-services-project-golden-milestone-workshop-report-part-1',
          'http://linked-development.org/r4d/output/64310/' =>
            'https://gov.uk/dfid-research-outputs/evaluation-of-strategies-for-tracking-climatic-variation-in-semi-arid-grazing-systems',
          'http://linked-development.org/r4d/output/63603/' =>
            'https://gov.uk/dfid-research-outputs/corrigendum-evaluation-of-strategies-for-tracking-climatic-variation-in-semi-arid-grazing-systems',
          'http://linked-development.org/r4d/output/174874/' =>
            'https://gov.uk/dfid-research-outputs/report-on-reading-in-english-in-primary-schools-in-malawi',
          'http://linked-development.org/r4d/output/174870/' =>
            'https://gov.uk/dfid-research-outputs/report-on-reading-in-english-in-primary-schools-in-zambia',
          'http://linked-development.org/r4d/output/174631/' =>
            'https://gov.uk/dfid-research-outputs/common-ground-investigating-the-importance-of-managing-land-a-literature-review-of-development-research-on-land-management-issues',
          'http://linked-development.org/r4d/output/174630/' =>
            'https://gov.uk/dfid-research-outputs/panos-media-toolkit-on-communicating-research-no-1-common-ground-investigating-the-importance-of-managing-land',
          'http://linked-development.org/r4d/output/174829/' =>
            'https://gov.uk/dfid-research-outputs/governance-of-water-and-sanitation-services-for-the-peri-urban-poor-a-framework-for-understanding-and-action-in-metropolitan-regions-leaflet',
          'http://linked-development.org/r4d/output/174827/' =>
            'https://gov.uk/dfid-research-outputs/so-close-to-the-city-so-far-from-the-pipes-the-governance-of-waterandsanitation-and-the-peri-urban-poor',
          'http://linked-development.org/r4d/output/174873/' =>
            'https://gov.uk/dfid-research-outputs/fresh-insights-number-6-impact-of-eurepgap-on-small-scale-vegetable-growers-in-kenya',
          'http://linked-development.org/r4d/output/174872/' =>
            'https://gov.uk/dfid-research-outputs/fresh-insights-number-5-impact-of-eurepgap-on-small-scale-vegetable-growers-in-zambia',
          'http://linked-development.org/r4d/output/174869/' =>
            'https://gov.uk/dfid-research-outputs/fresh-insights-number-3-virtual-water-trade-a-case-study-of-green-beans-and-flowers-from-africa',
          'http://linked-development.org/r4d/output/174850/' =>
            'https://gov.uk/dfid-research-outputs/fresh-perspectives-issue-5-african-air-freight-of-fresh-produce-is-transport-of-virtual-water-causing-drought',
          'http://linked-development.org/r4d/output/174471/' =>
            'https://gov.uk/dfid-research-outputs/investigating-bilingual-literacy-evidence-from-malawi-and-zambia',
          'http://linked-development.org/r4d/output/174847/' =>
            'https://gov.uk/dfid-research-outputs/fresh-perspectives-issue-3-impact-of-eurepgap-on-small-scale-vegetable-growers-in-zambia',
          'http://linked-development.org/r4d/output/174845/' =>
            'https://gov.uk/dfid-research-outputs/fresh-perspectives-issue-2-impact-of-eurepgap-on-small-scale-vegetable-growers-in-kenya',
          'http://linked-development.org/r4d/output/174693/' =>
            'https://gov.uk/dfid-research-outputs/rethinking-the-traditional-concept-of-livestock-services-a-study-of-response-capacity-in-thailand-malaysia-and-vietnam',
          'http://linked-development.org/r4d/output/174699/' =>
            'https://gov.uk/dfid-research-outputs/comparable-costings-of-alternatives-for-dealing-with-tsetse-estimates-for-uganda',
          'http://linked-development.org/r4d/output/174704/' =>
            'https://gov.uk/dfid-research-outputs/dairy-development-programs-in-andhra-pradesh-india-impacts-and-risks-for-small-scale-dairy-farms',
          'http://linked-development.org/r4d/output/174707/' =>
            'https://gov.uk/dfid-research-outputs/policies-and-strategies-to-address-the-vulnerability-of-pastoralists-in-sub-saharan-africa',
          'http://linked-development.org/r4d/output/174712/' =>
            'https://gov.uk/dfid-research-outputs/the-politics-of-livestock-sector-policy-and-the-rural-poor-in-peru-174712',
          'http://linked-development.org/r4d/output/174787/' =>
            'https://gov.uk/dfid-research-outputs/livestock-liberalization-and-democracy-constraints-and-opportunities-for-rural-livestock-producers-in-a-reforming-uganda',
          'http://linked-development.org/r4d/output/174790/' =>
            'https://gov.uk/dfid-research-outputs/navigating-the-livestock-sector-the-political-economy-of-livestock-policy-in-burkina-faso-174790',
          'http://linked-development.org/r4d/output/174801/' =>
            'https://gov.uk/dfid-research-outputs/livestock-policies-for-poverty-alleviation-theory-and-practical-evidence-from-africa-asia-and-latin-america',
          'http://linked-development.org/r4d/output/174803/' =>
            'https://gov.uk/dfid-research-outputs/the-political-economy-of-pro-poor-livestock-policy-in-cambodia-174803',
          'http://linked-development.org/r4d/output/175024/' =>
            'https://gov.uk/dfid-research-outputs/globalisation-education-and-development-ideas-actors-and-dynamics-researching-the-issues-68',
          'http://linked-development.org/r4d/output/175023/' =>
            'https://gov.uk/dfid-research-outputs/education-and-development-in-a-global-era-strategies-for-successful-globalisation-researching-the-issues-69',
          'http://linked-development.org/r4d/output/174805/' =>
            'https://gov.uk/dfid-research-outputs/international-rules-food-safety-and-the-poor-developing-country-livestock-producer',
          'http://linked-development.org/r4d/output/174949/' =>
            'https://gov.uk/dfid-research-outputs/a-review-of-milk-production-in-india-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174948/' =>
            'https://gov.uk/dfid-research-outputs/a-review-of-milk-production-in-pakistan-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174922/' =>
            'https://gov.uk/dfid-research-outputs/a-review-of-milk-production-in-bangladesh-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174825/' =>
            'https://gov.uk/dfid-research-outputs/the-economics-of-milk-production-in-orissa-india-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174821/' =>
            'https://gov.uk/dfid-research-outputs/eu-policy-making-reform-of-the-cap-and-eu-trade-in-beefanddairy-with-developing-countries',
          'http://linked-development.org/r4d/output/174824/' =>
            'https://gov.uk/dfid-research-outputs/funding-animal-healthcare-systems-mechanisms-and-options',
          'http://linked-development.org/r4d/output/174854/' =>
            'https://gov.uk/dfid-research-outputs/the-politics-of-livestock-sector-policy-and-the-rural-poor-in-bolivia-174854',
          'http://linked-development.org/r4d/output/174862/' =>
            'https://gov.uk/dfid-research-outputs/the-political-economy-of-international-development-and-pro-poor-livestock-policies-a-comparative-assessment-174862',
          'http://linked-development.org/r4d/output/174863/' =>
            'https://gov.uk/dfid-research-outputs/a-public-choice-approach-to-the-economic-analysis-of-animal-healthcare-systems',
          'http://linked-development.org/r4d/output/174913/' =>
            'https://gov.uk/dfid-research-outputs/the-role-of-livestock-in-economic-development-and-poverty-reduction',
          'http://linked-development.org/r4d/output/174914/' =>
            'https://gov.uk/dfid-research-outputs/livestock-production-and-the-rural-poor-in-andhra-pradesh-and-orissa-states-india',
          'http://linked-development.org/r4d/output/174919/' =>
            'https://gov.uk/dfid-research-outputs/trade-political-influence-and-liberalization-situating-the-poor-in-the-political-economy-of-livestock-in-senegal',
          'http://linked-development.org/r4d/output/174925/' =>
            'https://gov.uk/dfid-research-outputs/the-political-economy-of-pro-poor-livestock-policy-making-in-vietnam',
          'http://linked-development.org/r4d/output/174951/' =>
            'https://gov.uk/dfid-research-outputs/a-study-of-the-role-of-livestock-in-poverty-reduction-strategy-papers-prsps',
          'http://linked-development.org/r4d/output/175339/' =>
            'https://gov.uk/dfid-research-outputs/livestock-and-livelihoods-development-goals-and-indicators-applied-to-senegal',
          'http://linked-development.org/r4d/output/175313/' =>
            'https://gov.uk/dfid-research-outputs/promoting-livestock-service-reform-in-andhra-pradesh',
          'http://linked-development.org/r4d/output/175314/' =>
            'https://gov.uk/dfid-research-outputs/assessment-and-reflections-on-livestock-service-delivery-in-andhra-pradesh-a-synthesis',
          'http://linked-development.org/r4d/output/175326/' =>
            'https://gov.uk/dfid-research-outputs/livestock-service-delivery-in-andhra-pradesh-veterinarians-perspective',
          'http://linked-development.org/r4d/output/175315/' =>
            'https://gov.uk/dfid-research-outputs/minor-veterinary-services-in-andhra-pradesh-stakeholder-consultations-and-expert-group-deliberations',
          'http://linked-development.org/r4d/output/174817/' =>
            'https://gov.uk/dfid-research-outputs/the-contribution-of-livestock-to-household-income-in-vietnam-a-household-typology-based-analysis',
          'http://linked-development.org/r4d/output/174808/' =>
            'https://gov.uk/dfid-research-outputs/geographical-dimensions-of-livestock-holdings-in-vietnam-spatial-relationships-among-poverty-infrastructure-and-the-environment',
          'http://linked-development.org/r4d/output/175176/' =>
            'https://gov.uk/dfid-research-outputs/evidence-based-policy-for-controlling-hpai-in-poultry-bio-security-revisited',
          'http://linked-development.org/r4d/output/174818/' =>
            'https://gov.uk/dfid-research-outputs/the-economics-of-milk-production-in-chiang-mai-thailand-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174711/' =>
            'https://gov.uk/dfid-research-outputs/the-economics-of-milk-production-in-hanoi-vietnam-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174710/' =>
            'https://gov.uk/dfid-research-outputs/the-economics-of-milk-production-in-cajamarca-peru-with-particular-emphasis-on-small-scale-producers',
          'http://linked-development.org/r4d/output/174924/' =>
            'https://gov.uk/dfid-research-outputs/the-review-of-household-poultry-production-as-a-tool-in-poverty-reduction-with-focus-on-bangladesh-and-india',
          'http://linked-development.org/r4d/output/174708/' =>
            'https://gov.uk/dfid-research-outputs/poverty-mapping-in-uganda-an-analysis-using-remotely-sensed-and-other-environmental-data',
          'http://linked-development.org/r4d/output/176031/' =>
            'https://gov.uk/dfid-research-outputs/puesto-para-plantas-in-nicaragua-a-clinic-where-you-can-bring-your-sick-plants',
          'http://linked-development.org/r4d/output/176030/' =>
            'https://gov.uk/dfid-research-outputs/puesto-para-plantas-una-clinica-donde-usted-puede-traer-sus-plantas-enfermas',
          'http://linked-development.org/r4d/output/176177/' =>
            'https://gov.uk/dfid-research-outputs/bridging-research-and-policy-on-education-training-and-their-enabling-environments',
          'http://linked-development.org/r4d/output/181842/' =>
            'https://gov.uk/dfid-research-outputs/impact-of-acyclovir-on-genital-and-plasma-hiv-1-rna-genital-herpes-simplex-virus-type-2-dna-and-ulcer-healing-among-hiv-1-infected-african-women-with-herpes-ulcers-a-randomized-placebo-controlled-trial',
          'http://linked-development.org/r4d/output/122685/' =>
            'https://gov.uk/dfid-research-outputs/participatory-research-approaches-what-have-we-learned-the-experience-of-the-dfid-renewable-natural-resources-research-strategy-rnrrs-programme-1995-2005',
          'http://linked-development.org/r4d/output/176983/' =>
            'https://gov.uk/dfid-research-outputs/synthesis-studies-of-the-renewable-natural-resources-research-strategy-capacity-development',
          'http://linked-development.org/r4d/output/176978/' =>
            'https://gov.uk/dfid-research-outputs/a-synthesis-of-monitoring-and-evaluation-experience-in-the-renewable-natural-resources-research-strategy-rnrrs',
          'http://linked-development.org/r4d/output/176954/' =>
            'https://gov.uk/dfid-research-outputs/effective-policy-advocacy-an-rnrrs-synthesis',
          'http://linked-development.org/r4d/output/176979/' =>
            'https://gov.uk/dfid-research-outputs/innovations-systems-concepts-approaches-and-lessons-from-rnrrs-rnrrs-synthesis-study-no-10',
          'http://linked-development.org/r4d/output/176982/' =>
            'https://gov.uk/dfid-research-outputs/gender-and-the-dfid-rnrrs-a-synthesis',
          'http://linked-development.org/r4d/output/176955/' =>
            'https://gov.uk/dfid-research-outputs/poverty-mapping-and-analysis-an-rnrrs-synthesis',
          'http://linked-development.org/r4d/output/179362/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-26-a-thoroughly-modern-resource-curse-the-new-natural-resource-policy-agenda-and-the-mining-revival-in-peru-ids-working-paper-no-300',
          'http://linked-development.org/r4d/output/179361/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-25-the-vulnerability-of-self-help-women-and-micro-finance-in-south-india-ids-working-paper-no-303',
          'http://linked-development.org/r4d/output/180360/' =>
            'https://gov.uk/dfid-research-outputs/pregnancy-related-school-dropout-and-prior-school-performance-in-kwazulu-natal-south-africa',
          'http://linked-development.org/r4d/output/177414/' =>
            'https://gov.uk/dfid-research-outputs/the-role-of-environment-in-increasing-growth-and-reducing-poverty-in-uganda-summary-report-final',
          'http://linked-development.org/r4d/output/177407/' =>
            'https://gov.uk/dfid-research-outputs/the-role-of-environment-in-increasing-growth-and-reducing-poverty-in-uganda-technical-report-final-draft',
          'http://linked-development.org/r4d/output/176164/' =>
            'https://gov.uk/dfid-research-outputs/baits-and-lures-get-the-upper-hand-on-fruit-flies-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176179/' =>
            'https://gov.uk/dfid-research-outputs/clean-gene-technology-has-promise-for-safe-genetically-modified-crops-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176318/' =>
            'https://gov.uk/dfid-research-outputs/opening-the-doors-to-markets-and-credit-for-poor-fishers-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176238/' =>
            'https://gov.uk/dfid-research-outputs/opportunities-in-sustainable-coastal-aquaculture-for-the-very-poor-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176178/' =>
            'https://gov.uk/dfid-research-outputs/safe-biological-pesticides-for-india-and-south-asia-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176338/' =>
            'https://gov.uk/dfid-research-outputs/you-name-it-cassava-can-do-it-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176077/' =>
            'https://gov.uk/dfid-research-outputs/pheromone-traps-help-save-cowpea-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176453/' =>
            'https://gov.uk/dfid-research-outputs/tackling-fish-losses-along-the-marketing-chain-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176081/' =>
            'https://gov.uk/dfid-research-outputs/transgenic-banana-could-feed-millions-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176123/' =>
            'https://gov.uk/dfid-research-outputs/videos-help-cocoa-farmers-see-the-big-picture-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176192/' =>
            'https://gov.uk/dfid-research-outputs/a-cheaper-tsetse-control-method-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176383/' =>
            'https://gov.uk/dfid-research-outputs/database-provides-link-between-rural-groups-and-policy-makers-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176217/' =>
            'https://gov.uk/dfid-research-outputs/double-the-benefits-using-legumes-to-boost-both-milk-and-rice-production-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/176064/' =>
            'https://gov.uk/dfid-research-outputs/oiling-the-wheels-of-groundnut-production-validated-rnrrs-output',
          'http://linked-development.org/r4d/output/179363/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-27-idealism-realism-and-the-investment-climate-in-developing-countries-ids-working-paper-no-307',
          'http://linked-development.org/r4d/output/179365/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-31-where-are-pockets-of-effective-agencies-likely-in-weak-governance-states-and-why-a-propositional-inventory-ids-working-paper-306',
          'http://linked-development.org/r4d/output/179364/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-28-aid-rents-and-the-politics-of-the-budget-process-ids-working-paper-no-311',
          'http://linked-development.org/r4d/output/180486/' =>
            'https://gov.uk/dfid-research-outputs/provincial-tb-control-programme-punjab-guidelines-and-tools-for-facility-level-monitoring-event',
          'http://linked-development.org/r4d/output/178196/' =>
            'https://gov.uk/dfid-research-outputs/optimising-internet-bandwidth-in-developing-country-higher-education',
          'http://linked-development.org/r4d/output/178195/' =>
            'https://gov.uk/dfid-research-outputs/infobrief-1-optimising-internet-bandwidth-in-developing-country-higher-education',
          'http://linked-development.org/r4d/output/178375/' =>
            'https://gov.uk/dfid-research-outputs/guidelines-for-conducting-ipm-clinical-trials-2nd-edition',
          'http://linked-development.org/r4d/output/178289/' =>
            'https://gov.uk/dfid-research-outputs/one-world-one-health-learning-from-the-international-response-to-avian-influenza',
          'http://linked-development.org/r4d/output/178288/' =>
            'https://gov.uk/dfid-research-outputs/the-international-response-to-highly-pathogenic-avian-influenza-science-policy-and-politics',
          'http://linked-development.org/r4d/output/186367/' =>
            'https://gov.uk/dfid-research-outputs/microbicide-overview-186367',
          'http://linked-development.org/r4d/output/178595/' =>
            'https://gov.uk/dfid-research-outputs/a-risky-business-saving-money-and-improving-global-health-through-better-demand-forecasts',
          'http://linked-development.org/r4d/output/174227/' =>
            'https://gov.uk/dfid-research-outputs/understanding-and-explaining-chronic-poverty-an-evolving-framework-for-phase-iii-of-cprc-s-research-cprc-working-paper-no-80',
          'http://linked-development.org/r4d/output/176003/' =>
            'https://gov.uk/dfid-research-outputs/the-intergenerational-transmission-of-poverty-an-overview',
          'http://linked-development.org/r4d/output/178171/' =>
            'https://gov.uk/dfid-research-outputs/issue-brief-ipm-clinical-trials-178171',
          'http://linked-development.org/r4d/output/179596/' =>
            'https://gov.uk/dfid-research-outputs/supply-chain-and-price-components-of-antimalarial-medicines-uganda-2007',
          'http://linked-development.org/r4d/output/179367/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-33-re-creating-political-order-the-somali-systems-today-ids-working-paper-316',
          'http://linked-development.org/r4d/output/179366/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-32-an-african-success-story-ghana-s-cocoa-marketing-system-ids-working-paper-no-318',
          'http://linked-development.org/r4d/output/173976/' =>
            'https://gov.uk/dfid-research-outputs/programme-3-state-capacity-how-does-taxation-affect-the-quality-of-governance-ids-working-paper-no-280',
          'http://linked-development.org/r4d/output/173879/' =>
            'https://gov.uk/dfid-research-outputs/programme-2-mobilising-public-action-ambiguous-institutions-traditional-governance-and-local-democracy-in-rural-india-ids-working-paper-no-282',
          'http://linked-development.org/r4d/output/177079/' =>
            'https://gov.uk/dfid-research-outputs/the-vulnerability-of-self-help-women-and-microfinance-in-south-india',
          'http://linked-development.org/r4d/output/177078/' =>
            'https://gov.uk/dfid-research-outputs/a-thoroughly-modern-resource-curse-the-new-natural-resource-policy-agenda-and-the-mining-revival-in-peru',
          'http://linked-development.org/r4d/output/177857/' =>
            'https://gov.uk/dfid-research-outputs/idealism-realism-and-the-investment-climate-in-developing-countries',
          'http://linked-development.org/r4d/output/177859/' =>
            'https://gov.uk/dfid-research-outputs/aid-rents-and-the-politics-of-the-budget-process',
          'http://linked-development.org/r4d/output/177858/' =>
            'https://gov.uk/dfid-research-outputs/where-are-pockets-of-effective-agencies-likely-in-weak-governance-states-and-why-a-propositional-inventory',
          'http://linked-development.org/r4d/output/179357/' =>
            'https://gov.uk/dfid-research-outputs/an-african-success-story-ghana-s-cocoa-marketing-system',
          'http://linked-development.org/r4d/output/179356/' =>
            'https://gov.uk/dfid-research-outputs/recreating-political-order-the-somali-systems-today',
          'http://linked-development.org/r4d/output/180003/' =>
            'https://gov.uk/dfid-research-outputs/comparative-assessment-of-technologies-for-extraction-of-artemisinin',
          'http://linked-development.org/r4d/output/189694/' =>
            'https://gov.uk/dfid-research-outputs/pro-poor-growth-in-the-context-of-the-global-financial-crisis-a-selective-overview',
          'http://linked-development.org/r4d/output/189426/' =>
            'https://gov.uk/dfid-research-outputs/gendered-impacts-of-globalization-employment-and-social-protection-189426',
          'http://linked-development.org/r4d/output/188240/' =>
            'https://gov.uk/dfid-research-outputs/appp-background-paper-4-malawi-s-political-settlement-in-crisis-2011',
          'http://linked-development.org/r4d/output/190559/' =>
            'https://gov.uk/dfid-research-outputs/methods-manual-for-fieldwork',
          'http://linked-development.org/r4d/output/190562/' =>
            'https://gov.uk/dfid-research-outputs/livelihoods-and-rural-poverty-reduction-in-uganda',
          'http://linked-development.org/r4d/output/190568/' =>
            'https://gov.uk/dfid-research-outputs/livelihoods-and-rural-poverty-reduction-in-tanzania',
          'http://linked-development.org/r4d/output/190574/' =>
            'https://gov.uk/dfid-research-outputs/livelihoods-and-rural-poverty-reduction-in-malawi',
          'http://linked-development.org/r4d/output/190612/' =>
            'https://gov.uk/dfid-research-outputs/drussa-digital-engagement-strategy',
          'http://linked-development.org/r4d/output/190543/' =>
            'https://gov.uk/dfid-research-outputs/emissions-mitigation-and-low-carbon-growth-the-case-of-mozambique-agriculture',
          'http://linked-development.org/r4d/output/190593/' =>
            'https://gov.uk/dfid-research-outputs/a-brief-overview-of-the-strategic-processes-worked-through-in-devising-a-digital-engagement-strategy-for-the-drussa-programme',
          'http://linked-development.org/r4d/output/190009/' =>
            'https://gov.uk/dfid-research-outputs/child-development-and-economic-development-lessons-and-future-challenges-190009',
          'http://linked-development.org/r4d/output/191117/' =>
            'https://gov.uk/dfid-research-outputs/new-forms-of-religious-transnationalism-and-development-initiatives-a-case-study-of-dera-sant-sarwan-dass-ballan-punjab-india',
          'http://linked-development.org/r4d/output/189575/' =>
            'https://gov.uk/dfid-research-outputs/dfid-working-paper-38-broadening-the-range-of-designs-and-methods-for-impact-evaluations',
          'http://linked-development.org/r4d/output/192180/' =>
            'https://gov.uk/dfid-research-outputs/baseline-findings-comparing-first-and-second-tier-cphhs-of-cohort-2-2',
          'http://linked-development.org/r4d/output/192182/' =>
            'https://gov.uk/dfid-research-outputs/an-assessment-of-potential-numbers-of-cphhs-living-on-island-chars-in-chapai-nawabganj-rajshahi-and-natore',
          'http://linked-development.org/r4d/output/192217/' =>
            'https://gov.uk/dfid-research-outputs/socio-economic-characteristics-and-nutritional-status-of-households-recruited-in-clp2-1-report-of-the-baseline-survey-conducted-in-april-2010',
          'http://linked-development.org/r4d/output/192220/' =>
            'https://gov.uk/dfid-research-outputs/empowerment-baseline-survey-2010-clp2-1',
          'http://linked-development.org/r4d/output/182721/' =>
            'https://gov.uk/dfid-research-outputs/children-transport-and-mobility-sharing-experiences-of-young-researchers-in-ghana-malawi-and-south-africa',
          'http://linked-development.org/r4d/output/193608/' =>
            'https://gov.uk/dfid-research-outputs/biofuels-scoping-review',
          'http://linked-development.org/r4d/output/193606/' =>
            'https://gov.uk/dfid-research-outputs/final-report-biofuels-scoping-review',
          'http://linked-development.org/r4d/output/193647/' =>
            'https://gov.uk/dfid-research-outputs/indus-floods-research-project-result-from-the-field',
          'http://linked-development.org/r4d/output/193611/' =>
            'https://gov.uk/dfid-research-outputs/a-simple-human-vulnerability-index-to-climate-change-hazards-for-pakistan',
          'http://linked-development.org/r4d/output/193648/' =>
            'https://gov.uk/dfid-research-outputs/case-study-exploring-demographic-dimensions-of-flood-vulnerability-in-rural-charsadda-pakistan',
          'http://linked-development.org/r4d/output/193650/' =>
            'https://gov.uk/dfid-research-outputs/desk-study-indus-floods-research-project',
          'http://linked-development.org/r4d/output/193610/' =>
            'https://gov.uk/dfid-research-outputs/indus-floods-research-project-final-technical-report',
          'http://linked-development.org/r4d/output/193490/' =>
            'https://gov.uk/dfid-research-outputs/local-understandings-and-experiences-of-transitional-justice-a-review-of-the-evidence',
          'http://linked-development.org/r4d/output/192555/' =>
            'https://gov.uk/dfid-research-outputs/fiscal-space-for-health-a-review-of-the-literature',
          'http://linked-development.org/r4d/output/193090/' =>
            'https://gov.uk/dfid-research-outputs/providing-financial-protection-and-funding-health-service-benefits-for-the-informal-sector-evidence-from-sub-saharan-africa',
          'http://linked-development.org/r4d/output/194060/' =>
            'https://gov.uk/dfid-research-outputs/leaping-and-learning-case-studies',
          'http://linked-development.org/r4d/output/194059/' =>
            'https://gov.uk/dfid-research-outputs/leaping-and-learning-linking-smallholders-to-markets-in-africa',
          'http://linked-development.org/r4d/output/193456/' =>
            'https://gov.uk/dfid-research-outputs/taxation-and-livelihoods-a-review-of-the-evidence-from-fragile-and-conflict-affected-rural-areas-ictd-working-paper-11',
          'http://linked-development.org/r4d/output/194265/' =>
            'https://gov.uk/dfid-research-outputs/how-do-political-debate-programmes-influence-political-participation-a-case-study-from-nepal-research-report-issue-1',
          'http://linked-development.org/r4d/output/194264/' =>
            'https://gov.uk/dfid-research-outputs/how-do-political-debate-programmes-influence-political-participation-a-case-study-from-nepal-research-briefing-issue-1',
          'http://linked-development.org/r4d/output/194295/' =>
            'https://gov.uk/dfid-research-outputs/social-media-and-civic-participation-literature-review-and-empirical-evidence-from-bangladesh-and-palestinian-territories',
          'http://linked-development.org/r4d/output/194294/' =>
            'https://gov.uk/dfid-research-outputs/what-value-does-social-media-add-to-governance-programmes-research-briefing-issue-2',
          'http://linked-development.org/r4d/output/184773/' =>
            'https://gov.uk/dfid-research-outputs/nutritional-status-of-children-in-india-household-socio-economic-condition-as-the-contextual-determinant-184773',
          'http://linked-development.org/r4d/output/184634/' =>
            'https://gov.uk/dfid-research-outputs/religious-mobilizations-for-development-and-social-change-a-comparative-study-of-dalit-movements-in-punjab-and-maharashtra-india',
          'http://linked-development.org/r4d/output/183795/' =>
            'https://gov.uk/dfid-research-outputs/allowing-for-diversity-state-madrasa-relations-in-bangladesh',
          'http://linked-development.org/r4d/output/184837/' =>
            'https://gov.uk/dfid-research-outputs/the-impact-of-policies-institutions-and-processes-in-urban-up-grading',
          'http://linked-development.org/r4d/output/184855/' =>
            'https://gov.uk/dfid-research-outputs/the-development-activities-values-and-performance-of-non-governmental-and-faith-based-organizations-in-magu-and-newala-districts-tanzania',
          'http://linked-development.org/r4d/output/185481/' =>
            'https://gov.uk/dfid-research-outputs/managing-distance-poverty-and-rural-telecommunications-access-and-use-in-the-eastern-cape-south-africa-information-society-research-group-working-paper-1',
          'http://linked-development.org/r4d/output/185402/' =>
            'https://gov.uk/dfid-research-outputs/migration-return-and-socio-economic-change-in-west-africa-the-role-of-family-185402',
          'http://linked-development.org/r4d/output/184881/' =>
            'https://gov.uk/dfid-research-outputs/access-to-and-exclusion-from-primary-education-in-slums-of-dhaka-bangladesh',
          'http://linked-development.org/r4d/output/185049/' =>
            'https://gov.uk/dfid-research-outputs/improving-the-impact-of-development-research-through-better-research-communications-and-uptake-background-paper-for-the-ausaid-dfid-and-ukcds-funded-workshop-london-november-29th-and-30th-2010',
          'http://linked-development.org/r4d/output/181758/' =>
            'https://gov.uk/dfid-research-outputs/are-consumers-willing-to-pay-more-for-biofortified-foods-evidence-from-a-field-experiment-in-uganda',
          'http://linked-development.org/r4d/output/186640/' =>
            'https://gov.uk/dfid-research-outputs/gender-education-and-equality-in-a-global-context-conceptual-frameworks-and-policy-perspectives',
          'http://linked-development.org/r4d/output/179312/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-38-the-formation-and-evolution-of-childhood-skill-acquisition-evidence-from-india',
          'http://linked-development.org/r4d/output/187416/' =>
            'https://gov.uk/dfid-research-outputs/ethical-challenges-in-cluster-randomized-controlled-trials-experiences-from-public-health-interventions-in-africa-and-asia',
          'http://linked-development.org/r4d/output/187971/' =>
            'https://gov.uk/dfid-research-outputs/the-role-and-performance-of-ministry-of-agriculture-in-nyeri-south-district',
          'http://linked-development.org/r4d/output/185572/' =>
            'https://gov.uk/dfid-research-outputs/the-role-of-faith-in-the-charity-and-development-sector-in-karachi-and-sindh-pakistan',
          'http://linked-development.org/r4d/output/186140/' =>
            'https://gov.uk/dfid-research-outputs/the-people-know-they-need-religion-in-order-to-develop-the-relationships-between-hindu-and-buddhist-religious-teachings-values-and-beliefs-and-visions-of-the-future-in-pune-india',
          'http://linked-development.org/r4d/output/186142/' =>
            'https://gov.uk/dfid-research-outputs/religions-ethics-and-attitudes-towards-corruption-a-study-of-perspectives-in-india',
          'http://linked-development.org/r4d/output/186143/' =>
            'https://gov.uk/dfid-research-outputs/religion-development-and-wellbeing-in-india',
          'http://linked-development.org/r4d/output/188062/' =>
            'https://gov.uk/dfid-research-outputs/religion-politics-and-governance-in-india-pakistan-nigeria-and-tanzania-an-overview-research-summary-55',
          'http://linked-development.org/r4d/output/186253/' =>
            'https://gov.uk/dfid-research-outputs/comparing-religious-and-secular-ngos-in-nigeria-are-faith-based-organizations-distinctive',
          'http://linked-development.org/r4d/output/186255/' =>
            'https://gov.uk/dfid-research-outputs/the-women-s-land-rights-movement-customary-law-and-religion-in-tanzania',
          'http://linked-development.org/r4d/output/186254/' =>
            'https://gov.uk/dfid-research-outputs/mapping-the-development-activities-of-faith-based-organizations-in-tanzania',
          'http://linked-development.org/r4d/output/186530/' =>
            'https://gov.uk/dfid-research-outputs/the-role-of-religion-in-women-s-movements-the-campaign-for-domestication-of-cedaw-in-nigeria',
          'http://linked-development.org/r4d/output/186531/' =>
            'https://gov.uk/dfid-research-outputs/engagements-of-women-s-movements-with-religion-legal-reform-in-anambra-state-nigeria',
          'http://linked-development.org/r4d/output/186256/' =>
            'https://gov.uk/dfid-research-outputs/strengthening-the-voice-of-the-poor-faith-based-organizations-engagement-in-policy-consultation-processes-in-nigeria-and-tanzania',
          'http://linked-development.org/r4d/output/186532/' =>
            'https://gov.uk/dfid-research-outputs/interactions-between-religion-and-development-in-india-values-organizations-and-social-movements',
          'http://linked-development.org/r4d/output/186533/' =>
            'https://gov.uk/dfid-research-outputs/religious-organizations-values-and-rivalry-in-nigeria-exploring-the-implications-for-development-and-politics',
          'http://linked-development.org/r4d/output/179970/' =>
            'https://gov.uk/dfid-research-outputs/development-of-hplc-analytical-protocols-for-quantification-of-artemisinin-in-biomass-and-extracts',
          'http://linked-development.org/r4d/output/188928/' =>
            'https://gov.uk/dfid-research-outputs/social-safety-nets-and-the-extreme-poor-learning-from-a-participatory-pro-poor-governance-approach-shiree-working-paper-no-2',
          'http://linked-development.org/r4d/output/188929/' =>
            'https://gov.uk/dfid-research-outputs/eviction-and-the-challenges-of-protecting-the-gains-a-case-study-of-slum-dwellers-in-dhaka-city-shiree-working-paper-no-3',
          'http://linked-development.org/r4d/output/188930/' =>
            'https://gov.uk/dfid-research-outputs/extreme-poor-adivasis-and-the-problem-of-accessing-social-safety-nets-shiree-working-paper-no-4',
          'http://linked-development.org/r4d/output/188931/' =>
            'https://gov.uk/dfid-research-outputs/vulnerabilities-and-resilience-among-extreme-poor-people-the-south-west-coastal-region-of-bangladesh-shiree-working-paper-no-5',
          'http://linked-development.org/r4d/output/188932/' =>
            'https://gov.uk/dfid-research-outputs/making-productive-use-of-khas-land-experiences-of-extreme-poor-households-shiree-working-paper-no-6',
          'http://linked-development.org/r4d/output/190137/' =>
            'https://gov.uk/dfid-research-outputs/gendered-impacts-of-globalization-employment-and-social-protection-dfid-policy-brief',
          'http://linked-development.org/r4d/output/194693/' =>
            'https://gov.uk/dfid-research-outputs/compiled-database-on-nationality-of-bank-ownership',
          'http://linked-development.org/r4d/output/194696/' =>
            'https://gov.uk/dfid-research-outputs/compiled-database-on-cross-border-bank-mergers-and-acquisitions-m-as',
          'http://linked-development.org/r4d/output/195253/' =>
            'https://gov.uk/dfid-research-outputs/a-case-study-of-community-level-intervention-for-non-communicable-diseases-in-khayelitsha-cape-town-evidence-report-no-27',
          'http://linked-development.org/r4d/output/195255/' =>
            'https://gov.uk/dfid-research-outputs/the-health-of-women-and-girls-in-urban-areas-with-a-focus-on-kenya-and-south-africa-a-review-evidence-report-no-42',
          'http://linked-development.org/r4d/output/195259/' =>
            'https://gov.uk/dfid-research-outputs/reclaiming-the-streets-for-women-s-dignity-effective-initiatives-in-the-struggle-against-gender-based-violence-in-between-egypt-s-two-revolutions-evidence-report-no-48',
          'http://linked-development.org/r4d/output/10730/' =>
            'https://gov.uk/dfid-research-outputs/developing-a-global-methodology-and-manual-for-biodiversity-guides-suitable-for-use-in-rural-development-final-report',
          'http://linked-development.org/r4d/output/5005/' =>
            'https://gov.uk/dfid-research-outputs/road-safety-management-review-appendices',
          'http://linked-development.org/r4d/output/5004/' =>
            'https://gov.uk/dfid-research-outputs/review-of-road-safety-management-practice-final-report',
          'http://linked-development.org/r4d/output/179284/' =>
            'https://gov.uk/dfid-research-outputs/understanding-the-antimalarials-market-uganda-2007-an-overview-of-the-supply-side',
          'http://linked-development.org/r4d/output/179652/' =>
            'https://gov.uk/dfid-research-outputs/the-global-financial-crisis-developing-countries-and-policy-responses',
          'http://linked-development.org/r4d/output/179649/' =>
            'https://gov.uk/dfid-research-outputs/what-are-the-likely-poverty-impacts-of-the-current-crises',
          'http://linked-development.org/r4d/output/179647/' =>
            'https://gov.uk/dfid-research-outputs/voices-of-the-poor-in-the-current-crises',
          'http://linked-development.org/r4d/output/179644/' =>
            'https://gov.uk/dfid-research-outputs/social-protection-responses-to-the-financial-crisis-what-do-we-know',
          'http://linked-development.org/r4d/output/179643/' =>
            'https://gov.uk/dfid-research-outputs/macroeconomic-policy-stimuli-aid-and-budgeting-what-options',
          'http://linked-development.org/r4d/output/179642/' =>
            'https://gov.uk/dfid-research-outputs/china-and-the-global-financial-crisis-implications-for-low-income-countries',
          'http://linked-development.org/r4d/output/179638/' =>
            'https://gov.uk/dfid-research-outputs/the-impact-on-developing-countries-of-an-oecd-recession',
          'http://linked-development.org/r4d/output/179637/' =>
            'https://gov.uk/dfid-research-outputs/trade-credit',
          'http://linked-development.org/r4d/output/179636/' =>
            'https://gov.uk/dfid-research-outputs/from-crisis-management-to-institutional-reform',
          'http://linked-development.org/r4d/output/179635/' =>
            'https://gov.uk/dfid-research-outputs/will-the-global-financial-crisis-change-the-development-paradigm',
          'http://linked-development.org/r4d/output/120012/' =>
            'https://gov.uk/dfid-research-outputs/intrarectal-quinine-for-treating-plasmodium-falciparum-malaria',
          'http://linked-development.org/r4d/output/179935/' =>
            'https://gov.uk/dfid-research-outputs/medicines-for-malaria-venture-roadshow-afrique-francophone',
          'http://linked-development.org/r4d/output/179934/' =>
            'https://gov.uk/dfid-research-outputs/mmv-malaria-drugs-discover-develop-and-deliver',
          'http://linked-development.org/r4d/output/180386/' =>
            'https://gov.uk/dfid-research-outputs/country-classifications-for-a-changing-world',
          'http://linked-development.org/r4d/output/180622/' =>
            'https://gov.uk/dfid-research-outputs/the-politics-of-taxation-and-implications-for-accountability-in-ghana-1981-2008',
          'http://linked-development.org/r4d/output/181819/' =>
            'https://gov.uk/dfid-research-outputs/natural-resources-and-chronic-poverty-cprc-working-paper-no-152',
          'http://linked-development.org/r4d/output/176648/' =>
            'https://gov.uk/dfid-research-outputs/most-of-our-social-scientists-are-not-institution-based-they-are-there-for-hire-research-consultancies-and-social-science-capacity-for-health-research-in-east-africa',
          'http://linked-development.org/r4d/output/181831/' =>
            'https://gov.uk/dfid-research-outputs/scaling-up-stigma-the-effects-of-antiretroviral-roll-out-on-stigma-and-hiv-testing-early-evidence-from-rural-tanzania-181831',
          'http://linked-development.org/r4d/output/177154/' =>
            'https://gov.uk/dfid-research-outputs/pregnancy-related-school-dropout-and-prior-school-performance-in-south-africa',
          'http://linked-development.org/r4d/output/176815/' =>
            'https://gov.uk/dfid-research-outputs/access-to-elementary-education-in-india-country-analytical-review',
          'http://linked-development.org/r4d/output/180144/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-36-country-classifications-for-a-changing-world',
          'http://linked-development.org/r4d/output/177989/' =>
            'https://gov.uk/dfid-research-outputs/operational-guidelines-for-facility-level-monitoring-events-on-community-based-tb-care-dots',
          'http://linked-development.org/r4d/output/180590/' =>
            'https://gov.uk/dfid-research-outputs/servicios-publicos-de-salud-de-plantas-para-todos-resultados-y-lecciones-aprendidas-2005-2007',
          'http://linked-development.org/r4d/output/180589/' =>
            'https://gov.uk/dfid-research-outputs/nicaragua-public-plant-health-services-for-all-results-and-lessons-learned-2005-2007',
          'http://linked-development.org/r4d/output/180073/' =>
            'https://gov.uk/dfid-research-outputs/pathways-working-paper-1-conceptualising-policy-practices-in-researching-pathways-of-women-s-empowerment',
          'http://linked-development.org/r4d/output/178682/' =>
            'https://gov.uk/dfid-research-outputs/pathways-working-paper-2-voice-and-women-s-empowerment-mapping-a-research-agenda',
          'http://linked-development.org/r4d/output/180145/' =>
            'https://gov.uk/dfid-research-outputs/research-summary-37-the-politics-of-taxation-and-implications-for-accountability-in-ghana-1983-2008',
          'http://linked-development.org/r4d/output/181814/' =>
            'https://gov.uk/dfid-research-outputs/a-model-for-community-mental-health-services-in-south-africa',
          'http://linked-development.org/r4d/output/181123/' =>
            'https://gov.uk/dfid-research-outputs/trn-33-surfacing-alternatives-for-unsealed-rural-roads',
          'http://linked-development.org/r4d/output/181122/' =>
            'https://gov.uk/dfid-research-outputs/surfacing-alternatives-for-unsealed-rural-roads',
          'http://linked-development.org/r4d/output/181124/' =>
            'https://gov.uk/dfid-research-outputs/success-factors-for-road-management-systems',
          'http://linked-development.org/r4d/output/181146/' =>
            'https://gov.uk/dfid-research-outputs/trn31-how-a-road-agency-can-transform-force-account-road-maintenance-to-contracting',
          'http://linked-development.org/r4d/output/181145/' =>
            'https://gov.uk/dfid-research-outputs/how-a-road-agency-can-transform-force-account-road-maintenance-to-contracting',
          'http://linked-development.org/r4d/output/180078/' =>
            'https://gov.uk/dfid-research-outputs/pathways-working-paper-3-paid-work-women-s-empowerment-and-gender-justice-critical-pathways-of-social-change',
          'http://linked-development.org/r4d/output/174900/' =>
            'https://gov.uk/dfid-research-outputs/state-business-relationships-and-economic-growth-in-sub-saharan-africa',
          'http://linked-development.org/r4d/output/181067/' =>
            'https://gov.uk/dfid-research-outputs/state-business-relations-in-indian-states-paper-towards-constructing-an-effective-sbr-index-for-indian-states',
          'http://linked-development.org/r4d/output/182663/' =>
            'https://gov.uk/dfid-research-outputs/a-model-for-estimating-child-and-adolescent-mental-health-service-needs-and-resources-in-south-africa',
          'http://linked-development.org/r4d/output/181012/' =>
            'https://gov.uk/dfid-research-outputs/a-model-for-estimating-community-mental-health-service-needs-and-resources',
          'http://linked-development.org/r4d/output/180153/' =>
            'https://gov.uk/dfid-research-outputs/natural-resources-and-chronic-poverty-in-india-a-review-of-issues-and-evidence-cprc-iipa-working-paper-no-43',
          'http://linked-development.org/r4d/output/181242/' =>
            'https://gov.uk/dfid-research-outputs/pathways-working-paper-5-conditional-cash-transfers-a-pathway-to-women-s-empowerment',
          'http://linked-development.org/r4d/output/180358/' =>
            'https://gov.uk/dfid-research-outputs/scaling-up-stigma-the-effects-of-antiretroviral-treatment-on-stigma-early-evidence-from-rural-tanzania',
          'http://linked-development.org/r4d/output/174941/' =>
            'https://gov.uk/dfid-research-outputs/reduction-of-hiv-1-rna-levels-with-therapy-to-suppress-herpes-simplex-virus',
          'http://linked-development.org/r4d/output/176840/' =>
            'https://gov.uk/dfid-research-outputs/impact-of-hsv-2-episodic-therapy-on-hiv-1-and-hsv-2-genital-shedding-and-ulcer-healing-among-women-in-ghana-and-central-african-republic-randomised-controlled-trial',
          'http://linked-development.org/r4d/output/177409/' =>
            'https://gov.uk/dfid-research-outputs/dropping-out-from-school-a-cross-country-review-of-the-literature',
          'http://linked-development.org/r4d/output/182046/' =>
            'https://gov.uk/dfid-research-outputs/state-business-relations-and-performance-of-manufacturing-sector-in-andhra-pradesh-a-case-study',
          'http://linked-development.org/r4d/output/184130/' =>
            'https://gov.uk/dfid-research-outputs/working-paper-18-adapting-to-climate-change-in-the-water-sector-assessing-the-effectiveness-of-planned-adaptation-interventions-in-reducing-local-level-vulnerability',
          'http://linked-development.org/r4d/output/182059/' =>
            'https://gov.uk/dfid-research-outputs/implications-of-avian-flu-for-economic-development-in-kenya',
          'http://linked-development.org/r4d/output/120017/' =>
            'https://gov.uk/dfid-research-outputs/low-level-laser-therapy-for-treating-tuberculosis-120017',
          'http://linked-development.org/r4d/output/182491/' =>
            'https://gov.uk/dfid-research-outputs/women-s-empowerment-and-islam-in-bangladesh-summary-paper',
          'http://linked-development.org/r4d/output/180178/' =>
            'https://gov.uk/dfid-research-outputs/religions-democracy-and-governance-space-for-the-marginalized-in-contemporary-india',
          'http://linked-development.org/r4d/output/180530/' =>
            'https://gov.uk/dfid-research-outputs/religion-politics-and-governance-in-pakistan',
          'http://linked-development.org/r4d/output/181784/' =>
            'https://gov.uk/dfid-research-outputs/engaged-yet-disengaged-islamic-schools-and-the-state-in-kano-nigeria',
          'http://linked-development.org/r4d/output/180529/' =>
            'https://gov.uk/dfid-research-outputs/beyond-the-paradox-religions-family-and-modernity-in-contemporary-bangladesh',
          'http://linked-development.org/r4d/output/181427/' =>
            'https://gov.uk/dfid-research-outputs/marker-of-identity-religious-political-parties-and-welfare-work-the-case-of-jma-at-i-islami-in-pakistan-and-bangladesh',
          'http://linked-development.org/r4d/output/182484/' =>
            'https://gov.uk/dfid-research-outputs/beyond-the-religious-impasse-mobilizing-for-muslim-women-s-rights-in-india',
          'http://linked-development.org/r4d/output/181785/' =>
            'https://gov.uk/dfid-research-outputs/domains-of-contestation-women-s-empowerment-and-islam-in-bangladesh',
          'http://linked-development.org/r4d/output/181786/' =>
            'https://gov.uk/dfid-research-outputs/religious-political-parties-and-their-welfare-work-relations-between-the-rss-the-bharatiya-janata-party-and-the-vidya-bharati-schools-in-india',
          'http://linked-development.org/r4d/output/182485/' =>
            'https://gov.uk/dfid-research-outputs/religion-politics-and-governance-in-nigeria',
          'http://linked-development.org/r4d/output/182486/' =>
            'https://gov.uk/dfid-research-outputs/religion-politics-and-the-everyday-moral-order-in-bangladesh-182486',
          'http://linked-development.org/r4d/output/181787/' =>
            'https://gov.uk/dfid-research-outputs/mapping-the-activities-of-faith-based-organizations-in-development-in-nigeria',
          'http://linked-development.org/r4d/output/182481/' =>
            'https://gov.uk/dfid-research-outputs/the-state-and-madrasas-in-india',
          'http://linked-development.org/r4d/output/182858/' =>
            'https://gov.uk/dfid-research-outputs/unplanned-antiretroviral-treatment-interruptions-in-southern-africa-how-should-we-be-managing-these',
          'http://linked-development.org/r4d/output/181813/' =>
            'https://gov.uk/dfid-research-outputs/scaling-up-child-and-adolescent-mental-health-services-in-south-africa-human-resource-requirements-and-costs',
          'http://linked-development.org/r4d/output/182843/' =>
            'https://gov.uk/dfid-research-outputs/progress-in-reading-guidelines',
          'http://linked-development.org/r4d/output/182562/' =>
            'https://gov.uk/dfid-research-outputs/unplanned-art-treatment-interruption-in-south-africa-what-can-we-do-to-minimise-the-long-term-risks',
          'http://linked-development.org/r4d/output/183353/' =>
            'https://gov.uk/dfid-research-outputs/riu-tanzania-zonal-innovation-challenge-fund-processes-outcomes-and-lessons-learnt-to-date',
          'http://linked-development.org/r4d/output/184232/' =>
            'https://gov.uk/dfid-research-outputs/effective-state-business-relations-industrial-policy-and-economic-growth',
          'http://linked-development.org/r4d/output/183196/' =>
            'https://gov.uk/dfid-research-outputs/whither-morality-finding-god-in-the-fight-against-corruption',
          'http://linked-development.org/r4d/output/183197/' =>
            'https://gov.uk/dfid-research-outputs/corruption-religion-and-moral-development',
          'http://linked-development.org/r4d/output/183791/' =>
            'https://gov.uk/dfid-research-outputs/female-madrasas-in-pakistan-a-response-to-modernity',
          'http://linked-development.org/r4d/output/195887/' =>
            'https://gov.uk/dfid-research-outputs/the-impact-of-tertiary-education-on-development-education-rigorous-literature-review',
          'http://linked-development.org/r4d/output/195890/' =>
            'https://gov.uk/dfid-research-outputs/literacy-foundation-learning-and-assessment-in-developing-countries-education-rigorous-literature-review',
          'http://linked-development.org/r4d/output/195959/' =>
            'https://gov.uk/dfid-research-outputs/what-can-we-learn-from-field-experiments-on-media-communication-and-governance-research-briefing-issue-3',
          'http://linked-development.org/r4d/output/195958/' =>
            'https://gov.uk/dfid-research-outputs/democracy-governance-and-randomised-media-assistance-research-report-issue-3',
          'http://linked-development.org/r4d/output/196581/' =>
            'https://gov.uk/dfid-research-outputs/what-was-the-role-of-the-debate-programme-sema-kenya-in-the-2013-kenyan-election-research-report-issue-5',
          'http://linked-development.org/r4d/output/195981/' =>
            'https://gov.uk/dfid-research-outputs/special-issue-political-economy-of-climate-change',
          'http://linked-development.org/r4d/output/196116/' =>
            'https://gov.uk/dfid-research-outputs/resyst-working-paper-4-developing-leadership-and-management-competencies-in-low-and-middle-income-country-health-systems-a-review-of-the-literature-on-health-leadership-and-management',
          'http://linked-development.org/r4d/output/196215/' =>
            'https://gov.uk/dfid-research-outputs/technical-note-30-young-lives-rounds-1-to-3-constructed-files',
          'http://linked-development.org/r4d/output/196577/' =>
            'https://gov.uk/dfid-research-outputs/interventions-to-enhance-girls-education-and-gender-equality-education-rigorous-literature-review',
          'http://linked-development.org/r4d/output/195888/' =>
            'https://gov.uk/dfid-research-outputs/the-role-and-impact-of-private-schools-in-developing-countries-education-rigorous-literature-review',
          'http://linked-development.org/r4d/output/195960/' =>
            'https://gov.uk/dfid-research-outputs/what-was-the-role-of-the-debate-programme-sema-kenya-in-the-2013-kenyan-election-research-briefing-issue-5',
          'http://linked-development.org/r4d/output/196723/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-01-the-economics-of-the-brazilian-model-of-agricultural-development',
          'http://linked-development.org/r4d/output/196725/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-10-infrastructure-and-its-role-in-brazil-s-development-process',
          'http://linked-development.org/r4d/output/194202/' =>
            'https://gov.uk/dfid-research-outputs/improving-maternal-health-practices-in-four-countries-insights-and-lessons-learned-bridging-theory-and-practice-research-dissemination-series-working-paper-issue-06',
          'http://linked-development.org/r4d/output/195891/' =>
            'https://gov.uk/dfid-research-outputs/pedagogy-curriculum-teaching-practices-and-teacher-education-in-developing-countries-education-rigorous-literature-review',
          'http://linked-development.org/r4d/output/197307/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-02-what-explains-the-intensification-and-diversification-of-brazil-s-agricultural-production-and-exports-from-1990-to-2012',
          'http://linked-development.org/r4d/output/197309/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-03-technological-catch-up-and-indigenous-institutional-infrastructures-in-latecomer-natural-resource-related-industries-an-exploration-of-the-role-of-embrapa-in-brazil-s-soybeans-and-forestry-based-pulp-and-paper-industries',
          'http://linked-development.org/r4d/output/197376/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-12-a-more-level-playing-field-explaining-the-decline-in-earnings-inequality-in-brazil-1995-2012',
          'http://linked-development.org/r4d/output/197378/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-11-taxation-redistribution-and-the-social-contract-in-brazil',
          'http://linked-development.org/r4d/output/197382/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-08-mapping-corruption-and-its-institutional-determinants-in-brazil',
          'http://linked-development.org/r4d/output/197380/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-09-brazilian-anti-corruption-legislation-and-its-enforcement-potential-lessons-for-institutional-design',
          'http://linked-development.org/r4d/output/197383/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-07-institutions-for-macro-stability-in-brazil-inflation-targets-and-fiscal-responsibility',
          'http://linked-development.org/r4d/output/197385/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-06-restructuring-brazil-s-national-financial-system',
          'http://linked-development.org/r4d/output/197387/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-05-the-impact-of-senai-s-vocational-training-programme-on-employment-wages-and-mobility-in-brazil-what-lessons-for-sub-saharan-africa',
          'http://linked-development.org/r4d/output/197389/' =>
            'https://gov.uk/dfid-research-outputs/iriba-working-paper-04-antipoverty-transfers-and-inclusive-growth-in-brazil',
          'http://linked-development.org/r4d/output/189980/' =>
            'https://gov.uk/dfid-research-outputs/five-keys-to-improving-research-costing-in-low-and-middle-income-countries',
          'http://linked-development.org/r4d/output/197532/' =>
            'https://gov.uk/dfid-research-outputs/implementation-research-toolkit-197532',
          'http://linked-development.org/r4d/output/193103/' =>
            'https://gov.uk/dfid-research-outputs/community-mediation-and-social-harmony-in-nepal',
          'http://linked-development.org/r4d/output/199794/' =>
            'https://gov.uk/dfid-research-outputs/powering-the-health-sector-annex-a-literature-review',
          'http://linked-development.org/r4d/output/199795/' =>
            'https://gov.uk/dfid-research-outputs/powering-the-health-sector-approach-and-methodology-for-an-impact-assessment-of-the-provision-of-energy-to-health-facilities-in-low-income-countries-annex-b',
          'http://linked-development.org/r4d/output/197534/' =>
            'https://gov.uk/dfid-research-outputs/early-childhood-development-and-cognitive-development-in-developing-countries-a-rigorous-literature-review',
          'http://linked-development.org/r4d/output/199948/' =>
            'https://gov.uk/dfid-research-outputs/how-can-agriculture-and-food-system-policies-improve-nutrition-technical-brief-november-2014',
          'http://linked-development.org/r4d/output/191007/' =>
            'https://gov.uk/dfid-research-outputs/do-micro-credit-micro-savings-and-micro-leasing-serve-as-effective-financial-inclusion-interventions-enabling-poor-people-and-especially-women-to-engage-in-meaningful-economic-opportunities-in-low-and-middle-income-countries-a-systematic-review-of-the-evidence',
          'http://linked-development.org/r4d/output/196796/' =>
            'https://gov.uk/dfid-research-outputs/agriculture-and-nutrition-in-pakistan-pathways-and-disconnects',
          'http://linked-development.org/r4d/output/197316/' =>
            'https://gov.uk/dfid-research-outputs/the-other-asian-enigma-explaining-the-rapid-reduction-of-undernutrition-in-bangladesh-197316',
          'http://linked-development.org/r4d/output/201201/' =>
            'https://gov.uk/dfid-research-outputs/investor-perspectives-on-emerging-market-investments-stage-2-report',
          'http://linked-development.org/r4d/output/201349/' =>
            'https://gov.uk/dfid-research-outputs/after-ebola-why-and-how-capacity-support-to-sierra-leone-s-health-sector-needs-to-change',
          'http://linked-development.org/r4d/output/201628/' =>
            'https://gov.uk/dfid-research-outputs/cost-effectiveness-of-community-based-practitioner-programmes-in-ethiopia-indonesia-and-kenya',
          'http://linked-development.org/r4d/output/201636/' =>
            'https://gov.uk/dfid-research-outputs/health-services-and-users-perceptions-of-the-state-in-rolpa-nepal-slrc-working-paper-36',
          'http://linked-development.org/r4d/output/201637/' =>
            'https://gov.uk/dfid-research-outputs/education-services-and-users-perceptions-of-the-state-in-rolpa-nepal-slrc-working-paper-37',
          'http://linked-development.org/r4d/output/201642/' =>
            'https://gov.uk/dfid-research-outputs/after-the-revolution-what-do-libyans-and-tunisians-believe-about-their-media-research-briefing-issue-6',
          'http://linked-development.org/r4d/output/201641/' =>
            'https://gov.uk/dfid-research-outputs/after-the-revolution-libyan-and-tunisian-media-through-the-people-s-eyes-research-report-issue-6',
          'http://linked-development.org/r4d/output/201766/' =>
            'https://gov.uk/dfid-research-outputs/protracted-displacement-uncertain-paths-to-self-reliance-in-exile',
          'http://linked-development.org/r4d/output/202205/' =>
            'https://gov.uk/dfid-research-outputs/the-impact-of-non-state-schools-in-developing-countries-a-synthesis-of-the-evidence-from-two-rigorous-reviews',
          'http://linked-development.org/r4d/output/202203/' =>
            'https://gov.uk/dfid-research-outputs/the-role-and-impact-of-philanthropic-and-religious-schools-in-developing-countries-a-rigorous-review-of-the-evidence',
          'http://linked-development.org/r4d/output/212826/' =>
            'https://gov.uk/dfid-research-outputs/measuring-the-progress-and-success-of-regional-health-policies-prari-toolkit-of-indicators-for-the-union-of-south-american-nations-unasur',
          'http://linked-development.org/r4d/output/194064/' =>
            'https://gov.uk/dfid-research-outputs/assignment-report-systematic-review-of-complementary-feeding-strategies-amongst-children-less-than-two-years-of-age',
          'http://linked-development.org/r4d/output/202252/' =>
            'https://gov.uk/dfid-research-outputs/midiendo-el-progreso-y-el-exito-de-las-politicas-regionales-de-salud-compendio-de-indicadores-para-la-union-de-naciones-suramericanas-unasur-or-in-english-translation-measuring-progress-and-success-of-regional-health-policy-a-prari-toolkit-of-indicators-for-the-union-of-south-american-nations-unasur',
          'http://linked-development.org/r4d/output/213180/' =>
            'https://gov.uk/dfid-research-outputs/cash-based-approaches-in-humanitarian-emergencies-a-systematic-review',
          'http://linked-development.org/r4d/output/201812/' =>
            'https://gov.uk/dfid-research-outputs/gender-and-resilience',
        }
      end

      def self.canonicalize(linked_development_url)
        match = linked_development_url.match(
          %r{http://linked-development.org/r4d/(?<type>output|project)/(?<id>[0-9]+?)/?(?:default\.aspx)?/*?$}i
        )

        "http://linked-development.org/r4d/#{match[:type]}/#{match[:id]}/"
      end

      def self.[](bad_r4d_url)
        mappings[canonicalize(bad_r4d_url)]
      end
    end
  end
end
