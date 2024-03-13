desc 'Seed For Audits'

task seed_audits: :environment do
  Rental.all.each do |rental|
    rental.send(:generate_create_audit)
  end
end

