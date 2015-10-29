require 'gearlist_api'

class GearlistMapper
  def self.build_list(list_id, api)
    list = {}

    details = api.get_list_details(list_id)
    list[:name]        = details["name"]
    list[:user_id]     = details["user_id"]
    list[:description] = details["description"]
    list[:secret]      = details["secret"]
    list[:id]          = details['id']
    list[:user_name]   = details['user_name']

    list[:sections] = api.get_list_sections(list_id)

    list[:sections].each do |section|
      section[:items] = api.get_section_items(section["id"])
      section[:subtotal] = weight_subtotal(section)
    end

    list[:total_weight] = total_weight(list)

    return list
  end

  def self.get_lists(url_param, api)
    list_ids = []
    lists = []

    retrieved_lists = api.lists(url_param)

    retrieved_lists.each do |list|
      list_ids.push(list["id"])
    end

    list_ids.each do |id|
      lists.push(build_list(id, api))
    end

    return lists
  end

  def self.map_sections(api)
    sections = api.get_sections
    sections.map { |section| [section['name'], section['name']] }
  end

  private

  def self.weight_subtotal(section)
    sum = 0
    section[:items].each do |item|
      sum += (item["weight"].to_i * item["quantity"].to_i)
    end

    return sum
  end

  def self.total_weight(list)
    sum = 0
    list[:sections].each do |section|
      sum += section[:subtotal]
    end

    return sum
  end
end
