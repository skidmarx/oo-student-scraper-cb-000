require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student = doc.css(".student-card")
    student.each do |info|
      profile = {:name => info.css(".student-name").text, :location => info.css(".student-location").text, :profile_url => info.css("a").attribute("href").text}
      students << profile
    end
    students

  end

  def self.scrape_profile_page(profile_url)
    #student_profile = []
    #html = open(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    #social = doc.css(".vitals_container")
    social = doc.css(".social-icon-container a")
    #student_profile << x.attribute("href").text
    social_links = social.collect {|link| link.attribute('href').value}
    quote = doc.css("div div .profile-quote").text
    bio = doc.css(".bio-content div p").text


    hash = {bio: "#{bio}", profile_quote: "#{quote}"}
    social_links.each do |x|
      if x.include? ("twitter")
        hash[:twitter] = x
      elsif x.include?("linkedin")
        hash[:linkedin] = x
      elsif x.include?("github")
        hash[:github] = x
      else
        hash[:blog] = x
      end
    end
    hash


  end

end
