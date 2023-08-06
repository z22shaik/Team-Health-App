# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'date'


option = Option.create()
option.generate_admin_code(6)



# CREATING USERS ADMIN - PROFESSORS

user1 = User.create(
	email: 'msmucker@gmail.com', 
	name: 'Mark Smucker', 
	is_admin: true, 
	password: 'professor', 
	password_confirmation: 'professor'
)


user2 = User.create(
	email: 'mpirnia@uwaterloo.ca', 
	name: 'Mehrdad Pirnia', 
	is_admin: true, 
	password: 'professor', 
	password_confirmation: 'professor'
)


# user3 = User.create(
# 	email: 'kmckay@uwaterloo.ca', 
# 	name: 'Ken Mckay', 
# 	is_admin: true, 
# 	password: 'professor', 
# 	password_confirmation: 'professor'
# )

# # CREATING USERS NON-ADMIN - STUDENTS



user4 = User.create(
	email: 's383pate@uwaterloo.ca', 
	name: 'Stuti Patel', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)



user5 = User.create(
	email: 'c28wen@uwaterloo.ca', 
	name: 'Christine Wen', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)


user6 = User.create(
	email: 'a77yang@uwaterloo.ca', 
	name: 'anita yang', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)




user7 = User.create(
	email: 'batwal@uwaterloo.ca', 
	name: 'Bhavraj Atwal', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)


user8 = User.create(
	email: 'christian.chan@uwaterloo.ca', 
	name: 'Christian Chan', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)


user9 = User.create(
	email: 'z22shaikh@uwaterloo.ca', 
	name: 'Zuhayr Shaikh', 
	is_admin: false, 
	password: 'password', 
	password_confirmation: 'password'
)



# # TEAMS:


team1 = Team.new(
	team_code: "ABC123",
	team_name: "Team 8 Female",
	user: user1, # smucker
	created_at: '2016-06-22 19:10:25-07',
	updated_at: '2016-06-22 19:10:25-07'	
)
team1.users = [user4, user5, user6]
team1.save




team2 = Team.new(
	team_code: "DEF456",
	team_name: "Team 8 Male",
	user: user2, # pirnia
	created_at: '2016-06-22 19:10:25-07',
	updated_at: '2016-06-22 19:10:25-07'	
)

team2.users = [user7, user8, user9]
team2.save

time_now = Time.new
week = "#{time_now.year}-#{time_now.month}-#{time_now.day} #{time_now.hour}:#{time_now.min}:00-01"

prev_week =time_now - 604800 # go 1 week before (604800 seconds)


# # # Stuti's - gal team, week 1
# # feedback1 = Feedback.create(
# # 	comments: "not a good week",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 1,
# # 	user_id: 4,
# # 	priority: 5,
# # 	contribution: 1,
# # 	attendance: 2,
# # 	respect: 4,
# # 	knowledge: 4,
# # )

# # # Christine's - gal team, week 1
# # feedback2 = Feedback.create(
# # 	comments: "an ok week",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 1,
# # 	user_id: 5,
# # 	priority: 7,
# # 	contribution: 3,
# # 	attendance: 1,
# # 	respect: 3,
# # 	knowledge: 3,
# # )

# # # Anita's - gal team, week 1
# # feedback3 = Feedback.create(
# # 	comments: "i like the team",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 1,
# # 	user_id: 6,
# # 	priority: 7,
# # 	contribution: 4,
# # 	attendance: 1,
# # 	respect: 3,
# # 	knowledge: 4,
# # )









# # # Bhavraj's - guy team, week 1
# # feedback4 = Feedback.create(
# # 	comments: "not a good week",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 2,
# # 	user_id: 7,
# # 	priority: 8,
# # 	contribution: 1,
# # 	attendance: 2,
# # 	respect: 4,
# # 	knowledge: 4,
# # )


# # # Christian's - guy team, week 1
# # feedback5 = Feedback.create(
# # 	comments: "an ok week",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 2,
# # 	user_id: 8,
# # 	priority: 5,
# # 	contribution: 1,
# # 	attendance: 2,
# # 	respect: 4,
# # 	knowledge: 3,
# # )


