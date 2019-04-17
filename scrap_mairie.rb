require "pry"
require "nokogiri"
require "open-uri"



def get_townhall_email(townhall_url)
  info = {}
  page = Nokogiri::HTML(open(townhall_url))
  name = page.xpath('/html/body/div/header/section/div/div[1]/h1/small').text.split(" ")[-1]
  email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  info[name] = email
  return info
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
  urls_list
end

# ATTENTION when a mairie has no email
# this array has an empty place for it
# for the moment no exception handling needed
def get_all_emails(annuaire_url)
  email_list = []
  list = get_townhall_urls(annuaire_url)
  list.each do |mairie|
    email_list << get_townhall_email(mairie)
  end
  email_list
end


# for manual tests
# puts get_townhall_email("https://www.annuaire-des-mairies.com/95/avernes.html")
# puts get_townhall_urls("http://www.annuaire-des-mairies.com/hauts-de-seine.html")
# puts get_all_emails("http://www.annuaire-des-mairies.com/aube.html")
