require 'spec_helper'
require 'dfid-transition/extract/query/Base'

describe DfidTransition::Extract::Query::Base do
  class TestQuery < DfidTransition::Extract::Query::Base
    def query
      %{
        SELECT ?s ?p ?o WHERE { ?s ?p ?o }
      }
    end
  end

  subject(:test_query) { TestQuery.new }

  describe '#endpoint' do
    it 'defaults to linked-development.org' do
      expect(test_query.endpoint).to eql('http://linked-development.org/sparql')
    end

    describe 'endpoint configuration' do
      let(:changed_endpoint) { 'http://10.0.0.1:3030/sparql.tpl' }

      before { DfidTransition::Extract::Query.endpoint = nil }
      after  { DfidTransition::Extract::Query.endpoint = nil }

      subject { test_query.endpoint }

      context 'endpoint is set directly' do
        before { DfidTransition::Extract::Query.endpoint = changed_endpoint }
        it { is_expected.to eql(changed_endpoint) }
      end

      context 'endpoint is set through SPARQL_ENDPOINT' do
        before { ENV['SPARQL_ENDPOINT'] = changed_endpoint }
        it { is_expected.to eql(changed_endpoint) }
      end
    end
  end

  describe '#solutions' do
    context 'no descendant is used' do
      it 'needs a descendant to query' do
        expect {
          DfidTransition::Extract::Query::Base.new.solutions
        }.to raise_error(NotImplementedError)
      end
    end

    subject(:solutions) { test_query.solutions }

    let(:escaped_query) { URI.escape(test_query.query) }
    let(:json_results)  { File.read('spec/fixtures/service-results/research-outputs-sparql.json') }

    before do
      stub_request(
        :get,
        "#{test_query.endpoint}?query=#{escaped_query}"
      ).to_return(body: json_results)
    end

    it 'has a list of RDF::Query::Solution' do
      expect(test_query.solutions.count).to be > 0
      test_query.solutions.each do |solution|
        expect(solution).to be_an(RDF::Query::Solution)
      end
    end

    describe 'the last solution' do
      subject(:solution) { test_query.solutions.last }

      it 'behaves like a hash' do
        expect(solution[:output]).to be_an(RDF::URI)
      end
    end
  end
end
