require 'spec_helper'
require 'dfid-transition/services/slug_collision_index'
require 'mock_redis'

describe DfidTransition::Services::SlugCollisionIndex do
  SlugCollisionIndex = DfidTransition::Services::SlugCollisionIndex

  let(:redis)                { MockRedis.new }
  let(:slug_collision_index) { SlugCollisionIndex.new(redis) }

  let(:slug) { 'example-slug' }

  describe '#collides?' do
    subject { slug_collision_index.collides?(slug) }

    context 'no item in the index' do
      it { is_expected.to be false }
    end

    context 'is in the index' do
      before { slug_collision_index.put(slug) }
      it     { is_expected.to be true }
    end
  end

  describe '#clean' do
    let(:another_slug) { 'example-slug-2' }

    context 'slugs are in the index' do
      before do
        slug_collision_index.put(slug)
        slug_collision_index.put(another_slug)
      end

      it 'cleans the index' do
        expect(slug_collision_index.collides?(slug)).to be true
        expect(slug_collision_index.collides?(another_slug)).to be true

        slug_collision_index.clean

        expect(slug_collision_index.collides?(slug)).to be false
        expect(slug_collision_index.collides?(another_slug)).to be false
      end
    end
  end
end
