require 'benchmark'

desc 'Benchmark narrow fetches'

task benchmark_narrow_fetches: :environment do
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

  pp h
  pp memory
end
