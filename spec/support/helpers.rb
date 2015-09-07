module Helpers
    def json(body)
        JSON.parse(body, symbolize_names: true)
    end

    def delete_dummy_file
        File.delete('dummy_file')
    end
end
