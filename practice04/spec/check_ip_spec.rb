require '../ip_validator'

RSpec.describe IPValidator do
  describe '#check_ip' do
    it 'повертає true для валідних IP-адрес' do
      expect(IPValidator.new('192.168.0.1').check_ip).to eq(true)
      expect(IPValidator.new('127.0.0.1').check_ip).to eq(true)
      expect(IPValidator.new('255.255.255.255').check_ip).to eq(true)
      expect(IPValidator.new('0.0.0.0').check_ip).to eq(true)
    end

    it 'повертає false для IP-адрес з ведучими нулями' do
      expect(IPValidator.new('192.168.01.1').check_ip).to eq(false)
      expect(IPValidator.new('010.10.10.10').check_ip).to eq(false)
    end

    it 'повертає false для IP-адрес з числами поза межами 0-255' do
      expect(IPValidator.new('256.100.50.0').check_ip).to eq(false)
      expect(IPValidator.new('192.300.0.1').check_ip).to eq(false)
    end

    it 'повертає false для IP-адрес з неправильним форматом' do
      expect(IPValidator.new('192.168.0').check_ip).to eq(false)  # Недостатньо частин
      expect(IPValidator.new('192.168.0.1.1').check_ip).to eq(false)  # Зайва частина
      expect(IPValidator.new('192 .168.0.1').check_ip).to eq(false)  # Пробіл між частинами
      expect(IPValidator.new('192.168..1').check_ip).to eq(false)  # Дві крапки підряд
    end

    it 'повертає false для нечислових значень' do
      expect(IPValidator.new('192.abc.0.1').check_ip).to eq(false)
      expect(IPValidator.new('hello.world').check_ip).to eq(false)
      expect(IPValidator.new('...').check_ip).to eq(false)
    end
  end
end