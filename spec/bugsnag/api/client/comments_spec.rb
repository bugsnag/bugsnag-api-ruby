require "spec_helper"

describe Bugsnag::Api::Client::Comments do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".comments" do
    it "returns all comments on an error" do
      comments = @client.comments(test_bugsnag_error)
      expect(comments).to be_kind_of(Array)
      expect(comments.first.message).not_to be_nil

      assert_requested :get, bugsnag_url("/errors/#{test_bugsnag_error}/comments")
    end
  end

  describe ".create_comment" do
    it "created a comment", :beta do
      comment = @client.create_comment(test_bugsnag_error, "Comment message")
      expect(comment.message).to eq("Comment message")

      assert_requested :post, bugsnag_url("/errors/#{test_bugsnag_error}/comments")
    end
  end

  context "with comment", :beta do
    before do
      @comment = @client.create_comment(test_bugsnag_error, "Comment message")
    end

    describe ".comment" do
      it "returns a comment" do
        comment = @client.comment(@comment.id)
        expect(comment.id).to eq(@comment.id)

        assert_requested :get, bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".update_comment" do
      it "updates an existing comment" do
        new_message = Faker::Lorem.sentence

        updated_comment = @client.update_comment(@comment.id, new_message)
        expect(updated_comment.message).to eq(new_message)
        assert_requested :patch, bugsnag_url("/comments/#{@comment.id}")
      end
    end

    describe ".delete_comment" do
      it "deletes an existing comment" do
        response = @client.delete_comment(@comment.id)
        expect(response).to be_true
        assert_requested :delete, bugsnag_url("/comments/#{@comment.id}")
      end
    end
  end
end
