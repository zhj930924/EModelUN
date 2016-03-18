class CommentsController < ApplicationController
  def index
    @comments = Comment.hash_tree(limit_depth: 2)
    @filterrific = initialize_filterrific(
      Comment,
      params[:filterrific]
    ) or return
    @comments = @filterrific.find.page(params[:page])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @comment = Comment.new(parent_id: params[:parent_id], directive_id: params[:directive_id], function: params[:function])
  end
  
  def create
  if params[:comment][:parent_id].to_i > 0
    parent = Comment.find_by_id(params[:comment].delete(:parent_id))
    @comment = parent.children.build(comment_params)
    @comment.directive_id = parent.directive_id
    @comment.function = parent.function
  else
    @comment = Comment.new(comment_params)
  end

  if @comment.save
    flash[:success] = 'Your comment was successfully added!'
    redirect_to root_url
  else
    render 'new'
  end
end
  
  private
  
    def comment_params
      params.require(:comment).permit(:directive_id, :content, :parent_id, :function)
    end

end