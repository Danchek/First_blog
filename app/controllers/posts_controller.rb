class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :signed_in, only: [:show, :edit, :update, :destroy]
  # GET /posts
  # GET /posts.json
  def index
    if current_user != nil
      @posts = Post.page(params[:page]).per(20)
    else
      @posts = Post.last(10)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if current_user == nil
        respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
        end
    else
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
    if current_user == nil
        respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
        end
    else
      if @post.user_id != current_user.id
        respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
        end
      end
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    #@post = current_user.Posts.new(post_params)
    if current_user != nil
      @post = Post.new(post_params)
      @post.user_id=current_user.id
      @post.date=Date.today
      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.user_id != current_user.id or current_user == nil
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
      end
    else
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if current_user != nil
      if @post.user_id != current_user.id
        respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
        end
      else
        @post.destroy
        respond_to do |format|
          format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'You do not have permisson for this action' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :date, :user_id)
    end
end
