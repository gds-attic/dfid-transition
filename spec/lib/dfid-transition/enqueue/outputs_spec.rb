require 'spec_helper'
require 'dfid-transition/enqueue/outputs'
require 'dfid-transition/load/output'
require 'rdf/query/solution'
require 'rdf/query/solutions'

describe DfidTransition::Enqueue::Outputs do
  let(:logger) { spy('Logger') }

  let(:original_uri) { RDF::URI.parse('http://original_url/1234/') }
  let(:solutions) { RDF::Query::Solutions([solution, solution]) }
  let(:solution) { RDF::Query::Solution.new(solution_hash) }
  let(:solution_hash) do
    {
      output: original_uri
    }
  end

  subject(:enqueuer) do
    DfidTransition::Enqueue::Outputs.new(solutions, logger: logger)
  end

  before do
    allow(DfidTransition::Load::Output).to receive(:perform_async)
    enqueuer.run
  end

  it 'has queued both solutions as simple hashes' do
    expect(DfidTransition::Load::Output).to have_received(
      :perform_async
    ).with(
      output: original_uri
    ).twice
  end

  it 'logs how many it is publishing' do
    expect(logger).to have_received(:info).with('Enqueued 2 outputs for publishing')
  end
end
