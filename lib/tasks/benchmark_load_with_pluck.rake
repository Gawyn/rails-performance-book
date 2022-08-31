require 'benchmark'

desc 'Benchmark load with pluck'

task benchmark_load_with_pluck: :environment do

  h = {simple: {}, complex: {}}

  p "Executing simple exercise with n+1"
  h[:simple][:whole_object] = Benchmark.measure do
    Film.all.map { |f| f.title }
  end

  p "Executing simple exercise with limited select"
  h[:simple][:with_select] = Benchmark.measure do
    Film.select(:title).map { |f| f.title }
  end

  p "Executing simple exercise with pluck"
  h[:simple][:with_pluck] = Benchmark.measure do
    Film.pluck(:title)
  end

  pp h
end
