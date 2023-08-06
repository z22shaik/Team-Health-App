require "application_system_test_case"

# Acceptance Criteria
# 1. As a professor, I have the ability to delete a student user from the app
# 2. As a professor, I have the ability to delete an admin user from the app
# 3. As a student, I do not have the ability to delete any user from the app

class DeleteUserTest < ApplicationSystemTestCase
  setup do
    Option.create( admin_code: 'ADMIN')
    @generated_code = Team.generate_team_code
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'password', password_confirmation: 'password')
    @team = Team.create(team_name: 'Test Team', team_code: @generated_code.to_s, user: @prof)
  end
  
  #(1)
  def test_delete_astudent_as_prof
    Option.destroy_all
    Option.create( admin_code: 'ADMIN')
    @bob = User.create(email: 'bob@gmail.com', name: 'Bob', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @bob.teams << @team
    
    visit root_url 
    # Login as professor
    login 'msmucker@gmail.com', 'password'
    
    
    click_on "Manage Users"
    
    within('#user' + @bob.id.to_s) do
      assert_text @bob.email
      assert_text @bob.name
      click_on 'Delete User'
    end
    
    assert_current_path user_confirm_delete_path(@bob)
    click_on "Delete User"

    assert_text "User was successfully destroyed."
    
     User.all.each { |user| 
        assert_not_equal(@bob.name, user.name)
    }
  end
  
  
  #(2)
  def test_delete_admin_as_prof
    Option.destroy_all
    Option.create( admin_code: 'ADMIN')
    @ta = User.create(email: 'amir@gmail.com', name: 'Amir', is_admin: true, password: 'password', password_confirmation: 'password')
    
    visit root_url 
    # Login as professor
    login 'msmucker@gmail.com', 'password'

    click_on "Manage Users"
    
    within('#user' + @ta.id.to_s) do
      assert_text @ta.email
      assert_text @ta.name
      click_on 'Delete User'
    end
    
    assert_current_path user_confirm_delete_path(@ta)
    click_on "Delete User"
    
    assert_text "User was successfully destroyed."
    
     User.all.each { |user| 
        assert_not_equal(@ta.name, user.name)
    }
  end
  
    #(3)
  def test_delete_as_student
    Option.destroy_all
    Option.create( admin_code: 'ADMIN')
    @bob = User.create(email: 'bob@gmail.com', name: 'Bob', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @bob.teams << @team
    
    visit root_url 
    # Login as professor
    login 'bob@gmail.com', 'testpassword'

    visit users_path
    
    assert_current_path root_url
    assert_text "You do not have Admin permissions."
  end

end
