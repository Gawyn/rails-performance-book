require 'benchmark'

desc 'Benchmark preload'

task benchmark_preload: :environment do

  h = {simple: {}, complex: {}}

  p "Executing simple exercise with n+1"
  h[:simple][:n_plus_1] = Benchmark.measure do
    Film.all.map { |f| f.language.name }
  end

  p "Executing simple exercise with preload"
  h[:simple][:preload] = Benchmark.measure do
    Film.preload(:language).map { |f| f.language.name }
  end

  p "Executing simple exercise with eager load"
  h[:simple][:eager_load] = Benchmark.measure do
    Film.eager_load(:language).map { |f| f.language.name }
  end

  stores = Store.all.to_a

  p "Executing complex exercise with n+1"
  h[:complex][:n_plus_1] = Benchmark.measure do
    stores.each do |store|
      p store.id
      store.films.map { |f| f.language.name }
    end
  end

  p "Executing complex exercise with preload"
  h[:complex][:preload] = Benchmark.measure do
    stores.each do |store|
      store.films.preload(:language).map { |f| f.language.name }
    end
  end

  p "Executing complex exercise with eager load"
  h[:complex][:eager_load] = Benchmark.measure do
    stores.each do |store|
      store.films.eager_load(:language).map { |f| f.language.name }
    end
  end

  pp h
end
