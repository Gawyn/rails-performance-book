require 'benchmark'

desc 'Benchmark preload complex query'

task benchmark_preload_complex: :environment do

  def filter_report(report)
    {
      objects_allocated: report.total_allocated,
      memsize_allocated: report.total_allocated_memsize,
      objects_retained: report.total_retained,
      memsize_retained: report.total_retained_memsize
    }
  end
  h = {complex: {}}
  memory = {simple: {}, complex: {}}

  stores = Store.all.to_a
  p stores

  p "Executing complex exercise with n+1"
  report = MemoryProfiler.report do
    p 1
    h[:complex][:n_plus_1] = Benchmark.measure do
      p 2
      stores.each do |store|
        p store.id
        store.films.map { |f| f.language.name }
      end
    end
  end

  memory[:complex][:n_plus_1] = filter_report(report)

  p "Executing complex exercise with preload"
  report = MemoryProfiler.report do
    p 'a'
    h[:complex][:preload] = Benchmark.measure do
      p 'in it'
      stores.each do |store|
        p store.id
        store.films.preload(:language).map { |f| f.language.name }
      end
    end
  end

  memory[:complex][:preload] = filter_report(report)

  p "Executing complex exercise with eager load"
  report = MemoryProfiler.report do
    h[:complex][:eager_load] = Benchmark.measure do
      stores.each do |store|
        store.films.eager_load(:language).map { |f| f.language.name }
      end
    end
  end

  memory[:complex][:eager_load] = filter_report(report)

  pp h[:complex]
  pp memory[:complex]
end
