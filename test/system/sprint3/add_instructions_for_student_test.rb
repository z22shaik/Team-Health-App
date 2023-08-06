require "application_system_test_case"

# Acceptance Criteria: 
# 1. As a student, I should be able to see help instructions regarding submission of feedbacks

class AddReportsTogglesTest < ApplicationSystemTestCase
  setup do
    Option.create()
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @steve = User.create(email: 'steve@gmail.com', name: 'Steve', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @steve.teams << @team
    travel_to Time.new(2022, 3, 25, 16, 0, 0) 

  end
  
  def test_feedback_instructions
    visit root_url 
    login 'steve@gmail.com', 'testpassword'    
    travel_to Time.new(2022, 3, 25, 16, 0, 0)
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)      
      click_on "Submit for"
      assert_text "Please provide feedback on how well you believe your team performed this period using the dropdowns below.\nQ1-Q4: For each specific statement, select the option that best fits your team. Urgency: This field will determine the level of instructor intervention required.\nYou may enter optional comments in the text area below with a maximum of 2048 characters. If you require further assistance, please click on the 'Help' tab (on the top right corner of this page) before submitting your feedback"
    else
      page.assert_no_selector "#feedbackbutton"
    end
  end

end