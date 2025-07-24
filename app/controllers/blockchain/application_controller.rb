module Blockchain
  class ApplicationController < ::ApplicationController
    layout 'layouts/application' # Use the parent app's layout
    allow_unauthenticated_access if respond_to?(:allow_unauthenticated_access)
  end
end
