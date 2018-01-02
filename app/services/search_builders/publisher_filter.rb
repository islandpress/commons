module SearchBuilders
  class PublisherFilter
    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless @filters &&
                               @filters[:publisher].present?
      ignore_irrelevant_documents
      filter_by_publisher
      @es_params
    end

    private

    def ignore_irrelevant_documents
      @es_params[:query][:bool][:filter][:bool][:must] << {
        exists: { field: 'metadata.publisher' }
      }
    end

    def filter_by_publisher
      q = "select distinct metadata->>'publisher' from resources where "\
          "metadata->>'publisher' is not null order by "\
          "metadata->>'publisher' asc;"
      Rails.logger.info(ActiveRecord::Base.connection.execute(q).values.flatten)
      @es_params[:query][:bool][:filter][:bool][:must] << {
        match_phrase: { 'metadata.publisher': @filters[:publisher] }
      }
    end
  end
end
