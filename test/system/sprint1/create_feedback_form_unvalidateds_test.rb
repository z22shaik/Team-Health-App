require "application_system_test_case"

# Acceptance Criteria: 
# 1. When I submit the feedback form, all the input data should be added to
#    the database
# 2. When I select the rating dropdown, all the appropriate ratings should
#    appear
# 3. When I submit the feedback form, the data shold be associated with my 
#    team in the database

class CreateFeedbackFormUnvalidatedsTest < ApplicationSystemTestCase
  setup do
    # create prof, team, and user
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @bob = User.create(email: 'bob@gmail.com', name: 'Bob', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @bob.teams << @team
    travel_to Time.new(2022, 3, 25, 16, 0, 0) 
  end
  
  # Test that feedback can be added using correct form (1, 2)
  def test_add_feedback 
    visit root_url 
    login 'bob@gmail.com', 'testpassword'    
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)
      click_on "Submit for"
      assert_current_path new_feedback_url
      assert_text "Your Current Team: Test Team"
    
      select 4, :from => "Q1: Everyone in the group is contributing equally."
      select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
      select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
      select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
      select "Medium", :from => "Urgency"
      fill_in "Comments", with: "This week has gone okay."
      click_on "Create Feedback"
    
      assert_current_path root_url
    
      Feedback.all.each{ |feedback| 
      assert_equal(1 , feedback.priority)
      assert_equal('This week has gone okay.', feedback.comments)
      assert_equal(@bob, feedback.user)
      assert_equal(@team, feedback.team)
      }
    else
      page.assert_no_selector "#feedbackbutton"
    end
  end
  
  # Test that feedback that is added can be viewed (1, 3)
  def test_view_feedback 
    feedback = Feedback.new(contribution: 1, attendance: 1, respect: 1, knowledge: 1, comments: "This team is disorganized", priority: 0)
    datetime = Time.current
    feedback.timestamp = feedback.format_time(datetime)
    feedback.user = @bob
    feedback.team = @bob.teams.first
    feedback.save
    
    visit root_url 
    login 'msmucker@gmail.com', 'professor'
    
    click_on "Details"
    assert_current_path team_url(@team)
    assert_text "This team is disorganized"
    assert_text "2.5"
    assert_text "High"
    assert_text "Test Team"
    assert_text datetime.strftime("%Y-%m-%d %H:%M")
  end
end
