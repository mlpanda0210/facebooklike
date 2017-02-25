class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comments_params)
    @topic = @comment.topic
    @notification = @comment.notifications.build(user_id: @topic.user.id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました' }
        format.js {render :index}
        unless @comment.topic.user_id == current_user.id
          Pusher.trigger("user_#{@comment.topic.user_id}_channel","comment_created",{
            message: "あなたの作成した投稿にコメントがつきました"
            })
          end
          Pusher.trigger("user_#{@comment.topic.user_id}_channel","notification_created",{
            unread_counts: Notification.where(user_id: @comment.topic.user.id, read: false).count
            })
          else
            format.html { render :new }
          end
        end
      end

      def edit
        @comment = Comment.find(params[:id])
        respond_to do |format|
          format.js {render :edit}
        end
      end

      def update
        @comment = Comment.find(params[:id])
        @topic = @comment.topic
        @comments = @topic.comments.order(created_at: :desc)
        respond_to do |format|
          if @comment.update(comments_params)
            format.html { redirect_to topic_path(@topic), notice: 'コメントを更新しました' }
            format.js {render :update}
          else
            format.js {render :new}
          end
        end
      end


      def destroy
        @comment = Comment.find(params[:id])
        respond_to do |format|
          if @comment.destroy
            format.html { redirect_to topic_path(@topic), notice: 'コメントを削除しました' }
            format.js {render :index}
          else
            format.html { render :new }
          end
        end
      end

      private
      def comments_params
        params.require(:comment).permit(:topic_id, :content)
      end
    end
