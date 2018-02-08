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
    @events = Resource.events.order('RANDOM()').first(6)
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

  def get_book_hash(title)
    bk = Resource.find_by_sql('select * from resources where title = '\
                                           "'%s'" % title)
    if bk and bk.first
    	bk = bk.first
	    bkh = { 'title' => bk.title,
	    		'id' => bk.id,
	    		'class' => 'form-box__link' }
    else
	    bkh = { 'title' => title,
  			    'id' => 0,
	    		'class' => 'form-box__redlink' }
	end
	bkh
  end

  def get_network_hash(name)
    net = Network.find_by_sql('select * from networks where name = '\
                                           "'%s'" % name)
    if net and net.first
    	net = net.first
	    neth = { 'name' => net.name,
	    		 'id' => net.id,
	    		 'class' => 'form-box__link' }
    else
	    neth = { 'name' => name,
  			     'id' => 0,
	    		 'class' => 'form-box__redlink' }
	end
	neth
  end

  def demo2
	@book1 = get_book_hash('An Acceptable Time')
    @book2 = get_book_hash('An Instant In The Wind')
    q = "select distinct metadata->>'publisher' from resources where metadata->>'publisher' "\
        "is not null order by metadata->>'publisher' asc;"
    @publisher_arr = ActiveRecord::Base.connection.execute(q).values.flatten
    q = "select distinct metadata->>'source' from resources where metadata->>'source' "\
        "is not null order by metadata->>'source' asc;"
    @source_arr = ActiveRecord::Base.connection.execute(q).values.flatten
    q = "select distinct metadata->>'language' from resources where metadata->>'language' "\
        "is not null order by metadata->>'language' asc;"
    @language_arr = ActiveRecord::Base.connection.execute(q).values.flatten
  end

  def demo4
	@book1 = get_book_hash('An Acceptable Time')
	@network1 = get_network_hash('BLAHKoss-Price')
  end

  def policy; end

  def about; end
end
