require 'benchmark'

desc 'Benchmark preload'

task benchmark_preload_simple: :environment do

  def filter_report(report)
    {
      objects_allocated: report.total_allocated,
      memsize_allocated: report.total_allocated_memsize,
      objects_retained: report.total_retained,
      memsize_retained: report.total_retained_memsize
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

  pp h[:simple]
  pp memory[:simple]
end
