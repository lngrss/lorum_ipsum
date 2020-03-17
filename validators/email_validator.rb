class EmailValidator
  def initialize(email, emails)
    @email = email.to_s
    @emails = emails
  end

  def valid?
    validate
    @message.nil?
  end

  def message
    @message
  end

  private

    def validate
      if @email.empty?
        @message = "You need to enter a email."
      elsif !correct_format?
        @message = "Please enter a valid email."
      elsif @emails.include?(@email)
        @message = "#{@email} is already included in our list."
      end
    end

    def correct_format?
      @email.match? /.+@.+/
    end
end
