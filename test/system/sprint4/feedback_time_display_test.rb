require "application_system_test_case"

# Acceptance Criteria:
# 1. As student, I should be able to see the time I have started a feedback
# 2. As a student, I should be able to see the time that I have submitted a feedback

class FeebackTimeDisplayTest < ApplicationSystemTestCase
  setup do
    @user = User.new(email: 'test@gmail.com', password: 'asdasd', password_confirmation: 'asdasd', name: 'Zac', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @user.teams << @team
    @user.save
      
    # Time.zone = 'Pacific Time (US & Canada)'

    #datetime =  Time.zone.parse("2021-3-21 23:30:00")
    #feedback_time = Time.zone.parse("2021-3-20 23:30:00")
    #travel_to datetime
    #current time March 25, 2022

    travel_to Time.new(2022, 3, 25, 16, 0, 0) 

  end 
    
  def test_time_displays
      


    visit root_url
    login 'test@gmail.com', 'asdasd'
    assert_current_path root_url
    travel_to Time.new(2022, 3, 25, 16, 0, 0)
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)
    click_on "Submit for"
    assert_text "Current System Time: 2022/03/25 16:00" #Acceptance criteria #1
    select 4, :from => "Q1: Everyone in the group is contributing equally."
    select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
    select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
    select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
    select "Medium", :from => "Urgency"
    click_on "Create Feedback"
    assert_current_path root_url
    assert_text "Feedback was successfully created. Time created: 2022-03-25 16:00:00" #Acceptance criteria #2
  else
    page.assert_no_selector "#feedbackbutton"
  end 
end 
  
end