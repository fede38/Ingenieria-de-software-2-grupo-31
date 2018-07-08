class Question < ApplicationRecord
  belongs_to :trips
  has_one :answer, dependent: :destroy
end
