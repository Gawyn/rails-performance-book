redis_client = Redis.new
s3_client = Aws::S3::Client.new

while true
  Customer.all.pluck(:id).each do |customer_id|
    time = Time.now - 2.years
    bucket_key = Rental.archived_rentals_bucket_key(customer_id)
    rentals = redis_client.fetch(bucket_key)
    bucket = Aws::S3::Resource.new(client: s3_client).bucket("archived_rentals")
    folder = "customer_#{customer_id}"

    rentals.each do |rental|
      break if rental[:returnal_date] > time

      s3_client.put_object(
        bucket: aws_client.s3_bucket,
        key: folder + "/" + "archived_rental_#{rental[:id]}",
        body: rental,
        content_type: 'text/json'
      )
    end
  end
end
