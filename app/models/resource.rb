class Resource < ApplicationRecord
  include Indexable
  include Taggable
  include Privacy

  attr_accessor :user_input

  RESOURCE_TYPES = {
    article: 0,
    audio: 1,
    book: 2,
    course: 3,
    dataset: 4,
    image: 5,
    post: 6,
    profile: 7,
    report: 8,
    slide: 9,
    software: 10,
    syllabus: 11,
    url: 12,
    video: 13
  }.freeze

  METADATA_FIELDS = %w(
    content_download_link
    creators
    publisher
    date
    publisher
    rights
    pages
    isbn
  ).freeze

  has_paper_trail

  # Warning: since this is an enum (stored as an integer), we need to preserve the original integers
  # each value is associated with. Otherwise the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type: RESOURCE_TYPES

  belongs_to :user, optional: true
  has_many :lists_items, as: :item
  has_many :lists, through: :lists_items

  validates :title, :resource_type, presence: true
  validates :url, length: { maximum: 255 }

  after_commit :enqueue_process_uploaded_file, if: :process_uploaded_file?, on: :create

  scope :sort_by_created_at, -> { order('created_at DESC') }

  RESOURCE_TYPES.keys.each do |type|
    scope type.to_s.pluralize, -> { where(resource_type: type) }
  end

  alias_attribute :name, :title

  def excerpt
    return short_content unless short_content.is_a?(String)
    short_content.truncate(500)
  end

  METADATA_FIELDS.each do |field|
    define_method field do
      metadata[field]
    end

    define_method "#{field}=" do |value|
      metadata[field] = value
    end
  end

  private

  def process_uploaded_file?
    user_input && content_download_link.present?
  end

  def enqueue_process_uploaded_file
    ProcessResourceFileJob.perform_async(id)
  end
end
