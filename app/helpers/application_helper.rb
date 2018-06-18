module ApplicationHelper
  def formato_fecha(fecha)
    fecha.day.to_s+'/'+fecha.month.to_s+'/'+fecha.year.to_s
  end
end
