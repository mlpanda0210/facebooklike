class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.page(params[:page]).order(created_at: :desc)
    @topic = Topic.new
    @likes = Like.limit(10).order(created_at: :desc)
  end

  def my_topic
    @topic = Topic.new
    @topics = Topic.where(user_id: current_user.id).order(created_at: :desc)
    @users = User.all
    @likes = Like.limit(10)

  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comment = @topic.comments.build
    @comments = @topic.comments.order(created_at: :asc)
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id

    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path, notice: '記事を投稿しました。' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to topics_path, notice: '記事を更新しました。' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: '記事を削除しました。' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def topic_params
    params.require(:topic).permit(:title, :content, :image, :image_cache)
  end
end
