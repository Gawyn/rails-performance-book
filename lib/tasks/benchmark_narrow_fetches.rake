require 'benchmark'
require "active_support"
require "active_support/core_ext/numeric/conversions"
require "active_support/core_ext/integer"

desc 'Benchmark narrow fetches'

def human_ms(seconds)
  if seconds >= 1
    return format("%.2f s", seconds)
  end
  format("%.2f ms", seconds * 1000)
end

task benchmark_narrow_fetches: :environment do
  def filter_report(report)
    {
      objects_allocated: report.total_allocated.to_fs(:delimited),
      memsize_allocated: report.total_allocated_memsize.to_fs(:human_size),
      objects_retained: report.total_retained.to_fs(:delimited),
      memsize_retained: report.total_retained_memsize.to_fs(:human_size)
    }
  end

  h = {}
  memory = {}

  p 'Executing wide fetch'
  report = MemoryProfiler.report do
    h[:wide_fetch] = Benchmark.measure do
      Film.all.map { |film| [film.id, film.title] }
    end
  end
  memory[:wide_fetch] = filter_report(report)

  p 'Executing narrow fetch with select'
  report = MemoryProfiler.report do
    h[:select_fetch] = Benchmark.measure do
      Film.select(:id, :title).all.map { |film| [film.id, film.title] }
    end
  end
  memory[:select_fetch] = filter_report(report)

  p 'Executing narrow fetch with pluck'
  report = MemoryProfiler.report do
    h[:pluck_fetch] = Benchmark.measure do
      Film.pluck(:id, :title)
    end
  end
  memory[:pluck_fetch] = filter_report(report)
  json_h = h.each_with_object({}) do |(k, v), hash|
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
  pp memory
end
