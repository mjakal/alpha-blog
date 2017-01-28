class ArticlesController < ApplicationController
  # call set_article method before edit, update, show and destroy 
  before_action :set_article, only: [:edit, :update, :show, :destroy] 

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
    @article.user = User.first

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

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description)
    end
end