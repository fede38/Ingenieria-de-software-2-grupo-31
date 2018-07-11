class QuestionMailer < ActionMailer::Base

  default from: "mail@example.com"

  def sendMail(viaje, decision, client)
    @client = client
    @viaje = viaje
    if decision == "q"
      mail(to: "#{@client.email}", subject: "Un usuario te ha hecho una pregunta en un viaje tuyo.",
           template_path: "question_mailer/sendMail", template_name: "preguntado.html.erb")
    else
      mail(to: "#{@client.email}", subject: "Han respondido a una pregunta que hiciste en un viaje.",
           template_path: "question_mailer/sendMail", template_name: "respondido.html.erb")
    end
  end
end
