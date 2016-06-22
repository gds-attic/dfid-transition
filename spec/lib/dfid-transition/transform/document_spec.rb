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
          date:         literal('2016-04-28T09:52:00'),
          title:        literal(' &amp;#8216;And Then He Switched off the Phone&amp;#8217;: Mobile Phones ... '),
          creators:     literal(' Heinlein, R. | Asimov, A. '),
          abstract:     literal(
            '&amp;lt;p&amp;gt;This research design and methods paper can be '\
            'applied to other countries in Africa and Latin America.'\
            '&amp;lt;p&amp;gt;&amp;lt;ul&amp;gt;&amp;lt;li&amp;gt;Hello&amp;lt;/li&amp;gt;&amp;lt;/ul&amp;gt;&amp;lt;/p&amp;gt;'\
            '&amp;lt;/p&amp;gt;'),
          countryCodes: literal('AZ GB')
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

      it 'fixes #summary to the example' do
        expect(doc.summary).to include('This is an example summary for output 5050')
      end

      it 'knows the original ID for things' do
        expect(doc.original_id).to eql('5050')
      end

      it 'has a base_path' do
        expect(doc.base_path).to eql('/dfid-research-outputs/5050')
      end

      it 'has a public_updated_at' do
        expect(doc.public_updated_at).to eql('2016-04-28T09:52:00')
      end

      it 'has a first_published_at date' do
        expect(doc.first_published_at).to eql('2016-04-28T09:52:00')
      end

      it 'splits country codes' do
        expect(doc.countries).to eql(%w(AZ GB))
      end

      describe '#format_specific_metadata' do
        it 'has our countries' do
          expect(doc.format_specific_metadata[:country]).to eql(doc.countries)
        end
        it 'has our first_published_at date' do
          expect(doc.format_specific_metadata[:first_published_at]).to eql(doc.first_published_at)
        end
      end

      it 'has fixed organisations' do
        dfid_content_id = 'db994552-7644-404d-a770-a2fe659c661f'
        expect(doc.organisations).to eql([dfid_content_id])
      end

      describe '#details' do
        subject(:details) { doc.details }

        it 'has metadata' do
          expect(details[:metadata]).to eql(doc.metadata)
        end

        it 'has a non-empty change history list' do
          expect(details[:change_history]).to be_an(Array)
          expect(details[:change_history]).not_to be_empty
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
        it 'has a list of countries' do
          expect(metadata[:country]).to eql(%w(AZ GB))
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
        it 'has a header with no indents for the creators' do
          expect(body).to match(/^## Authors/)
        end
        it 'has a list for the creators' do
          expect(body).to include('* Heinlein, R.')
          expect(body).to include('* Asimov, A.')
        end
        it 'has the abstract as markdown' do
          expect(body).to include('This research design and methods paper')
          expect(body).not_to include('<p>')
        end
        it 'corrects non-standard HTML – the list is separate' do
          expect(body).to include("\n* Hello")
        end
      end

      describe '#creators' do
        subject(:creators) { doc.creators }

        it { is_expected.to eql(['Heinlein, R.', 'Asimov, A.']) }
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
