require 'benchmark'

desc 'Benchmark indexes'

task benchmark_indexes: :environment do

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

  p "Executing simple exercise with no indexing"
  report = MemoryProfiler.report do
    h[:simple][:no_index] = Benchmark.measure do
      Film.order("title asc").force_index("PRIMARY").pluck(:title)
    end
  end

  memory[:simple][:no_index] = filter_report(report)

  p "Executing simple exercise with language and title index"
  report = MemoryProfiler.report do
    h[:simple][:with_language_and_title_index] = Benchmark.measure do
      Film.force_index('index_films_on_language_id_and_title').order("title asc").pluck(:title)
    end
  end

  memory[:simple][:with_language_and_title_index] = filter_report(report)

  p "Executing simple exercise with title index"
  report = MemoryProfiler.report do
    h[:simple][:with_title_index] = Benchmark.measure do
      Film.order("title asc").pluck(:title)
    end
  end

  memory[:simple][:with_title_index] = filter_report(report)

  pp h[:simple]
  pp memory[:simple]

  p "Executing complex exercise with no indexing"
  report = MemoryProfiler.report do
    h[:complex][:no_index] = Benchmark.measure do
      Film.where(language_id: 3).order("title asc").force_index("PRIMARY").pluck(:title)
    end
  end

  memory[:complex][:no_index] = filter_report(report)

  p "Executing complex exercise with language and title indexing"
  report = MemoryProfiler.report do
    h[:complex][:with_language_and_title_index] = Benchmark.measure do
      Film.where(language_id: 3).order("title asc").pluck(:title)
    end
  end

  memory[:complex][:with_language_and_title_index] = filter_report(report)

  p "Executing complex exercise with title indexing"
  report = MemoryProfiler.report do
    h[:complex][:with_title_index] = Benchmark.measure do
      Film.force_index('index_films_on_title').where(language_id: 3).order("title asc").pluck(:title)
    end
  end

  memory[:complex][:with_title_index] = filter_report(report)

  pp h[:complex]
  pp memory[:complex]
end
