require 'date'

def luhn_algorithm(number)
  sum = 0
  alt = false
  i = number.length - 1
  while i >= 0
    n = number[i].to_i
    if alt
      n *= 2
      n -= 9 if n > 9
    end
    sum += n
    alt = !alt
    i -= 1
  end
  (sum % 10).zero?
end

def generate_card_number(prefix, length)
  card_number = prefix.dup
  (length - prefix.length - 1).times { card_number << rand(0..9).to_s }

  check_digit = (0..9).find { |d| luhn_algorithm(card_number + d.to_s) }
  card_number + check_digit.to_s
end
#I made dis btch wit AI ngl
def generate_cvv(network)
  case network
  when :amex
    rand(1000..9999).to_s
  else
    rand(100..999).to_s
  end
end

def generate_expiration_date
  today = Date.today
  exp_year = today.year + rand(1..5)
  exp_month = rand(1..12)
  Date.new(exp_year, exp_month).strftime("%m/%y")
end

def generate_fake_card(network = :visa)
  card_number = case network
                when :visa
                  generate_card_number('4', 16)
                when :mastercard
                  prefix = %w[51 52 53 54 55].sample
                  generate_card_number(prefix, 16)
                when :amex
                  prefix = %w[34 37].sample
                  generate_card_number(prefix, 15)
                when :discover
                  generate_card_number('6011', 16)
                else
                  raise "Unknown card network: #{network}"
                end

  cvv = generate_cvv(network)
  expiration_date = generate_expiration_date

  card_type = network.to_s.capitalize
  "Card Type: #{card_type}\n" +
    "Card Number: #{card_number}\n" +
    "Expiration Date: #{expiration_date}\n" +
    "CVV: #{cvv}\n" +
    "-" * 30
end

puts generate_fake_card(:visa)
puts generate_fake_card(:mastercard)
puts generate_fake_card(:amex)
puts generate_fake_card(:discover)
