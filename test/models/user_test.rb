require 'test_helper'
require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase

   def setup 
    @user = User.create(email: 'scott@gmail.com', password: 'password', password_confirmation: 'password', name: 'Scott A', is_admin: false)
    @prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: true)
   end
    
  def test_role_function_professor
    professor = User.new(email: 'azina@gmail.com', password: 'password', password_confirmation: 'password', name: 'Azin', is_admin: true) 
    assert_equal('Professor', professor.role)
  end 
  
  def test_role_function_student 
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false)
    assert_equal('Student', user1.role)
  end 
  
  def test_team_names 
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.user = @prof 
    team2.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false, teams: [team, team2])
    assert_equal(['Team 1', 'Team 2'], user1.team_names)
  end
  
  def test_one_submission_no_submissions
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false, teams: [team])
    assert_equal([], user1.one_submission_teams)
  end
  
  def test_one_submission_existing_submissions 
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false, teams: [team])
    save_feedback(1, 1, 1, 1, 'Test', user1, Time.zone.now, team, 1)
    assert_equal([team], user1.one_submission_teams)
  end
  
  # 1) As a user, I cannot create an account with a duplicate email
  test 'valid signup' do
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false, teams: [team])
    assert user1.valid?

  end
    
  #test that two professors can signup
  test 'valid prof signup' do
     professor = User.new(email: 'azina@gmail.com', password: 'password', password_confirmation: 'password', name: 'Azin', is_admin: true) 
     assert professor.valid?
  end
  
  test 'invalid signup without unique email' do
      user1 = User.new(email: 'scott@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott F', is_admin: false)
      refute user1.valid?, 'user must have unique email'
      assert_not_nil user1.errors[:email]
  end
    
  # 4) As a user, I cannot create an account with a password less than 6 characters
  test 'invalid signup password' do
      user1 = User.new(email: 'scottf@gmail.com', password: 'apple', password_confirmation: 'apple', name: 'Scott F', is_admin: false)
      refute user1.valid?, 'user password must have at least 6 characters'
      assert_not_nil user1.errors[:password]
  end
  
  #name is too long
  test 'invalid signup name' do
      user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', is_admin: false)
      refute user1.valid?, 'user name must have less than 40 characters'
      assert_not_nil user1.errors[:name]
  end

  #Check if generated password meets minimum size requirements
  test 'generated password length' do
      user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'tester', is_admin: false)
      new_password = user1.generate_user_password
      user1.update(password: new_password, password_confirmation: new_password) 
      assert_equal 10, user1.password.size
  end

  # As a student, I should be able to see the number of days until a weekly rating is due,
  # and I should only see that if there are ratings due.
  def test_rating_reminders
    user = User.new(email: 'charles42@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: false)
    user.save!

    team = Team.new(team_name: 'Hello World', team_code: 'Code', user: user)
    team.save!
    team2 = Team.new(team_name: 'Team Name', team_code: 'Code2', user: user)
    team2.save!
    user.teams << [team, team2]
    user.save!
    reminders = user.rating_reminders
    assert_equal reminders.size, 2

    # create feeedback for team
    datetime = Time.zone.now
    feedback = Feedback.new(contribution: 1, attendance: 1, respect: 1, knowledge: 1, priority: 2, comments: "This team is disorganized")
    feedback.timestamp = feedback.format_time(datetime)
    feedback.user = user
    feedback.team = team
    feedback.save! 

    # ensure that feedback created in previous week does not stop warning from displaying 
    datetime2 = DateTime.new(1990,2,3)
    feedback2 = Feedback.new(contribution: 1, attendance: 1, respect: 1, knowledge: 1, priority: 2, comments: "This team is disorganized")
    feedback2.timestamp = feedback2.format_time(datetime2)
    feedback2.user = user
    feedback2.team = team2
    feedback2.save!
    array = user.rating_reminders
    array = array.map { |team| team.team_name }
    assert_equal true, array.include?("Team Name")
    assert_equal 1, array.size
  end

  def test_sort_desc_multiple_users_no_numbers
    userB = User.create(email: 'bob@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Bob', is_admin: false)
    userC = User.create(email: 'carl@gmail.com', password: 'carrot', password_confirmation: 'carrot', name: 'Carl', is_admin: false)
        
    params = {:sort => 'name', :direction => 'desc'}
    result = User.sort_users(params)
    assert_equal result, [@user, @prof, userC, userB] 
  end

  def test_sort_asc_multiple_users_no_numbers
    userB = User.create(email: 'bob@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Bob', is_admin: false)
    userC = User.create(email: 'carl@gmail.com', password: 'carrot', password_confirmation: 'carrot', name: 'Carl', is_admin: false)
        
    params = {:sort => 'name', :direction => 'asc'}
    result = User.sort_users(params)
    assert_equal result, [userB, userC, @prof, @user] 
  end

  def test_sort_desc_users_with_numbers
    userS1 = User.create(email: 'scott1@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott 1', is_admin: false)
       
    params = {:sort => 'name', :direction => 'desc'}
    result = User.sort_users(params)
    assert_equal result, [@user, userS1, @prof] 
  end

  def test_sort_asc_users_with_numbers
    userS1 = User.create(email: 'scott1@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Scott 1', is_admin: false)
       
    params = {:sort => 'name', :direction => 'asc'}
    result = User.sort_users(params)
    assert_equal result, [@prof, userS1, @user] 
  end

  def test_sort_desc_users_regular_setup   
    params = {:sort => 'name', :direction => 'desc'}
    result = User.sort_users(params)
    assert_equal result, [@user, @prof] 
  end

  def test_sort_asc_users_regular_setup
    params = {:sort => 'name', :direction => 'asc'}
    result = User.sort_users(params)
    assert_equal result, [@prof, @user] 
  end

  def test_sorting_of_roles_asc
    params = {:sort => 'is_admin', :direction => 'asc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@user, @prof] 
  end

  def test_sorting_of_roles_desc
    params = {:sort => 'is_admin', :direction => 'desc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@prof, @user] 
  end

  def test_sorting_of_roles_asc_multiple_profs
    prof1 = User.create(email: 'james@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'James', is_admin: true)
    prof2 = User.create(email: 'jamie@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Jamie', is_admin: true)
    prof3 = User.create(email: 'jake@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Jake', is_admin: true)

    params = {:sort => 'is_admin', :direction => 'asc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@user, @prof, prof1, prof2, prof3] 
  end
  
  def test_sorting_of_roles_desc_multiple_profs
    prof1 = User.create(email: 'james@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'James', is_admin: true)
    prof2 = User.create(email: 'jamie@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Jamie', is_admin: true)
    prof3 = User.create(email: 'jake@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Jake', is_admin: true)

    params = {:sort => 'is_admin', :direction => 'desc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@prof, prof1, prof2, prof3, @user] 
  end

  def test_sorting_of_roles_asc_multiple_students
    student1 = User.create(email: 'liz@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Liz', is_admin: false)
    student2 = User.create(email: 'lizzy@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Lizzy', is_admin: false)
    student3 = User.create(email: 'lizzie@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Lizzie', is_admin: false)

    params = {:sort => 'is_admin', :direction => 'asc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@user, student1, student2, student3, @prof] 
  end

  def test_sorting_of_roles_desc_multiple_students
    student1 = User.create(email: 'liz@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Liz', is_admin: false)
    student2 = User.create(email: 'lizzy@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Lizzy', is_admin: false)
    student3 = User.create(email: 'lizzie@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Lizzie', is_admin: false)

    params = {:sort => 'is_admin', :direction => 'desc'}
    result = User.sort_user_roles(params)
    assert_equal result, [@prof, @user, student1, student2, student3] 
  end

end
