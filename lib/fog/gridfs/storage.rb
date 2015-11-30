require 'mongoid/grid_fs'

module Fog
  module Storage
    class Gridfs < Fog::Service

      model_path 'fog/gridfs/storage/models'
      collection  :directories
      model       :directory
      model       :file
      collection  :files

      class Real
        def initialize(options = {})
        end

        def method_missing(*args, &block)
          if Mongoid::GridFs.respond_to?(args.first)
            Mongoid::GridFs.send(*args, &block)
          else
            super
          end
        end

        def dump_object_to_file_system(gridfs_file, target_file)
          file = ::File.open(target_file, 'w')
          gridfs_file.each do |chunk|
            file.write(chunk.force_encoding('UTF-8'))
          end
        end
      end
    end
  end
end