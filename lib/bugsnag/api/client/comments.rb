module Bugsnag
  module Api
    class Client

      # Methods for the Errors API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/comments
      module Comments
        # List Comments on an Error
        #
        # @option offset [Number] The pagination offset (not required for general use)
        # @option sort [String] Comments are only sortable by creation time e.g. "created_at"
        # @option direction [String] Which direction to sort the result by, one of: asc, desc
        # @option per_page [Number] How many results to return per page
        # @return [Array<Sawyer::Resource>] List of Error Comments
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/comments/list-comments-on-an-error
        def comments(project_id, error_id, options = {})
            paginate "projects/#{project_id}/errors/#{error_id}/comments", options
        end

        # View an Comment
        #
        # @return [Sawyer::Resource] Requested Comment
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/comments/view-a-comment
        def comment(id, options = {})
            get "comments/#{id}", options
        end

        # Create a Comment on an Error
        #
        # @return [Sawyer::Resource] The new Comment
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/comments/create-a-comment-on-an-error
        def create_comment(project_id, error_id, message, options = {})
            post "projects/#{project_id}/errors/#{error_id}/comments", options.merge({:message => message})
        end

        # Update a Comment
        #
        # @return [Sawyer::Resource] The updated Comment
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/comments/update-a-comment
        def update_comment(id, message, options = {})
            patch "comments/#{id}", options.merge({:message => message})
        end

        # Delete a Comment
        #
        # @return 
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/comments/delete-a-comment
        def delete_comment(id, options = {})
            boolean_from_response :delete, "comments/#{id}", options
        end
      end
    end
  end
end
