require 'benchmark'

desc 'Benchmark preload complex query'

task benchmark_preload_complex: :environment do

  h = {complex: {}}

  stores = Store.all.to_a

  p "Executing complex exercise with n+1"
  h[:complex][:n_plus_1] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.map { |f| f.language.name }
    end
  end

  p "Executing complex exercise with preload"
  h[:complex][:preload] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.preload(:language).map { |f| f.language.name }
    end
  end

  p "Executing complex exercise with eager load"
  h[:complex][:eager_load] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.eager_load(:language).map { |f| f.language.name }
    end
  end

  pp h[:complex]
end
