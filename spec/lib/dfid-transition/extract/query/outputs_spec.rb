require 'spec_helper'
require 'dfid-transition/extract/query/outputs'

describe DfidTransition::Extract::Query::Outputs do
  subject(:query) { DfidTransition::Extract::Query::Outputs.new }

  it 'has an endpoint that defaults to linked-development.org' do
    expect(query.endpoint).to eql('http://linked-development.org/sparql')
  end

  describe '#solutions' do
    subject(:solutions) { query.solutions }

    let(:escaped_query) { URI.escape(DfidTransition::Extract::Query::Outputs::QUERY) }
    let(:json_results)  { File.read('spec/fixtures/service-results/research-outputs-sparql.json') }

    before do
      stub_request(
        :get,
        "#{query.endpoint}?query=#{escaped_query}"
      ).to_return(body: json_results)
    end

    it 'has a list of RDF::Query::Solution' do
      expect(query.solutions.count).to be > 0
      query.solutions.each do |solution|
        expect(solution).to be_an(RDF::Query::Solution)
      end
    end

    describe 'the first solution' do
      subject(:solution) { query.solutions.first }

      it 'has an output URI' do
        expect(solution[:output]).to be_an(RDF::URI)
      end
    end
  end
end
