require 'test_helper'
require 'date'
class FeedbackTest < ActiveSupport::TestCase
  setup do
    @user = User.new(email: 'xyz@gmail.com', password: '123456789', password_confirmation: '123456789', name: 'Adam', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    
    @team = Team.create(team_name: 'Test Team 1', team_code: 'TEAM_A', user: @prof)
    @user.teams << @team
    @user.save
  end
  
  test 'valid feedback' do
    #feedback with rating and comment and priority
    feedback = Feedback.new(
      comments: "Some test comment here", 
      team_id:1, 
      user_id:4, 
      priority:0, 
      contribution: 4, 
      attendance: 4, 
      respect: 4, 
      knowledge: 4)
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    assert feedback.valid?

    #feedback with no optional comment
    feedback2 = Feedback.new(
      team_id:1, 
      user_id:4, 
      priority:0, 
      contribution: 4, 
      attendance: 4, 
      respect: 4, 
      knowledge: 4)
    feedback2.timestamp = feedback2.format_time(DateTime.now)
    feedback2.user = @user
    feedback2.team = @user.teams.first
    feedback2.save
    assert feedback2.valid?
  end

  test 'invalid feedback comment over 2048 characters' do
    #test with 2050 characters 
    feedback = Feedback.new(priority: 2, comments: "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")
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, 'Please limit your comment to 2048 characters or less!'
    assert_not_nil feedback.errors[:comments]
  end 
  
  test 'valid feedback comment with 2048 characters' do
    #test with 2048 characters 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 4, 
    attendance: 4, 
    respect: 4, 
    knowledge: 4, 
    comments: "zeAUPevpnNGjDVT0spzptxYP29b69jYsVJ2TyC8kHpflVZ2cjyCC3AQwIKYuo04HilhpyhzQY0UNOSUBCBweioLkD7pZBMsOdeusulIQXIxfA8I8LRP6OCBTR59PIGjSzCm6y5SeMAcfiB3RzE0lTZYxZIpofc4pmRsPqWzUdz6b1ADnZJFoVscOQtgJAjSTyh2G0HxpjFY9r2o8nRAZz6v3jujWVirPUXbTkBSH80YIvZ5SrwLJa1QrZI6UQRoFJhPuOHWjSmkiSe7KQYUrjijkiYLBVWORPrbe9JUOXJphUsbp2kP7Gn8WSVFWWgutb6E2NbbroD0VLNU30E7mshqwGSUG9nJwru5iL2QN2oJ89LcD2IAZVOcet55M1b3sO712DGQ9Cg1qAFlhylFEucE1hAxwrFqKvDL9B1N2hiSzja8Mgj69dmopyuhYeMk2DxjYJZVllt8iOyLoAhrtgqP8ZPTgoBgc6GqEK5rPDd6cY0bPApZzCcooxTBv3ueViQKMjI5WucuROUryJl11KT32iULPEStjy5RWjOH3LjyVCkV9Z5xnZdu4loyX8tPZWHmktj1kZCm9vsQj2JkCF6qJWtIrJ8LGir7B1JwpmR0NCk7PExbSz56DBYWfWiqYeyMrtY04lYGT8DwZAsROYUhP7B9BmjG4eAe9cFc3mQPnc2mHm5hx4f0Z2n3D1V5IMFlnPFVOjMjC3nk0mGBK0zKvh9Mvhmw2MUQ2NEZBfeclrcpxWn0fZ8eTsJxsxaKGX5YgHlxthmMnRXc37AgLiQ1skR6q2Y25N9lYL1jdKQ20KWiPRPU5e11ZOk0dtgptYZ4XsUBbTdZeAMdTGRzahgG1eVViiyCHL0HCCIWO9qhgIxN0jIrLr51dY4KrYf33bABid6Z6Q4oQAXjBwKh0I47iSl7RMBb5ucRfGdJPPdRJ4TylfPONbFBenokJtlYfPhKSE2xohtNN3t8x6GUjLPf1Vsuse4BhRoW7keb12Atp1AnpbOevlwTr8VzBnIU8xciD1cke4WJLRCAiFPM32qqnXvFxUyUH9q8eUEczCFaDQwTwwCLCvYc9LCepm6tHsgPGwaeNMQW9zx5cMxmuKQkFr8OKOSlAG6qwLt8batQViuZo3Gd9Jw4tp7yfiNezgXAGVSEpoI5yQZQEhADIWh8pLS9ZgSSKWxRkffyjHXV9BNMN8RoEthLhKXXz5qcHPuuq8qt0UKeKSjtgM5rr623QEu2ffBUFPgtGOgDR3p64IVpBE7YRbMPYkqoFFqZcNMIwGmxFg5wAjclls9DTgpJ4E5l9JmqkpI3aWfTTG3msOxwEFwKANem9CRIRXzVJlI7jLuyiwIfq2Hoce8mlKqJgtY5jE5jLyP2GZKu6Ik9BEHZNCujwqqDuVeWmgt1okB56BABk6ybSufeMphTtfBoVIMnRkxfcVuLHtRLqeH90XSaR6WHmIm4uWouN37vdDYN2ETrtPMDrxbSg7mUQPCcJsJa65TMHLGalJjUQJrRsAZRbw15hJBdZiGe03vMsu8hQhUBOJsxossfJnFXRF5RtH06S55mfjB2FKaHhPMCHkSgI3PNvxAqdfr6XOuELqoHKqvgRvlsBpdTcxfobMbZcDWpeYqTV2G9qC2PMxcpN0g3jtcCT6g8nsOLIRU3WE5iT8Tc830nE32H9iiHItz04fzvjnyepioS4LIKmqaAhCxtsJRJSAkrsOjuCzEVAdcAHwBHmfz6SCgkdJaVOrkjMxhh7GHAxNI9PIqkqvWrG28gmANnrGSayXtawcvEIS2bZPGYfeeCoU8MDXFJ7CoehmdTrQIcxMUDf7D0qE5dSNBFwMtIjWjq9XV6xRiUhlLo2G9LGTjiAlURdxRquTCgYhhiPOAbhzkmrd3MKrpEmdRoTAD0Wl91kYR3RX6IVuiveZnZF9FeZk7smJAOHkIJYAsY8HQtkuCTDEQnzCn7ycXj81CvhWdvOedu17q5uevN8dQp0F681aY4hoBl7NEkVgQdzbHwpiBgXJh7bTrlcfeJauxYa0kpunYByKxVQ")
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    assert feedback.valid?
  end 
  
  test 'invalid feedback no contribution provided' do 
    #when students do not submit a rating 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: nil, 
    attendance: 4, 
    respect: 4, 
    knowledge: 4, 
    comments:"no contribution provided")
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, "Contribution can't be blank"
    assert_not_nil feedback.errors[:contribution]
  end 
  

  test 'invalid feedback no attendance provided' do 
    #when students do not submit a rating 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 4, 
    attendance: nil, 
    respect: 4, 
    knowledge: 4, 
    comments:"no contribution provided")
  
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, "Contribution can't be blank"
    assert_not_nil feedback.errors[:attendance]
  end 


  test 'invalid feedback no respect provided' do 
    #when students do not submit a rating 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 4, 
    attendance: 4, 
    respect: nil, 
    knowledge: 4, 
    comments:"no respect provided")
  
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, "respect can't be blank"
    assert_not_nil feedback.errors[:respect]
  end 


  test 'invalid feedback no knowledge provided' do 
    #when students do not submit a rating 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: nil, 
    attendance: 4, 
    respect: 4, 
    knowledge: nil, 
    comments:"no contribution provided")
  
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, "knowledge can't be blank"
    assert_not_nil feedback.errors[:knowledge]
  end 

  test 'invalid feedback no priority provided' do 
    #when students do not submit a rating 
    feedback = Feedback.new(      
    team_id:1, 
    user_id:4, 
    priority:"", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided")
  
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = @user
    feedback.team = @user.teams.first
    feedback.save
    refute feedback.valid?, "priority can't be blank"
    assert_not_nil feedback.errors[:priority]
  end 

# TODO: Test average rating

# test the sorting feature
def test_sort_desc_letters_2_teams
  teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)
  teamB = Team.create(team_code: 'CodeB', team_name: 'Team B', user: @prof)

  @user.teams.push(teamA, teamB)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: teamA)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: teamB)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save
    
  params = {:sort => 'teams.team_name', :direction => 'desc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:team_name), [teamB.team_name, teamA.team_name]
end

def test_sort_asc_letters_2_teams
  teamA = Team.create(team_code: 'CodeA', team_name: 'Team A', user: @prof)
  teamB = Team.create(team_code: 'CodeB', team_name: 'Team B', user: @prof)

  @user.teams.push(teamA, teamB)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: teamA)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: teamB)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save
    
  params = {:sort => 'teams.team_name', :direction => 'asc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:team_name), [teamA.team_name, teamB.team_name]
end

def test_sort_desc_numbers_2_teams
  team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
  team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)

  @user.teams.push(team1, team2)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team2)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save
    
  params = {:sort => 'teams.team_name', :direction => 'desc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:team_name), [team2.team_name, team1.team_name]
end

def test_sort_asc_numbers_2_teams
  team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
  team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)

  @user.teams.push(team1, team2)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:0, 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team2)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save
    
  params = {:sort => 'teams.team_name', :direction => 'desc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:team_name), [team2.team_name, team1.team_name]
end

def test_sort_desc_urgency
  team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
  team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
  team3 = Team.create(team_code: 'Code3', team_name: 'Team 3', user: @prof)

  @user.teams.push(team1, team2, team3)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:"High", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:"Medium", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team2)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save

  feedback3 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:"Low", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback3.timestamp =  feedback3.format_time(DateTime.now)
  feedback3.save
    
  params = {:sort => 'priority', :direction => 'desc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:priority), [feedback2.priority, feedback3.priority, feedback1.priority]
end

def test_sort_asc_urgency
  team1 = Team.create(team_code: 'Code1', team_name: 'Team 1', user: @prof)
  team2 = Team.create(team_code: 'Code2', team_name: 'Team 2', user: @prof)
  team3 = Team.create(team_code: 'Code3', team_name: 'Team 3', user: @prof)

  @user.teams.push(team1, team2, team3)

  feedback1 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:"High", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback1.timestamp =  feedback1.format_time(DateTime.now)
  feedback1.save

  feedback2 = Feedback.new( 
    team_id:1, 
    user_id:4, 
    priority:"Medium", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team2)

  feedback2.timestamp =  feedback2.format_time(DateTime.now)
  feedback2.save

  feedback3 = Feedback.new(
    team_id:1, 
    user_id:4, 
    priority:"Low", 
    contribution: 1, 
    attendance: 4, 
    respect: 4, 
    knowledge: 1, 
    comments:"no contribution provided",
    user: @user,
    team: team1)

  feedback3.timestamp =  feedback3.format_time(DateTime.now)
  feedback3.save
    
  params = {:sort => 'priority', :direction => 'asc'}

  result = Feedback.sort_feedbacks(params)
  assert_equal result.pluck(:priority), [feedback1.priority, feedback3.priority, feedback2.priority]
end

end
