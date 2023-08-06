require "application_system_test_case"

# Acceptance Criteria:
# 1: As a professor, I should be able to view a specific user's page
# 2: As a professor, I should be able to reset a user's password
# 3: As a student, I should not be able to reset another user's password (or my own, if I do not remember my current password)
class InstructorResetPasswordTest < ApplicationSystemTestCase
  setup do 
    @prof = User.new(email: 'msmucker@gmail.com', password: 'professor', password_confirmation: 'professor', name: 'Mark', is_admin: true)
    @prof.save
    @user1 = User.new(email: 'adam@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Adam', is_admin: false)
    @user1.save

    @team1 = Team.new(team_code: 'Code', team_name: 'Team 1')
    @team1.user = @prof
    @team1.save
    @user1.teams << @team1
  end
  
  def test_instructor_resets_user_password
    #Passes acceptance criteria 1: As a professor, I will receive a delete confirmation message when I want to delete a student account
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Manage Users'
    assert_current_path users_url
    
    click_on 'Adam'
    assert_current_path user_path(@user1)


    assert_text @user1.name
    assert_text @user1.email
    assert_text @user1.role
    #assert_text @user1.teams

    click_on 'Regenerate Password'
    
    assert_current_path root_url    
    assert_text "Adam's new password is:"
  end 
end

