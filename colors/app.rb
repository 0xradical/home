require "nokogiri"
require "color"

ICELANDIC_SW = Color::RGB.new(203, 216, 225)

suvinil = Nokogiri::HTML(File.read("suvinil.html"))
suvinil.css(".swiper-slide a").select do |a|
  a.attributes["style"].to_s.length > 0
end.map do |a|
  bc = a.attributes["style"].to_s.scan(/background-color: (.*?);/).first.first
  rgb = bc.gsub("rgb(","").gsub(")","").split(",").map(&:to_i)
  name = a.text
  link = a.attributes["href"].to_s
  color = Color::RGB.new(*rgb)
  delta_E = ICELANDIC_SW.delta_e94(color.to_lab, ICELANDIC_SW.to_lab)
  {
    name: name,
    link: link,
    color: color,
    delta_E: delta_E
  }
end.sort_by do |props|
  props[:delta_E]
end

sw_azul = Nokogiri::HTML(File.read("sw_azul.html"))
sw_azul.css(".wrap-cores li a").map do |a|
  hex = a.attributes["data-cor"].value
  name = a.attributes["data-titulo"].value
  link = a.attributes["href"].value
  color = Color::RGB.by_hex(hex)
  delta_E = ICELANDIC_SW.delta_e94(color.to_lab, ICELANDIC_SW.to_lab)

  {
    name: name,
    link: link,
    color: color,
    delta_E: delta_E
  }
end.sort_by do |props|
  props[:delta_E]
end

coral_azul = Nokogiri::HTML(File.read("coral_azul.html"))
coral_azul.css(".m7-color-card").map do |div|

  hex = div.attributes["data-hex"].value.sub("#","")
  name = div.attributes["data-label"].value
  link = nil
  color = Color::RGB.by_hex(hex)
  delta_E = ICELANDIC_SW.delta_e94(color.to_lab, ICELANDIC_SW.to_lab)

  {
    name: name,
    link: link,
    color: color,
    delta_E: delta_E
  }
end.sort_by do |props|
  props[:delta_E]
end