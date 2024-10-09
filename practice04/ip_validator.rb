class IPValidator
  attr_reader :ip

  # Конструктор для ініціалізації з IP-адресою
  def initialize(ip)
    @ip = ip
  end

  # Метод для перевірки IP-адреси
  def check_ip
    parts = ip.split(".")

    # Перевіряємо, чи складається адреса з 4 частин
    return false unless parts.length == 4

    parts.all? do |part|
      # Перевіряємо, чи кожна частина є числом без ведучих нулів та знаходиться в межах 0-255
      part.match?(/\A[1-9]\d{0,2}\z|0\z/) && part.to_i.between?(0, 255)
    end
  end
end
