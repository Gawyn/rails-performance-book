require 'benchmark'

desc 'Benchmark load with pluck'

task benchmark_load_with_pluck: :environment do

  h = {simple: {}, complex: {}}

  p "Executing simple exercise with n+1"
  h[:simple][:no_pluck] = Benchmark.measure do
    Film.all.map { |f| f.title }
  end

  p "Executing simple exercise with preload"
  h[:simple][:with_pluck] = Benchmark.measure do
    Film.pluck(:title)
  end

  pp h
end
