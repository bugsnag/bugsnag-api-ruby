module Bugsnag
  module Api
    class Client
      # Methods for the Stability API
      module Stability
        # View the stability trend for a project
        #
        # @return [Sawyer::Resource] Stability trend
        # @see https://bugsnagapiv2.docs.apiary.io/#reference/projects/stability-trend/view-the-stability-trend-for-a-project
        def stability_trend(id, options = {})
          get "projects/#{id}/stability_trend", options
        end
      end
    end
  end
end
