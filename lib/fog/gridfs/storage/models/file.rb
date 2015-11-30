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
          service.put(body, { filename: key })
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