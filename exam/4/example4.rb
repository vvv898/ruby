class DynamicAttributes
  def initialize
    @attributes = {}
  end

  def method_missing(name, *args)
    method_name = name.to_s

    if method_name.end_with?('=')
      attribute_name = method_name.chomp('=').to_sym
      @attributes[attribute_name] = args.first
    else
      @attributes[name] || "Attribute '#{name}' not set"
    end
  end
end

obj = DynamicAttributes.new

# Використовуємо динамічні методи
obj.name = "Vika"
obj.age = 20

puts obj.name
puts obj.age
puts obj.city