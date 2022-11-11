require 'benchmark'

desc 'Benchmark lean fetches'

task benchmark_lean_fetches: :environment do
  def filter_report(report)
    {
      objects_allocated: report.total_allocated,
      memsize_allocated: report.total_allocated_memsize,
      objects_retained: report.total_retained,
      memsize_retained: report.total_retained_memsize
    }
  end

  h = {}
  memory = {}

  p 'Executing fat fetch'
  report = MemoryProfiler.report do
    h[:fat_fetch] = Benchmark.measure do
      Film.all.map { |film| [film.id, film.title] }
    end
  end
  memory[:fat_fetch] = filter_report(report)

  p 'Executing lean fetch with select'
  report = MemoryProfiler.report do
    h[:select_fetch] = Benchmark.measure do
      Film.select(:id, :title).all.map { |film| [film.id, film.title] }
    end
  end
  memory[:select_fetch] = filter_report(report)

  p 'Executing lean fetch with pluck'
  report = MemoryProfiler.report do
    h[:pluck_fetch] = Benchmark.measure do
      Film.pluck(:id, :title)
    end
  end
  memory[:pluck_fetch] = filter_report(report)

  pp h
  pp memory
end
