module SearchBuilders
  class SourceFilter
    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless @filters &&
                               @filters[:source].present?
      ignore_irrelevant_documents
      filter_by_source
      @es_params
    end

    private

    def ignore_irrelevant_documents
      @es_params[:query][:bool][:filter][:bool][:must] << {
        exists: { field: 'metadata.source' }
      }
    end

    def filter_by_source
      q = "select distinct metadata->>'source' from resources where "\
          "metadata->>'source' is not null order by "\
          "metadata->>'source' asc;"
      Rails.logger.info(ActiveRecord::Base.connection.execute(q).values.flatten)
      @es_params[:query][:bool][:filter][:bool][:must] << {
        match_phrase: { 'metadata.source': @filters[:source] }
      }
    end
  end
end
