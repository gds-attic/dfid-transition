require 'spec_helper'
require 'dfid-transition/transform/document'

module DfidTransition::Transform
  describe Document do
    def literal(value, options={class: 'RDF::Literal'})
      double(options[:class]).tap do |literal|
        allow(literal).to receive(:to_s).and_return(value)
      end
    end

    def uri(value, options={class: 'RDF::URI'})
      literal(value, options)
    end

    subject(:doc) { Document.new(solution) }

    context 'a solution that behaves like a hash is given' do
      AN_R4D_OUTPUT_URL = 'http://r4d.dfid.gov.uk/Output/5050/Default.aspx'

      let(:original_url)  { AN_R4D_OUTPUT_URL }
      let(:solution)      { double('RDF::Query::Solution') }
      let(:solution_hash) do
        {
          output:  uri(original_url),
          date:    literal('2016-04-28T09:52:00'),
          title:   literal(' &amp;#8216;And Then He Switched off the Phone&amp;#8217;: Mobile Phones ... '),
          summary: literal('  a summary with leading and trailing space  '),
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

      it 'normalises the summary by stripping' do
        expect(doc.summary).to eql(
          'a summary with leading and trailing space')
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

      it 'has fixed metadata' do
        expect(doc.metadata).to eql({ document_type: "dfid_research_output" })
      end

      it 'splits country codes' do
        expect(doc.countries).to eql(['AZ', 'GB'])
      end

      it 'has these countries in format_specific_metadata' do
        expect(doc.format_specific_metadata).to eql(
          {country: doc.countries}
        )
      end
      
      it 'has fixed organisations' do
        dfid_content_id = 'b994552-7644-404d-a770-a2fe659c661f'
        expect(doc.organisations).to eql([dfid_content_id])
      end

      describe '#details' do
        subject(:details) { doc.details }
        it 'has a body' do
          expect(details[:body]).to be_an(Array)
        end

        it 'has metadata' do
          expect(details[:metadata]).to eql(doc.metadata)
        end
      end

      it 'has a body it gets from details' do
        expect(doc.body).to eql(doc.details[:body])
      end
    end
  end
end
