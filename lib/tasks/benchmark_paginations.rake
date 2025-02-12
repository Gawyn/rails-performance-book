require 'benchmark'

desc 'Benchmark paginations'

task benchmark_paginations: :environment do

  h = {page: {}, cursor: {}}

  r = [2, 3, 4, 22, 35, 100, 333, 460]
  per = 15

  h[:page] = Benchmark.measure do
    100.times do
      r.each do |page|
        Film.page(page).per(per).pluck(:id)
      end
    end
  end

  cursors = r.map { |page| Film.page(page).per(per).pluck(:id).first }

  h[:cursor] = Benchmark.measure do
    100.times do
      cursors.each do |cursor|
        Film.where("id > ?", cursor).limit(per).pluck(:id)
      end
    end
  end

  pp h
end
