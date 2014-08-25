module Bugsnag
  module Api
    class Client

      # Methods for the Errors API
      #
      # @see https://bugsnag.com/docs/api/errors
      module Errors
        # List a project's errors
        #
        # @param project [String] Bugsnag project for which to list errors
        # @return [Array<Sawyer::Resource>] List of errors
        # @see https://bugsnag.com/docs/api/errors#list-a-project-s-errors
        # @example
        #   Bugsnag::Api.errors("50baed119bf39c1431000004")
        def errors(project, options = {})
          paginate "projects/#{project}/errors", options
        end

        # Get a single error
        #
        # @param error [String] A Bugsnag error
        # @return [Sawyer::Resource] The error you requested, if it exists
        # @see https://bugsnag.com/docs/api/errors#get-error-details
        # @example
        #   Bugsnag::Api.error("518031bcd775355c48a1cd4e")
        def error(error, options = {})
          get "errors/#{error}", options
        end

        # Resolve an error
        #
        # @param error [String] A Bugsnag error
        # @return [Sawyer::Resource] The updated error
        # @see https://bugsnag.com/docs/api/errors#update-an-error-s-status
        # @example
        #   Bugsnag::Api.resolve_error("518031bcd775355c48a1cd4e")
        def resolve_error(error, options = {})
          patch "errors/#{error}", options.merge({:resolved => true})
        end

        # Re-open an error
        #
        # @param error [String] A Bugsnag error
        # @return [Sawyer::Resource] The updated error
        # @see https://bugsnag.com/docs/api/errors#update-an-error-s-status
        # @example
        #   Bugsnag::Api.reopen_error("518031bcd775355c48a1cd4e")
        def reopen_error(error, options = {})
          patch "errors/#{error}", options.merge({:resolved => false})
        end

        # Update an error
        #
        # @param error [String] A Bugsnag error
        # @return [Sawyer::Resource] The updated error
        # @see https://bugsnag.com/docs/api/errors#update-an-error-s-status
        # @example
        #   Bugsnag::Api.update_error("518031bcd775355c48a1cd4e")
        def update_error(error, options = {})
          patch "errors/#{error}", options
        end

        # Delete an error
        #
        # @param error [String] A Bugsnag error
        # @return [Boolean] `true` if error was deleted
        # @see https://bugsnag.com/docs/api/errors#delete-an-error
        def delete_error(error, options = {})
          delete "errors/#{error}", options
        end
      end
    end
  end
end
