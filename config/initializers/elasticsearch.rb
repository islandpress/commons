Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV.fetch('BONSAI_URL', 'http://localhost:9200')
)
