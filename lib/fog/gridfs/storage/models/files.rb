require 'fog/core/collection'
require 'fog/gridfs/storage/models/file'

module Fog
  module Storage
    class Gridfs
      class Files < Fog::Collection
        attribute :directory

        model Fog::Storage::Gridfs::File

        def all
          requires :directory
          load(service.file_model.all.map(&:attributes))
        end

        def get(key, options = {}, &block)
          head(key, options)
        end

        def head(key, options = {})
          requires :directory
          file = service.file_model.where(filename: key).first
          file ? new(file.attributes) : nil
        end
      end
    end
  end
end