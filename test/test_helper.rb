require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all

  # Add more helper methods to be used by all tests here...


  def login(email, password)
    assert_current_path login_url
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Login"
  end 

  def logout()
    click_on "Logout/Account"
  end

  def save_feedback(contribution, respect, attendance, knowledge, comments, user, timestamp, team, priority)
    feedback = Feedback.new(contribution: contribution, respect: respect, attendance: attendance, knowledge: knowledge, comments: comments, priority: priority)
    feedback.user = user
    feedback.timestamp = feedback.format_time(timestamp)
    feedback.team = team
    feedback.save
    feedback
  end 

end
