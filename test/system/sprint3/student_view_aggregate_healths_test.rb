require "application_system_test_case"
# Acceptance Criteria: 
# 1. As a student, I should only be to allowed to see my team's detailed weekly health
# 2. As a student, I should be able to see my team's overall health

class StudentViewAggregateHealthsTest < ApplicationSystemTestCase
  include FeedbacksHelper
  
  setup do 
    @user = User.new(email: 'test@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Adam', is_admin: false)
    @user2 = User.new(email: 'test2@gmail.com', password: '1234567891', password_confirmation: '1234567891', name: 'Adam2', is_admin: false)
    @user3 = User.new(email: 'test10@gmail.com', password: '1234567891', password_confirmation: '1234567891', name: 'Adam10', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @team2 = Team.create(team_name: 'Test Team 2', team_code: 'TEAM02', user: @prof)
    @user.teams << @team
    @user.save!
    @user2.teams << @team
    @user2.save!
    @user3.teams << @team2
    @user3.save!
    
    @week_range = week_range(2021, 7)
    #sets the app's date to week of Feb 15 - 21, 2021 for testing
    travel_to Time.new(2021, 02, 15, 06, 04, 44)
  end 
  
  # (2)
  def test_view_overall_team_health
    #Passes Acceptance Criteria 2: As a student, I should be able to see my team's overall health
    feedback1 = save_feedback(1, 2, 1, 2, "Data1", @user, DateTime.civil_from_format(:local, 2021, 2, 15), @team, 2)
    feedback2 = save_feedback(1, 2, 3, 4, "Data2", @user2, DateTime.civil_from_format(:local, 2021, 2, 16), @team, 2)
    
    average_rating = (((1+2+1+2).to_f/4)*(2.5) + ((1+2+3+4).to_f/4)*(2.5))/2.round(2)
    
    visit root_url 
    login 'test@gmail.com', '123456789'
    assert_current_path root_url 
    
    assert_text 'Current Week: ' + @week_range[:start_date].strftime('%b %-e, %Y').to_s + " to " + @week_range[:end_date].strftime('%b %-e, %Y').to_s
    assert_text average_rating.to_s
    assert_text 'Low'
  end 
  
  # (1)
  def test_view_weekly_team_health
    #Passes Acceptance Criteria 1: As a student, I should only be to allowed to see their team's detailed weekly health
    feedback = save_feedback(1, 2, 1, 2, "Week 10 data 1", @user, DateTime.civil_from_format(:local, 2021, 3, 8), @team, 2)
    feedback2 = save_feedback(1, 2, 3, 4, "Week 10 data 2", @user2, DateTime.civil_from_format(:local, 2021, 3, 9), @team, 2)
    feedback = save_feedback(1, 2, 1, 2, "Week 9 data 1", @user, DateTime.civil_from_format(:local, 2021, 3, 1), @team, 0)
    feedback2 = save_feedback(1, 2, 3, 4, "Week 9 data 2", @user2, DateTime.civil_from_format(:local, 2021, 3, 3), @team, 2)
    feedback3 = save_feedback(1, 2, 1, 2, "Week 7 data 1", @user, DateTime.civil_from_format(:local, 2021, 2, 15), @team, 1)
    feedback4 = save_feedback(1, 2, 3, 4, "Week 7 data 2", @user2, DateTime.civil_from_format(:local, 2021, 2, 16), @team, 2)
    
    average_ratingFeb = (((1+2+1+2).to_f/4)*(2.5) + ((1+2+3+4).to_f/4)*(2.5))/2.round(2)
    average_ratingMarch = (((1+2+1+2).to_f/4)*(2.5) + ((1+2+3+4).to_f/4)*(2.5))/2.round(2)
    
    visit root_url 
    login 'test@gmail.com', '123456789'
    assert_current_path root_url 
    click_on 'View Historical Data'
    assert_current_path team_path(@team)
    
  if @team.all_submit(@team.feedbacks) == true || Time.now.wday ==0 && Time.now.hour >= 18
    within('#2021-7') do
      assert_text 'Feb 15, 2021 to Feb 21, 2021'
      assert_text 'Medium'
      assert_text average_ratingFeb.to_s
    end
    
    within('#2021-9') do
      assert_text 'Mar 1, 2021 to Mar 7, 2021'
      assert_text 'High'
      assert_text average_ratingMarch.to_s
    end

    within('#2021-10') do
      assert_text 'Mar 8, 2021 to Mar 14, 2021'
      assert_text 'Low'
      assert_text average_ratingMarch.to_s
    end
  
  else
    within('#2021-7') do
      assert_text 'Feb 15, 2021 to Feb 21, 2021'
      assert_no_text 'Medium'
      assert_no_text average_ratingFeb.to_s
    end
    
    within('#2021-9') do
      assert_text 'Mar 1, 2021 to Mar 7, 2021'
      assert_no_text 'High'
      assert_no_text average_ratingMarch.to_s
    end

    within('#2021-10') do
      assert_text 'Mar 8, 2021 to Mar 14, 2021'
      assert_no_text 'Low'
      assert_no_text average_ratingMarch.to_s
    end
  end
  end 
  
  # (1)
  def test_only_view_current_team_weekly_feedback
    #Passes Acceptance Criteria 1: As a student, I should not be able to view another team's weekly health that they're not a part of
    feedback = save_feedback(1, 1, 1, 1, "Team1", @user, DateTime.civil_from_format(:local, 2021, 3, 1), @team, 0)
    feedback2 = save_feedback(1, 1, 1, 1, "Team2", @user3, DateTime.civil_from_format(:local, 2021, 3, 3), @team2, 2)
    
    visit root_url 
    #user1 should not be able to view user3's weekly team health data
    login 'test@gmail.com', '123456789'
    visit team_url(@team2)
    assert_current_path root_url
  end 
  
end
