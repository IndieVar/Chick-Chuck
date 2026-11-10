# frozen_string_literal: true

module Contents
  class NewsController < ApplicationController
    after_action :update_views, only: :show

    def index
      set_meta_tags(
        title: t('pages.news'),
        alternate: {
          'x-default' => news_index_url(locale: nil),
          'en' => news_index_url(locale: :en),
          'ru' => news_index_url(locale: :ru),
          'uk' => news_index_url(locale: :uk)
        }
      )

      @pagy, @news = pagy(News.where(published: true), items: 8, fragment: '#news')
      @news = @news.decorate
    end

    def show
      set_meta_tags(
        title: t('pages.news')
      )

      @new = News.find_by_id(params[:id]).decorate
      @news = News.all.decorate
      @commentable, @ratingable = @new
      @comment = Comment.new
      @pagy, @comments = pagy(@new.comments.where(commentable_type: News.name).newest, items: 10,
                                                                                       fragment: '#comments')
    end

    private

    def update_views
      return if request.is_crawler? || current_admin

      @new.update(views: @new.views + 1)
    end
  end
end
