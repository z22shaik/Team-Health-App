require "application_system_test_case"


class DeleteFeedbackTest < ApplicationSystemTestCase
  setup do 
    @prof = User.new(email: 'msmucker@gmail.com', password: 'professor', password_confirmation: 'professor', name: 'Mark', is_admin: true)
    @prof.save
    @user = User.new(email: 'adam@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Adam', is_admin: false)
    @user.save

    @team = Team.new(team_code: 'Code', team_name: 'Team 1')
    @team.user = @prof
    @team.save
    @user.teams << @team

    #create new feedback from student with comment and priority of 2 (low)
    @feedback = Feedback.new(contribution: 1, attendance: 1, respect: 1, knowledge: 1, comments: "This team is disorganized", priority: 2)
    @feedback.timestamp = @feedback.format_time(DateTime.now)
    @feedback.user = @user
    @feedback.team = @user.teams.first
    
    @feedback.save
  end 
  
  def test_delete_feedback
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    click_on "Feedback & Ratings"
    assert_text "This team is disorganized"
    click_on "Delete Feedback"
    assert_no_text "This team is disorganized"
    assert_text "Feedback was successfully destroyed."
  end 

  def test_edit_feedback
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    click_on "Feedback & Ratings"
    click_on "Edit"
    select 4, :from => "Q1: Everyone in the group is contributing equally."
    select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
    select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
    select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
    fill_in "Comments", with: "New Comment"
    click_on "Update Feedback"
    assert_text "New Comment"
  end
end
