module Yumi
  module Presenters
    class Relationships
      def initialize(presenter)
        @presenter = presenter
      end

      def to_json_api
        @presenter.relationships.each_with_object({}) do |rel, hash|
          value = @presenter.resource.send(rel)
          hash[rel] = presenter(rel, value).as_relationship if value
        end
      end

      private

      def prefix
        @prefix ||= "#{@presenter.type.pluralize}/#{@presenter.resource.id}/"
      end

      def presenter(rel, value)
        Yumi::Utils::PresenterHelper.new(url: @presenter.url,
                                         resource: value,
                                         presenter_module: @presenter.presenter_module,
                                         prefix: prefix).presenter_from_rel(rel)
      end
    end
  end
end
