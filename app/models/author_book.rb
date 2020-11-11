# frozen_string_literal: true

class AuthorBook < ApplicationRecord
  belongs_to :author
  belongs_to :book
end
