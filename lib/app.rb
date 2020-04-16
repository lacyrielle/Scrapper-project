require 'nokogiri'
require 'open-uri'

puts 'Hello'

# full html download
def get_page
    return Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
end

# get all lines of html table
def get_all_lines(page)
    return page.xpath('//tr[@class="cmc-table-row"]')
end

# parse one line and return hash
def parse_line(line)
    price = 0
    symbol = '---'
    line.children.each do |element|
        if element['class'].include? '__price'
            price = element.text
        elsif element['class'].include? '__symbol'
            symbol = element.text
        end
    end
    result = Hash.new
    result[symbol] = parse_price(price)
    return result
end

def parse_price(price_text)
    # TODO: remove$ and convert to float
    return price_text[1..-1].to_f
end

puts 'Download page...'
page = get_page
puts 'OK'

puts 'Extract lines...'
all_lines = get_all_lines(page)
puts 'OK'

# Test sur quelques lignes
#all_lines = all_lines.slice(0,4)

# Remplissage du tableau de hash
crypto_name_array = []

all_lines.each do |line|
    crypto_name_array.append(parse_line(line))
end

# affichage des 20 premiers
puts crypto_name_array.slice(0,20)

puts 'Bye'

