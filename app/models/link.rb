class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: { no_local: true}

  def gist?
    self.url.include?('gist.github.com')
  end
end
