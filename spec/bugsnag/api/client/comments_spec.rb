require "spec_helper"

describe Bugsnag::Api::Client::Comments do
  before do
    Bugsnag::Api.reset!
    @client = basic_auth_client
  end

  describe ".comments", :vcr do
    it "returns all comments on an error" do
      comments = @client.comments(test_bugsnag_error)
      expect(comments).to be_kind_of(Array)
      expect(comments.first.message).not_to be_nil

      assert_requested :get, basic_bugsnag_url("/errors/#{test_bugsnag_error}/comments")
    end
  end

  describe ".create_comment", :vcr do
    it "created a comment" do
      comment = @client.create_comment(test_bugsnag_error, "Comment message")
      expect(comment.message).to eq("Comment message")

      assert_requested :post, basic_bugsnag_url("/errors/#{test_bugsnag_error}/comments")
    end
  end

  context "with comment", :vcr do
    before do
      @comment = @client.create_comment(test_bugsnag_error, "Comment message")
    end

    describe ".comment" do
      it "returns a comment" do
        comment = @client.comment(@comment.id)
        expect(comment.id).to eq(@comment.id)

        assert_requested :get, basic_bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".update_comment" do
      it "updates an existing comment" do
        updated_comment = @client.update_comment(@comment.id, "Example new message")
        expect(updated_comment.id).to eq(@comment.id)
        assert_requested :patch, basic_bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".delete_comment" do
      it "deletes an existing comment" do
        response = @client.delete_comment(@comment.id)
        expect(response).to be true
        assert_requested :delete, basic_bugsnag_url("/comments/#{@comment.id}")
      end
    end
  end
end
