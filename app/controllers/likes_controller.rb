class LikesController < ApplicationController
  respond_to :js
  def create
    @like = current_user.likes.create!(user_id: current_user.id, topic_id: params[:topic_id],likes_count: 1)
    @topic = Topic.find_by(id: params[:topic_id])
    @topics = Topic.all
    @likes = Like.where(topic_id: params[:topic_id])

  end

  def destroy
    like = Like.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    @topic = Topic.find_by(id: params[:topic_id])
    like.destroy
  end

  private
  def like_params
    params.require(:like).permit(:user_id,:topic_id)
  end
end
