require "application_system_test_case"

# Acceptance Criteria:
# 1: As a professor, I should be able to see colored indicators for team summary and detailed views
# 2: As a student, I should be able to see colored indicators for team summary and detailed views

class VisualIndicatorsTest < ApplicationSystemTestCase
  setup do
    @prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: true)
    
    @user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    @user1.save!
    @user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    @user2.save!
    @user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    @team = Team.new(team_code: 'Code', team_name: 'Team 1')
    @team.users = [@user1, @user2]
    @team.user = @prof 
    @team.save!     

    @feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", @user1, Time.zone.now.to_datetime - 30, @team, 2)
    @feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", @user2, Time.zone.now, @team, 2)
    @feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", @user1, Time.zone.now, @team, 2)
  end 
  
  def test_student_view 
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    
    within('#' + @team.id.to_s + '-status') do
      assert find('.dot-red')
    end
    
    assert find('.dot-empty')
    
    click_on 'View Historical Data'
    
    assert find('.dot-red')
    assert find('.dot-empty')
  end
  
  def test_professor_view 
    visit root_url 
    login 'charles@gmail.com', 'banana'
    
    within('#' + @team.id.to_s) do 
      assert find('.dot-red')
    end 
    
    assert find('.dot-empty')
    
    click_on 'Details'
    
    assert find('.dot-red')
    assert find('.dot-empty')
  end
end
