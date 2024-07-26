module Utils
  class AwsS3
    def self.client
      Aws::S3::Client.new(
        region: dig_aws_param(:region),
        credentials: Aws::Credentials.new(dig_aws_param(:access_key_id), dig_aws_param(:secret_access_key))
      )
    end

    def self.bucket(name = nil)
      s3_resource = Aws::S3::Resource.new(client: client)
      s3_resource.bucket(name.presence || dig_aws_param(:bucket))
    end

    def self.upload_to_s3(folder_path, content, content_type = 'application/octet-stream', bucket_name = nil)
      s3_bucket = bucket(bucket_name)
      s3_object = s3_bucket.object("#{folder_path}/#{SecureRandom.uuid}")
      s3_object.put(body: content, acl: 'public-read', content_type: content_type)
      s3_object.public_url
    end

    private

    def self.dig_aws_param(param)
      Rails.application.credentials.dig(:aws, "#{param}")
    end
  end
end
