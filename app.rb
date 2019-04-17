require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)

require "app/mail_list"
require "app/scrap"

class App

  attr_accessor:url

  def initialize
    welcome
    @url = get_url
    list = create_list(@url)
    menu
    choice(list)
  end

  private

  def welcome
    puts "-------------------------------------"
    puts "|       THIS IS AN ASSISTANCE       |"
    puts "|  TO CREATE EMAIL ADDRESSE LISTS   |"
    puts "|  OF DIFFERENT FRENCH DEPARTMENTS  |"
    puts "-------------------------------------"
  end

  def get_url
    puts "-- Please paste the annuaire url you wish to use"
    puts "-- OR press <d> to use the default address"
    puts "   Default addresse : https://www.annuaire-des-mairies.com/guyane.html"
    print ">  "
    answer = gets.chomp
    if answer == "d"
      url = "https://www.annuaire-des-mairies.com/guyane.html"
    else
      url = answer
    end
    puts "-- We took note of your url"
    puts ""
    url
  end

  def create_list(url)
    list = MailList.new(Scrap.new(url).emails)
    puts "--------------------------------------------------"
    puts "-- Email list generated"
    return list
  end

  def menu
    puts "--------------------------------------------------"
    puts ""
    puts "This assistance will create a list of email lists"
    puts "According to the annuaire url that you enter"
    puts "You can then choose to save the list in 3 ways"
    puts ".csv file, .json file or on a certain google sheet"
    puts "please specify your saving option"
    puts ""
    puts "   1 --- to .csv"
    puts "   2 --- to .json"
    puts "   3 --- to google sheet"
    puts ""
  end

  def choice(list)
    print "Your choice here  >>  "
    answer = gets.chomp
    case answer
    when "1"
      list.save_as_csv_doc
    when "2"
      list.save_as_json
    when "3"
      list.save_as_gsheet
    else
      puts "WRONG INPUT"
    end
    puts "-- Thank you."
  end
end

App.new
