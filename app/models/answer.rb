class Answer < ApplicationRecord
  belongs_to :question, optional: true

  validates :respuesta, presence: true
end
