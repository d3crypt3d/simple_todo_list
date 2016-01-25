module Helpers
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def delete_dummy_file
    File.delete('dummy_file')
  end

  def parse_for_id(resposne)
    json(response.body)[:data].map {|i| i[:id].to_i}
  end
end
