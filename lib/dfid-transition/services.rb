require 'gds_api/publishing_api_v2'
require 'gds_api/asset_manager'
require 'gds_api/rummager'

module DfidTransition
  module Services
    def self.publishing_api
      @publishing_api ||= GdsApi::PublishingApiV2.new(
        Plek.new.find('publishing-api'),
        bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
      )
    end

    def self.asset_manager
      @asset_manager ||= GdsApi::AssetManager.new(
        Plek.new.find('asset-manager'),
        bearer_token: ENV['ASSET_MANAGER_BEARER_TOKEN'] || 'example',
      )
    end

    def self.rummager
      @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
    end
  end
end
