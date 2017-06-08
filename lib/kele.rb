require "httparty"
require "json"
require_relative "roadmap"

class Kele
  include HTTParty
  include Roadmap
  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    if @user_token == nil
      "Invalid Credentials"
    else
      "Welcome"
    end
    @user_token = response["auth_token"]
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: {"authorization" => @user_token })
    user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @user_token })
    mentor_data = JSON.parse(response.body)
  end

  def get_messages(page)
    response = self.class.get("https://www.bloc.io/api/v1/message_threads?page=#{page}", headers: {"authorization" => @user_token })
    message_data = JSON.parse(response.body)
  end

  def create_message(recipient_id, subject, message)
    response = self.class.post("https://www.bloc.io/api/v1/messages", body: {"recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: {"authorization" => @user_token })
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
      body: {
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "checkpoint_id": checkpoint_id,
        "comment": comment,
        "enrollment_id": enrollment_id
      },
      headers: {"authorization" => @user_token })
  end
end
