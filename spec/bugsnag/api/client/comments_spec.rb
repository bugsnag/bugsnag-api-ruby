require "spec_helper"

describe Bugsnag::Api::Client::Comments do
  before do
    @client = auth_token_client
    @project_id = test_bugsnag_project_id
    @error_id = test_bugsnag_error_id
    Bugsnag::Api.reset!
  end

  describe ".create_comment", :vcr do
    it "creates a comment on the error" do
      comment = @client.create_comment @project_id, @error_id, "test_message"
      expect(comment.message).to eq("test_message")
      expect(comment.id).to_not be_nil

      assert_requested :post, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/comments")
    end
  end

  context "given a comment has been created" do
    before do
      @comment = @client.create_comment @project_id, @error_id, "message"
    end

    describe ".comments", :vcr do
      it "retrieves all comments on an error" do
        comments = @client.comments @project_id, @error_id

        expect(comments).to be_kind_of(Array)
        expect(comments.first.message).to_not be_nil

        assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/comments")
      end
    end

    describe ".comment", :vcr do
      it "retrieves the comment specified" do
        comment = @client.comment @comment.id

        expect(comment.message).to eq("message")
        expect(comment.id).to eq(@comment.id)

        assert_requested :get, bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".update_comment", :vcr do
      it "updates the message on a comment" do
        comment = @client.update_comment @comment.id, "updated"
        
        expect(comment.message).to eq("updated")
        expect(comment.id).to eq(@comment.id)

        assert_requested :patch, bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".delete_comment", :vcr do
      it "deletes the comment and returns true" do
        stub_request(:delete, bugsnag_url("/comments/#{@comment.id}")).to_return(:status => [204, "No Content"])
        
        response = @client.delete_comment @comment.id
        expect(response).to be true

        assert_requested :delete, bugsnag_url("/comments/#{@comment.id}")
      end
    end
  end
end
