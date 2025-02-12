class Language < ApplicationRecord
  include IdentityCache

  has_many :films
  cache_has_many :films
end
