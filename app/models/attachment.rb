class Attachment < ActiveRecord::Base
    belongs_to :comment

    #validates_presence_of :filename
    validate :file_size, on: :file_upload=
    
    def file_upload=(incoming_file)
        @incoming_file = incoming_file      #to be accessible in other method
        self.filename = sanitize_filename(@incoming_file.original_filename)
        self.mime_type = @incoming_file.content_type
        #Bug in Rails 4.1 - can't properly load  binary data while pg 0.18 been used
        #base64 encding/decoding as a workaround
        #Also we are not going to load big files into the memory
        #validation will prevent this
        self.data = Base64.encode64( @incoming_file.read ) if valid?(:file_upload=)
    end

    private

    def file_size
        #2**20 according to JEDEC standart
        if @incoming_file.size.to_f/2**20 > 5
            errors.add(:data, "File size can't be over 5 Mb")
        end
    end

    def sanitize_filename(filename)
        # Get only the filename, not the whole path (for IE)
        return File.basename(filename)
    end    
end
