require 'bundler'
Bundler.require

class Scrap
  attr_accessor :annuaire_url
  attr_reader :emails

  def initialize(annuaire_url)
    @annuaire_url = annuaire_url
    @emails = get_all_emails(annuaire_url)
  end

  private

  def get_all_emails(annuaire_url)
    email_list = []
    list = get_townhall_urls(annuaire_url)
    list.each do |mairie|
      email_list << get_townhall_email(mairie)
    end
    email_list
  end

  def get_townhall_urls(annuaire_url)
    page = Nokogiri::HTML(open(annuaire_url))

    # since the href is not an entire url
    # need to get the first part of the url from the annuaire list and to glue later
    # method : split the original url by /
    # get rid of the last part
    # glue back together with /
    prefix = annuaire_url.split('/')[0..-2].join('/')
    urls_list = []

    # the links are really well organised on this page
    page.xpath('//a[@class = "lientxt"]').each do |link|
    # but the links all start with a dot
    # need to chop off the dot
    # then glue the prefix with the href
    # then stuff it into a list
      urls_list << "#{prefix}#{link['href'][1..-1]}"
    end
    puts "all city hall urls obtained"
    urls_list
  end


  def get_townhall_email(townhall_url)
    info = {}
    page = Nokogiri::HTML(open(townhall_url))
    name = page.xpath('/html/body/div/header/section/div/div[1]/h1/small').text.split(" ")[-1]
    email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    unless email == ""
      # coz yes, some city just doesn't have an email address
      info[name] = email
    else
      info[name] = "mairie_sans_email"
    end
    puts "email of #{name} obtained..."
    return info
  end
end

#Scrap.new("https://www.annuaire-des-mairies.com/guyane.html")
