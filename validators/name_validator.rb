class NameValidator
  def initialize(name, names)
    @name = name.to_s
    @names = names
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
      if @name.empty?
        @message = "You need to enter a name."
      elsif !without_numbers?
        @message = "Please enter a valid name."
      elsif @names.include?(@name)
        @message = "#{@name} is already included in our list."
      end
    end

    def without_numbers?
      (0..9).to_a.none? { |num| @name.include? num.to_s }
    end
end
