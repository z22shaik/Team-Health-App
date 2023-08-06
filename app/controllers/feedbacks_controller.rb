class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:index, :show, :destroy, :update]
  before_action :get_user_detail
  # before_action :redirect_to_home
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
   
      
  def get_user_detail
    @user = current_user
  end

  # def redirect_to_home
  #   if (Time.now.monday? || Time.now.tuesday?) && @user.is_admin == false
  #     redirect_to root_url
  #   end
    
  # end

  # GET /feedbacks
  def index
    # @feedbacks = Feedback.all
    @feedbacks = Feedback.sort_feedbacks(params)
  end

  # GET /feedbacks/1
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  def create
      
    team_submissions = @user.one_submission_teams
      
    @feedback = Feedback.new(feedback_params)
    
    @feedback.timestamp = @feedback.format_time(now)
    @feedback.user = @user
    @feedback.team = @user.teams.first
    if team_submissions.include?(@feedback.team)
        redirect_to root_url, notice: 'You have already submitted feedback for this team this week.'
    elsif @feedback.save
      redirect_to root_url, notice: "Feedback was successfully created. Time created: #{@feedback.timestamp}"
    else
      render :new
    end
  end

  # PATCH/PUT /feedbacks/1
  def update
    if @feedback.update(feedback_params)
      redirect_to @feedback, notice: 'Feedback was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /feedbacks/:id
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feedback_params
      params.require(:feedback).permit(:contribution, :attendance, :respect, :knowledge, :comments, :priority)
    end
end
