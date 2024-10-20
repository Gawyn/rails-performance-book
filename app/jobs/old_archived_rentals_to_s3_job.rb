class OldArchivedRentalsToS3Job < ApplicationJob
  queue_as :default

  def perform(*args)
    time = Time.now - 2.years
    Customer.all.pluck(:id).each do |customer_id|
      bucket_key = Rental.archived_rentals_bucket_key(customer_id)
      bucket = Aws::S3::Resource.new(client: s3_client).bucket("archived_rentals")
      rentals = redis_client.fetch(bucket_key)
      folder = "customer_#{customer_id}"

      rentals.each do |rental|
        rental[:returnal_date] > time ? break : redis_client.lpop(bucket_key)

        s3_client.put_object(
          bucket: aws_client.s3_bucket,
          key: folder + "/" + "archived_rental_#{rental[:id]}", body: rental,
          content_type: 'text/json'
        )
      end
    end
  end

  private

  def redis_client
    @redis_client ||= Redis.new
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new
  end
end
