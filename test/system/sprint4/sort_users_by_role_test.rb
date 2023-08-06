require "application_system_test_case"

class SortUsersByRoleTest < ApplicationSystemTestCase
  setup do 
    @prof = User.new(email: 'msmucker@gmail.com', password: 'professor', password_confirmation: 'professor', name: 'Mark', is_admin: true)
    @prof.save
    @user1 = User.new(email: 'liz@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Liz', is_admin: false)
    @user1.save

    @team1 = Team.new(team_code: 'Code', team_name: 'Team 1')
    @team1.user = @prof
    @team1.save
    @user1.teams << @team1
  end
    
  def test_sort_by_role_order
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Manage Users'
    assert_current_path users_url
    
    click_on 'Role'
    within('#user' + @prof.id.to_s) do
      assert_text @prof.email
      assert_text @prof.name
    end
    within('#user' + @user1.id.to_s) do
      assert_text @user1.email
      assert_text @user1.name
    end

  end 

end