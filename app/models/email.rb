class Email < ApplicationRecord

  ## ASSOCIATIONS
  belongs_to :setting

  ## VALIDATIONS
  validates :address, presence: true, uniqueness: { case_sensitive: false }, format:{
    with: Regexp.new(ENV['email_regex']),
    allow_blank: true
  }

end
