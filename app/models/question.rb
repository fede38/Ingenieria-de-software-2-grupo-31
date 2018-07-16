class Question < ApplicationRecord
  belongs_to :trip, optional: true
  belongs_to :comentador, class_name: 'User', foreign_key: 'user_id', optional: true
  has_one :answer, dependent: :destroy

  validates :pregunta, presence: true
end
