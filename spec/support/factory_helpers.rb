module FactoryHelpers
    #extend self
    
    def create_dummy_file(required_size)
        file_size = 0
        string = "abcdefghijklmnopqrstuvwxyz123456"

        File.open('dummy_file', 'w') do |f|
            while file_size < required_size
                f.print string
                file_size += string.size
            end
        end

        return Rack::Test::UploadedFile.new('dummy_file', 'image/png')
    end
end
