require 'test_helper'
require 'date'
class TeamTest < ActiveSupport::TestCase
    include FeedbacksHelper
    
    setup do
        @prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: true)
    end

    def test_unique_team_code_admin
      Option.destroy_all
      Option.create( admin_code: 'admin')
      
      team2 = Team.new(team_code: 'admin', team_name: 'Team 2')
      team2.user = @prof
      assert_not team2.valid?
    end 
  
    def test_add_students
        # create test admin
        user = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: false)
        user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: false)
       

        team = Team.new(team_code: 'Code', team_name: 'Team 1')
        team.user = @prof
        team.users = [user, user2]
        assert_difference('Team.count', 1) do
            team.save
        end
    end

    def test_create_team_invalid_team_code
        team = Team.new(team_code: 'Code', team_name: 'Team 1')
        team.user = @prof
        team.save!
        # try creating team with another team with same team code
        # test case insensitive
        team2 = Team.new(team_code: 'code', team_name: 'Team 2')
        team2.user = @prof
        assert_not team2.valid?
    end

    def test_create_team_blank_team_code
        team = Team.new(team_code: 'Code', team_name: 'Team 1')
        team.user = @prof
        team.save!
        # try creating team with blank code
        team2 = Team.new(team_name: 'Team 2')
        team2.user = @prof
        assert_not team2.valid?
    end
    
    def test_create_team_blank_team_name
        team = Team.new(team_code: 'Code', team_name: 'Team 1')
        team.user = @prof
        team.save!
        # try creating team with blank name
        team2 = Team.new(team_code: 'Code2')
        team2.user = @prof
        assert_not team2.valid?
    end
    
    def test_add_students_to_team
        user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: false)
        user1.save!
        team = Team.new(team_code: 'Code', team_name: 'Team 1')
        team.user = @prof
        team.save!
        assert_difference("team.users.count", + 1) do
            team.users << user1
            team.save!
        end
    end

  def test_create_user_invalid_team_duplicate
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save!
    # try creating team with another team with same team code
    team2 = Team.new(team_code: 'Code', team_name: 'Team 2')
    team2.user = @prof
    assert_not team2.valid?
  end
  
  def test_create_user_invalid_team_code
    # too long of a code
    team2 = Team.new(team_code: 'qwertyuiopasdfghjklzxcvbnmq', team_name: 'Team 2')
    team2.user = @prof
    assert_not team2.valid?
  end

  def test_create_user_invalid_team_name
    # too long of a name
    team2 = Team.new(team_code: 'qwerty', team_name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
    team2.user = @prof
    assert_not team2.valid?
  end
    
  def test_add_students_to_team
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.save!
    assert_difference("team.users.count", + 1) do
      team.users << user1
      team.save!
    end
  end

  def test_get_student_names
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof
    team.users = [user1, user2]
    team.save!

    students = team.student_names
    students.sort!
    assert_equal ['Charles1', 'Charles2'], students
  end
  
  def test_feedback_by_period_no_feedback 
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save! 
    
    assert_nil(team.feedback_by_period)
  end
  
  def test_feedback_by_period_one_period
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team.user = @prof 
    team.save!     
    
    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    
    periods = team.feedback_by_period 
    assert_equal({year: 2021, week: 9}, periods[0][0])
    assert_includes( periods[0][1], feedback )
    assert_includes( periods[0][1], feedback2 )
    assert_equal( 2, periods[0][1].length )
  end
  
  def test_feedback_by_period_multi_period
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team.user = @prof 
    team.save!     
    
    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback4 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    
    periods = team.feedback_by_period 
    assert_equal({year: 2021, week: 9}, periods[0][0])
    assert_equal({year: 2021, week: 7}, periods[1][0])
    assert_includes( periods[0][1], feedback )
    assert_includes( periods[0][1], feedback2 )
    assert_includes( periods[1][1], feedback3 )
    assert_includes( periods[1][1], feedback4 )
    assert_equal( 2, periods[0][1].length )
    assert_equal( 2, periods[1][1].length )
  end
  
  def test_find_priority_weighted_team_summary_high_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 0)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 1)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "High", team_weighted_priority
  end
  
  def test_find_priority_weighted_team_summary_medium_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(3, 3, 3, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(2, 2, 2, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 1)
    feedback3 = save_feedback(3, 3, 2, 2, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 1)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])

    assert_equal "Medium", team_weighted_priority
  end
  
  def test_find_priority_weighted_team_summary_low_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(3, 3, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(3, 3, 4, 4, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(3, 3, 4, 4, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "Low", team_weighted_priority
  end
  
  def test_multi_feedback_average_rating_team_summary
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(3, 3, 3, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(1, 2, 1, 2, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 7.08, current_week_average
  end
  
  def test_single_feedback_average_rating_team_summary
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 2.5, current_week_average
  end
  
  def test_find_priority_weighted_no_feedbacks 
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    team_weighted_priority = team.find_priority_weighted(DateTime.civil_from_format(:local, 2021, 2, 15), DateTime.civil_from_format(:local, 2021, 2, 21))
    assert "No feedback"
  end
  
   def test_find_students_not_submitted_no_submissions
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.users = [user3]
    team2.user = @prof 
    team2.save 

    # No submissions made yet 
    assert_equal([user1, user2], team.users_not_submitted([]))
  end 

  def test_find_students_not_submitted_partial_submissions
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.users = [user3]
    team2.user = @prof 
    team2.save 

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)


    # No submissions made yet 
    assert_equal([user2], team.users_not_submitted([feedback]))

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback4 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
  end

  def test_find_students_not_submitted_all_submitted
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2]))
  end

  def test_find_students_not_submitted_over_submitted 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 2), team, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2, feedback3]))
  end 

  def test_find_students_not_submitted_user_not_in_team
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!    
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2')
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 3, 2), team2, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2, feedback3]))
  end

  def test_find_current_feedback 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    result = team.current_feedback(d=Date.new(2021, 3, 2))
    assert_includes( result, feedback )
    assert_includes( result, feedback2 )
    refute_includes( result, feedback3 )
    assert_equal( 2, result.length )
  end
  
  def test_generate_team_code 
    assert_equal(6, Team::generate_team_code(length = 6).size)
  end
  
  def test_status_no_feedback_submitted
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!     

    assert_equal('empty', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_status_partial_submitted_feedback 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    team = Team.new(team_code: '123456', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)

    assert_equal('empty', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_status_everyone_submitted_feedback_rating
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    team = Team.new(team_code: '123456', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(4, 4, 4, 4, "This team is organized", user1, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback2 = save_feedback(4, 4, 4, 4, "This team is organized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    
    assert_equal('green', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 3, 28)))
  end

  
  def test_green_rating6_low_urgency
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(2, 2, 2, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(2, 2, 2, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(2, 3, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('green', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_green_rating10_low_urgency
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(4, 4, 4, 4, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('green', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_green_rating8_medium_urgency
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(2, 3, 3, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(3, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 1)
    
    assert_equal('green', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_yellow_rating6_medium_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(2, 2, 2, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(2, 2, 2, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 1)
    feedback3 = save_feedback(2, 3, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('yellow', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_yellow_rating8_medium_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(2, 2, 2, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(3, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 1)
    
    assert_equal('yellow', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_yellow_status_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 0)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 1)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_red_rating_lessthan_6_low_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(2, 2, 2, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(2, 2, 2, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_red_rating_lessthan_6_med_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(2, 2, 2, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 1)
    feedback3 = save_feedback(2, 2, 2, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 1)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_red_rating_6to8_high_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 4, 4, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 0)
    feedback3 = save_feedback(3, 4, 4, 2, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_red_rating_morethan8_high_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(4, 4, 4, 4, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 0)
    feedback3 = save_feedback(4, 4, 4, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_red_status_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 0)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 0)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_red_status_rating
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2, user3]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 26), team, 0)
    feedback2 = save_feedback(1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_all_submit_false    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam2', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam3', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1, user2, user3]
    team.user = @prof 
    team.save!
    
    #feedback1 = save_feedback(5, 'a great week',DateTime.civil_from_format(:local, 2021, 3, 1),DateTime.civil_from_format(:local, 2021, 3, 1), DateTime.civil_from_format(:local, 2021, 3, 1), 2, 7, 1, 1, 1, 1)
    #feedback2 = save_feedback(5, 'a great week',DateTime.civil_from_format(:local, 2021, 3, 1),DateTime.civil_from_format(:local, 2021, 3, 1), DateTime.civil_from_format(:local, 2021, 3, 1), 2, 7, 1, 1, 1, 1)
    #Only two users gave feedback, method should return false
    feedback1 = Feedback.new(       
    team_id:1, 
    user_id:1, 
    priority:1, 
    contribution: 2, 
    attendance: 4, 
    respect: 4, 
    knowledge: 4, 
    comments: 'no contribution provided')

    feedback1.timestamp = feedback1.format_time(DateTime.now)
    feedback1.user = user1
    feedback1.team = team
    feedback1.save
    all_submit_result = team.all_submit(team.feedbacks)
    assert_equal false, all_submit_result
  end

  def test_all_submit_true    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'adam1', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.users = [user1]
    team.user = @prof 
    team.save!
    
    #feedback1 = save_feedback(5, 'a great week',DateTime.civil_from_format(:local, 2021, 3, 1),DateTime.civil_from_format(:local, 2021, 3, 1), DateTime.civil_from_format(:local, 2021, 3, 1), 2, 7, 1, 1, 1, 1)
    #feedback2 = save_feedback(5, 'a great week',DateTime.civil_from_format(:local, 2021, 3, 1),DateTime.civil_from_format(:local, 2021, 3, 1), DateTime.civil_from_format(:local, 2021, 3, 1), 2, 7, 1, 1, 1, 1)
    #Only two users gave feedback, method should return false
    feedback1 = Feedback.new(       
    team_id:1, 
    user_id:1, 
    priority:1, 
    contribution: 2, 
    attendance: 4, 
    respect: 4, 
    knowledge: 4, 
    comments: 'no contribution provided')

    feedback1.timestamp = feedback1.format_time(DateTime.now)
    feedback1.user = user1
    feedback1.team = team
    feedback1.save
    all_submit_result = team.all_submit(team.feedbacks)
    assert_equal true, all_submit_result
  end

  def test_no_members_submit_blank    
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = @prof 
    team.save!
    
    all_submit_result = team.all_submit(team.feedbacks)
    assert_nil all_submit_result
  end

  # test the sorting feature
  def test_sort_desc_letters_2_teams
    teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)
    teamB = Team.create(team_code: 'CodeB', team_name: 'Team B', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'desc'}

    result = Team.sort_teams(params)
    assert_equal result, [teamB, teamA] 
  end

  def test_sort_asc_letters_2_teams
    teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)
    teamB = Team.create(team_code: 'CodeB', team_name: 'Team B', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [teamA, teamB] 
  end

  def test_sort_desc_numbers_2_teams
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'desc'}

    result = Team.sort_teams(params)
    assert_equal result, [team2, team1] 
  end

  def test_sort_asc_numbers_2_teams
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [team1, team2] 
  end

  def test_sort_desc_multiple_teams
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
    team3 = Team.create(team_code: 'Code3', team_name: 'Team 3', user: @prof)

    params = {:sort => 'team_name', :direction => 'desc'}

    result = Team.sort_teams(params)
    assert_equal result, [team3, team2, team1] 
  end

  def test_sort_asc_multiple_teams
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
    team3 = Team.create(team_code: 'Code3', team_name: 'Team 3', user: @prof)

    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [team1, team2, team3] 
  end

  def test_sort_desc_number_letter
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)

    params = {:sort => 'team_name', :direction => 'desc'}

    result = Team.sort_teams(params)
    assert_equal result, [teamA, team1] 
  end

  def test_sort_asc_number_letter
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)

    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [team1, teamA] 
  end

  def test_sort_desc_one_team
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'desc'}

    result = Team.sort_teams(params)
    assert_equal result, [team1] 
  end

  def test_sort_asc_one_team
    team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
    
    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [team1] 
  end

  def test_sort_no_team
    params = {:sort => 'team_name', :direction => 'asc'}

    result = Team.sort_teams(params)
    assert_equal result, [] 
  end

end
