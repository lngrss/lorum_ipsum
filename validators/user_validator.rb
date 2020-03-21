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
      if @users.where(@user).empty?
        @message = "This user doesn't exist"
      elsif @user.any? { |str| str.nil? }
        @message = "Please enter all necessary information"
      end
    end
end
