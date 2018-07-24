class ContactForm < MailForm::Base
  attribute :name
  attribute :email
  attribute :message
  validates :message, presence: true

  def headers
    {
      :subject => "Contacto",
      :to => "unaventon1@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end
