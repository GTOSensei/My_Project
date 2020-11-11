# frozen_string_literal: true

module RegexReview
  TEXT = /\A[a-zA-Z]+( [a-zA-Z,.:+;?!#$%&'*^`{|}~=-]+)*\Z/.freeze
  MAX_TITLE = 80
  MAX_COMMENT = 500
  MIN_RATE = 1
  MAX_RATE = 5
end
