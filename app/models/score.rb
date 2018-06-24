class Score < ApplicationRecord
	belongs_to :calificado, :class_name => 'User', foreign_key: 'calificado_id'
	belongs_to :creador, :class_name => 'User', foreign_key: 'creador_id', optional: true

  validate :noBlank, on: :update

  def noBlank
    if self.descripcion.blank?
      errors.add('La descripción no puede estar en blanco.', "")
    end
  end
end
