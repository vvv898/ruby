require 'test/unit'

def is_ip?(ip)
  !!IPAddr.new(ip) rescue false
end

if __FILE__ == $0
  puts "Enter an IP address:"
  ip = gets.chomp

  if is_ip?(ip)
    puts "This is a valid IP address."
  else
    puts "This is an invalid IP address."
  end
end

class TestIPv4 < Test::Unit::TestCase
  def test_valid_ipadd
    assert(is_ip?("182.91.56.77"))
    assert(is_ip?("0.0.0.0"))
    assert(is_ip?("255.255.255.255"))
  end

  def test_invalid_ipadd
    assert(!is_ip?("186.244.256.126"))
    assert(!is_ip?("98.65.08.7"))
    assert(!is_ip?("dfs.scc.cac.we"))
    assert(!is_ip?("152. 67.9.45"))
    assert(!is_ip?("177.98.35"))
    assert(!is_ip?("155.840.156.86.23"))
    assert(!is_ip?(""))
  end
end