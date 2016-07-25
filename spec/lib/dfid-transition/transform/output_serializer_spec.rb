require 'spec_helper'
require 'rdf/query'
require 'dfid-transition/transform/output_serializer'

##
# Demonstrate the behaviour on which we rely
describe DfidTransition::Transform::OutputSerializer do
  let(:fixture_json) { File.read('spec/fixtures/service-results/research-outputs-sparql.json') }

  describe '#deserialize' do
    subject(:result) { DfidTransition::Transform::OutputSerializer.deserialize(fixture_json) }

    it 'is an array of Solution' do
      expect(result).to be_an(Array)
      result.each { |result| expect(result).to be_an(RDF::Query::Solution) }
    end

    describe 'the first result' do
      subject(:first_result) { result.first }

      it 'supports xsd:boolean' do
        expect(first_result[:peerReviewed]).to be_false
      end
      it 'has dates as literals' do
        expect(first_result[:date]).to be_an(RDF::Literal)
      end
      it 'has output and type as URIs' do
        expect(first_result[:output]).to be_an(RDF::URI)
        expect(first_result[:type]).to be_an(RDF::URI)
      end
    end
  end

  describe '#serialize' do
    let(:input_solution) { DfidTransition::Transform::OutputSerializer.deserialize(fixture_json).first }
    let(:json_str) { DfidTransition::Transform::OutputSerializer.serialize(input_solution) }
    let(:json) { JSON.parse(json_str) }

    it 'serializes to a valid JSON string' do
      expect(json_str).to be_a(String)
      expect(json).to be_a(Hash)
    end

    it 'has a head' do
      expect(json['head']['vars']).to eql(%w(
        output
        date
        type
        abstract
        title
        citation
        peerReviewed
        creators
        countryCodes
        uris
        themes
      ))
    end

    it 'is a single result' do
      expect(json['results']['bindings'].count).to eql(1)
    end

    describe 'the result' do
      subject(:binding) { json['results']['bindings'].first }

      it 'has a date' do
        expect(binding['date']).to eql({ 'type' => 'literal', 'value' => '2016-04-28T11:26:00' })
      end
      it 'has an output uri' do
        expect(binding['output']).to eql({ 'type' => 'uri', 'value' => 'http://linked-development.org/r4d/output/213014/' })
      end
      it 'has a boolean peerReviewed' do
        expect(binding['peerReviewed']).to eql(
          {
            'datatype' => 'http://www.w3.org/2001/XMLSchema#boolean',
            'type' => 'literal',
            'value' => 'false' }
        )
      end
    end
  end
end
