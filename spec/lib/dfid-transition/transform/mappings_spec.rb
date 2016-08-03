require 'spec_helper'
require 'dfid-transition/transform/mappings'

describe DfidTransition::Transform::Mappings do
  let(:attachment_index)     { double 'DfidTransition::Services::AttachmentIndex' }
  let(:slug_collision_index) { double 'DfidTransition::Services::SlugCollisionIndex' }
  let(:attachment_details)   { nil }
  let(:collides)             { false }

  let(:stdout) { spy '$stdout' }
  let(:mappings) do
    DfidTransition::Transform::Mappings.new(
      attachment_index, slug_collision_index, solutions, output_to: stdout)
  end

  describe '#to_csv' do
    context 'solutions are an empty set' do
      let(:solutions) { [] }

      before { mappings.dump_csv }

      it 'generates only the header' do
        expect(stdout).to have_received(:puts).with("Old URL, New URL\n")
      end
    end

    context 'solutions has a valid solution in it' do
      include RDFDoubles

      let(:onsite_pdf)         { 'http://r4d.dfid.gov.uk/pdfs/onsite.pdf' }
      let(:offsite_pdf)        { 'http://example.com/offsite.pdf' }
      let(:attachment_details) { nil }

      let(:solutions) do
        [{
          output:       uri('http://linked-development.org/r4d/output/5050/'),
          title:        literal('This is the title'),
          uris:         literal("#{onsite_pdf} #{offsite_pdf}"),
        }]
      end

      before do
        allow(attachment_index).to receive(:get).and_return(attachment_details)
        allow(slug_collision_index).to receive(:collides?).and_return(collides)

        mappings.dump_csv
      end

      it 'still has the header' do
        expect(stdout).to have_received(:puts).with("Old URL, New URL\n")
      end

      it 'has a mapping from the old to the new document URL with www' do
        expect(stdout).to have_received(:puts).with(
          "http://r4d.dfid.gov.uk/Output/5050/Default.aspx,https://www.gov.uk/dfid-research-outputs/this-is-the-title\n"
        )
      end

      context 'onsite PDF has no entry in the AttachmentIndex' do
        it 'omits the mapping for the onsite PDF' do
          expect(stdout).not_to have_received(:puts).with(onsite_pdf)
        end
      end

      context 'onsite PDF is in the AttachmentIndex' do
        let(:attachment_details) {
          {
            'file_url' => 'https://new.attachment.url'
          }
        }

        it 'has a mapping for the onsite PDF' do
          expect(stdout).to have_received(:puts).with(
            "http://r4d.dfid.gov.uk/pdfs/onsite.pdf,https://new.attachment.url\n"
          )
        end
      end

      context 'there is a namespace collision on title' do
        let(:collides) { true }

        it 'outputs the disambiguated URL' do
          expect(stdout).to have_received(:puts).with(
            "http://r4d.dfid.gov.uk/Output/5050/Default.aspx,https://www.gov.uk/dfid-research-outputs/this-is-the-title-5050\n"
          )
        end
      end
    end
  end
end
