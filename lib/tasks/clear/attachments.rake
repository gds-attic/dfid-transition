require 'dfid-transition/services/attachment_index'

namespace :clear do
  desc 'Clear attachment index'
  task :attachments do
    DfidTransition::Services.attachment_index.clear
  end
end
