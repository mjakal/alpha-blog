class ArticlesController < ApplicationController
  # call set_article method before edit, update, show and destroy 
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show, :search]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :search_query, only: [:search]

  def index
    # will_paginate gem syntax
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
    
  end

  def create
    # Inspect parameters sent to create method
    # render plain: params[:article].inspect

    # debug app with debugger breakpoint
    # debugger

    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      flash[:success] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render "new"
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
      redirect_to article_path(@article)
    else
      render "edit"
    end
  end

  def show

  end

  def destroy
    @article.destroy
    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path
  end

  def search
    @articles = Article.search_articles(params[:search], params[:page])

    if @articles.any?
      render "search"
    else
      flash[:danger] = "No results found"
      redirect_to articles_path
    end
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        flash[:danger] = "You can only edit or delete your own articles"
        redirect_to root_path
      end
    end

    # validates user input before search
    def search_query
      query = params[:search]

      if query.length < 3 || query.length > 30
        flash[:danger] = "Wrong input"
        redirect_to articles_path
      end
    end
end