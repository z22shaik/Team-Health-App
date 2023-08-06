require "application_system_test_case"

class SortUsersByNameTeam < ApplicationSystemTestCase
  setup do 
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @team2 = Team.create(team_name: 'Test Team 2', team_code: 'TEAM02', user: @prof)
    
    @bob = User.create(email: 'bob@gmail.com', name: 'Bob', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @bob.teams << @team
    
    @mike = User.create(email: 'mike@gmail.com', name: 'Mike', is_admin: false, password: 'testpassword4', password_confirmation: 'testpassword4')
    @mike.teams << @team2
  end
    
  def test_sort_by_team_order_no_click
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Manage Users'
    assert_current_path users_url
    
    within('#user' + @bob.id.to_s) do
      assert_text @bob.email
      assert_text @bob.name
    end
    within('#user' + @mike.id.to_s) do
      assert_text @mike.email
      assert_text @mike.name
    end
    within('#user' + @prof.id.to_s) do
      assert_text @prof.email
      assert_text @prof.name
    end
  end 

  def test_sort_by_team_order_click
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Manage Users'
    assert_current_path users_url
    
    click_on 'Team'
    within('#user' + @prof.id.to_s) do
      assert_text @prof.email
      assert_text @prof.name
    end
    within('#user' + @mike.id.to_s) do
      assert_text @mike.email
      assert_text @mike.name
    end
    within('#user' + @bob.id.to_s) do
      assert_text @bob.email
      assert_text @bob.name
    end
  end 


  


end