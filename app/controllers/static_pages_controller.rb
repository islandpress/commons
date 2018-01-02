class StaticPagesController < ApplicationController
  layout false, only: :home

  def home
    @counts = Resource.group(:resource_type).count
    @networks = Network.order('RANDOM()').first(10)
    @articles = Resource.articles.order('RANDOM()').first(6)
    @audio = Resource.audio.order('RANDOM()').first(6)
    @books = Resource.books.order('RANDOM()').first(6)
    @courses = Resource.courses.order('RANDOM()').first(6)
    @datasets = Resource.datasets.order('RANDOM()').first(6)
    @images = Resource.images.order('RANDOM()').first(6)
    @posts = Resource.posts.order('RANDOM()').first(6)
    @profiles = Resource.profiles.order('RANDOM()').first(6)
    @reports = Resource.reports.order('RANDOM()').first(6)
    @slides = Resource.slides.order('RANDOM()').first(6)
    @software = Resource.software.order('RANDOM()').first(6)
    @syllabi = Resource.syllabi.order('RANDOM()').first(6)
    @urls = Resource.urls.order('RANDOM()').first(6)
    @videos = Resource.videos.order('RANDOM()').first(6)
  end

  def demo2
    @books = Resource.books.order('RANDOM()').first(6)
    @specific_book1 = Resource.find_by_sql('select * from resources where title = '\
                                           '"An Acceptable Time"').first
    @specific_book2 = Resource.find_by_sql('select * from resources where title = '\
                                           '"An Instant In The Wind"').first
    q = "select distinct metadata->>'publisher' from resources where metadata->>'publisher' "\
        "is not null order by metadata->>'publisher' asc;"
    @publisher_arr = ActiveRecord::Base.connection.execute(q).values.flatten
  end

  def policy; end

  def about; end
end
