class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :team

  #attribute :priority, default: " "

  #requires feedback to answer contribution, attendance, respect, knowledge
  #comments are optional 
  validates_presence_of :contribution, :attendance, :respect, :knowledge, :priority
  #allows a max of 2048 characters for additional comments
  validates_length_of :comments, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"

  def format_time(given_date)
  #refomats the UTC time in terms if YYYY/MM?DD HH:MM
      #current_time = given_date.in_time_zone('Eastern Time (US & Canada)').strftime('%Y/%m/%d %H:%M')
      current_time = given_date.strftime('%Y/%m/%d %H:%M')
      return current_time
  end
  
  # takes list of feedbacks and returns average rating
  def self.average_rating(feedbacks)
    # 4x+4x+4x+4x = 10 points
    # 4 (0.625)+ 4 (0.625)+ 4 (0.625)+ 4 (0.625)=10
    if feedbacks.count > 0
      average_rating = 0
      weight = 0.625 
      for x in feedbacks do
        temp = x
        feedback_rating = 0.625*x.contribution+0.625*x.attendance+0.625*x.respect+0.625*x.knowledge
        average_rating = average_rating + feedback_rating
      end
	  average_rating = (average_rating / feedbacks.length).round(2)
    else
      return nil
    end
  end



  def self.sort_feedbacks( params )
    Feedback.joins(:team).order(Feedback.sort_column_feedbacks(params) + ' ' + Feedback.sort_direction_feedbacks(params))
  end

  # reference for sort: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
  def self.sort_column_feedbacks(params)
    Feedback.joins(:team).column_names.include?(params[:sort]) ? params[:sort] : "teams.team_name"
  end

  def self.sort_direction_feedbacks(params)
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end


end
