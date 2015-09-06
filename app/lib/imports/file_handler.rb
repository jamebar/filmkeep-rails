module Imports
  class FileHandler

    def initialize(opts = {})
      @glob = opts.fetch(:glob)
      @archive_dir = opts.fetch(:archive_dir)
    end

    def each_file
      files_to_process.each do |file|
        ActiveRecord::Base.transaction do
          yield(file) if block_given?
        end
      end
    end

    private
    def files_to_process
      @ftp ||= Pathname.glob(@glob)
    end
  end
end