# # # Zuhayr's - guy team, week 1
# # feedback6 = Feedback.create(
# # 	comments: "mediocre",
# # 	timestamp: week,
# # 	created_at: week, 
# # 	updated_at: week, 
# # 	team_id: 2,
# # 	user_id: 9,
# # 	priority: 7,
# # 	contribution: 2,
# # 	attendance: 2,
# # 	respect: 3,
# # 	knowledge: 4,
# # )











# # Stuti's - gal team, week 2
# feedback7 = Feedback.create(
# 	comments: "things are better",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 1,
# 	user_id: 4,
# 	priority: 5,
# 	contribution: 2,
# 	attendance: 2,
# 	respect: 4,
# 	knowledge: 3,
# )


# # Christine's - gal team, week 3
# feedback8 = Feedback.create(
# 	comments: "things are worse",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 1,
# 	user_id: 5,
# 	priority: 10,
# 	contribution: 3,
# 	attendance: 2,
# 	respect: 3,
# 	knowledge: 4,
# )


# # Anita's - gal team, week 3
# feedback9 = Feedback.create(
# 	comments: "everything is on fire",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 1,
# 	user_id: 6,
# 	priority: 17,
# 	contribution: 3,
# 	attendance: 2,
# 	respect: 4,
# 	knowledge: 3,
# )








# # Bhavraj - guy team, week 2
# feedback10 = Feedback.create(
# 	comments: "a great week",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 2,
# 	user_id: 7,
# 	priority: 1,
# 	contribution: 4,
# 	attendance: 2,
# 	respect: 3,
# 	knowledge: 4,
# )


# # Christian - guy team, week 2
# feedback11 = Feedback.create(
# 	comments: "everything is broken",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 2,
# 	user_id: 8,
# 	priority: 10,
# 	contribution: 3,
# 	attendance: 2,
# 	respect: 4,
# 	knowledge: 4,
# )


# # Zuhayr's - guy team, week 2
# feedback12 = Feedback.create(
# 	comments: "nothing",
# 	timestamp: prev_week,
# 	created_at: prev_week, 
# 	updated_at: prev_week, 
# 	team_id: 2,
# 	user_id: 9,
# 	priority: 7,
# 	contribution: 3,
# 	attendance: 4,
# 	respect: 4,
# 	knowledge: 3,
# )


# # Bhavraj's rating of guy team, current week
# feedback13 = Feedback.create(rating: 5,
# 	comments: "a great week",
# 	timestamp: '2022-02-24 19:10:25-07',
# 	created_at: '2022-02-24 19:10:25-07', 
# 	updated_at: '2022-02-24 19:10:25-07', 
# 	team_id: 2,
# 	user_id: 7,
# 	priority: 1,
# 	contribution: 1,
# 	attendance: 1,
# 	respect: 1,
# 	knowledge: 1
# )


# # Christian's rating of guy team, current week
# feedback14 = Feedback.create(rating: 5,
# 	comments: "everything is broken",
# 	timestamp: '2022-02-24 19:10:25-07',
# 	created_at: '2022-02-24 19:10:25-07', 
# 	updated_at: '2022-02-24 19:10:25-07', 
# 	team_id: 2,
# 	user_id: 8,
# 	priority: 10,
# 	contribution: 1,
# 	attendance: 1,
# 	respect: 1,
# 	knowledge: 1
# )


# # Zuhayr's rating of guy team, current week
# feedback15 = Feedback.create(rating: 5,
# 	comments: "nothing",
# 	timestamp: '2022-02-24 19:10:25-07',
# 	created_at: '2022-02-24 19:10:25-07', 
# 	updated_at: '2022-02-24 19:10:25-07', 
# 	team_id: 2,
# 	user_id: 9,
# 	priority: 7,
# 	contribution: 1,
# 	attendance: 1,
# 	respect: 1,
# 	knowledge: 1
# )



=begin


# Stuti's - gal team, week 2
feedback7 = Feedback.create(
	comments: "things are better",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 1,
	user_id: 4,
	priority: 5,
	contribution: 2,
	attendance: 2,
	respect: 4,
	knowledge: 3,
)


