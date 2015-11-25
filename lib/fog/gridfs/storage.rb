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
      end
    end
  end
end