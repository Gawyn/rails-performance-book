require 'benchmark'
require "active_support"
require "active_support/core_ext/numeric/conversions"
require "active_support/core_ext/integer"

def human_ms(seconds)
  if seconds >= 1
    return format("%.2f s", seconds)
  end
  format("%.2f ms", seconds * 1000)
end

desc 'Benchmark preload'

task benchmark_preload_simple: :environment do

  def filter_report(report)
    {
      objects_allocated: report.total_allocated.to_fs(:delimited),
      memsize_allocated: report.total_allocated_memsize.to_fs(:human_size),
      objects_retained: report.total_retained.to_fs(:delimited),
      memsize_retained: report.total_retained_memsize.to_fs(:human_size)
    }
  end

  h = {simple: {}, complex: {}}
  memory = {simple: {}, complex: {}}

  p "Executing simple exercise with n+1"
  report = MemoryProfiler.report do
    h[:simple][:n_plus_1] = Benchmark.measure do
      Film.all.map { |f| f.language.name }
    end
  end

  memory[:simple][:n_plus_1] = filter_report(report)

  p "Executing simple exercise with preload"
  report = MemoryProfiler.report do
    h[:simple][:preload] = Benchmark.measure do
      Film.preload(:language).map { |f| f.language.name }
    end
  end

  memory[:simple][:preload] = filter_report(report)

  p "Executing simple exercise with eager load"
  report = MemoryProfiler.report do
    h[:simple][:eager_load] = Benchmark.measure do
      Film.eager_load(:language).map { |f| f.language.name }
    end
  end

  memory[:simple][:eager_load] = filter_report(report)
  json_h = h[:simple].each_with_object({}) do |(k, v), hash|
    inner_h =  v.to_h
    new_h = inner_h.each_with_object({}) do |(k, v), h|
      if k != :label
        v = human_ms(v)
      end
      h[k] = v
    end
    hash[k] = new_h
  end
  pp json_h
  pp memory[:simple]
end
