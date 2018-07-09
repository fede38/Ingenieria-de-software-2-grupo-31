class Answer < ApplicationRecord
  belongs_to :question

  validates :respuesta, presence: true
end
