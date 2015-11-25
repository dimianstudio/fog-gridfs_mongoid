require 'fog/core/collection'
require 'fog/gridfs/storage/models/directory'

module Fog
  module Storage
    class Gridfs
      class Directories < Fog::Collection
        model Fog::Storage::Gridfs::Directory

        def all
          load([{ key: '/' }])
        end
      end
    end
  end
end