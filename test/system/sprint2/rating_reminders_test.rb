require "application_system_test_case"
# Acceptance Criteria:
# 1. As a student I should be able to see the
#    remaining time until a weekly rating is due.
# 2. As a student, I should clearly get a reminder if I haven't submitted a rating

class RatingReminders < ApplicationSystemTestCase
  setup do 
    @user = User.create(email: 'user2@gmail.com', name: 'Mark', is_admin: false, password: 'professor', password_confirmation: 'professor')
    @user.save
    visit root_url
    login 'user2@gmail.com', 'professor'
  end

  # Test that no feedback visible visible if user is not part of team
  def test_no_team
    visit root_url
    assert_no_text "Submit for"
  end

  # test that remaining time is visible
  def test_rating_warning
    team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
    team.save!
    team2 = Team.new(team_name: 'Team Name', team_code: 'Code2', user: @user)
    team2.save!
    @user.teams << [team, team2]
    @user.save!
    visit root_url
    assert_text "Hello World"
    assert_text "Team Name"
  end
  #For warnings we have 3 levels: under 2, exactly 2 and over 2 days
  #Exactly 2
  def test_rating_warning_exactly_2
      #https://api.rubyonrails.org/classes/ActiveSupport/Testing/TimeHelpers.html#method-i-travel
      travel_to Time.new(2021, 03, 05, 06, 04, 44)
      team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
      team.save!
      @user.teams << [team]
      @user.save!
      visit root_url
      assert_text "2 days left"
  end
  #Under 2
  def test_rating_warning_under_2
      travel_to Time.new(2021, 02, 27, 06, 04, 44)
      team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
      team.save!
      @user.teams << [team]
      @user.save!
      visit root_url
      assert_text "1 days left"
  end
  #Over 2
  def test_rating_warning_over_2
      travel_to Time.new(2021, 03, 04, 06, 04, 44)
      team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
      team.save!
      @user.teams << [team]
      @user.save!
      visit root_url
      assert_text "3 days left"
  end
  
  #No "days to submit" text should be present on Wednesday
  def test_no_text_wednesday
    travel_to Time.new(2021, 03, 03, 06, 04, 44)
    team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
    team.save!
    @user.teams << [team]
    @user.save!
    visit root_url
    assert_no_text "4 days left"
end
 
#No "days to submit" text should be present on Tuesday
 def test_no_text_tuesday
  travel_to Time.new(2021, 03, 02, 06, 04, 44)
  team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
  team.save!
  @user.teams << [team]
  @user.save!
  visit root_url
  assert_no_text "5 days left"
end

#No "days to submit" text should be present on Monday
def test_no_text_monday
  travel_to Time.new(2021, 03, 01, 06, 04, 44)
  team = Team.new(team_name: 'Hello World', team_code: 'Code', user: @user)
  team.save!
  @user.teams << [team]
  @user.save!
  visit root_url
  assert_no_text "6 days left"
end

end
