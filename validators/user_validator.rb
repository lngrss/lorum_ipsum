class UserValidator
  def initialize(user, users)
    @user = user
    @users = users
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

    end
end
