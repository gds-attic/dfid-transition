require 'spec_helper'
require 'dfid-transition/services/stats'
require 'mock_redis'

def add_a_collision!
  redis.sadd('slug-collisions', 'a-collision')
end

def add_an_attachment!
  redis.sadd('known-attachments', 'http://an.attachment')
end

describe DfidTransition::Services::Stats do
  Stats = DfidTransition::Services::Stats

  let(:redis) { MockRedis.new }
  subject(:stats) { Stats.new(redis) }

  describe '#collision_index_size' do
    it 'reflects the number of collision index members' do
      expect { add_a_collision! }.
        to change { stats.collision_index_size }.from(0).to(1)
    end
  end

  describe '#attachment_index_size' do
    it 'reflects the number of attachments' do
      expect { add_an_attachment! }.
        to change { stats.attachment_index_size }.from(0).to(1)
    end
  end

  describe '#to_s' do
    it 'shows info about each that changes with the indexes' do
      expect(stats.to_s).to eql(
        "Slug collisions: 0\n" \
        "Attachments: 0"
      )
      add_a_collision!
      add_an_attachment!
      expect(stats.to_s).to eql(
        "Slug collisions: 1\n" \
        "Attachments: 1"
      )
    end
  end
end
