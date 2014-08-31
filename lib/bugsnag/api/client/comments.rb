module Bugsnag
  module Api
    class Client

      # Methods for the Comments API
      #
      # @see https://bugsnag.com/docs/api/comments
      module Comments
        # List an error's comments
        #
        # @param error [String] Bugsnag error for which to list comments
        # @return [Array<Sawyer::Resource>] List of comments
        # @see https://bugsnag.com/docs/api/comments#list-an-error-s-comments
        # @example
        #   Bugsnag::Api.comments("515fb9337c1074f6fd000009")
        def comments(error, options = {})
          paginate "errors/#{error}/comments", options
        end

        # Get a single comment
        #
        # @param comment [String] A Bugsnag comment ID
        # @return [Sawyer::Resource] The comment you requested, if it exists
        # @see https://bugsnag.com/docs/api/comments#get-comment-details
        # @example
        #   Bugsnag::Api.comment("50baed119bf39c1431000004")
        def comment(comment, options = {})
          get "comments/#{comment}", options
        end

        # Create a comment
        #
        # @param error [String] The Bugsnag error to create the comment on
        # @option message [String] The comment's message
        # @see https://bugsnag.com/docs/api/comments#create-a-comment
        # @example
        #   Bugsnag::Api.create_comment("515fb9337c1074f6fd000009", message: "Oops!")
        def create_comment(error, message, options = {})
          post "errors/#{error}/comments", options.merge({:message => message})
        end

        # Update a comment
        #
        # @param error [String] The Bugsnag comment to update
        # @return [Sawyer::Resource] The updated comment
        # @see https://bugsnag.com/docs/api/comments#update-a-comment
        # @example
        #   Bugsnag::Api.update_comment("50baed119bf39c1431000004", message: "Fixed!")
        def update_comment(comment, message, options = {})
          patch "comments/#{comment}", options.merge({:message => message})
        end

        # Delete a comment
        #
        # @param comment [String] The Bugsnag comment to delete
        # @return [Boolean] `true` if comment was deleted
        # @see https://bugsnag.com/docs/api/comments#delete-a-comment
        def delete_comment(comment, options = {})
          boolean_from_response :delete, "comments/#{comment}", options
        end
      end
    end
  end
end
