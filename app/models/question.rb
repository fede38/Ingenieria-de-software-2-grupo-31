class Question < ApplicationRecord
  belongs_to :trips
  belongs_to :comentador, class_name: 'User', foreign_key: 'user_id'
  has_one :answer, dependent: :destroy
end
