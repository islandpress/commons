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

  def get_list_hash(name)
    lst = List.find_by_sql('select * from lists where name = '\
                                           "'%s'" % name)
    if lst and lst.first
    	lst = lst.first
	    lst = { 'name' => lst.name,
	    		'id' => lst.id,
	    		'class' => 'form-box__link' }
    else
	    lst = { 'name' => name,
  			    'id' => 0,
	    		'class' => 'form-box__redlink' }
	end
	lst
  end

  def walkthru_content
	@press_list = get_list_hash('Presses - Sample Resources')
	@journal_list = get_list_hash('Journals - Sample Resources')
	@other_list = get_list_hash('Misc. Large and Small Publishers - Sample Resources')

    q = "select metadata->>'language' AS language, metadata->>'language_name' "\
        "as language_name from resources where metadata->>'language_name' "\
        "is not null   GROUP BY metadata->>'language', metadata->>'language_name';"
    @language_arr2 = ActiveRecord::Base.connection.execute(q).values

	q = "select source, resource_type, access, input_type, count from resource_summary;"
    tmp = ActiveRecord::Base.connection.execute(q).values

	rev_resource_map = Hash[Resource::RESOURCE_TYPES.map { |k, v| [v, k.to_s()] }]
	@data_counts = tmp.map {|item| [item[0], rev_resource_map[item[1]].pluralize, item[2], item[3], item[4]] }
  end

  def walkthru_sampleusers
	@book1 = get_book_hash('An Acceptable Time')
	@network1 = get_network_hash('BLAHKoss-Price')
  end

  def policy; end

  def about; end
end
