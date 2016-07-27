require 'spec_helper'
require 'dfid-transition/services/slug_collision_index'
require 'mock_redis'

describe DfidTransition::Services::SlugCollisionIndex do
  SlugCollisionIndex = DfidTransition::Services::SlugCollisionIndex

  let(:redis)                { MockRedis.new }
  let(:slug_collision_index) { SlugCollisionIndex.new(redis) }

  describe '#collides?' do
    let(:slug) { 'example-slug' }

    subject { slug_collision_index.collides?(slug) }

    context 'no item in the index' do
      it { is_expected.to be false }
    end

    context 'is in the index' do
      before { slug_collision_index.put(slug) }
      it     { is_expected.to be true}
    end
  end
end
