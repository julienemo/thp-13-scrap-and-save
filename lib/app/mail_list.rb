require 'bundler'
Bundler.require


class MailList
  attr_accessor:original_scrap, :huge_hash
  attr_reader:nb_cols

#=====public methods
  def initialize(original_scrap)
    @original_scrap = original_scrap
    @nb_cols = 2
    @huge_hash = {"APATOU"=>"mairie_sans_email", "AWALA-YALIMAPOa"=>"mairie@awala-yalimapo.fr", "CAMOPI"=>"mairie.camopi@yahoo.fr"}
  end

  def save_as_csv_doc
    csv_string = @original_scrap
    puts "list converted to string of csv format"
    time_id = (Time.now).to_s.split(" ")[0..1].join("_")
    csv_doc = File.open("../../db/mails_mairie_#{time_id}.csv", "w")
    csv_doc.puts(csv_string)
    csv_doc.close
    puts "emails written in file ../../db/mails_marie_#{time_id}.csv"
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
  end

  def save_as_json
    unic_hash = convert_to_hash
    json_string = unic_hash.to_json
    puts "list converted to string of json format"
    time_id = (Time.now).to_s.split(" ")[0..1].join("_")
    json_doc = File.open("../../db/mails_mairie_#{time_id}.json", "w")
    json_doc.puts(json_string)
    json_doc.close
    puts "emails written in file ../../db/mails_marie_#{time_id}.json"
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
