class StaticPagesController < ApplicationController
  layout false, only: :home

  def home
    @counts = Resource.group(:resource_type).count
    @networks = Network.order('RANDOM()').first(10)
    @books = Resource.books.order('RANDOM()').first(6)
    @articles = Resource.articles.order('RANDOM()').first(6)
    @reports = Resource.reports.order('RANDOM()').first(6)
    @audios = Resource.audios.order('RANDOM()').first(6)
    @courses = Resource.courses.order('RANDOM()').first(6)
    @datasets = Resource.datasets.order('RANDOM()').first(6)
    @syllabuses = Resource.syllabuses.order('RANDOM()').first(6)
    @videos = Resource.videos.order('RANDOM()').first(6)
  end

  def demo2
    @books = Resource.books.order('RANDOM()').first(6)
    @specific_book1 = Resource.find_by_sql("select * from resources where title = 'Heaven and Earth'").first
    @specific_book2 = Resource.find_by_sql("select * from resources where title = 'In Death Ground'").first
    q = "select distinct metadata->>'publisher' from resources where metadata->>'publisher' is not null order by metadata->>'publisher' asc;"
	@publisher_arr = ActiveRecord::Base.connection.execute(q).values.flatten
	#Rails.logger.info()
  end

  def demo9
    @specific_book1 = Resource.find_by_sql("select * from resources where title = 'Heaven and Earth'").first
    @specific_book2 = Resource.find_by_sql("select * from resources where title = 'In Death Ground'").first
  end

  def policy; end

  def about; end
end
