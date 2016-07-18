{
  lib: '..',
  app: '../..'
}.each_value do |path|
  $LOAD_PATH.unshift(File.expand_path(path, File.dirname(__FILE__)))
end

require 'config/initializers/sidekiq'

require 'dfid-transition/extract/download/attachment'
