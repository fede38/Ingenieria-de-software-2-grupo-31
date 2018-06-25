class TripMailer < ActionMailer::Base

  default from: "mail@example.com"

  def sendMail(viaje, decision, client)
    @client = client
    @viaje = viaje
    if decision == "a"
      mail(to: "#{@client.email}", subject: "Has sido aceptado en un viaje!",
           template_path: "trip_mailer/sendMail", template_name: "aceptado.html.erb")
    elsif decision == 'r'
      mail(to: "#{@client.email}", subject: "Has sido rechazado en un viaje.",
           template_path: "trip_mailer/sendMail", template_name: "rechazado.html.erb")
    elsif decision == 'x'
      mail(to: "#{@client.email}", subject: "Un viaje ha sido cancelado", 
            template_path: "trip_mailer/sendMail", template_name: "cancelado.html.erb")
    elsif decision == 'e'
      mail(to: "#{@client.email}", subject: "Has sido eliminado de un viaje.",
           template_path: "trip_mailer/sendMail", template_name: "eliminado.html.erb")
    else
      mail(to: "#{@client.email}", subject: "Un copiloto se ha dado de baja.",
           template_path: "trip_mailer/sendMail", template_name: "cancelar.html.erb")
    end
  end
end
