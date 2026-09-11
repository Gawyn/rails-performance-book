require 'benchmark'

def human_ms(seconds)
  if seconds >= 1
    return format("%.2f s", seconds)
  end
  format("%.2f ms", seconds * 1000)
end

desc 'Benchmark load with pluck'

task benchmark_load_with_pluck: :environment do

  h = { simple: {}, complex: {} }

  p "Executing simple exercise with n+1"
  h[:simple][:whole_object] = Benchmark.measure do
    Film.all.map { |f| f.title }
  end.to_h

  p "Executing simple exercise with limited select"
  h[:simple][:with_select] = Benchmark.measure do
    Film.select(:title).map { |f| f.title }
  end.to_h

  p "Executing simple exercise with pluck"
  h[:simple][:with_pluck] = Benchmark.measure do
    Film.pluck(:title)
  end.to_h
  json_h = h[:simple].each_with_object({}) do |(k, v), hash|
    new_h = v.each_with_object({}) do |(inner_k, inner_v), inner_h|
      if inner_k != :label
        inner_v = human_ms(inner_v)
      end
      inner_h[inner_k] = inner_v
    end
    hash[k] = new_h
  end
  h[:simple] = json_h
  pp h
end
