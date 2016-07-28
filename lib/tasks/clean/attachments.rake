require 'dfid-transition/services/attachment_index'

namespace :clean do
  desc 'Clean attachment index'
  task :attachments do
    DfidTransition::Services.attachment_index.clean
  end
end


