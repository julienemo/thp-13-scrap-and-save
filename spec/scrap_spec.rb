require_relative '../lib/app/scrap'


describe 'takes a url of a department and returns a list of hashes' do
  scrap = Scrap.new("https://www.annuaire-des-mairies.com/paris.html")

  it 'the result should be at least 10 items long' do
    expect(scrap.emails.length).to be > (10)
  end

  it 'the result should be a list' do
    expect(scrap.emails).to be_a(Array)
  end

  it 'the items of the list should be hashes' do
    expect(scrap.emails[0]).to be_a(Hash)
  end

end
