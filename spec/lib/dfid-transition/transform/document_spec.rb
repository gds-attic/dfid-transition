require 'spec_helper'
require 'dfid-transition/transform/document'
require 'active_support/core_ext/string/strip'

module DfidTransition::Transform
  describe Document do
    include RDFDoubles

    subject(:doc) { Document.new(solution) }

    context 'a solution that behaves like a hash is given' do
      AN_R4D_OUTPUT_URL = 'http://r4d.dfid.gov.uk/Output/5050/Default.aspx'.freeze

      let(:original_url)  { AN_R4D_OUTPUT_URL }
      let(:solution)      { double('RDF::Query::Solution') }
      let(:solution_hash) do
        {
          output:       uri(original_url),
          type:         uri('http://r4d.dfid.gov.uk/rdf/skos/DocumentTypes#Book%20Chapter'),
          date:         literal('2016-04-28T09:52:00'),
          title:        literal(' &amp;#8216;And Then He Switched off the Phone&amp;#8217;: Mobile Phones ... '),
          citation:     literal(' Heinlein, R.; Asimov, A. &lt;b&gt;Domestic Violence Law: The Gap Between Legislation and Practice in Cambodia and What Can Be Done About It.&lt;/b&gt; 72 pp. '),
          creators:     literal(' Heinlein, R. | Asimov, A. '),
          peerReviewed: boolean(true),
          abstract:     literal(
            '&amp;lt;p&amp;gt;This research design and methods paper can be '\
            'applied to other countries in Africa and Latin America.'\
            '&amp;lt;p&amp;gt;&amp;lt;ul&amp;gt;&amp;lt;li&amp;gt;Hello&amp;lt;/li&amp;gt;&amp;lt;/ul&amp;gt;&amp;lt;/p&amp;gt;'\
            '&amp;lt;/p&amp;gt;'),
          countryCodes: literal('AZ GB'),
          uris:         literal('http://r4d.dfid.gov.uk/pdfs/some.pdf http://example.com/offsite.pdf'),
          themes:       literal(
            'http://r4d.dfid.gov.uk/rdf/skos/Themes#Infrastructure '\
            'http://r4d.dfid.gov.uk/rdf/skos/Themes#Climate%20and%20Environment'
          )
        }
      end

      before do
        allow(solution).to receive(:[]) { |key| solution_hash[key] }
      end

      it 'generates a content_id for the document' do
        uuid = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        expect(doc.content_id).to match(uuid), 'content_id wasn\'t a UUID'
      end

      it 'allows content_id to change' do
        doc.content_id = SecureRandom.uuid
      end

      describe '#original_url' do
        context 'the solution has come from the linked development endpoint' do
          it 'does not change the original URL' do
            expect(doc.original_url).to eql(AN_R4D_OUTPUT_URL)
          end
        end
        context 'the solution has come from a local endpoint' do
          let(:original_url) { 'http://linked-development.org/r4d/output/5050/' }

          it 'remaps the original URL to r4d' do
            expect(doc.original_url).to eql(AN_R4D_OUTPUT_URL)
          end
        end
      end

      it 'normalises the title by stripping, correcting ampersands and unescaping HTML' do
        expect(doc.title).to eql(
          '‘And Then He Switched off the Phone’: Mobile Phones ...')
      end

      it 'has a slug' do
        expect(doc.slug).to eql('and-then-he-switched-off-the-phone-mobile-phones')
      end

      it 'always has an empty summary' do
        expect(doc.summary).to be_empty
      end

      it 'knows the original ID for things' do
        expect(doc.original_id).to eql('5050')
      end

      it 'has a base_path that corresponds to the title' do
        expect(doc.base_path).to eql('/dfid-research-outputs/and-then-he-switched-off-the-phone-mobile-phones')
      end

      describe '#disambiguate_slug!' do
        it 'appends the original_id' do
          expect { doc.disambiguate! }.to change { doc.slug }.from(
            'and-then-he-switched-off-the-phone-mobile-phones'
          ).to (
            'and-then-he-switched-off-the-phone-mobile-phones-5050'
          )
        end
      end

      it 'has a public_updated_at' do
        expect(doc.public_updated_at).to eql('2016-04-28T09:52:00')
      end

      it 'has a first_published_at date' do
        expect(doc.first_published_at).to eql('2016-04-28T09:52:00')
      end

      describe '#peer_reviewed' do
        subject { doc.peer_reviewed }

        context 'it is peer reviewed' do
          it { is_expected.to be true }
        end

        context 'it is not peer reviewed' do
          before { solution_hash[:peerReviewed] = boolean(false) }
          it     { is_expected.to be false }
        end
      end

      it 'splits country codes' do
        expect(doc.countries).to eql(%w(AZ GB))
      end

      describe '#format_specific_metadata' do
        it 'has our countries' do
          expect(doc.format_specific_metadata[:country]).to eql(doc.countries)
        end
        it 'has our authors' do
          expect(doc.format_specific_metadata[:dfid_authors]).to eql(doc.creators)
        end
        it 'has our first_published_at date' do
          expect(doc.format_specific_metadata[:first_published_at]).to eql(doc.first_published_at)
        end
        it 'has the document review status' do
          expect(doc.format_specific_metadata[:dfid_review_status]).to eql('peer_reviewed')
        end
      end

      it 'has fixed organisations' do
        dfid_content_id = 'db994552-7644-404d-a770-a2fe659c661f'
        expect(doc.organisations).to eql([dfid_content_id])
      end

      describe '#details' do
        subject(:details) { doc.details }

        before do
          doc.attachments.each do |attachment|
            allow(attachment).to receive(:asset_response).and_return(
              double('response', file_url: 'http://asset.url'))
          end
        end

        it 'has metadata' do
          expect(details[:metadata]).to eql(doc.metadata)
        end

        it 'has a non-empty change history list' do
          expect(details[:change_history]).to be_an(Array)
          expect(details[:change_history]).not_to be_empty
        end

        it 'has onsite attachments only with URLs assigned by asset manager' do
          attachments_json = details[:attachments]
          expect(attachments_json.size).to eql(1)
          expect(attachments_json.first[:url]).to eql('http://asset.url')
        end

        describe 'the presented body' do
          subject(:presented_body) { details[:body] }

          it { is_expected.to be_an(Array) }

          it 'contains the body in the markdown section' do
            expect(presented_body.first[:content]).to eql(doc.body)
          end
        end
      end

      describe '#metadata' do
        subject(:metadata) { doc.metadata }

        it 'has the document type' do
          expect(metadata[:document_type]).to eql('dfid_research_output')
        end
        it 'has the DFID document type' do
          expect(metadata[:dfid_document_type]).to eql('book_chapter')
        end
        it 'has a list of countries' do
          expect(metadata[:country]).to eql(%w(AZ GB))
        end
        it 'has a list of theme identifiers' do
          expect(metadata[:dfid_theme]).to eql(%w(infrastructure climate_and_environment))
        end
        it 'says that this is bulk_published' do
          expect(metadata[:bulk_published]).to be true
        end
        it 'has the published date of the research output' do
          expect(metadata[:first_published_at]).to eql(doc.first_published_at)
        end
      end

      describe '#change_history' do
        subject(:change_history) { doc.change_history }

        it {
          is_expected.to eql \
            [{ public_timestamp: doc.public_updated_at, note: 'First published.' }]
        }
      end

      describe '#body' do
        subject(:body) { doc.body }

        it { is_expected.to be_a(String) }

        it 'has a header with no indents for the abstract' do
          expect(body).to match(/^## Abstract/)
        end
        it 'has a header with no indents for the links' do
          expect(body).to match(/^## Links/)
        end
        it 'has the citation' do
          expect(body).to include(doc.citation)
        end
        it 'has the abstract as markdown' do
          expect(body).to include('This research design and methods paper')
          expect(body).not_to include('<p>')
        end
        it 'corrects non-standard HTML – the list is separate' do
          expect(body).to include("\n* Hello")
        end
        it 'has the onsite link' do
          expect(body).to include('[InlineAttachment:some.pdf]')
        end
        it 'has the offsite link' do
          expect(body).to include('[offsite.pdf](http://example.com/offsite.pdf)')
        end

        context 'the abstract is blank' do
          context 'with a single dash' do
            before { solution_hash[:abstract] = literal('-') }
            it 'has no abstract section' do
              expect(body).not_to include('## Abstract')
            end
          end

          context 'with a single dash and leading/trailing space' do
            before { solution_hash[:abstract] = literal(' - ') }
            it 'has no abstract section' do
              expect(body).not_to include('## Abstract')
            end
          end

          context 'properly blank' do
            before { solution_hash[:abstract] = literal('') }
            it 'has no abstract section' do
              expect(body).not_to include('## Abstract')
            end
          end
        end
      end

      describe '#creators' do
        subject(:creators) { doc.creators }

        it { is_expected.to eql(['Heinlein, R.', 'Asimov, A.']) }
      end

      describe '#citation' do
        it 'strips all formatting' do
          expect(doc.citation).to eql(
            'Heinlein, R.; Asimov, A. Domestic Violence Law: The Gap Between '\
            'Legislation and Practice in Cambodia and What Can Be Done About It. 72 pp.'
          )
        end
      end

      describe '#headers' do
        subject(:headers) { doc.headers }

        before do
          allow(doc).to receive(:body).and_return(body)
        end

        context 'there is just one header' do
          let(:body) { '## Abstract' }

          it { is_expected.to be_an(Array) }

          it 'has one item for the abstract' do
            expect(headers.first).to eql(
              text: 'Abstract', level: 2, id: 'abstract'
            )
          end
        end

        context 'there are some nested headers' do
          let(:body) do
            <<-MARKDOWN.strip_heredoc
              ## Abstract

              ### Sub-abstract

              ## Downloads
            MARKDOWN
          end

          it { is_expected.to be_an(Array) }

          it 'has 2 main headers' do
            expect(headers.size).to eql(2)
          end

          it 'nests the other headers' do
            expect(headers).to eql(
              [
                {
                  text: 'Abstract', level: 2, id: 'abstract',
                  headers: [
                    { text: 'Sub-abstract', level: 3, id: 'sub-abstract' }
                  ]
                },
                { text: 'Downloads', level: 2, id: 'downloads' }
              ]
            )
          end
        end
      end
    end
  end
end
