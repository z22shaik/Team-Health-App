require "application_system_test_case"
# Acceptance Criteria:
# 1. As a student, I cannot submit feedback without a rating
# 2. As a student, I can submit feedback without a comment
# 3. As a student, I cannot submit feedback with a comment greater than 2048 characters
# 4. As a student, I cannot submit feedback without a priority 

class CreateFeedbackValidationsTest < ApplicationSystemTestCase
   setup do
    @user = User.new(email: 'test@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Adam', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @user.teams << @team
    @user.save
    travel_to Time.new(2022, 3, 25, 16, 0, 0) 

  end 
  
  # def test_create_invalid_feedback_no_rating
  #   #Passes acceptance criteria 1: student cannot submit feedback without a rating
  #   #"Sad test", student tries to submit feedback without a rating    
  #   visit root_url
  #   login 'test@gmail.com', '123456789'
  #   assert_current_path root_url
    
  #   click_on "Submit for"
  #   select "Urgent", :from => "Urgency"
  #   fill_in "Comments", with: "I did not select a rating"
    
  #   click_on "Create Feedback"
  #   assert_text "Rating can't be blank"
  # end 
  
  def test_create_valid_feedback_no_comment
    #Passes acceptance criteria 2: Student can submit feedback with no comment
    #"Happy test", student submits feedback with no comments
    visit root_url
    login 'test@gmail.com', '123456789'
    assert_current_path root_url
    travel_to Time.new(2022, 3, 25, 16, 0, 0)
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)
      click_on "Submit for"
    
      select 4, :from => "Q1: Everyone in the group is contributing equally."
      select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
      select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
      select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
      select "Medium", :from => "Urgency"
      click_on "Create Feedback"
      assert_current_path root_url
      assert_text "Feedback was successfully created."
    else
      page.assert_no_selector "#feedbackbutton"
    end
  end 
  
  def test_create_invalid_feedback_too_many_characters_comment
    #Passes acceptance criteria 3: Student cannot submit a comment that has greater than 2048 characters
    #"Sad test", student tries to submit feedback with a comment that is greater than 2048 characters
    visit root_url
    login 'test@gmail.com', '123456789'
    assert_current_path root_url
    travel_to Time.new(2022, 3, 25, 16, 0, 0)
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)
     click_on "Submit for"
    
      select 4, :from => "Q1: Everyone in the group is contributing equally."
      select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
      select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
      select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
      select "Medium", :from => "Urgency"
      fill_in "Comments", with: "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"
    
      click_on "Create Feedback"
      assert_text "Comments Please limit your comment to 2048 characters or less!"
    else
      page.assert_no_selector "#feedbackbutton"
    end
  end
  
def test_create_valid_feedback_default_priority
    #Passes acceptance criteria 4: Student cannot submit feedback without priority, must change dropdown value from blank (default) to a valid value
    visit root_url
    login 'test@gmail.com', '123456789'
    assert_current_path root_url
    travel_to Time.new(2022, 3, 25, 16, 0, 0)
    if (Time.now.wday!=1 && Time.now.wday!=2 && Time.now.wday!=3 && Time.now.wday != 0) || (Time.now.wday == 0 && Time.now.hour < 18)
      click_on "Submit for"
    
      select 4, :from => "Q1: Everyone in the group is contributing equally."
      select 4, :from => "Q2: Everyone in the group is attending all meetings (unless they have an excused absence)."
      select 4, :from => "Q3: The group treats me with respect and provides constructive criticism for my work when needed."
      select 4, :from => "Q4: My group members take the time to share their knowledge and assist other members of the group when needed."
      select "Medium", :from => "Urgency"
      fill_in "Comments", with: "I did not select a priority, default of low set"
      click_on "Create Feedback"
      assert_current_path root_url
      assert_text "Feedback was successfully created."
    else
      page.assert_no_selector "#feedbackbutton"
    end
  end 
end
