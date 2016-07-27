require 'spec_helper'
require 'dfid-transition/load/slug_collisions'

describe DfidTransition::Load::SlugCollisions do
  describe '#run' do
    include RDFDoubles

    let(:collision_index) { spy 'DfidTransition::Services::CollisionIndex' }
    let(:logger)          { double('Logger').as_null_object }


    let(:solutions) do
      [
        { output: uri('http://linked-development.org/r4d/output/5050/'), title: 'A slug' },
        { output: uri('http://linked-development.org/r4d/output/5051/'), title: 'Another slug' }
      ]
    end

    subject(:loader) do
      DfidTransition::Load::SlugCollisions.new(
        collision_index, solutions, logger: logger)
    end

    before do
      loader.run
    end

    it 'has loaded all the slugs' do
      expect(collision_index).to have_received(:put).with('a-slug')
      expect(collision_index).to have_received(:put).with('another-slug')
    end

    it 'tells us how many' do
      expect(logger).to have_received(:info).with('2 collisions loaded')
    end
  end
end