# Christine's - gal team, week 3
feedback8 = Feedback.create(
	comments: "things are worse",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 1,
	user_id: 5,
	priority: 10,
	contribution: 3,
	attendance: 2,
	respect: 3,
	knowledge: 4,
)


# Anita's - gal team, week 3
feedback9 = Feedback.create(
	comments: "everything is on fire",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 1,
	user_id: 6,
	priority: 17,
	contribution: 3,
	attendance: 2,
	respect: 4,
	knowledge: 3,
)








# Bhavraj - guy team, week 2
feedback10 = Feedback.create(
	comments: "a great week",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 2,
	user_id: 7,
	priority: 1,
	contribution: 4,
	attendance: 2,
	respect: 3,
	knowledge: 4,
)


# Christian - guy team, week 2
feedback11 = Feedback.create(
	comments: "everything is broken",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 2,
	user_id: 8,
	priority: 10,
	contribution: 3,
	attendance: 2,
	respect: 4,
	knowledge: 4,
)


# Zuhayr's - guy team, week 2
feedback12 = Feedback.create(
	comments: "nothing",
	timestamp: prev_week,
	created_at: prev_week, 
	updated_at: prev_week, 
	team_id: 2,
	user_id: 9,
	priority: 7,
	contribution: 3,
	attendance: 4,
	respect: 4,
	knowledge: 3,
)


# Bhavraj's rating of guy team, current week
feedback13 = Feedback.create(
	comments: "a great week",
	timestamp: '2022-02-24 19:10:25-07',
	created_at: '2022-02-24 19:10:25-07', 
	updated_at: '2022-02-24 19:10:25-07', 
	team_id: 2,
	user_id: 7,
	priority: 1,
	contribution: 1,
	attendance: 1,
	respect: 1,
	knowledge: 1
)


# Christian's rating of guy team, current week
feedback14 = Feedback.create(
	comments: "everything is broken",
	timestamp: '2022-02-24 19:10:25-07',
	created_at: '2022-02-24 19:10:25-07', 
	updated_at: '2022-02-24 19:10:25-07', 
	team_id: 2,
	user_id: 8,
	priority: 10,
	contribution: 1,
	attendance: 1,
	respect: 1,
	knowledge: 1
)


# Zuhayr's rating of guy team, current week
#feedback15 = Feedback.create(
#	comments: "nothing",
#	timestamp: '2022-02-24 19:10:25-07',
#	created_at: '2022-02-24 19:10:25-07', 
	updated_at: '2022-02-24 19:10:25-07', 
	team_id: 2,
	user_id: 9,
	priority: 7,
	contribution: 1,
	attendance: 1,
	respect: 1,
	knowledge: 1
)

# insert feedback
#sql_add_feedback_13_to_team8male = "INSERT INTO feedbacks (comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES ('a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
#sql_add_feedback_14_to_team8male = "INSERT INTO feedbacks (comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES ('a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
#sql_add_feedback_15_to_team8male = "INSERT INTO feedbacks (comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES ('a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
#temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_13_to_team8male)
#temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_14_to_team8male)
#temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_15_to_team8male)

#Commented out our seed data (B&Z)
# # insert feedback
# sql_add_feedback_13_to_team8male = "INSERT INTO feedbacks (rating, comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES (5, 'a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
# sql_add_feedback_14_to_team8male = "INSERT INTO feedbacks (rating, comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES (5, 'a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
# sql_add_feedback_15_to_team8male = "INSERT INTO feedbacks (rating, comments, timestamp, created_at, updated_at, user_id, priority, contribution, attendance, respect, knowledge) VALUES (5, 'a great week','2022-02-24 19:10:25-07','2022-02-24 19:10:25-07', '2022-02-24 19:10:25-07', 2, 7, 1, 1, 1, 1);"
# temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_13_to_team8male)
# temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_14_to_team8male)
# temp = ActiveRecord::Base.connection.exec_query(sql_add_feedback_15_to_team8male)

=end
