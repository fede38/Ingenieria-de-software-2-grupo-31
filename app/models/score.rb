class Score < ApplicationRecord
	belongs_to :calificado, :class_name => 'User', foreign_key: 'user_id'
	belongs_to :creador, :class_name => 'User', foreign_key: 'user_id'
end
