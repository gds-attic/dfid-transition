require 'gds_api/publishing_api_v2'
require 'gds_api/rummager'

module DfidTransition
  class Services
    def self.publishing_api
      @publishing_api ||= GdsApi::PublishingApiV2.new(
        Plek.new.find('publishing-api'),
        bearer_token: 'example',
      )
    end

    def self.rummager
      @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
    end
  end
end
