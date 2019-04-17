require_relative "scrap.rb"
require 'bundler'
Bundler.require



class MailList
  attr_accessor :original_scrap
  attr_reader :nb_cols, :save_path

#=====public methods
  def initialize(original_scrap, save_path = nil)
    @original_scrap = original_scrap
    @nb_cols = 2
    @save_path = save_path || File.expand_path("../../db/", __dir__)
  end

  def save_as_csv_doc
    csv_string = convert_to_csv_string
    puts "list converted to string of csv format"
    time_id = (Time.now).to_s.split(" ")[0..1].join("_")
    filepath = File.expand_path("mails_mairie_#{time_id}.csv", save_path)
    csv_doc = File.open(filepath, "w")
    csv_doc.puts(csv_string)
    csv_doc.close
    puts "emails written in file #{filepath}"
  end

  def save_as_gsheet
    session = GoogleDrive::Session.from_config("../../config.json")
    work_sheet = session.spreadsheet_by_key("1EF6_Y6WOy9PwIrF24Q9f4ow05CDqjvP6_1uzCl9R7-U").worksheets[0]
    text = convert_to_comma_separated_elements
    puts "list converted to string of csv format"
    positions = get_position_list
    n = text.length / @nb_cols
    hash = {}
    puts "writting on google sheet..."
    (0..n).each do |i|
      work_sheet[positions[i][0], positions[i][1]] = text[i]
    end
    work_sheet.save
    puts "google sheet written"
    puts "here is the url"
    puts "https://docs.google.com/spreadsheets/d/1EF6_Y6WOy9PwIrF24Q9f4ow05CDqjvP6_1uzCl9R7-U/edit#gid=0"
  end

  def save_as_json
    unic_hash = convert_to_hash
    json_string = unic_hash.to_json
    puts "list converted to string of json format"
    time_id = (Time.now).to_s.split(" ")[0..1].join("_")
    filepath = File.expand_path("mails_mairie_#{time_id}.json", save_path)
    json_doc = File.open(filepath, "w")
    json_doc.puts(json_string)
    json_doc.close
    puts "emails written in file #{filepath}"
  end

#========private methods

  def convert_to_csv_string
    csv_string = "city,email\n"
    @original_scrap.each do |hash|
      hash.each {|key,value|
          csv_string << "#{key},#{value}\n"
      }
    end
    csv_string
  end

  def convert_to_comma_separated_elements
    convert_to_csv_string.split("\n").join(",").split(",")
  end

  def get_position_list
    puts "converting csv string to comma-separated elements"
    n = convert_to_comma_separated_elements.length
    nb_rows = n / @nb_cols
    positions = []
    (1..nb_rows).each do |row|
      (1..nb_cols).each do |col|
        positions << [row, col]
      end
    end
    positions
  end

  def convert_to_hash
    unic_hash = {}
    @original_scrap.each do |hash|
      hash.each do |k,v|
        unic_hash[k] = v
      end
    end
    unic_hash
  end

end

# scrap = Scrap.new("https://www.annuaire-des-mairies.com/guyane.html")
# list = MailList.new(scrap.emails)
# list.save_as_gsheet
