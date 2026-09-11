require 'benchmark'

def human_ms(seconds)
  if seconds >= 1
    return format("%.2f s", seconds)
  end
  format("%.2f ms", seconds * 1000)
end

desc 'Benchmark preload complex query'

task benchmark_preload_complex: :environment do

  h = { complex: {} }

  stores = Store.all.to_a

  p "Executing complex exercise with n+1"
  h[:complex][:n_plus_1] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.map { |f| f.language.name }
    end
  end.to_h

  p "Executing complex exercise with preload"
  h[:complex][:preload] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.preload(:language).map { |f| f.language.name }
    end
  end.to_h

  p "Executing complex exercise with eager load"
  h[:complex][:eager_load] = Benchmark.measure do
    stores.each do |store|
      p "Processing record #{store.id}..."
      store.films.eager_load(:language).map { |f| f.language.name }
    end
  end.to_h

  json_h = h[:complex].each_with_object({}) do |(k, v), hash|
    new_h = v.each_with_object({}) do |(inner_k, inner_v), inner_h|
      if inner_k != :label
        inner_v = human_ms(inner_v)
      end
      inner_h[inner_k] = inner_v
    end
    hash[k] = new_h
  end
  h[:complex] = json_h

  pp h[:complex]
end
