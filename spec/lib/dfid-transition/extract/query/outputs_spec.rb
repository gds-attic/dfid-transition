require 'spec_helper'
require 'dfid-transition/extract/query/outputs'

Outputs = DfidTransition::Extract::Query::Outputs

describe Outputs do
  subject(:outputs) { Outputs.new(options) }

  describe '#query' do
    context "No no, no no no no, no no no no, no no, there's no :limit" do
      let(:options) { {} }

      it 'defaults to the DEFAULT_LIMIT constant' do
        expect(outputs.query).to include("LIMIT #{Outputs::DEFAULT_LIMIT}")
      end
    end

    context "Yes, yes, yes yes yes yes, yes yes yes yes, yes yes, there's a :limit" do
      context 'a string, as from a rake task' do
        let(:options) { { limit: '2000' } }

        it 'uses the limit sent' do
          expect(outputs.query).to include("LIMIT 2000")
        end
      end

      context 'a numeric, as from irb' do
        let(:options) { { limit: 2000 } }

        it 'uses the limit sent' do
          expect(outputs.query).to include("LIMIT 2000")
        end
      end

      context 'unsanitary input (not an integer)' do
        context 'injection' do
          let(:options) { { limit: '; Little Bobby Tables; DROP TABLE students;' } }

          it 'raises an ArgumentError' do
            expect { outputs.query }.to raise_error(ArgumentError, /invalid value for Integer\(\)/)
          end
        end
      end
    end
  end
end
