module SearchBuilders
  class LanguageFilter
    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless @filters &&
                               @filters[:language].present?
      ignore_irrelevant_documents
      filter_by_language
      @es_params
    end

    private

    def ignore_irrelevant_documents
      @es_params[:query][:bool][:filter][:bool][:must] << {
        exists: { field: 'metadata.language' }
      }
    end

    def filter_by_language
      q = "select distinct metadata->>'language' from resources where "\
          "metadata->>'language' is not null order by "\
          "metadata->>'language' asc;"
      Rails.logger.info(ActiveRecord::Base.connection.execute(q).values.flatten)
      @es_params[:query][:bool][:filter][:bool][:must] << {
        match_phrase: { 'metadata.language': @filters[:language] }
      }
    end
  end
end
