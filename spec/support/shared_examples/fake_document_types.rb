require_relative '../rdf_doubles'

shared_examples 'fake document types' do
  include RDFDoubles
  let(:document_type_solutions) do
    [
      RDFDoubles::Solution.new(
        type: uri('http://www.example.com/DocumentTypes#Book%20Chapter'),
        prefLabel: literal('Book Chapter')
      ),
      RDFDoubles::Solution.new(
        type: uri('http://www.example.com/DocumentTypes#Magazine/Newsletter/Newspaper%20Article'),
        prefLabel: literal('Magazine/Newsletter/Newspaper Article')
      )
    ]
  end

  let(:fake_document_types) {
    RDFDoubles::Query.new(document_type_solutions)
  }
end
