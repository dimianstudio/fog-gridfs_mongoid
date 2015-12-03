require 'fog/core/model'

module Fog
  module Storage
    class Gridfs
      class File < Fog::Model
        identity :key, aliases: 'filename'

        attribute :content_length, aliases: 'length', type: :integer
        attribute :content_type, aliases: 'contentType'
        attribute :last_modified, aliases: 'uploadDate'

        def body
          service.file_model.where(filename: key).first.try(:data) || attributes[:body] || ''
        end

        def body=(value)
          attributes[:body] = value
        end

        def save(options = {})
          requires :key, :body

          aliases_map = self.class.aliases.invert
          attrs = {}

          attributes.each do |key, value|
            __alias = aliases_map[key.to_sym]
            next unless __alias
            attrs[__alias] = value
          end

          service.put(attributes[:body], attrs)
        end

        def copy(target_directory_key, target_file_key, options={})
          requires :key

          target_file = target_directory_key + '/' + target_file_key
          file = service.file_model.where(filename: key).first
          service.dump_object_to_file_system(file, target_file)
        end

        def destroy
          requires :key

          file = service.file_model.where(filename: key).first
          service.delete(file.id)

          true
        end
      end
    end
  end
end